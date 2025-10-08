--- @class AETHR.FILEOPS
--- @brief  
---@diagnostic disable: undefined-global
--- @field AETHR AETHR Parent AETHR instance (injected by AETHR:New)
--- @field CONFIG AETHR.CONFIG Configuration table attached per-instance.
--- @field FILEOPS AETHR.FILEOPS File operations helper table attached per-instance.
--- @field POLY AETHR.POLY Geometry helper table attached per-instance.
--- @field IO AETHR.IO Basic file I/O submodule attached per-instance.
--- @field MATH AETHR.MATH Math helper table attached per-instance.
--- @field ENUMS AETHR.ENUMS ENUMS submodule attached per-instance.
--- @field AUTOSAVE AETHR.AUTOSAVE Autosave submodule attached per-instance.
--- @field UTILS AETHR.UTILS Utility functions submodule attached per-instance.
--- @field MARKERS AETHR.MARKERS Markers submodule attached per-instance.
--- @field BRAIN AETHR.BRAIN AI behavior submodule attached per-instance.
--- @field WORLD AETHR.WORLD World learning submodule attached per-instance.
--- @field ZONE_MANAGER AETHR.ZONE_MANAGER Zone management submodule attached per-instance.
AETHR.FILEOPS = {}

--- Creates a new AETHR.FILEOPS submodule instance.
--- @function AETHR.FILEOPS:New
--- @param parent AETHR Parent AETHR instance
--- @return AETHR.FILEOPS instance New instance inheriting AETHR.FILEOPS methods.
function AETHR.FILEOPS:New(parent)
    local instance = {
        AETHR = parent,
        -- submodule-local caches/state can be initialized here
        _cache = {},
    }
    setmetatable(instance, { __index = self })
    return instance ---@diagnostic disable-line
end

--- @function joinPaths
--- @brief Joins multiple path segments using the system path separator.
--- @param ... string Path segments to join.
--- @return string Joined path
function AETHR.FILEOPS:joinPaths(...)
    local sep = package.config:sub(1,1)
    return table.concat({ ... }, sep)
end

--- @function ensureDirectory
--- @brief Ensures a directory path exists, recursively creating missing segments.
--- @param path string Directory path.
--- @return boolean success True if exists or created, false on error.
function AETHR.FILEOPS:ensureDirectory(path)
    -- Best-effort directory creation with optional lfs (preferred) and OS fallback.
    -- Keeps behavior identical when lfs is present; degrades gracefully when missing/sandboxed.
    if not path or path == "" then
        return false
    end

    local sep = package.config:sub(1,1)
    -- Normalize separators
    local normalized = (tostring(path) or ""):gsub("[/\\]", sep)

    -- Split into components for recursive mkdir
    local parts = {}
    for part in string.gmatch(normalized, "[^" .. sep .. "]+") do
        table.insert(parts, part)
    end

    local okLfs, lfs = pcall(require, "lfs")

    local function existsDir(p)
        if okLfs and lfs and type(lfs.attributes) == "function" then
            local attr = lfs.attributes(p)
            return attr and attr.mode == "directory"
        end
        -- Without lfs we cannot reliably stat; let mkdir attempt handle existence.
        return false
    end

    local function mkdirDir(p)
        if okLfs and lfs and type(lfs.mkdir) == "function" then
            return lfs.mkdir(p)
        end
        -- OS fallback (may be sandboxed; ignore errors)
        local cmd
        if sep == "\\" then
            cmd = 'mkdir "' .. p .. '"'
        else
            cmd = 'mkdir -p "' .. p .. '"'
        end
        if type(os) == "table" and type(os.execute) == "function" then
            local status = os.execute(cmd)
            local ok = (status == true) or (status == 0)
            return ok, ok and nil or "mkdir failed (no lfs)"
        end
        return false, "mkdir not available (no lfs, os.execute disabled)"
    end

    local current = ""
    for _, part in ipairs(parts) do
        current = current .. (current == "" and "" or sep) .. part
        if not existsDir(current) then
            local ok, err = mkdirDir(current)
            if not ok then
                print("Failed to create directory '" .. current .. "': " .. (err or "unknown"))
                return false
            end
        else
            if okLfs and lfs and type(lfs.attributes) == "function" then
                local attr = lfs.attributes(current)
                if attr and attr.mode ~= "directory" then
                    print("Path exists and is not a directory: " .. current)
                    return false
                end
            end
        end
    end
    return true
end

--- @function ensureFile
--- @brief Ensures a file exists; creates its directory and an empty file if missing.
--- @param directory string Directory path.
--- @param filename string Filename.
--- @return boolean success True on success, false on error.
function AETHR.FILEOPS:ensureFile(directory, filename)
    -- Attempt directory creation (best-effort); continue even if it fails in sandboxed envs.
    self:ensureDirectory(directory)

    local filepath = self:joinPaths(directory, filename)

    -- Check existence (prefer lfs, fallback to io)
    local okLfs, lfs = pcall(require, "lfs")
    if okLfs and lfs and type(lfs.attributes) == "function" then
        local attr = lfs.attributes(filepath)
        if attr and attr.mode == "file" then
            return true
        end
    else
        local f = io.open(filepath, "r")
        if f then f:close(); return true end
    end

    -- Create the file
    local fh, err = io.open(filepath, "w")
    if not fh then
        print("Failed to create file '" .. filepath .. "': " .. (err or "unknown"))
        return false
    end
    fh:close()
    return true
