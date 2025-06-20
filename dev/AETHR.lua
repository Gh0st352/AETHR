AETHR = {
    VERSION = "0.1.0",
    AUTHOR = "Gh0st352",
    GITHUB = "https://github.com/Gh0st352",
    DESCRIPTION = {
        "Autonomous Environment for Theater Realism",
        "AETHR is a framework designed to enhance the realism and immersion of DCS World missions.",
        "It provides a set of tools and libraries to create dynamic and engaging scenarios.",
        "A high-fidelity simulation layer that weaves in adaptive machine learning decision-making across the whole theater.",
    },
    STORAGE = {
    ROOT_FOLDER = "AETHR",
    SUB_FOLDERS = {
        CONFIG_FOLDER = "CONFIG",
        TERRAIN_FOLDER = "TERRAIN",
        UNITS_FOLDER = "UNITS",
        OBJECTS_FOLDER = "OBJECTS",
        USER_FOLDER = "USER",
    },
    },
}

function AETHR:New()
    local instance = {}
    setmetatable(instance, { __index = self })
    return instance
end

function AETHR:Init()
    for folderName, folderPath in pairs(self.STORAGE.SUB_FOLDERS) do
        local fullPath = self.STORAGE.ROOT_FOLDER .. "/" .. folderPath
        AETHR.fileOps.ensureDirectory(fullPath)
    end

    return self
end