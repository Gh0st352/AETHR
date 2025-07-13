AETHR.ZONE_MANAGER = {}

function AETHR.ZONE_MANAGER:New(AETHR)
    local instance = { AETHR = AETHR }
    setmetatable(instance, { __index = self })
    return instance
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
                    }
                    break
                end
            end
        end

        self.fileOps.saveTableAsPrettyJSON(
            self.CONFIG.STORAGE.PATHS.MAP_FOLDER,
            self.CONFIG.STORAGE.FILENAMES.MIZ_ZONES_FILE,
            self.MIZ_ZONES
        )
    end
    return self
end
