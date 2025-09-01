--- @module AETHR.fileOps
--- @brief Provides functions for file and directory operations: ensure, read, write, existence checks.
--- @author Gh0st352

AETHR.fileOps = {}

--- @function AETHR.fileOps.ensureDirectory
--- @brief Ensures a directory exists; creates it if missing.
--- @param path string Directory path to check or create.
--- @return boolean success True if created or already exists, false on error.
function AETHR.fileOps.ensureDirectory(path)
    local lfs = require("lfs") -- LuaFileSystem for filesystem operations.

    -- Get file system attributes for the path.
    local attr = lfs.attributes(path)
    if attr and attr.mode == "directory" then
        return true -- Directory already exists.
    end

    -- Attempt to create the missing directory.
    local ok, err = lfs.mkdir(path)
    if ok then
        return true
    else
        print("Failed to create directory: " .. (err or "unknown error"))
        return false
    end
end

--- @function AETHR.fileOps.ensureFile
--- @brief Ensures a file exists in the given directory; creates an empty file if missing.
--- @param directory string Directory path to check.
--- @param filename string Filename to check or create.
--- @return boolean success True on success, false on error.
function AETHR.fileOps.ensureFile(directory, filename)
    local lfs = require("lfs") -- LuaFileSystem for attribute checks.

    -- Construct full file path.
    local filepath = directory .. "/" .. filename

    -- Return if the file already exists.
    local attr = lfs.attributes(filepath)
    if attr and attr.mode == "file" then
        return true
    end

    -- Create an empty file.
    local fh, err = io.open(filepath, "w")
    if fh then
        fh:close()
        return true
    else
        print("Failed to create file: " .. (err or "unknown error"))
        return false
    end
end

--- @function AETHR.fileOps.saveTableAsJSON
--- @brief Saves a Lua table as compact JSON to a file.
--- @param directory string Directory path to write JSON.
--- @param filename string Filename for JSON output.
--- @param data table Lua table to encode.
--- @return boolean success True on success, false on error.
function AETHR.fileOps.saveTableAsJSON(directory, filename, data)
    -- Ensure the target directory exists.
    if not AETHR.fileOps.ensureDirectory(directory) then
        print("Failed to ensure directory exists: " .. directory)
        return false
    end

    -- Encode the table to a JSON string.
    local ok, jsonStr = pcall(AETHR.json.encode, data)
    if not ok then
        print("Failed to convert table to JSON: " .. tostring(jsonStr))
        return false
    end

    -- Construct full file path.
    local filepath = directory .. "/" .. filename

    -- Write JSON string to file.
    local fh, err = io.open(filepath, "w")
    if not fh then
        print("Failed to open file for writing: " .. (err or "unknown error"))
        return false
    end
    fh:write(jsonStr)
    fh:close()
    return true
end

--- @function AETHR.fileOps.loadTableFromJSON
--- @brief Loads and decodes JSON from a file into a Lua table.
--- @param directory string Directory path containing JSON.
--- @param filename string JSON filename to load.
--- @return table|nil data Decoded table or nil on failure.
function AETHR.fileOps.loadTableFromJSON(directory, filename)
    -- Construct full file path.
    local filepath = directory .. "/" .. filename

    -- Verify the file exists.
    local lfs = require("lfs")
    local attr = lfs.attributes(filepath)
    if not attr or attr.mode ~= "file" then
        print("File does not exist: " .. filepath)
        return nil
    end

    -- Read the JSON string from the file.
    local fh, err = io.open(filepath, "r")
    if not fh then
        print("Failed to open file for reading: " .. (err or "unknown error"))
        return nil
    end
    local content = fh:read("*all")
    fh:close()

    -- Check for empty content.
    if not content or content == "" then
        print("File is empty or could not be read: " .. filepath)
        return nil
    end

    -- Decode JSON into a Lua table.
    local ok, data = pcall(AETHR.json.decode, content)
    if not ok then
        print("Failed to parse JSON from file: " .. tostring(data))
        return nil
    end

    -- Verify the decoded result is a table.
    if type(data) ~= "table" then
        print("JSON did not decode to a table: " .. filepath)
        return nil
    end

    return data
