--- @module AETHR.fileOps
--- @brief Provides functions for file and directory operations: ensure, read, write, existence checks.
AETHR.fileOps = {}

--- Ensures a directory exists; creates it if missing.
--- @function ensureDirectory
--- @param path string Directory path to check or create
--- @return boolean success True if created or already exists, false on error
function AETHR.fileOps.ensureDirectory(path)
    local lfs = require("lfs")

    -- Check if directory already exists
local attr = lfs.attributes(path)  -- Get file system attributes
    if attr and attr.mode == "directory" then
        return true
    end

    -- Try to create the directory
    local success, err = lfs.mkdir(path)
    if success then
        return true
    else
        print("Failed to create directory: " .. (err or "unknown error"))
        return false
    end
end

--- Ensures a file exists in the given directory; creates empty file if missing.
--- @function ensureFile
--- @param directory string Directory path to check
--- @param filename string Filename to check or create
--- @return boolean success True on success, false on error
function AETHR.fileOps.ensureFile(directory, filename)
    local lfs = require("lfs")
    -- Construct full file path
    local filepath = directory .. "/" .. filename

    -- Check if file already exists
    local attr = lfs.attributes(filepath)
    if attr and attr.mode == "file" then
        return true
    end

    -- Try to create the file
    local file, err = io.open(filepath, "w")
    if file then
        file:close()
        return true
    else
        print("Failed to create file: " .. (err or "unknown error"))
        return false
    end
end

--- Saves a Lua table as compact JSON to a file.
--- @function saveTableAsJSON
--- @param directory string Directory path to write JSON
--- @param filename string Filename for JSON output
--- @param data table Lua table to encode
--- @return boolean success True on success, false on error
function AETHR.fileOps.saveTableAsJSON(directory, filename, data)
    -- Ensure directory exists
    if not AETHR.fileOps.ensureDirectory(directory) then
        print("Failed to ensure directory exists: " .. directory)
        return false
    end

    -- Convert table to JSON string
    local success, jsonString = pcall(AETHR.json.encode, data)

    if not success then
        print("Failed to convert table to JSON: " .. (jsonString or "unknown error"))
        return false
    end

    -- Construct full file path
    local filepath = directory .. "/" .. filename

    -- Write JSON string to file
    local file, err = io.open(filepath, "w")
    if not file then
        print("Failed to open file for writing: " .. (err or "unknown error"))
        return false
    end

    file:write(jsonString)
    file:close()

    return true
end

--- Loads and decodes JSON from a file into a Lua table.
--- @function loadTableFromJSON
--- @param directory string Directory path containing JSON
--- @param filename string JSON filename to load
--- @return table|nil data Decoded table or nil on failure
function AETHR.fileOps.loadTableFromJSON(directory, filename)
    -- Construct full file path
    local filepath = directory .. "/" .. filename

    -- Check if file exists
    local lfs = require("lfs")
    local attr = lfs.attributes(filepath)
    if not attr or attr.mode ~= "file" then
        print("File does not exist: " .. filepath)
        return nil
    end

    -- Read JSON string from file
    local file, err = io.open(filepath, "r")
    if not file then
        print("Failed to open file for reading: " .. (err or "unknown error"))
        return nil
    end

    local jsonString = file:read("*all")
    file:close()

    if not jsonString or jsonString == "" then
        print("File is empty or could not be read: " .. filepath)
        return nil
    end

    -- Convert JSON string to Lua table
    local success, data = pcall(AETHR.json.decode, jsonString)

    if not success then
        print("Failed to parse JSON from file: " .. (data or "unknown error"))
        return nil
    end

    -- Ensure the decoded data is a table
    if type(data) ~= "table" then
        print("JSON file does not contain a valid table: " .. filepath)
        return nil
    end

    return data
end

--- Saves a Lua table as formatted (pretty) JSON to a file.
--- @function saveTableAsPrettyJSON
--- @param directory string Directory path to write JSON
--- @param filename string Filename for pretty JSON
--- @param data table Lua table to encode
--- @return boolean success True on success, false on error
function AETHR.fileOps.saveTableAsPrettyJSON(directory, filename, data)
    if not AETHR.fileOps.ensureDirectory(directory) then
        return false
    end
    local ok, jsonString = pcall(AETHR.json.prettyEncode, data)
    if not ok then
        print("Failed to pretty encode data: " .. (jsonString or "unknown error"))
        return false
    end
    local filepath = directory .. "/" .. filename
    local file, err = io.open(filepath, "w")
    if not file then
        print("Failed to open file: " .. (err or "unknown error"))
        return false
    end
    file:write(jsonString)
    file:close()
    return true
end

--- Loads and decodes pretty JSON from a file into a Lua table.
--- @function loadTableFromPrettyJSON
--- @param directory string Directory path containing JSON
--- @param filename string Pretty JSON filename to load
--- @return table|nil data Decoded table or nil on failure
function AETHR.fileOps.loadTableFromPrettyJSON(directory, filename)
    local filepath = directory .. "/" .. filename
    local lfs = require("lfs")
    local attr = lfs.attributes(filepath)
    if not attr or attr.mode ~= "file" then
        print("File does not exist: " .. filepath)
        return nil
    end
    local file, err = io.open(filepath, "r")
    if not file then
        print("Failed to open file: " .. (err or "unknown error"))
        return nil
    end
    local jsonString = file:read("*all")
    file:close()
    if not jsonString or jsonString == "" then
        return nil
    end
    local ok, data = pcall(AETHR.json.decode, jsonString)
    if not ok or type(data) ~= "table" then
        return nil
    end
    return data
end

--- Checks if a file exists in the specified directory.
--- @function fileExists
--- @param directory string Directory path to check
--- @param filename string Filename to verify
--- @return boolean exists True if file is found, false otherwise
function AETHR.fileOps.fileExists(directory, filename)
    local filepath = directory .. "/" .. filename
    local lfs = require("lfs")
    local attr = lfs.attributes(filepath)
    return attr and attr.mode == "file" or false
end

--- Joins multiple path segments using the system path separator.
--- @function joinPaths
--- @param ... string Path segments to join
--- @return string Joined path string
function AETHR.fileOps.joinPaths(...)
    local sep = package.config:sub(1, 1)
    return table.concat({ ... }, sep)
end

--- Performs deep copy of tables (including nested tables and metatables).
--- @function deepcopy
--- @param orig any Source value or table to copy
--- @return any copy Deep copied value
function AETHR.fileOps.deepcopy(orig)
  local orig_type = type(orig)
  local copy
  if orig_type == 'table' then
    copy = {}
    for orig_key, orig_value in next, orig, nil do
      copy[AETHR.fileOps.deepcopy(orig_key)] = AETHR.fileOps.deepcopy(orig_value)
    end
    setmetatable(copy, AETHR.fileOps.deepcopy(getmetatable(orig)))
  else -- number, string, boolean, etc
    copy = orig
  end
  return copy
end
