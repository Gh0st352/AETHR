--- @class AETHR.AI
---@diagnostic disable: undefined-global
--- @brief 2D clustering utilities using DBSCAN for point sets.
--- Accepts points shaped as { x, y } or { x, z }; coordinates are normalized internally via AETHR.UTILS:normalizePoint.
--- Parameterization:
---   - epsilon = f * math.sqrt(Area / n)
---   - min_samples = math.max(1, math.ceil(p * n))
--- Notes:
---   - region_query returns neighbors including the index itself
---   - RadiusExtension is added to the computed cluster radius in post_process_clusters
---   - Units are meters for coordinates and radii
--- Usage:
---   -- Facade:
---   -- local clusters = self.AI:clusterPoints(points, area, { radiusExtension = 0, f = 2, p = 0.1 })
---   -- Direct:
---   -- local scanner = self.AI.DBSCANNER:New(self.AI, points, area, 0, { f = 2, p = 0.1 }):Scan()
---   -- local clusters = scanner.Clusters
---
--- Submodule wiring (set by AETHR:New):
--- @field AETHR AETHR Parent AETHR instance (injected by AETHR:New).
--- @field CONFIG AETHR.CONFIG Configuration table attached per-instance.
--- @field FILEOPS AETHR.FILEOPS File operations helper table attached per-instance.
--- @field POLY AETHR.POLY Geometry helper table attached per-instance.
--- @field UTILS AETHR.UTILS Utility helper table attached per-instance.
--- @field AI AETHR.AI AI submodule attached per-instance.
--- @field MATH AETHR.MATH Math helper table attached per-instance.
--- @field AUTOSAVE AETHR.AUTOSAVE Autosave submodule attached per-instance.
--- @field ENUMS AETHR.ENUMS ENUMS submodule attached per-instance.
--- @field WORLD AETHR.WORLD World learning submodule attached per-instance.
--- @field ZONE_MANAGER AETHR.ZONE_MANAGER Zone management submodule attached per-instance.
--- @field MARKERS AETHR.MARKERS Marker utilities submodule attached per-instance.
--- @field DATA AETHR.AI.DATA Container for AI-managed defaults and helpers.
---
--- Cluster result structure returned by DBSCANNER and AI:clusterPoints
--- @class AETHR.AI.DBSCAN_Cluster
--- @field Points (_vec2|_vec2xz|{x:number,y:number}|{x:number,z:number})[] Points assigned to the cluster (original references)
--- @field Center _vec2 Center of mass in 2D (x,y)
--- @field Radius number Radius from center to farthest member (meters)
AETHR.AI = {} ---@diagnostic disable-line


--- Creates a new AETHR.AI submodule instance.
--- @function AETHR.AI:New
--- @param parent AETHR Parent AETHR instance
--- @return AETHR.AI instance New instance inheriting AETHR.AI methods.
function AETHR.AI:New(parent)
  local instance = {
    AETHR = parent,
    _cache = {},
  }
  setmetatable(instance, { __index = self })
  return instance ---@diagnostic disable-line
end

--- AI module data container.
--- @class AETHR.AI.DATA
---
--- Defaults for DBSCAN parameterization and scratch state
--- @class AETHR.AI.DATA.DBSCANNER
--- @field params table Parameters override table (optional, used by constructor).
--- @field _DBScan table<integer, integer> Internal label map: index -> clusterId (-1 noise, 0 unmarked, >0 cluster)
--- @field Clusters AETHR.AI.DBSCAN_Cluster[] Computed clusters (post processing)
--- @field Points (_vec2|_vec2xz|{x:number,y:number}|{x:number,z:number})[] Points being clustered
--- @field numPoints integer Number of points
--- @field f number Scaling factor for epsilon (epsilon = f * sqrt(Area / n))
--- @field p number Proportion for min_samples (min_samples = ceil(p * n))
--- @field epsilon number Epsilon radius for neighbor query
--- @field epsilon2 number Squared epsilon (precomputed)
--- @field min_samples integer Minimum neighbors to be a core point (>=1)
--- @field Area number Area used to estimate epsilon
--- @field _RadiusExtension number Additional radius added to computed cluster radii

--- AI module data defaults.
---@type AETHR.AI.DATA
AETHR.AI.DATA = {
    DBSCANNER = {
        params = {},
        _DBScan = {},
        Clusters = {},
        Points = {},
        numPoints = 1,
        f = 2,
        p = 0.1,
        epsilon = 0,
        epsilon2 = 0,
        min_samples = 0,
        Area = 0,
        _RadiusExtension = 0,
    },
}