end

--- @function AETHR.fileOps.saveTableAsPrettyJSON
--- @brief Saves a Lua table as pretty-printed JSON to a file.
--- @param directory string Directory path to write JSON.
--- @param filename string Filename for pretty JSON.
--- @param data table Lua table to encode.
--- @return boolean success True on success, false on error.
function AETHR.fileOps.saveTableAsPrettyJSON(directory, filename, data)
    -- Ensure the target directory exists.
    if not AETHR.fileOps.ensureDirectory(directory) then
        return false
    end

    -- Pretty-print the table to JSON.
    local ok, jsonStr = pcall(AETHR.json.prettyEncode, data)
    if not ok then
        print("Failed to pretty encode data: " .. tostring(jsonStr))
        return false
    end

    -- Write the JSON to file.
    local filepath = directory .. "/" .. filename
    local fh, err = io.open(filepath, "w")
    if not fh then
        print("Failed to open file: " .. (err or "unknown error"))
        return false
    end
    fh:write(jsonStr)
    fh:close()
    return true
end

--- @function AETHR.fileOps.loadTableFromPrettyJSON
--- @brief Loads and decodes pretty JSON from a file into a Lua table.
--- @param directory string Directory path containing JSON.
--- @param filename string Pretty JSON filename to load.
--- @return table|nil data Decoded table or nil on failure.
function AETHR.fileOps.loadTableFromPrettyJSON(directory, filename)
    -- Construct full file path.
    local filepath = directory .. "/" .. filename

    -- Verify file existence.
    local lfs = require("lfs")
    local attr = lfs.attributes(filepath)
    if not attr or attr.mode ~= "file" then
        print("File does not exist: " .. filepath)
        return nil
    end

    -- Read file contents.
    local fh, err = io.open(filepath, "r")
    if not fh then
        print("Failed to open file: " .. (err or "unknown error"))
        return nil
    end
    local content = fh:read("*all")
    fh:close()

    -- Return nil for empty content.
    if not content or content == "" then
        return nil
    end

    -- Decode JSON into a Lua table.
    local ok, data = pcall(AETHR.json.decode, content)
    if not ok or type(data) ~= "table" then
        return nil
    end
    return data
end

--- @function AETHR.fileOps.fileExists
--- @brief Checks if a file exists in the specified directory.
--- @param directory string Directory path to check.
--- @param filename string Filename to verify.
--- @return boolean exists True if file is found, false otherwise.
function AETHR.fileOps.fileExists(directory, filename)
    local filepath = directory .. "/" .. filename
    local lfs = require("lfs")
    local attr = lfs.attributes(filepath)
    return attr and attr.mode == "file"
end

--- @function AETHR.fileOps.joinPaths
--- @brief Joins multiple path segments using the system path separator.
--- @param ... string Path segments to join.
--- @return string Joined path string.
function AETHR.fileOps.joinPaths(...)
    local sep = package.config:sub(1, 1) -- Extract path separator.
    return table.concat({ ... }, sep)
end

--- @function AETHR.fileOps.deepcopy
--- @brief Performs deep copy of value or tables including nested tables and metatables.
--- @param orig any Source value or table to duplicate.
--- @return any copy Deep copied value.
function AETHR.fileOps.deepcopy(orig)
    local origType = type(orig)
    local copy
    if origType == "table" then
        copy = {}
        for k, v in next, orig, nil do
            copy[AETHR.fileOps.deepcopy(k)] = AETHR.fileOps.deepcopy(v)
        end
        setmetatable(copy, AETHR.fileOps.deepcopy(getmetatable(orig)))
    else
        copy = orig
    end
    return copy
end
