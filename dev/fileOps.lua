AETHR.fileOps = {}
--- File Operations Module for AETHR
--- Provides functions to handle file operations such as reading, writing, and checking file existence.
--- @module AETHR.fileOps

--- Check if a directory exists, create it if it doesn't
--- @param path string The directory path to check/create
--- @return boolean success True if directory exists or was created successfully
function AETHR.fileOps.ensureDirectory(path)
    local lfs = require("lfs")
    
    -- Check if directory already exists
    local attr = lfs.attributes(path)
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

--- Check if a file exists in a directory, create it if it doesn't
--- @param directory string The directory path to check
--- @param filename string The name of the file to check/create
--- @return boolean success True if file exists or was created successfully
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



--- Convert a Lua table to JSON string and save to file
--- @param directory string The directory path where the file will be saved
--- @param filename string The name of the file to save
--- @param data table The Lua table to convert to JSON
--- @return boolean success True if the file was created and data was written successfully
function AETHR.fileOps.saveTableAsJSON(directory, filename, data)
    local JSON = require("JSON")
    
    -- Ensure directory exists
    if not AETHR.fileOps.ensureDirectory(directory) then
        print("Failed to ensure directory exists: " .. directory)
        return false
    end
    
    -- Convert table to JSON string
    local success, jsonString = pcall(function()
        return JSON:encode_pretty(data)
    end)
    
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

--- Read a JSON file and convert it to a Lua table
--- @param directory string The directory path where the file is located
--- @param filename string The name of the JSON file to read
--- @return table|nil data The Lua table from the JSON file, or nil if failed
function AETHR.fileOps.loadTableFromJSON(directory, filename)
    local JSON = require("JSON")
    
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
    local success, data = pcall(function()
        return JSON:decode(jsonString)
    end)
    
    if not success then
        print("Failed to parse JSON from file: " .. (data or "unknown error"))
        return nil
    end
    
    return data
end