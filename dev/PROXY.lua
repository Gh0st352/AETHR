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
    divProxyDistanceAirUnits = 80000, --- Distance in meters
    divProxyDistanceHeliUnits = 40000,
    divProxyDistanceGroundUnits = 20000,
    divProxyDistanceSeaUnits = 40000,
    -- Debounce/hysteresis and scheduling
    presenceDwellMs = 5000,     -- ms to wait before clearing presence flags after last seen
    spawnDespawnDwellMs = 5000, -- ms to wait between spawn/despawn actions per group
    scanDivFraction = 1.0,      -- 0<frac≤1: fraction of divisions processed per invocation
    debug = false,              -- additional PROXY-local debug gating (requires CONFIG.MAIN.DEBUG_ENABLED)
    _cache = {},
    _airborneScanState = { ids = nil, idx = 1 },
}


--- Create a new PROXY instance attached to parent AETHR.
--- @param parent AETHR Parent AETHR instance (owner)
--- @return AETHR.PROXY instance
function AETHR.PROXY:New(parent)
    local instance = {
        AETHR = parent,
        -- submodule-local caches/state can be initialized here
        _cache = {},
        _airborneScanState = { ids = nil, idx = 1 },
    }
    setmetatable(instance, { __index = self })
    return instance ---@diagnostic disable-line
end

-- Category-specific airborne scan helpers (separate volumes/thresholds)
function AETHR.PROXY:scanDivisionAir(div)
    if not div then return false end
    local corners_ = div.proxyCornersAir or div.corners
    if not corners_ then return false end
    local corners = self.UTILS:vec2xyToVec2xz(corners_)
    local height = div.heightAir or div.height or 100000
    local cats = { self.ENUMS.UnitCategory.AIRPLANE }
    local found = self.WORLD:searchObjectsBox(self.ENUMS.ObjectCategory.UNIT, corners, height, cats)
    return next(found) ~= nil
end

function AETHR.PROXY:scanDivisionHeli(div)
    if not div then return false end
    local corners_ = div.proxyCornersHeli or div.proxyCornersAir or div.corners
    if not corners_ then return false end
    local corners = self.UTILS:vec2xyToVec2xz(corners_)
    local height = div.heightHeli or div.height or 100000
    local cats = { self.ENUMS.UnitCategory.HELICOPTER }
    local found = self.WORLD:searchObjectsBox(self.ENUMS.ObjectCategory.UNIT, corners, height, cats)
    return next(found) ~= nil
end