end


--- @function saveTableAsJSON
--- @brief Saves a Lua table as pretty-printed JSON to a file.
--- @param directory string Directory path.
--- @param filename string JSON filename.
--- @param data any Lua table to encode.
--- @return boolean success True on success, false on error.
function AETHR.FILEOPS:saveData(directory, filename, data)
    if not self:ensureDirectory(directory) then
        return false
    end
    local filepath = self:joinPaths(directory, filename)
    local ok, err = pcall(AETHR.IO.store, filepath, data)
    if not ok then
        print("Failed to store data: " .. tostring(err))
        return false
    end
    return true
end

--- @function loadData
--- @brief Loads and decodes JSON data from a file into a Lua table.
--- @param directory string Directory path.
--- @param filename string JSON filename.
--- @return any|nil data Decoded table or nil on failure.
function AETHR.FILEOPS:loadData(directory, filename)
    local filepath = self:joinPaths(directory, filename)
    local ok, data = pcall(AETHR.IO.load, filepath)
    if not ok then
        print("Failed to load data: " .. tostring(data))
        return nil
    end
    return data
end


--- @function fileExists
--- @brief Checks if a file exists in the specified directory.
--- @param directory string Directory path.
--- @param filename string Filename to check.
--- @return boolean exists True if file exists, false otherwise.
function AETHR.FILEOPS:fileExists(directory, filename)
    local filepath = self:joinPaths(directory, filename)
    local okLfs, lfs = pcall(require, "lfs")
    if okLfs and lfs and type(lfs.attributes) == "function" then
        local attr = lfs.attributes(filepath)
        return (attr and attr.mode == "file") or false
    end
    -- Fallback: try opening the file for read
    local f = io.open(filepath, "r")
    if f then f:close(); return true end
    return false
end

--- @function deepcopy
--- @brief Performs a deep copy of a value or table, including nested tables and metatables.
--- @param orig any Source value or table to copy.
--- @return any copy Deep copied value.
function AETHR.FILEOPS:deepcopy(orig)
    -- Cycle-safe deep copy that preserves table structure and metatables.
    -- Uses a visited table to avoid infinite recursion on cyclic references.
    local function _deepcopy(obj, visited)
        if type(obj) ~= "table" then
            return obj
        end
        visited = visited or {}
        if visited[obj] then
            return visited[obj]
        end

        local copy = {}
        visited[obj] = copy

        for k, v in pairs(obj) do
            local nk = _deepcopy(k, visited)
            local nv = _deepcopy(v, visited)
            copy[nk] = nv
        end

        local mt = getmetatable(obj)
        if mt then
            setmetatable(copy, _deepcopy(mt, visited))
        end

        return copy
    end

    return _deepcopy(orig, {})
end

function AETHR.FILEOPS:splitAndSaveData(db, fileName, saveFolder, divParam)

    local count = self.UTILS.sumTable(db)
    local fileDB = {}
    local fileTracker = {}

    self.UTILS:debugInfo("AETHR.FILEOPS:splitAndSaveData - splitting and saving " .. count .. " datagroups")
    local fileCounter = 1
    local counter = 0
    for i, array in pairs(db or {}) do
        fileDB[i] = array
        counter = counter + 1
        if counter >= divParam then
            counter = 0
            local fileNamePart = fileCounter .. fileName
            fileTracker[fileCounter] = fileNamePart
            local ok = self.FILEOPS:saveData(
                saveFolder,
                fileNamePart,
                fileDB
            )
            if not ok and self.CONFIG.MAIN.DEBUG_ENABLED then
                self.UTILS:debugInfo("AETHR.FILEOPS:splitAndSaveData Part failed")
            end
            fileDB = {}
        end
    end

    local ok = self.FILEOPS:saveData(
        saveFolder,
        fileName,
        fileTracker
    )
    if not ok and self.CONFIG.MAIN.DEBUG_ENABLED then
        self.UTILS:debugInfo("AETHR.FILEOPS:splitAndSaveData failed")
    end

end

function AETHR.FILEOPS:loadandJoinData(fileName, saveFolder)
    local totalData = {}
    local masterData = self.FILEOPS:loadData(
        saveFolder,
        fileName
    )
    if masterData then
        for i, file in pairs(masterData) do
            local partData = self.FILEOPS:loadData(
                saveFolder,
                file
            )
            if partData then
                for j, array in pairs(partData) do
                    totalData[j] = array
                end
            end
        end
        return totalData
    else
        return nil
    end
end