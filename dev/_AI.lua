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

--- Spawner-managed data container.
--- @class AETHR.AI.DATA
--- @field DBSCANNER AETHR.AI.DBSCANNER DBSCAN clustering utility.

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
function AETHR.AI.DBSCANNER:New(Points, Area, RadiusExtension)
  local self=BASE:Inherit(self, AETHR:New())
  self.Points = Points
  self.numPoints = #Points
  self.Area = Area
  self._RadiusExtension = RadiusExtension or 0
  self:generateDBSCANparams()
  return self
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
  -- Initial calculations
  local n = self.numPoints
  self.epsilon = self.f * math.sqrt(self.Area / n)
  self.min_samples = math.ceil(self.p * n)

  -- Debug information consolidated
  AETHR.UTILS.debugInfo("AETHR.AI.DBSCANNER:generateDBSCANparams | ------------------------\n" ..
    "| NumUnits    | " .. n .. "\n" ..
    "| ZoneArea    | " .. self.Area .. "\n" ..
    "| f           | " .. self.f .. "\n" ..
    "| p           | " .. self.p .. "\n" ..
    "| epsilon     | " .. self.epsilon .. "\n" ..
    "| min_samples | " .. self.min_samples)

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
  local function _distance(point1, point2)
    -- Calculate the differences in x and y coordinates between the two points
    local dx = point1.x - point2.x
    local dy = point1.y - point2.y

    -- Use the Pythagorean theorem to compute the distance
    return math.sqrt(dx^2 + dy^2)
  end
  -- Debug information consolidated
  AETHR.UTILS.debugInfo("AETHR.ZONEMGR.Zone:region_query | --------------------------------------------\n" ..
    "| point       | ", point)

  local neighbors = {}
  -- Iterate through detected units and find neighbors within the epsilon distance
  for _, unit in ipairs(self.Points) do
    if _distance(point.vec2, unit.vec2) < self.epsilon then
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
  AETHR.UTILS.debugInfo("AETHR.ZONEMGR.Zone:expand_cluster | -------------------------------------------- ")
  AETHR.UTILS.debugInfo("AETHR.ZONEMGR.Zone:expand_cluster | cluster_id  | " .. cluster_id)
  AETHR.UTILS.debugInfo("AETHR.ZONEMGR.Zone:expand_cluster | point       | ", point)
  AETHR.UTILS.debugInfo("AETHR.ZONEMGR.Zone:expand_cluster | neighbors   | ", neighbors)
  AETHR.UTILS.debugInfo("AETHR.ZONEMGR.Zone:expand_cluster | labels      | ", self._DBScan)
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
  AETHR.UTILS.debugInfo("AETHR.ZONEMGR.Zone:post_process_clusters | -------------------------------------------- ")
  local function _distance(point1, point2)
    -- Calculate the differences in x and y coordinates between the two points
    local dx = point1.x - point2.x
    local dy = point1.y - point2.y

    -- Use the Pythagorean theorem to compute the distance
    return math.sqrt(dx^2 + dy^2)
  end
  local clusters = {}
  local cluster_centers = {}
  local cluster_radii = {}
  self.Clusters = {}
  -- Group units by cluster
  for _, unit in ipairs(self.Points) do
    local cluster = self._DBScan[unit.unit]
    if not clusters[cluster] then
      clusters[cluster] = {}
    end
    table.insert(clusters[cluster], unit)
  end

  -- Compute center and radius for each cluster
  for cluster, units in pairs(clusters) do
    local sum_x = 0
    local sum_y = 0
    local max_radius = 0
    for _, unit in ipairs(units) do
      sum_x = sum_x + unit.vec2.x
      sum_y = sum_y + unit.vec2.y
    end
    local center = {x = sum_x / #units, y = sum_y / #units}
    cluster_centers[cluster] = center

    for _, unit in ipairs(units) do
      local distance = _distance(center, unit.vec2)
      if distance > max_radius then
        max_radius = distance
      end
    end
    cluster_radii[cluster] = max_radius
  end

  local sorted_groups = {}
  for cluster, units in pairs(clusters) do
    if cluster > 0 then
      table.insert(sorted_groups, {
        Units = units,
        Center = cluster_centers[cluster],
        CenterVec3 = mist.utils.makeVec3(cluster_centers[cluster]),
        Radius = cluster_radii[cluster] + self._RadiusExtension,
      })
    end
  end
  self.Clusters = sorted_groups
  return self
end



