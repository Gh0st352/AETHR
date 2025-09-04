--- @module AETHR.fileOps
--- @brief Provides functions for file and directory operations: ensure, read, write, existence checks.
--- @author Gh0st352

AETHR.fileOps = {}

--- @function joinPaths
--- @brief Joins multiple path segments using the system path separator.
--- @param ... string Path segments to join.
--- @return string Joined path
function AETHR.fileOps.joinPaths(...)
    local sep = package.config:sub(1,1)
    return table.concat({ ... }, sep)
end

--- @function ensureDirectory
--- @brief Ensures a directory path exists, recursively creating missing segments.
--- @param path string Directory path.
--- @return boolean success True if exists or created, false on error.
function AETHR.fileOps.ensureDirectory(path)
    if not path or path == "" then
        return false
    end
    local lfs = require("lfs")
    local sep = package.config:sub(1,1)
    -- Normalize separators
    local normalized = path:gsub("[/\\]", sep)
    -- Split into components
    local parts = {}
    for part in string.gmatch(normalized, "[^" .. sep .. "]+") do
        table.insert(parts, part)
    end
    local current = ""
    for _, part in ipairs(parts) do
        current = current .. (current == "" and "" or sep) .. part
        local attr = lfs.attributes(current)
        if not attr then
            local ok, err = lfs.mkdir(current)
            if not ok then
                print("Failed to create directory '" .. current .. "': " .. (err or "unknown"))
                return false
            end
        elseif attr.mode ~= "directory" then
            print("Path exists and is not a directory: " .. current)
            return false
        end
    end
    return true
end

--- @function ensureFile
--- @brief Ensures a file exists; creates its directory and an empty file if missing.
--- @param directory string Directory path.
--- @param filename string Filename.
--- @return boolean success True on success, false on error.
function AETHR.fileOps.ensureFile(directory, filename)
    if not AETHR.fileOps.ensureDirectory(directory) then
        return false
    end
    local filepath = AETHR.fileOps.joinPaths(directory, filename)
    local lfs = require("lfs")
    local attr = lfs.attributes(filepath)
    if attr and attr.mode == "file" then
        return true
    end
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
function AETHR.fileOps.saveData(directory, filename, data)
    if not AETHR.fileOps.ensureDirectory(directory) then
        return false
    end
    local filepath = AETHR.fileOps.joinPaths(directory, filename)
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
function AETHR.fileOps.loadData(directory, filename)
    local filepath = AETHR.fileOps.joinPaths(directory, filename)
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
function AETHR.fileOps.fileExists(directory, filename)
    local filepath = AETHR.fileOps.joinPaths(directory, filename)
    local lfs = require("lfs")
    local attr = lfs.attributes(filepath)
    return attr and attr.mode == "file"
end

--- @function deepcopy
--- @brief Performs a deep copy of a value or table, including nested tables and metatables.
--- @param orig any Source value or table to copy.
--- @return any copy Deep copied value.
function AETHR.fileOps.deepcopy(orig)
    if type(orig) ~= "table" then
        return orig
    end
    local copy = {}
    for k, v in pairs(orig) do
        copy[AETHR.fileOps.deepcopy(k)] = AETHR.fileOps.deepcopy(v)
    end
    setmetatable(copy, AETHR.fileOps.deepcopy(getmetatable(orig)))
    return copy
end
