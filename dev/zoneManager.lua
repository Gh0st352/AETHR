AETHR.ZONE_MANAGER = {}

function AETHR.ZONE_MANAGER:New(AETHR)
    local instance = { AETHR = AETHR }
    setmetatable(instance, { __index = self })
    return instance
end

function AETHR.ZONE_MANAGER.determineBorderingZones(MIZ_ZONES)
    for zoneName1, zone1 in pairs(MIZ_ZONES) do
        for zoneName2, zone2 in pairs(MIZ_ZONES) do
            -- Ensure we're not comparing a zone with itself
            if zoneName1 ~= zoneName2 then
                local borderIndex = 0 -- Initialize index for potential borders

                -- Compare borders of zone1 with zone2
                for _, lineA in ipairs(zone1.LinesVec2) do
                    for _, lineB in ipairs(zone2.LinesVec2) do
                        -- Check if two lines are close enough to be considered bordering
                        if AETHR.math.isWithinOffset(lineA, lineB, zone1.BorderOffsetThreshold) then
                            borderIndex = borderIndex + 1 -- Increment the index for borders found

                            -- Initialize border data structure if it doesn't exist
                            local zoneBorder = MIZ_ZONES[zoneName1].BorderingZones[zoneName2] or {}
                            zoneBorder[borderIndex] = zoneBorder[borderIndex] or {}

                            -- Populate border details
                            local currentBorder = zoneBorder[borderIndex]
                            currentBorder.OwnedByCoalition = 0
                            currentBorder.ZoneLine = lineA
                            currentBorder.ZoneLineLen = AETHR.math.lineLength(lineA)
                            currentBorder.ZoneLineMidP = AETHR.math.getMidpoint(lineA)
                            currentBorder.ZoneLineSlope = AETHR.math.calculateLineSlope(lineA)
                            currentBorder.ZoneLinePerpendicularPoint = {}
                            currentBorder.NeighborLine = lineB
                            currentBorder.NeighborLineLen = AETHR.math.lineLength(lineB)
                            currentBorder.NeighborLineMidP = AETHR.math.getMidpoint(lineB)
                            currentBorder.NeighborLineSlope = AETHR.math.calculateLineSlope(lineB)
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

                            local _ZoneLinePerpendicularPoint = AETHR.math.findPerpendicularEndpoints(ArrowMP, line_,
                                length_)
                            local _NeighborLinePerpendicularPoint = AETHR.math.findPerpendicularEndpoints(ArrowMP,
                                NeighborLine_, NeighborLength_)

                            -- Adjust perpendicular points if needed to ensure they are within the zone shape
                            if AETHR.math.PointWithinShape(_ZoneLinePerpendicularPoint, MIZ_ZONES[zoneName1].Vertices2D) then
                                currentBorder.ZoneLinePerpendicularPoint = AETHR.math.findPerpendicularEndpoints(ArrowMP,
                                    line_, length_)
                                currentBorder.NeighborLinePerpendicularPoint = AETHR.math.findPerpendicularEndpoints(
                                ArrowMP, NeighborLine_, NeighborLength_)
                            else
                                currentBorder.ZoneLinePerpendicularPoint = AETHR.math.findPerpendicularEndpoints(ArrowMP,
                                    NeighborLine_, NeighborLength_)
                                currentBorder.NeighborLinePerpendicularPoint = AETHR.math.findPerpendicularEndpoints(
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

function AETHR:setMizZones(zoneNames)
    self.CONFIG.MIZ_ZONES.ALL = zoneNames
    return self
end

function AETHR:setRedStartMizZones(zoneNames)
    self.CONFIG.MIZ_ZONES.REDSTART = zoneNames
    return self
end

function AETHR:setBlueStartMizZones(zoneNames)
    self.CONFIG.MIZ_ZONES.BLUESTART = zoneNames
    return self
end

function AETHR:getMizZoneData()
    local configData = self.fileOps.loadTableFromJSON(
        self.CONFIG.STORAGE.PATHS.MAP_FOLDER,
        self.CONFIG.STORAGE.FILENAMES.MIZ_ZONES_FILE
    )
    if configData then
        for k, v in pairs(configData) do
            self.MIZ_ZONES[v.name] = v
        end
    else
        if self.CONFIG.MIZ_ZONES.ALL == nil or #self.CONFIG.MIZ_ZONES.ALL == 0 then return self end
        local envZones_ = env.mission.triggers.zones
        for _, zoneName in ipairs(self.CONFIG.MIZ_ZONES.ALL) do
            for __, envZone in ipairs(envZones_) do
                if envZone.name == zoneName then
                    self.MIZ_ZONES[zoneName] = {
                        name = envZone.name,
                        zoneId = envZone.zoneId,
                        type = envZone.type,
                        verticies = AETHR.math.ensureConvex(envZone.verticies),
                        ownedBy = 0,    -- Default to neutral
                        oldOwnedBy = 0, -- Default to neutral
                        markID = 0,     -- Default to no mark ID
                        readOnly = true,
                        BorderingZones = {},
                        Airbases = {},
                        LinesVec2 = {},
                    }
                    self.MIZ_ZONES[zoneName].LinesVec2 = AETHR.math.convertZoneToLines(self.MIZ_ZONES[zoneName]
                    .verticies)
                    break
                end
            end
        end
        self.MIZ_ZONES = AETHR.ZONE_MANAGER.determineBorderingZones(self.MIZ_ZONES)
        self.fileOps.saveTableAsPrettyJSON(
            self.CONFIG.STORAGE.PATHS.MAP_FOLDER,
            self.CONFIG.STORAGE.FILENAMES.MIZ_ZONES_FILE,
            self.MIZ_ZONES
        )
    end
    return self
end
