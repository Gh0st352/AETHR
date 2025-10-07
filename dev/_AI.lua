--- @class AETHR.AI
---@diagnostic disable: undefined-global
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
--- @field DATA AETHR.AI.DATA Container for spawner-managed data.
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

--- Spawner-managed data container.
--- @class AETHR.AI.DATA

--- @class AETHR.AI.DATA.DBSCANNER
--- @field params table Parameters for DBSCAN algorithm.
--- @field _DBScan table Internal state for DBSCAN algorithm.
--- @field Clusters table List of clusters formed by DBSCAN.
--- @field Points table List of points to be clustered.
--- @field numPoints number Number of points.
--- @field f number Scaling factor for epsilon calculation.
--- @field p number Proportion for min_samples calculation.
--- @field epsilon number Epsilon distance for DBSCAN.
--- @field min_samples number Minimum samples for core point in DBSCAN.
--- @field Area number Area considered for clustering.
--- @field _RadiusExtension number Additional radius extension for clusters.

--- Container for spawner-managed data.
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
        min_samples = 0,
        Area = 0,
        _RadiusExtension = 0,
    },
}

-- Class table for DBSCAN utility
AETHR.AI.DBSCANNER = {}




--- Constructs a new DBSCANNER object.
--
-- This function initializes a new DBSCANNER object with specified parameters. 
-- It sets up the points, area, and radius extension for the DBSCAN algorithm. 
-- It also calls 'generateDBSCANparams' to calculate necessary parameters for the DBSCAN process.
--
-- @param Points An array of points for the DBSCAN algorithm.
-- @param Area The area to be considered for the DBSCAN algorithm.
-- @param RadiusExtension The radius extension value for the DBSCAN calculations.
-- @return self The newly created DBSCANNER object.
-- @usage local dbscanner = AETHR.AI.DBSCANNER:New(pointsArray, areaValue, radiusExtension)
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
--
-- This function calculates 'epsilon' and 'min_samples' for the DBSCAN algorithm, based on:
-- the number of points, the area, and specific factors 'f' and 'p'
-- It updates the object with these calculated values. 
--
-- @return self The updated DBSCANNER object with newly calculated parameters.
-- @usage dbscanner:generateDBSCANparams() -- Updates the 'dbscanner' object with DBSCAN parameters.
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
      "| NumUnits    | " .. tostring(n) .. "\n" ..
      "| ZoneArea    | " .. tostring(self.Area) .. "\n" ..
      "| f           | " .. tostring(self.f) .. "\n" ..
      "| p           | " .. tostring(self.p) .. "\n" ..
      "| epsilon     | " .. tostring(self.epsilon) .. "\n" ..
      "| min_samples | " .. tostring(self.min_samples))
  end

  return self
end

--- Executes the DBSCAN clustering algorithm and post-processes the clusters.
--
-- This function initiates the DBSCAN clustering process by calling '_DBScan' and then performs post-processing on the clusters formed. 
-- It structures the scanning process and post-processing as a sequence of operations on the DBSCANNER object.
--
-- @return self The DBSCANNER object after completing the scan and post-processing steps.
-- @usage dbscanner:Scan() -- Performs the DBSCAN algorithm and post-processes the results.
function AETHR.AI.DBSCANNER:Scan()
  self:_DBScan()
  self:post_process_clusters()
  return self
end

--- Core function of the DBSCAN algorithm for clustering points.
--
-- This internal function implements the DBSCAN clustering algorithm. 
-- It initializes each point as unmarked, then iterates through each point to determine if it is a core point and expands clusters accordingly. 
-- Points are marked as either part of a cluster or as noise.
--
-- @return self The DBSCANNER object with updated clustering information.
-- @usage dbscanner:_DBScan() -- Directly performs the DBSCAN clustering algorithm.
function AETHR.AI.DBSCANNER:_DBScan()
  -- Initialization
  local UNMARKED, NOISE = 0, -1
  local cluster_id = 0
  self._DBScan = {}
  -- Mark all units as unmarked initially
  for _, unit in ipairs(self.Points) do
    self._DBScan[unit.unit] = UNMARKED
  end
  -- Main clustering loop
  for _, unit in ipairs(self.Points) do
    if self._DBScan[unit.unit] == UNMARKED then
      local neighbors = self:region_query(unit)
      if #neighbors < self.min_samples then
        self._DBScan[unit.unit] = NOISE
      else
        cluster_id = cluster_id + 1
        self:expand_cluster(unit, neighbors, cluster_id)
      end
    end
  end
  return self
end

