--- @class AETHR.AUTOSAVE
--- @brief Manages mission trigger zones and computes bordering relationships.
---@diagnostic disable: undefined-global
--- @field AETHR AETHR Parent AETHR instance (injected by AETHR:New)
--- @field CONFIG AETHR.CONFIG Configuration table attached per-instance.
--- @field FILEOPS AETHR.FILEOPS File operations helper table attached per-instance.
--- @field POLY AETHR.POLY Geometry helper table attached per-instance.
--- @field WORLD AETHR.WORLD World learning submodule attached per-instance.
--- @field MARKERS AETHR.MARKERS Markers submodule attached per-instance.
--- @field MATH AETHR.MATH Math helper table attached per-instance.
--- @field ENUMS AETHR.ENUMS ENUMS submodule attached per-instance.
--- @field SPAWNER AETHR.SPAWNER Spawner submodule attached per-instance.
--- @field UTILS AETHR.UTILS Utilities helper table attached per-instance.
--- @field BRAIN AETHR.BRAIN Brain submodule attached per-instance.
--- @field ZONE_MANAGER AETHR.ZONE_MANAGER Zone management submodule attached per-instance.
AETHR.AUTOSAVE = {}

--- Create a new AUTOSAVE submodule instance.
--- @function AETHR.AUTOSAVE:New
--- @param parent AETHR Parent AETHR instance
--- @return AETHR.AUTOSAVE instance
function AETHR.AUTOSAVE:New(parent)
    local instance = {
        AETHR = parent,
        _cache = {},
    }
    setmetatable(instance, { __index = self })
    return instance ---@diagnostic disable-line
end

function AETHR.AUTOSAVE:saveGeneratedGroundGroups()
    self.UTILS:debugInfo("AETHR.AUTOSAVE:saveGroundUnits -------------")
    -- local _zones = self.ZONE_MANAGER.DATA.MIZ_ZONES
    -- local co_ = self.BRAIN.DATA.coroutines.saveGroundUnits

    -- if co_.thread then
    --     co_.yieldCounter = co_.yieldCounter + 1
    --     if co_.yieldCounter >= co_.yieldThreshold then
    --         co_.yieldCounter = 0
    --         self.UTILS:debugInfo("AETHR.AUTOSAVE:saveGroundUnits --> YIELD")
    --         coroutine.yield()
    --     end
    -- end
    local saveGroups = {}
    local generatedGroupsDB = self.SPAWNER.DATA.generatedGroups

    for name, obj in pairs(generatedGroupsDB) do
        if obj._save then
            self.SPAWNER:updateDBGroupInfo(name)
            saveGroups[name] = obj
        end
    end

    self.FILEOPS:splitAndSaveData(
        saveGroups,
        self.CONFIG.MAIN.STORAGE.FILENAMES.SAVED_GROUND_GROUPS,
        self.CONFIG.MAIN.STORAGE.PATHS.GENGROUPS_FOLDER,
        self.CONFIG.MAIN.saveChunks.genGroups)

    local p = ""
    return self
end