-- Unified airborne proximity pass with hysteresis and optional scan cadence
function AETHR.PROXY:proximityDivAirborneUnits(co_)
    local co = co_ or
        (self.BRAIN and self.BRAIN.DATA and self.BRAIN.DATA.coroutines and (self.BRAIN.DATA.coroutines.proximityDivAirUnits or self.BRAIN.DATA.coroutines.proximityDivHeliUnits))
    local activeDivs = self.WORLD and self.WORLD.DATA and self.WORLD.DATA.saveDivisions or {}
    if not next(activeDivs) then
        self.BRAIN:maybeYield(co, "PROXY:proximityDivAirborneUnits - no active divs", 1)
        return self
    end

    -- Initialize/refresh scan state
    self.DATA._airborneScanState = self.DATA._airborneScanState or { ids = nil, idx = 1 }
    local state = self.DATA._airborneScanState
    if not state.ids then
        state.ids = {}
        for divID, _ in pairs(activeDivs) do state.ids[#state.ids + 1] = divID end
        table.sort(state.ids, function(a, b) return a < b end)
        state.idx = 1
    end

    local n = #state.ids
    local frac = tonumber(self.DATA and self.DATA.scanDivFraction) or 1.0
    if frac <= 0 then frac = 1.0 end
    if frac > 1 then frac = 1.0 end
    local toProcess = math.max(1, math.ceil(n * frac))
    local startIdx = state.idx
    local endIdx = math.min(startIdx + toProcess - 1, n)

    local nowSec = (self.UTILS and self.UTILS.getTime) and self.UTILS:getTime() or os.time()
    local nowMs = math.floor((tonumber(nowSec) or 0) * 1000)
    local dwellMs = tonumber(self.DATA and self.DATA.presenceDwellMs) or 5000

    for i = startIdx, endIdx do
        local divID = state and state.ids and state.ids[i] or nil
        if not divID then
            self.BRAIN:maybeYield(co, "PROXY:proximityDivAirborneUnits - missing divID", 1)
        else
            local div = activeDivs[divID]
            if div then
                local groups = div.groundGroups or {}
                if next(groups) ~= nil then
                    local hasAir = self:scanDivisionAir(div)
                    local hasHeli = self:scanDivisionHeli(div)
                    div._proxyAirLastSeenMs = div._proxyAirLastSeenMs or 0
                    div._proxyHeliLastSeenMs = div._proxyHeliLastSeenMs or 0

                    if hasAir then
                        if not div.proxyAirUnits and self.DATA and self.DATA.debug then
                            self.UTILS:debugInfo("PROXY: Air presence in div " .. tostring(divID))
                        end
                        div.proxyAirUnits = true
                        div._proxyAirLastSeenMs = nowMs
                    else
                        if div.proxyAirUnits and (nowMs - (div._proxyAirLastSeenMs or 0)) >= dwellMs then
                            if self.DATA and self.DATA.debug then
                                self.UTILS:debugInfo("PROXY: Air cleared in div " .. tostring(divID))
                            end
                            div.proxyAirUnits = false
                        end
                    end

                    if hasHeli then
                        if not div.proxyHeliUnits and self.DATA and self.DATA.debug then
                            self.UTILS:debugInfo("PROXY: Heli presence in div " .. tostring(divID))
                        end
                        div.proxyHeliUnits = true
                        div._proxyHeliLastSeenMs = nowMs
                    else
                        if div.proxyHeliUnits and (nowMs - (div._proxyHeliLastSeenMs or 0)) >= dwellMs then
                            if self.DATA and self.DATA.debug then
                                self.UTILS:debugInfo("PROXY: Heli cleared in div " .. tostring(divID))
                            end
                            div.proxyHeliUnits = false
                        end
                    end
                end
            end
            self.BRAIN:maybeYield(co, "PROXY:proximityDivAirborneUnits - Div", 1)
        end
    end

    state.idx = endIdx + 1
    if state.idx > n then
        state.idx = 1
        state.ids = nil
    end

    self.BRAIN:maybeYield(co, "PROXY:proximityDivAirborneUnits", 1)
    return self
end

function AETHR.PROXY:proximityDivAirUnits()
    local co_ = self.BRAIN.DATA.coroutines.proximityDivAirUnits
    return self:proximityDivAirborneUnits(co_)
end

function AETHR.PROXY:proximityDivHeliUnits()
    local co_ = self.BRAIN.DATA.coroutines.proximityDivHeliUnits
    return self:proximityDivAirborneUnits(co_)
end

function AETHR.PROXY:proximityDespawnDivGroundGroups()
    local co_ = self.BRAIN.DATA.coroutines.proximityDespawnDivGroundGroups
    local activeDivs = self.WORLD.DATA.saveDivisions or {}
    local nowSec = (self.UTILS and self.UTILS.getTime) and self.UTILS:getTime() or os.time()
    local nowMs = math.floor((tonumber(nowSec) or 0) * 1000)
    local dwellMs = tonumber(self.DATA and self.DATA.spawnDespawnDwellMs) or 5000

    for divID, div in pairs(activeDivs) do
        if div.proxyAirUnits or div.proxyHeliUnits then
            -- presence detected: skip despawn
        else
            local groundGroups = div.groundGroups or {}
            if next(groundGroups) ~= nil then
                for gName, gObj in pairs(groundGroups) do
                    if gObj._allowProxySpawn and gObj._spawned then
                        local last = tonumber(gObj._proxyLastChangeMs) or 0
                        if (nowMs - last) >= dwellMs then
                            self.SPAWNER:despawnGroup(gName)
                            gObj._proxyLastChangeMs = nowMs
                            gObj._proxyPending = false
                            if self.DATA and self.DATA.debug then
                                self.UTILS:debugInfo("PROXY: Despawn enqueued " .. tostring(gName))
                            end
                        end
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
    local nowSec = (self.UTILS and self.UTILS.getTime) and self.UTILS:getTime() or os.time()
    local nowMs = math.floor((tonumber(nowSec) or 0) * 1000)
    local dwellMs = tonumber(self.DATA and self.DATA.spawnDespawnDwellMs) or 5000

    for divID, div in pairs(activeDivs) do
        if div.proxyAirUnits or div.proxyHeliUnits then -- or div.proxyGroundUnits or div.proxySeaUnits
            local groundGroups = div.groundGroups or {}
            if next(groundGroups) ~= nil then
                for gName, gObj in pairs(groundGroups) do
                    if gObj._allowProxySpawn and not gObj._spawned and not gObj._proxyPending then
                        local last = tonumber(gObj._proxyLastChangeMs) or 0
                        if (nowMs - last) >= dwellMs then
                            self.SPAWNER:spawnGroup(gName)
                            gObj._proxyLastChangeMs = nowMs
                            gObj._proxyPending = true
                            if self.DATA and self.DATA.debug then
                                self.UTILS:debugInfo("PROXY: Spawn enqueued " .. tostring(gName))
                            end
                        end
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