--- Identifies neighboring points within a specified epsilon distance of a given point.
--
-- This function searches for neighbors of a given 'point' within the 'epsilon' radius. 
-- It utilizes a private function '_distance' to calculate the Euclidean distance between points. 
-- The function is used within the DBSCAN algorithm to find points in the epsilon neighborhood of a given point.
--
-- @param point The point around which neighbors are to be found.
-- @return neighbors A list of neighboring points within the epsilon distance of the given point.
-- @usage local neighbors = dbscanner:region_query(specificPoint) -- Finds neighbors of 'specificPoint'.
function AETHR.AI.DBSCANNER:region_query(point)
  local function _toXY(obj)
    if obj == nil then return { x = 0, y = 0 } end
    if obj.vec2 ~= nil then
      return self.UTILS:normalizePoint(obj.vec2)
    end
    return self.UTILS:normalizePoint(obj)
  end

  -- Debug information consolidated
  if self.UTILS and self.UTILS.debugInfo then
    self.UTILS:debugInfo("AETHR.AI.DBSCANNER:region_query | --------------------------------------------\n" ..
      "| point       | ", point)
  end

  local p = _toXY(point)
  local eps2 = self.epsilon2 or ((self.epsilon or 0) * (self.epsilon or 0))

  local neighbors = {}
  -- Iterate through detected units and find neighbors within the epsilon distance (squared)
  for _, unit in ipairs(self.Points or {}) do
    local q = _toXY(unit)
    local dx = p.x - q.x
    local dy = p.y - q.y
    if (dx * dx + dy * dy) <= eps2 then
      table.insert(neighbors, unit)
    end
  end
  return neighbors
end

--- Expands a cluster around a given point based on its neighbors and a specified cluster ID.
--
-- This function adds a given point and its neighbors to a cluster identified by 'cluster_id'. 
-- It iteratively checks each neighbor and includes them in the cluster if they are not already part of another cluster or marked as noise. 
-- The function also discovers new neighbors of neighbors, expanding the cluster until no further additions are possible.
--
-- @param point The point around which the cluster is being expanded.
-- @param neighbors The initial set of neighbors of the point.
-- @param cluster_id The identifier of the cluster being expanded.
-- @return self The updated DBSCANNER object after expanding the cluster.
-- @usage dbscanner:expand_cluster(corePoint, initialNeighbors, clusterId) -- Expands a cluster around 'corePoint'.
function AETHR.AI.DBSCANNER:expand_cluster(point, neighbors, cluster_id)
  if self.UTILS and self.UTILS.debugInfo then
    self.UTILS:debugInfo("AETHR.AI.DBSCANNER:expand_cluster | -------------------------------------------- ")
    self.UTILS:debugInfo("AETHR.AI.DBSCANNER:expand_cluster | cluster_id  | " .. tostring(cluster_id))
    self.UTILS:debugInfo("AETHR.AI.DBSCANNER:expand_cluster | point       | ", point)
    self.UTILS:debugInfo("AETHR.AI.DBSCANNER:expand_cluster | neighbors   | ", neighbors)
    self.UTILS:debugInfo("AETHR.AI.DBSCANNER:expand_cluster | labels      | ", self._DBScan)
  end
  local UNMARKED, NOISE = 0, -1
  self._DBScan[point.unit] = cluster_id
  local i = 1
  while i <= #neighbors do
    local neighbor = neighbors[i]
    if self._DBScan[neighbor.unit] == NOISE or self._DBScan[neighbor.unit] == UNMARKED then
      self._DBScan[neighbor.unit] = cluster_id
      local new_neighbors = self:region_query(neighbor)
      if #new_neighbors >= self.min_samples then
        for _, new_neighbor in ipairs(new_neighbors) do
          table.insert(neighbors, new_neighbor)
        end
      end
    end
    i = i + 1
  end
  return self
end

--- Post-processes the clusters formed by the DBSCAN algorithm.
--
-- After clustering is done, this function processes each cluster to compute its center, radius, and other relevant details. 
-- It organizes the clusters into a sorted array and calculates the center and radius for each cluster, including any radius extension. 
-- The results are stored in the 'Clusters' attribute of the DBSCANNER object.
--
-- @return self The updated DBSCANNER object with fully processed clusters.
-- @usage dbscanner:post_process_clusters() -- Post-processes clusters to compute centers and radii.
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

  -- Group units by cluster id
  for _, unit in ipairs(self.Points or {}) do
    local cluster = self._DBScan[unit.unit]
    clusters[cluster] = clusters[cluster] or {}
    table.insert(clusters[cluster], unit)
  end

  local out = {}
  for cluster, units in pairs(clusters) do
    if cluster and cluster > 0 and type(units) == "table" and #units > 0 then
      local sum_x, sum_y = 0, 0
      for _, u in ipairs(units) do
        local ux = u.vec2 and u.vec2.x or 0
        local uy = u.vec2 and (u.vec2.y or u.vec2.z) or 0
        sum_x = sum_x + ux
        sum_y = sum_y + uy
      end
      local center = { x = sum_x / #units, y = sum_y / #units }

      local max_d2 = 0
      for _, u in ipairs(units) do
        local uv = { x = (u.vec2 and u.vec2.x or 0), y = (u.vec2 and (u.vec2.y or u.vec2.z) or 0) }
        local d2 = _dist2(center, uv)
        if d2 > max_d2 then max_d2 = d2 end
      end

      local radius = math.sqrt(max_d2) + (self._RadiusExtension or 0)
      table.insert(out, {
        Units = units,
        Center = center,
        CenterVec3 = self.AETHR._vec3:New(center.x, 0, center.y),
        Radius = radius,
      })
    end
  end

  self.Clusters = out
  return self
end

--- Convenience facade: cluster standardized points { unit, vec2 = { x, y } }.
--- @function AETHR.AI:clusterPoints
--- @param points table Array of items with fields: unit, vec2={x,y}
--- @param area number Area to consider for epsilon calculation
--- @param opts table|nil { radiusExtension?: number, f?: number, p?: number }
--- @return table clusters Array of { Units, Center, CenterVec3, Radius }
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



