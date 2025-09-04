--- @class AETHR.ZONE_MANAGER
--- @brief Manages mission trigger zones and computes bordering relationships.
---@diagnostic disable: undefined-global
--- @field AETHR AETHR Parent AETHR instance (injected by AETHR:New)
--- @field CONFIG AETHR.CONFIG Configuration table attached per-instance.
--- @field FILEOPS AETHR.FILEOPS File operations helper table attached per-instance.
--- @field POLY AETHR.POLY Geometry helper table attached per-instance.
--- @field WORLD AETHR.WORLD World learning submodule attached per-instance.
--- @field ZONE_MANAGER AETHR.ZONE_MANAGER Zone management submodule attached per-instance.
--- @field DATA table Container for zone management data.
--- @field DATA.MIZ_ZONES table<string, _MIZ_ZONE> Loaded mission trigger zones.
AETHR.ZONE_MANAGER = {}

AETHR.ZONE_MANAGER.DATA = {
    MIZ_ZONES    = {},        -- Mission trigger zones keyed by name.
}


function AETHR.ZONE_MANAGER:New(parent)
    local instance = {
        AETHR = parent,
        -- submodule-local caches/state can be initialized here
        _cache = {},
    }
    setmetatable(instance, { __index = self })
    return instance
end


--- Sets mission trigger zone names (all, red and blue start).
--- @function AETHR:setMizZones
--- @param zoneNames string[] List of all mission trigger zone names.
--- @param RedStartZones string[]|nil Optional list of Red start mission trigger zones.
--- @param BlueStartZones string[]|nil Optional list of Blue start mission trigger zones.
--- @return AETHR.ZONE_MANAGER self
function AETHR.ZONE_MANAGER:setMizZones(zoneNames, RedStartZones, BlueStartZones)
    if not self.CONFIG.MAIN.MIZ_ZONES then self.CONFIG.MAIN.MIZ_ZONES = { ALL = {}, REDSTART = {}, BLUESTART = {} } end
    self.CONFIG.MAIN.MIZ_ZONES.ALL = zoneNames or {}
    if RedStartZones then self:setRedStartMizZones(RedStartZones) end
    if BlueStartZones then self:setBlueStartMizZones(BlueStartZones) end
    return self
end

--- Sets Red start mission trigger zones.
--- @function AETHR:setRedStartMizZones
--- @param zoneNames string[] List of Red start mission trigger zone names.
--- @return AETHR.ZONE_MANAGER self
function AETHR.ZONE_MANAGER:setRedStartMizZones(zoneNames)
    if not self.CONFIG.MAIN.MIZ_ZONES then self.CONFIG.MAIN.MIZ_ZONES = { ALL = {}, REDSTART = {}, BLUESTART = {} } end
    self.CONFIG.MAIN.MIZ_ZONES.REDSTART = zoneNames or {}
    return self
end

--- Sets Blue start mission trigger zones.
--- @function AETHR:setBlueStartMizZones
--- @param zoneNames string[] List of Blue start mission trigger zone names.
--- @return AETHR.ZONE_MANAGER self
function AETHR.ZONE_MANAGER:setBlueStartMizZones(zoneNames)
    if not self.CONFIG.MAIN.MIZ_ZONES then self.CONFIG.MAIN.MIZ_ZONES = { ALL = {}, REDSTART = {}, BLUESTART = {} } end
    self.CONFIG.MAIN.MIZ_ZONES.BLUESTART = zoneNames or {}
    return self
end

--- Initializes mission trigger zone data, loading existing or generating defaults.
--- @function AETHR:initMizZoneData
--- @return AETHR.ZONE_MANAGER self
function AETHR.ZONE_MANAGER:initMizZoneData()
    local data = self:getStoredMizZoneData()
    if data and type(data) == "table" then
        self.DATA.MIZ_ZONES = data
    else
        self:generateMizZoneData()
        self:saveMizZoneData()
    end
    return self
end

--- Loads mission trigger zone data from storage file if available.
--- @function AETHR:getStoredMizZoneData
--- @return table<string, _MIZ_ZONE>|nil Data table of mission trigger zones or nil if not found.
function AETHR.ZONE_MANAGER:getStoredMizZoneData()
    local mapPath = self.CONFIG.MAIN.STORAGE.PATHS.MAP_FOLDER
    local saveFile = self.CONFIG.MAIN.STORAGE.FILENAMES and self.CONFIG.MAIN.STORAGE.FILENAMES.MIZ_ZONES_FILE
    local data = self.FILEOPS.loadData(mapPath, saveFile)
    if data then return data end
    return nil
end

--- Saves current mission trigger zone data to storage file.
--- @function AETHR:saveMizZoneData
--- @return nil
function AETHR.ZONE_MANAGER:saveMizZoneData()
    local mapPath = self.CONFIG.MAIN.STORAGE.PATHS.MAP_FOLDER
    local saveFile = self.CONFIG.MAIN.STORAGE.FILENAMES and self.CONFIG.MAIN.STORAGE.FILENAMES.MIZ_ZONES_FILE
    self.FILEOPS.saveData(mapPath, saveFile, self.DATA.MIZ_ZONES)
end

