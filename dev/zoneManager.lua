--- @module AETHR.ZONE_MANAGER
--- @brief Manages mission trigger zones and computes bordering relationships.
---@diagnostic disable: undefined-global
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
                        if AETHR.POLY.isWithinOffset(lineA, lineB, zone1.BorderOffsetThreshold) then
                            borderIndex = borderIndex + 1 -- Increment the index for borders found

                            -- Initialize border data structure if it doesn't exist
                            local zoneBorder = MIZ_ZONES[zoneName1].BorderingZones[zoneName2] or {}
                            zoneBorder[borderIndex] = zoneBorder[borderIndex] or {}

                            -- Populate border details
                            local currentBorder = zoneBorder[borderIndex]
                            currentBorder.OwnedByCoalition = 0
                            currentBorder.ZoneLine = lineA
                            currentBorder.ZoneLineLen = AETHR.POLY.lineLength(lineA)
                            currentBorder.ZoneLineMidP = AETHR.POLY.getMidpoint(lineA)
                            currentBorder.ZoneLineSlope = AETHR.POLY.calculateLineSlope(lineA)
                            currentBorder.ZoneLinePerpendicularPoint = {}
                            currentBorder.NeighborLine = lineB
                            currentBorder.NeighborLineLen = AETHR.POLY.lineLength(lineB)
                            currentBorder.NeighborLineMidP = AETHR.POLY.getMidpoint(lineB)
                            currentBorder.NeighborLineSlope = AETHR.POLY.calculateLineSlope(lineB)
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

                            local _ZoneLinePerpendicularPoint = AETHR.POLY.findPerpendicularEndpoints(ArrowMP, line_,
                                length_)
                            local _NeighborLinePerpendicularPoint = AETHR.POLY.findPerpendicularEndpoints(ArrowMP,
                                NeighborLine_, NeighborLength_)

                            -- Adjust perpendicular points if needed to ensure they are within the zone shape
                            if AETHR.POLY.PointWithinShape(_ZoneLinePerpendicularPoint, MIZ_ZONES[zoneName1].verticies) then
                                currentBorder.ZoneLinePerpendicularPoint = AETHR.POLY.findPerpendicularEndpoints(ArrowMP,
                                    line_, length_)
                                currentBorder.NeighborLinePerpendicularPoint = AETHR.POLY.findPerpendicularEndpoints(
                                ArrowMP, NeighborLine_, NeighborLength_)
                            else
                                currentBorder.ZoneLinePerpendicularPoint = AETHR.POLY.findPerpendicularEndpoints(ArrowMP,
                                    NeighborLine_, NeighborLength_)
                                currentBorder.NeighborLinePerpendicularPoint = AETHR.POLY.findPerpendicularEndpoints(
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

