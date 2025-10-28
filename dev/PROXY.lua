--- @class AETHR.PROXY
--- @brief Manages proximity detection and object lookups via division mapping for handling and changing game states based on unit locations.
---@diagnostic disable: undefined-global
--- @field AETHR AETHR Parent AETHR instance (injected by AETHR:New)
--- @field CONFIG AETHR.CONFIG Configuration table attached per-instance.
--- @field FILEOPS AETHR.FILEOPS File operations helper table attached per-instance.
--- @field POLY AETHR.POLY Geometry helper table attached per-instance.
--- @field UTILS AETHR.UTILS Utility functions submodule attached per-instance.
--- @field BRAIN AETHR.BRAIN
--- @field AI AETHR.AI
--- @field ENUMS AETHR.ENUMS Enumeration constants submodule attached per-instance.
--- @field AUTOSAVE AETHR.AUTOSAVE Autosave submodule attached per-instance.
--- @field MATH AETHR.MATH Math helper table attached per-instance.
--- @field MARKERS AETHR.MARKERS
--- @field SPAWNER AETHR.SPAWNER Spawner submodule attached per-instance.
--- @field WORLD AETHR.WORLD World learning submodule attached per-instance.
--- @field ZONE_MANAGER AETHR.ZONE_MANAGER Zone management submodule attached per-instance.
--- @field DATA AETHR.PROXY.Data Container for zone management data.
--- @field divisionBaseObjects table<number, table<number, _FoundObject>>
AETHR.PROXY = {} ---@diagnostic disable-line


---@class AETHR.PROXY.Data
AETHR.PROXY.DATA = {
    divProxyDistanceAirUnits = 160934, --- Distance in meters
    divProxyDistanceHeliUnits = 48280,
    divProxyDistanceGroundUnits = 24140,
    divProxyDistanceSeaUnits = 160934,
}

---TODO Check if Proxy Air/Heli Units are spawned or active in game, if no, do not include in foundobjects

--- Create a new PROXY instance attached to parent AETHR.
--- @param parent AETHR Parent AETHR instance (owner)
--- @return AETHR.PROXY instance
function AETHR.PROXY:New(parent)
    local instance = {
        AETHR = parent,
        -- submodule-local caches/state can be initialized here
        _cache = {},
    }
    setmetatable(instance, { __index = self })
    return instance ---@diagnostic disable-line
end

function AETHR.PROXY:proximityDivAirUnits()
    local co_ = self.BRAIN.DATA.coroutines.proximityDivAirUnits
    local activeDivs = self.WORLD.DATA.saveDivisions or {}
    local unitCats = { self.ENUMS.UnitCategory.AIRPLANE }
    for divID, div in pairs(activeDivs) do
        if div.groundGroups ~= {} then
            local corners_ = div.proxyCornersAir
            local corners = self.UTILS:vec2xyToVec2xz(corners_)
            local height = div.height
            local foundObjects = self.WORLD:searchObjectsBox(self.ENUMS.ObjectCategory.UNIT, corners, height, unitCats)
            if self.UTILS.sumTable(foundObjects) > 0 then
                self.UTILS:debugInfo("PROXY: Found air units in proximity of division ID " .. divID)
                div.proxyAirUnits = true
            else
                div.proxyAirUnits = false
            end
            local pause = ""
        end
        self.BRAIN:maybeYield(co_, "PROXY:proximityDivAirUnits - Between Divs", 1)
    end
    self.BRAIN:maybeYield(co_, "PROXY:proximityDivAirUnits", 1)
    return self
end

function AETHR.PROXY:proximityDivHeliUnits()
    local co_ = self.BRAIN.DATA.coroutines.proximityDivHeliUnits
    local activeDivs = self.WORLD.DATA.saveDivisions or {}
    local unitCats = { self.ENUMS.UnitCategory.HELICOPTER }
    for divID, div in pairs(activeDivs) do
        if div.groundGroups ~= {} then
            local corners_ = div.proxyCornersAir
            local corners = self.UTILS:vec2xyToVec2xz(corners_)
            local height = div.height
            local foundObjects = self.WORLD:searchObjectsBox(self.ENUMS.ObjectCategory.UNIT, corners, height, unitCats)
            if self.UTILS.sumTable(foundObjects) > 0 then
                self.UTILS:debugInfo("PROXY: Found Heli units in proximity of division ID " .. divID)
                div.proxyHeliUnits = true
            else
                div.proxyHeliUnits = false
            end
            local pause = ""
        end
        self.BRAIN:maybeYield(co_, "PROXY:proximityDivHeliUnits - Between Divs", 1)
    end
    self.BRAIN:maybeYield(co_, "PROXY:proximityDivHeliUnits", 1)
    return self
end

function AETHR.PROXY:proximityDespawnDivGroundGroups()
    local co_ = self.BRAIN.DATA.coroutines.proximityDespawnDivGroundGroups
    local activeDivs = self.WORLD.DATA.saveDivisions or {}
    for divID, div in pairs(activeDivs) do
        if div.proxyAirUnits or div.proxyHeliUnits then -- or div.proxyGroundUnits or div.proxySeaUnits
            -- Do not despawn if air or heli units are present
        else
            local groundGroups = div.groundGroups or {}
            if groundGroups ~= {} then
                for gName, gObj in pairs(groundGroups) do
                    if gObj._allowProxySpawn and gObj._spawned then
                        self.SPAWNER:despawnGroup(gName)
                    end
                    self.BRAIN:maybeYield(co_, "PROXY:proximityDespawnDivGroundGroups - Group", 1)
                end
            end
        end
        self.BRAIN:maybeYield(co_, "PROXY:proximityDespawnDivGroundGroups - Div", 1)
    end

    self.BRAIN:maybeYield(co_, "PROXY:proximityDespawnDivGroundGroups", 1)
    return self
end

function AETHR.PROXY:proximitySpawnDivGroundGroups()
    local co_ = self.BRAIN.DATA.coroutines.proximitySpawnDivGroundGroups
    local activeDivs = self.WORLD.DATA.saveDivisions or {}
    for divID, div in pairs(activeDivs) do
        if div.proxyAirUnits or div.proxyHeliUnits then -- or div.proxyGroundUnits or div.proxySeaUnits
            local groundGroups = div.groundGroups or {}
            if groundGroups ~= {} then
                for gName, gObj in pairs(groundGroups) do
                    if gObj._allowProxySpawn and not gObj._spawned then
                        self.SPAWNER:spawnGroup(gName)
                    end
                    self.BRAIN:maybeYield(co_, "PROXY:proximitySpawnDivGroundGroups - Group", 1)
                end
            end
        else
            -- Do not spawn if no air or heli units are present
        end
        self.BRAIN:maybeYield(co_, "PROXY:proximitySpawnDivGroundGroups - Div", 1)
    end
    self.BRAIN:maybeYield(co_, "PROXY:proximitySpawnDivGroundGroups", 1)
    return self
end