--- Generates mission trigger zone data based on configured zone names and environment data.
--- Guards against missing env structures and missing constructors.
--- @function AETHR:generateMizZoneData
--- @return AETHR.ZONE_MANAGER self
function AETHR.ZONE_MANAGER:generateMizZoneData()
    local zoneNames = (self.CONFIG and self.CONFIG.MIZ_ZONES and self.CONFIG.MIZ_ZONES.ALL) or {}
    if not zoneNames or #zoneNames == 0 then
        return self
    end

    local envZones = {}
    if env.mission.triggers.zones then envZones = env.mission.triggers.zones end

    local mzCtor = self.AETHR._MIZ_ZONE or AETHR._MIZ_ZONE
    for _, zoneName in ipairs(zoneNames) do
        for _, envZone in ipairs(envZones) do
            if envZone and envZone.name == zoneName then
                self.DATA.MIZ_ZONES[zoneName] = mzCtor:New(envZone)
                break
            end
        end
    end
    self.DATA.MIZ_ZONES = self:determineBorderingZones(self.DATA.MIZ_ZONES)
    return self
end

--- Determine bordering zones.
--- @param MIZ_ZONES table<string, _MIZ_ZONE> Map of mission trigger zones.
--- @return table Updated MIZ_ZONES with .BorderingZones populated.
function AETHR.ZONE_MANAGER:determineBorderingZones(MIZ_ZONES)
    --- @type AETHR.POLY
    local POLY = self.POLY
    for zoneName1, zone1 in pairs(MIZ_ZONES) do
        for zoneName2, zone2 in pairs(MIZ_ZONES) do
            -- Ensure we're not comparing a zone with itself
            if zoneName1 ~= zoneName2 then
                local borderIndex = 0 -- Initialize index for potential borders

                -- Compare borders of zone1 with zone2
                for _, lineA in ipairs(zone1.LinesVec2) do
                    for _, lineB in ipairs(zone2.LinesVec2) do
                        -- Check if two lines are close enough to be considered bordering
                        if self.POLY.isWithinOffset(lineA, lineB, zone1.BorderOffsetThreshold) then
                            borderIndex = borderIndex + 1 -- Increment the index for borders found

                            -- Initialize border data structure if it doesn't exist
                            local zoneBorder = MIZ_ZONES[zoneName1].BorderingZones[zoneName2] or {}
                            zoneBorder[borderIndex] = zoneBorder[borderIndex] or {}

                            -- Populate border details
                            local currentBorder = zoneBorder[borderIndex]
                            currentBorder.OwnedByCoalition = 0
                            currentBorder.ZoneLine = lineA
                            currentBorder.ZoneLineLen = POLY.lineLength(lineA)
                            currentBorder.ZoneLineMidP = POLY.getMidpoint(lineA)
                            currentBorder.ZoneLineSlope = POLY.calculateLineSlope(lineA)
                            currentBorder.ZoneLinePerpendicularPoint = {}
                            currentBorder.NeighborLine = lineB
                            currentBorder.NeighborLineLen = POLY.lineLength(lineB)
                            currentBorder.NeighborLineMidP = POLY.getMidpoint(lineB)
                            currentBorder.NeighborLineSlope = POLY.calculateLineSlope(lineB)
                            currentBorder.NeighborLinePerpendicularPoint = {}
                            currentBorder.MarkID = {
                                [0] = 0,
                                [1] = 0,
                                [2] = 0,
                            }

                            -- Determine the perpendicular points and update them
                            local ArrowMP, line_, NeighborLine_, length_, NeighborLength_
                            if currentBorder.ZoneLineLen <= currentBorder.NeighborLineLen then
                                ArrowMP = currentBorder.ZoneLineMidP
                                line_ = currentBorder.ZoneLine
                                NeighborLine_ = { [1] = line_[2], [2] = line_[1] }
                                length_ = MIZ_ZONES[zoneName1].ArrowLength
                                NeighborLength_ = -(length_)
                            else
                                ArrowMP = currentBorder.NeighborLineMidP
                                line_ = currentBorder.NeighborLine
                                NeighborLine_ = { [1] = line_[2], [2] = line_[1] }
                                length_ = MIZ_ZONES[zoneName1].ArrowLength
                                NeighborLength_ = -(length_)
                            end

                            local _ZoneLinePerpendicularPoint = POLY.findPerpendicularEndpoints(ArrowMP, line_,
                                length_)
                            local _NeighborLinePerpendicularPoint = POLY.findPerpendicularEndpoints(ArrowMP,
                                NeighborLine_, NeighborLength_)

                            -- Adjust perpendicular points if needed to ensure they are within the zone shape
                            if POLY.PointWithinShape(_ZoneLinePerpendicularPoint, MIZ_ZONES[zoneName1].verticies) then
                                currentBorder.ZoneLinePerpendicularPoint = POLY.findPerpendicularEndpoints(ArrowMP,
                                    line_, length_)
                                currentBorder.NeighborLinePerpendicularPoint = POLY.findPerpendicularEndpoints(
                                    ArrowMP, NeighborLine_, NeighborLength_)
                            else
                                currentBorder.ZoneLinePerpendicularPoint = POLY.findPerpendicularEndpoints(ArrowMP,
                                    NeighborLine_, NeighborLength_)
                                currentBorder.NeighborLinePerpendicularPoint = POLY.findPerpendicularEndpoints(
                                    ArrowMP, line_, length_)
                            end

                            -- Save back the updated border data
                            MIZ_ZONES[zoneName1].BorderingZones[zoneName2] = zoneBorder
                        end
                    end
                end
            end
        end
    end
    return MIZ_ZONES
end