-- Class table for DBSCAN utility
AETHR.AI.DBSCANNER = {}

--- Runtime DBSCAN class
--- @class AETHR.AI.DBSCANNER
--- @field AI AETHR.AI Parent AI instance
--- @field AETHR AETHR Parent AETHR instance
--- @field UTILS AETHR.UTILS Utility helpers
--- @field Points (_vec2|_vec2xz|{x:number,y:number}|{x:number,z:number})[] Points being clustered
--- @field numPoints integer Number of points
--- @field Area number Area used to estimate epsilon
--- @field _RadiusExtension number Extra radius added to computed cluster radii
--- @field _DBScan table<integer, integer> Label map: index -> clusterId
--- @field Clusters AETHR.AI.DBSCAN_Cluster[] Cluster outputs (after post processing)
--- @field epsilon number Epsilon radius
--- @field epsilon2 number Epsilon squared
--- @field min_samples integer Minimum neighbor count to be core
--- @field f number Epsilon scale factor
--- @field p number Min-sample proportion

--- Constructs a new DBSCANNER object.
---
--- Initializes DBSCAN with the given AI instance and dataset.
--- Uses area and parameters to derive epsilon and min_samples.
---
--- Input points are raw coordinates; no "unit" field is required or used.
--- Each point is a table shaped as either:
---   { x = number, y = number }  OR  { x = number, z = number }
---
--- @param ai AETHR.AI The AI instance (for access to UTILS/AETHR)
--- @param Points (_vec2|_vec2xz|{x:number,y:number}|{x:number,z:number})[] Array of vec2/vec2xz tables
--- @param Area number Area considered for parameterization
--- @param RadiusExtension number|nil Extra radius added to computed cluster radius
--- @param params table|nil Optional overrides { f?: number, p?: number }
--- @return AETHR.AI.DBSCANNER self
--- @usage local dbscanner = self.AI.DBSCANNER:New(self.AI, pointsArray, areaValue, 0, { f = 2, p = 0.1 })
function AETHR.AI.DBSCANNER:New(ai, Points, Area, RadiusExtension, params)
  -- Lightweight constructor; no external frameworks.
  local instance = {
    AI = ai,
    AETHR = ai and ai.AETHR or AETHR,
    UTILS = ai and ai.UTILS or AETHR.UTILS,

    Points = Points or {},
    numPoints = (Points and #Points or 0),
    Area = Area or 0,
    _RadiusExtension = RadiusExtension or 0,

    _DBScan = {},
    Clusters = {},

    epsilon = 0,
    epsilon2 = 0,
    min_samples = 1,

    -- Defaults from module DATA with safe fallbacks
    f = (AETHR and AETHR.AI and AETHR.AI.DATA and AETHR.AI.DATA.DBSCANNER and AETHR.AI.DATA.DBSCANNER.f) or 2,
    p = (AETHR and AETHR.AI and AETHR.AI.DATA and AETHR.AI.DATA.DBSCANNER and AETHR.AI.DATA.DBSCANNER.p) or 0.1,
  }

  if params and type(params) == "table" then
    if params.f ~= nil then instance.f = params.f end
    if params.p ~= nil then instance.p = params.p end
  end

  setmetatable(instance, { __index = self })
  return instance:generateDBSCANparams()
end

--- Generates parameters for the DBSCAN algorithm based on the object's attributes.
---
--- This function calculates 'epsilon' and 'min_samples' for the DBSCAN algorithm, based on:
--- the number of points, the area, and specific factors 'f' and 'p'
--- It updates the object with these calculated values. 
---
--- @return AETHR.AI.DBSCANNER self The updated DBSCANNER object with newly calculated parameters.
--- @usage dbscanner:generateDBSCANparams() -- Updates the 'dbscanner' object with DBSCAN parameters.
function AETHR.AI.DBSCANNER:generateDBSCANparams()
  -- Safe calculations with guards
  local n = tonumber(self.numPoints) or 0
  if n <= 0 or not self.Area or self.Area <= 0 then
    self.epsilon = 0
    self.epsilon2 = 0
  else
    self.epsilon = (self.f or 2) * math.sqrt(self.Area / n)
    self.epsilon2 = self.epsilon * self.epsilon
  end
  self.min_samples = math.max(1, math.ceil((self.p or 0) * math.max(1, n)))

  -- Debug information consolidated
  if self.UTILS and self.UTILS.debugInfo then
    self.UTILS:debugInfo("AETHR.AI.DBSCANNER:generateDBSCANparams | ------------------------\n" ..
      "| NumPoints   | " .. tostring(n) .. "\n" ..
      "| ZoneArea    | " .. tostring(self.Area) .. "\n" ..
      "| f           | " .. tostring(self.f) .. "\n" ..
      "| p           | " .. tostring(self.p) .. "\n" ..
      "| epsilon     | " .. tostring(self.epsilon) .. "\n" ..
      "| min_samples | " .. tostring(self.min_samples))
  end

  return self
end

--- Executes the DBSCAN clustering algorithm and post-processes the clusters.
---
--- This function initiates the DBSCAN clustering process by calling '_DBScan' and then performs post-processing on the clusters formed. 
--- It structures the scanning process and post-processing as a sequence of operations on the DBSCANNER object.
---
--- @return AETHR.AI.DBSCANNER self The DBSCANNER object after completing the scan and post-processing steps.
--- @usage dbscanner:Scan() -- Performs the DBSCAN algorithm and post-processes the results.
function AETHR.AI.DBSCANNER:Scan()
  self:_DBScan()
  self:post_process_clusters()
  return self
end

--- Core function of the DBSCAN algorithm for clustering points.
---
--- This internal function implements the DBSCAN clustering algorithm. 
--- It initializes each point as unmarked, then iterates through each point to determine if it is a core point and expands clusters accordingly. 
--- Points are marked as either part of a cluster or as noise.
---
--- @return AETHR.AI.DBSCANNER self The DBSCANNER object with updated clustering information.
--- @usage dbscanner:_DBScan() -- Directly performs the DBSCAN clustering algorithm.
function AETHR.AI.DBSCANNER:_DBScan()
  -- Initialization
  local UNMARKED, NOISE = 0, -1
  local cluster_id = 0
  self._DBScan = {}

  -- Localize for speed
  local Points = self.Points or {}
  local min_samples = self.min_samples or 1

  -- Mark all points as unmarked initially (index-based labels)
  for i = 1, #Points do
    self._DBScan[i] = UNMARKED
  end

  -- Main clustering loop
  for i = 1, #Points do
    if self._DBScan[i] == UNMARKED then
      local neighbors = self:region_query(i)
      if #neighbors < min_samples then
        self._DBScan[i] = NOISE
      else
        cluster_id = cluster_id + 1
        self:expand_cluster(i, neighbors, cluster_id)
      end
    end
  end
  return self
end

--- Identifies neighboring points within a specified epsilon distance of a given point index.
---
--- @param index integer Index of the point in self.Points to query around.
--- @return neighbors integer[] List of neighbor indices within epsilon (including index itself).
--- @usage local neighbors = dbscanner:region_query(i) -- Finds neighbors of point i.
function AETHR.AI.DBSCANNER:region_query(index)
  local Points = self.Points or {}

  local function _toXY(obj)
    if obj == nil then return { x = 0, y = 0 } end
    return self.UTILS:normalizePoint(obj)
  end

  -- Debug information consolidated
  if self.UTILS and self.UTILS.debugInfo then
    self.UTILS:debugInfo("AETHR.AI.DBSCANNER:region_query | idx | " .. tostring(index))
  end

  local p = _toXY(Points[index])
  local eps2 = self.epsilon2 or ((self.epsilon or 0) * (self.epsilon or 0))
  if eps2 <= 0 then return {} end

  local neighbors = {}
  -- Iterate through points and find neighbors within the epsilon distance (squared)
  for j = 1, #Points do
    local q = _toXY(Points[j])
    local dx = p.x - q.x
    local dy = p.y - q.y
    if (dx * dx + dy * dy) <= eps2 then
      neighbors[#neighbors + 1] = j
    end
  end
  return neighbors
end

--- Expands a cluster around a given point index based on its neighbors and a specified cluster ID.
---
--- This function adds a given point (by index) and its neighbor indices to a cluster identified by 'cluster_id'.
--- It iteratively checks each neighbor and includes them in the cluster if they are not already part of another cluster or marked as noise.
--- The function also discovers new neighbors of neighbors, expanding the cluster until no further additions are possible.
---
--- @param pointIndex integer Index of the core point used to seed/expand the cluster
--- @param neighbors integer[] Neighbor indices (including the core index)
--- @param cluster_id integer The identifier of the cluster being expanded
--- @return AETHR.AI.DBSCANNER self The updated DBSCANNER object (for chaining)
--- @usage dbscanner:expand_cluster(i, neighbors, clusterId)
function AETHR.AI.DBSCANNER:expand_cluster(pointIndex, neighbors, cluster_id)
  if self.UTILS and self.UTILS.debugInfo then
    self.UTILS:debugInfo("AETHR.AI.DBSCANNER:expand_cluster | -------------------------------------------- ")
    self.UTILS:debugInfo("AETHR.AI.DBSCANNER:expand_cluster | cluster_id  | " .. tostring(cluster_id))
    self.UTILS:debugInfo("AETHR.AI.DBSCANNER:expand_cluster | pointIndex  | " .. tostring(pointIndex))
  end
  local UNMARKED, NOISE = 0, -1
  local min_samples = self.min_samples or 1

  self._DBScan[pointIndex] = cluster_id
  local i = 1
  while i <= #neighbors do
    local nIdx = neighbors[i]
    if self._DBScan[nIdx] == NOISE or self._DBScan[nIdx] == UNMARKED then
      self._DBScan[nIdx] = cluster_id
      local new_neighbors = self:region_query(nIdx)
      if #new_neighbors >= min_samples then
        for _, nn in ipairs(new_neighbors) do
          neighbors[#neighbors + 1] = nn
        end
      end
    end
    i = i + 1
  end
  return self
end

--- Post-processes the clusters formed by the DBSCAN algorithm.
---
--- Computes center and radius in 2D for each cluster (skipping noise), and populates self.Clusters.
--- Output clusters contain original Points references, Center {x,y}, and Radius (meters).
---
--- @return AETHR.AI.DBSCANNER self The DBSCANNER object with Clusters populated
--- @usage dbscanner:post_process_clusters()
function AETHR.AI.DBSCANNER:post_process_clusters()
  if self.UTILS and self.UTILS.debugInfo then
    self.UTILS:debugInfo("AETHR.AI.DBSCANNER:post_process_clusters | -------------------------------------------- ")
  end

  local function _dist2(a, b)
    local dx = (a.x or 0) - (b.x or 0)
    local dy = (a.y or 0) - (b.y or 0)
    return dx * dx + dy * dy
  end

  local clusters = {}
  self.Clusters = {}

  -- Group points by cluster id (skip noise cluster -1)
  for i, pt in ipairs(self.Points or {}) do
    local cid = self._DBScan[i]
    if cid and cid > 0 then
      clusters[cid] = clusters[cid] or {}
      clusters[cid][#clusters[cid] + 1] = pt
    end
  end

  local out = {}
  for cluster, pts in pairs(clusters) do
    if cluster and cluster > 0 and type(pts) == "table" and #pts > 0 then
      local sum_x, sum_y = 0, 0
      for _, p in ipairs(pts) do
        local v = self.UTILS:normalizePoint(p)
        sum_x = sum_x + (v.x or 0)
        sum_y = sum_y + (v.y or 0)
      end
      local center = { x = sum_x / #pts, y = sum_y / #pts }

      local max_d2 = 0
      for _, p in ipairs(pts) do
        local v = self.UTILS:normalizePoint(p)
        local d2 = _dist2(center, v)
        if d2 > max_d2 then max_d2 = d2 end
      end

      local radius = math.sqrt(max_d2) + (self._RadiusExtension or 0)
      table.insert(out, {
        Points = pts,
        Center = center,
        Radius = radius,
      })
    end
  end

  self.Clusters = out
  return self
end

--- Convenience facade: cluster raw points (vec2/vec2xz only).
--- @function AETHR.AI:clusterPoints
--- @param points (_vec2|_vec2xz|{x:number,y:number}|{x:number,z:number})[] Array of points; each is { x=number, y=number } or { x=number, z=number }
--- @param area number Area to consider for epsilon calculation
--- @param opts table|nil { radiusExtension?: number, f?: number, p?: number }
--- @return AETHR.AI.DBSCAN_Cluster[] clusters Array of cluster result objects
function AETHR.AI:clusterPoints(points, area, opts)
  local radiusExtension = (opts and opts.radiusExtension) or 0
  local params = {}
  if opts then
    if opts.f ~= nil then params.f = opts.f end
    if opts.p ~= nil then params.p = opts.p end
  end
  local scanner = self.DBSCANNER:New(self, points or {}, area or 0, radiusExtension, params)
  scanner:Scan()
  return scanner.Clusters
end


