AETHR.IO = {}


do
  local write, writeNoFunc, writeSerialString, writeIndent, writeIndentSerial, writers, writersNoFunc, writersSerialString, refCount;

  --- Internal Methods.
  -- 
  -- Not meant to be used directly, but can be.
  --
  --  *Stores persistence generation functions.*
  --
  -- Houses methods for interacting with files outside of the game.
  --
  -- ===
  --
  --     -Exports table of data from MissionScripting environment to text file
  --     -Imports table of data from text file to MissionScripting environment
  --     -Dumps table to string format
  --
  -- @section IO.persistence
  -- @field #persistence
  AETHR.IO = {}

  --- Transforms a table or value into its string representation.
  --
  --  @{AETHR.IO.dump}
  --
  -- A utility function crafted to convert a table into its string representation recursively.
  -- For any non-table values, the function will directly convert them into strings.
  --
  -- @param o The table or value that needs conversion.
  -- @return #string A string that represents the serialized form of the given table or value.
  -- @usage local serializedString = AETHR.IO.dump(dataTable) -- Retrieves the string format of `dataTable`.
  function AETHR.IO.dump(o)
    if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
        if type(k) ~= 'number' then k = '"'..k..'"' end
        s = s .. '['..k..'] = ' .. AETHR.IO.dump(v) .. ','
      end
      return s .. '} '
    else
      return tostring(o)
    end
  end

  --- Persists multiple Lua values by serializing and saving them to a file.
  --
  --  @{AETHR.IO.store}
  --
  -- A utility function designed to serialize multiple Lua values, including tables, into a string format.
  -- It then writes the serialized string into a specified file. This method ensures efficient storage by
  -- avoiding redundant storage of duplicate table references.
  --
  -- @param path The path where the serialized values should be written.
  -- @param ... Lua values that need to be serialized and persisted.
  -- @usage AETHR.IO.store("destination/file.txt", dataTable1, dataTable2) -- Serializes and saves `dataTable1` and `dataTable2` to the defined file.
  function AETHR.IO.store(path, ...)
    local file, e = io.open(path, "w")
    if not file then
      return error(e)
    end

    local n = select("#", ...)
    -- Count references
    local objRefCount = {} -- Stores references that will be exported
    for i = 1, n do
      refCount(objRefCount, (select(i,...)))
    end

    -- Export Objects with more than one ref and assign name
    local objRefNames = {}
    local objRefIdx = 0
    file:write("-- Persistent Data\n")
    file:write("local multiRefObjects = {\n")
    for obj, count in pairs(objRefCount) do
      if count > 1 then
        objRefIdx = objRefIdx + 1
        objRefNames[obj] = objRefIdx
        file:write("{};") -- table objRefIdx
      end
    end
    file:write("\n} -- multiRefObjects\n")

    -- Fill the multi-reference objects
    for obj, idx in pairs(objRefNames) do
      for k, v in pairs(obj) do
        file:write("multiRefObjects["..idx.."][")
        write(file, k, 0, objRefNames)
        file:write("] = ")
        write(file, v, 0, objRefNames)
        file:write(";\n")
      end
    end

    -- Create the remaining objects
    for i = 1, n do
      file:write("local obj"..i.." = ")
      write(file, (select(i,...)), 0, objRefNames)
      file:write("\n")
    end

    -- Return the serialized values
    if n > 0 then
      file:write("return obj1")
      for i = 2, n do
        file:write(", obj"..i)
      end
      file:write("\n")
    else
      file:write("return\n")
    end

    if type(path) == "string" then
      file:close()
    end
  end

  ---  NO FUNCTION OUTPUT VERSION.
  -- @param path The path where the serialized values should be written.
  -- @param ... Lua values that need to be serialized and persisted.
  -- @usage AETHR.IO.store("destination/file.txt", dataTable1, dataTable2) -- Serializes and saves `dataTable1` and `dataTable2` to the defined file.
  function AETHR.IO.storeNoFunc(path, ...)
    local file, e = io.open(path, "w")
    if not file then
      return error(e)
    end

    local n = select("#", ...)
    -- Count references
    local objRefCount = {} -- Stores references that will be exported
    for i = 1, n do
      refCount(objRefCount, (select(i,...)))
    end

    -- Export Objects with more than one ref and assign name
    local objRefNames = {}
    local objRefIdx = 0
    file:write("-- Persistent Data\n")
    file:write("local multiRefObjects = {\n")
    for obj, count in pairs(objRefCount) do
      if count > 1 then
        objRefIdx = objRefIdx + 1
        objRefNames[obj] = objRefIdx
        file:write("{};") -- table objRefIdx
      end
    end
    file:write("\n} -- multiRefObjects\n")

    -- Fill the multi-reference objects
    for obj, idx in pairs(objRefNames) do
      for k, v in pairs(obj) do
        file:write("multiRefObjects["..idx.."][")
        writeNoFunc(file, k, 0, objRefNames)
        file:write("] = ")
        writeNoFunc(file, v, 0, objRefNames)
        file:write(";\n")
      end
    end

    -- Create the remaining objects
    for i = 1, n do
      file:write("local obj"..i.." = ")
      writeNoFunc(file, (select(i,...)), 0, objRefNames)
      file:write("\n")
    end

    -- Return the serialized values
    if n > 0 then
      file:write("return obj1")
      for i = 2, n do
        file:write(", obj"..i)
      end
      file:write("\n")
    else
      file:write("return\n")
    end

    if type(path) == "string" then
      file:close()
    end
  end

  function AETHR.IO.serializeNoFunc(...)
    --AETHR.UTILS.debugInfo("AETHR.IO:serializeNoFunc | ------------------------- ")
    local serialString_ = ""

    local n = select("#", ...)

    --AETHR.UTILS.debugInfo("AETHR.IO:serializeNoFunc | Count references ~~~~~ ")
    -- Count references
    local objRefCount = {} -- Stores references that will be exported
    for i = 1, n do
      refCount(objRefCount, (select(i,...)))
    end

    --AETHR.UTILS.debugInfo("AETHR.IO:serializeNoFunc | Export Objects with more than one ref and assign name ~~~~~ ")
    -- Export Objects with more than one ref and assign name
    local objRefNames = {}
    local objRefIdx = 0
    serialString_ = serialString_ .. ("-- Persistent Data\n")
    serialString_ = serialString_ .. ("local multiRefObjects = {\n")
    for obj, count in pairs(objRefCount) do
      if count > 1 then
        objRefIdx = objRefIdx + 1
        objRefNames[obj] = objRefIdx
        serialString_ = serialString_ .. ("{};") -- table objRefIdx
      end
    end
    serialString_ = serialString_ .. ("\n} -- multiRefObjects\n")

    --AETHR.UTILS.debugInfo("AETHR.IO:serializeNoFunc | serialString_ : " .. serialString_)
    --AETHR.UTILS.debugInfo("AETHR.IO:serializeNoFunc | Fill the multi-reference objects ~~~~~ ")
    -- Fill the multi-reference objects
    for obj, idx in pairs(objRefNames) do
      for k, v in pairs(obj) do
        serialString_ = serialString_ .. ("multiRefObjects["..idx.."][")
        serialString_ = writeSerialString(serialString_, k, 0, objRefNames)
        serialString_ = serialString_ .. ("] = ")
        serialString_ = writeSerialString(serialString_, v, 0, objRefNames)
        serialString_ = serialString_ .. (";\n")
      end
    end
    --AETHR.UTILS.debugInfo("AETHR.IO:serializeNoFunc | serialString_ : " .. serialString_)
    --AETHR.UTILS.debugInfo("AETHR.IO:serializeNoFunc | Create the remaining objects ~~~~~ ")
    -- Create the remaining objects
    for i = 1, n do
      serialString_ = serialString_ .. ("local obj"..i.." = ")
      serialString_ = writeSerialString(serialString_, (select(i,...)), 0, objRefNames)
      serialString_ = serialString_ .. ("\n")
    end
    --AETHR.UTILS.debugInfo("AETHR.IO:serializeNoFunc | serialString_ : " .. serialString_)
    --AETHR.UTILS.debugInfo("AETHR.IO:serializeNoFunc | Return the serialized values ~~~~~ ")
    -- Return the serialized values
    if n > 0 then
      serialString_ = serialString_ .. ("return obj1")
      for i = 2, n do
        serialString_ = serialString_ .. (", obj"..i)
      end
      serialString_ = serialString_ .. ("\n")
    else
      serialString_ = serialString_ .. ("return\n")
    end
    --AETHR.UTILS.debugInfo("AETHR.IO:serializeNoFunc | serialString_ : " .. serialString_)
    return serialString_
  end


  --- Loads and executes Lua content from the specified path or file object.
  --
  --  @{AETHR.IO.load}
  --
  -- This utility function reads, loads, and executes Lua content from a given file path or a file-like object.
  -- If the content is successfully loaded and executed, the result of the execution is returned.
  -- In case of an error during loading, it returns `nil` alongside an error message.
  --
  -- @param serialString_
  -- @return e The result of the Lua content execution, or `nil` and an associated error message if an error occurs.
  -- @usage local executionResult = AETHR.IO.load("directory/luaScript.lua") -- Loads and executes the Lua script at the defined path.
  function AETHR.IO.deSerialize(serialString_)
    -- Attempt to load the serialized data string as a Lua chunk
    local f, e = loadstring(serialString_)
    if f then
      -- Execute the chunk to deserialize it into Lua objects
      return f()
    else
      -- Return nil and the error if the chunk cannot be loaded
      return nil, e
    end
  end

  --- Loads and executes Lua content from the specified path or file object.
  --
  --  @{AETHR.IO.load}
  --
  -- This utility function reads, loads, and executes Lua content from a given file path or a file-like object.
  -- If the content is successfully loaded and executed, the result of the execution is returned.
  -- In case of an error during loading, it returns `nil` alongside an error message.
  --
  -- @param path The path to the Lua file, or a file-like object containing Lua content.
  -- @return e The result of the Lua content execution, or `nil` and an associated error message if an error occurs.
  -- @usage local executionResult = AETHR.IO.load("directory/luaScript.lua") -- Loads and executes the Lua script at the defined path.
  function AETHR.IO.load(path)
    local f, e
    if type(path) == "string" then
      f, e = loadfile(path)
    else
      f, e = path:read('*a')
    end
    if f then
      return f()
    else
      return nil, e
    end
  end

  -- Private methods

  --- Writes the provided item to the file using the appropriate writer based on the item's type.
  --
  -- This function selects a writer function based on the type of the provided item and then invokes it.
  -- The writer functions are expected to be stored in the `writers` table, indexed by the item type.
  --
  -- @param file The file object to write to.
  -- @param item The item to be written.
  -- @param level The current nesting level (used for recursive calls).
  -- @param objRefNames A table of object reference names (used for recursive calls).
  -- @param skipFunctions (optional, default false)if true will insert placeholder text for func instead of data.
  -- @usage write(myFile, myItem, 0, {}) -- Writes `myItem` to `myFile` using the appropriate writer.
  write = function (file, item, level, objRefNames)
    writers[type(item)](file, item, level, objRefNames)
  end

  --- NO FUNCTION OUTPUT VERSION.
  --
  -- @param file The file object to write to.
  -- @param item The item to be written.
  -- @param level The current nesting level (used for recursive calls).
  -- @param objRefNames A table of object reference names (used for recursive calls).
  -- @param skipFunctions (optional, default false)if true will insert placeholder text for func instead of data.
  -- @usage write(myFile, myItem, 0, {}) -- Writes `myItem` to `myFile` using the appropriate writer.
  writeNoFunc = function (file, item, level, objRefNames)
    writersNoFunc[type(item)](file, item, level, objRefNames)
  end

  ---  serial OUTPUT VERSION.
  --
  -- @param serialString_ The file object to write to.
  -- @param item The item to be written.
  -- @param level The current nesting level (used for recursive calls).
  -- @param objRefNames A table of object reference names (used for recursive calls).
  -- @param skipFunctions (optional, default false)if true will insert placeholder text for func instead of data.
  -- @usage write(myFile, myItem, 0, {}) -- Writes `myItem` to `myFile` using the appropriate writer.
  writeSerialString = function (serialString_, item, level, objRefNames)
--    AETHR.UTILS.debugInfo("AETHR.IO.serializeNoFunc | START writeSerialString | ------------------")
--    AETHR.UTILS.debugInfo("AETHR.IO:serializeNoFunc | pre serialString_ : " .. serialString_)
--    AETHR.UTILS.debugInfo("AETHR.IO:serializeNoFunc | item : " , item)
--    AETHR.UTILS.debugInfo("AETHR.IO:serializeNoFunc | level : " .. level)
--    AETHR.UTILS.debugInfo("AETHR.IO:serializeNoFunc | objRefNames : " , objRefNames)
    return writersSerialString[type(item)](serialString_, item, level, objRefNames)
  end

  --- Writes indentation to the provided file.
  --
  -- This function writes a specified number of tab characters to the given file, creating an indentation effect.
  --
  -- @param file The file object to write to.
  -- @param level The number of tab characters to write.
  -- @usage writeIndent(myFile, 3) -- Writes 3 tab characters to `myFile` for indentation.
  writeIndent = function (file, level)
    for i = 1, level do
      file:write("\t")
    end
  end

  writeIndentSerial = function (serialString_, level)
--    AETHR.UTILS.debugInfo("AETHR.IO.serializeNoFunc | writeIndentSerial | ------------------")
--    AETHR.UTILS.debugInfo("AETHR.IO:serializeNoFunc | serialString_ : " .. serialString_)
--    AETHR.UTILS.debugInfo("AETHR.IO:serializeNoFunc | level : " .. level)
    for i = 1, level do
      serialString_ = serialString_ .. ("  ")
    end
    return serialString_
  end

  --- Counts references for tables recursively.
  --
  -- This function increases the reference count for tables. When encountering a table for the first time,
  -- it counts its references and then recursively counts the references of its keys and values.
  --
  -- @param objRefCount A table that stores reference counts for other tables.
  -- @param item The item (potentially a table) whose references are to be counted.
  -- @usage refCount(objRefCountTable, myTable) -- Counts references for `myTable` and updates `objRefCountTable`.
  refCount = function (objRefCount, item)
    --AETHR.UTILS.debugInfo("AETHR.IO:refCount | ~~~~~ ")
    -- only count reference types (tables)
    if type(item) == "table" then
      -- Increase ref count
      if objRefCount[item] then
        objRefCount[item] = objRefCount[item] + 1
      else
        objRefCount[item] = 1
        -- If first encounter, traverse
        for k, v in pairs(item) do
          refCount(objRefCount, k)
          refCount(objRefCount, v)
        end
      end
    end
  end

  --- Table of writer functions for serializing various types of Lua data.
  --
  -- Each function in this table converts a Lua value of a specific type into a string representation suitable for storing in a file.
  writers = {
    ["nil"] = function(file)
      file:write("nil")
    end,

    ["number"] = function(file, item)
      file:write(tostring(item))
    end,

    ["string"] = function(file, item)
      file:write(string.format("%q", item))
    end,

    ["boolean"] = function(file, item)
      if item then
        file:write("true")
      else
        file:write("false")
      end
    end,

    ["table"] = function(file, item, level, objRefNames)
      local refIdx = objRefNames[item]
      if refIdx then
        file:write("multiRefObjects["..refIdx.."]")
      else
        file:write("{\n")
        for k, v in pairs(item) do
          writeIndent(file, level+1)
          file:write("[")
          write(file, k, level+1, objRefNames)
          file:write("] = ")
          write(file, v, level+1, objRefNames)
          file:write(";\n")
        end
        writeIndent(file, level)
        file:write("}")
      end
    end,

    ["function"] = function(file, item)
      local dInfo = debug.getinfo(item, "uS")
      if dInfo.nups > 0 then
        file:write("nil --[[functions with upvalue not supported]]")
      elseif dInfo.what ~= "Lua" then
        file:write("nil --[[non-lua function not supported]]")
      else
        local r, s = pcall(string.dump,item)
        if r then
          file:write(string.format("loadstring(%q)", s))
        else
          file:write("nil --[[function could not be dumped]]")
        end
      end
    end,

    ["thread"] = function(file)
      file:write("nil --[[thread]]")
    end,

    ["userdata"] = function(file)
      file:write("nil --[[userdata]]")
    end
  }

  --- NO FUNCTION OUTPUT VERSION.
  writersNoFunc = {
    ["nil"] = function(file)
      file:write("nil")
    end,

    ["number"] = function(file, item)
      file:write(tostring(item))
    end,

    ["string"] = function(file, item)
      file:write(string.format("%q", item))
    end,

    ["boolean"] = function(file, item)
      if item then
        file:write("true")
      else
        file:write("false")
      end
    end,

    ["table"] = function(file, item, level, objRefNames)
      local refIdx = objRefNames[item]
      if refIdx then
        file:write("multiRefObjects["..refIdx.."]")
      else
        file:write("{\n")
        for k, v in pairs(item) do
          writeIndent(file, level+1)
          file:write("[")
          writeNoFunc(file, k, level+1, objRefNames)
          file:write("] = ")
          writeNoFunc(file, v, level+1, objRefNames)
          file:write(";\n")
        end
        writeIndent(file, level)
        file:write("}")
      end
    end,

    ["function"] = function(file, item)
      file:write("nil --[[INTENDEDSKIP]]")
    end,

    ["thread"] = function(file)
      file:write("nil --[[thread]]")
    end,

    ["userdata"] = function(file)
      file:write("nil --[[userdata]]")
    end
  }
  --- SERIAL OUTPUT VERSION.
  --
  --
  -- ---------------------------------------------
  --
  --
  writersSerialString = {
    ["nil"] = function(serialString_)
      return serialString_ .. ("nil")
    end,

    ["number"] = function(serialString_, item)
      return serialString_ .. (tostring(item))
    end,

    ["string"] = function(serialString_, item)
      return serialString_ .. (string.format("%q", item))
    end,

    ["boolean"] = function(serialString_, item)
      if item then
        return serialString_ .. ("true")
      else
        return serialString_ .. ("false")
      end
    end,

    ["table"] = function(serialString_, item, level, objRefNames)
--      AETHR.UTILS.debugInfo("AETHR.IO.serializeNoFunc | START writersSerialString | ------------------")
--      AETHR.UTILS.debugInfo("AETHR.IO:serializeNoFunc | pre serialString_ : " .. serialString_)
--      AETHR.UTILS.debugInfo("AETHR.IO:serializeNoFunc | item : " , item)
--      AETHR.UTILS.debugInfo("AETHR.IO:serializeNoFunc | level : " .. level)
--      AETHR.UTILS.debugInfo("AETHR.IO:serializeNoFunc | objRefNames : " , objRefNames)

      local refIdx = objRefNames[item]
      if refIdx then
        serialString_ = serialString_ .. ("multiRefObjects["..refIdx.."]")
      else
        serialString_ = serialString_ .. ("{\n")
        for k, v in pairs(item) do

          serialString_ = writeIndentSerial(serialString_, level+1)
          serialString_ = serialString_ .. ("[")
          serialString_ = writeSerialString(serialString_, k, level+1, objRefNames)
          serialString_ = serialString_ .. ("] = ")
          serialString_ = writeSerialString(serialString_, v, level+1, objRefNames)
          serialString_ = serialString_ .. (";\n")
        end
        serialString_ = writeIndentSerial(serialString_, level)
        serialString_ = serialString_ .. ("}")
      end
      return serialString_
    end,

    ["function"] = function(serialString_, item)
      return serialString_ .. ("nil --[[INTENDEDSKIP]]")
    end,

    ["thread"] = function(serialString_)
      return serialString_ .. ("nil --[[thread]]")
    end,

    ["userdata"] = function(serialString_)
      return serialString_ .. ("nil --[[userdata]]")
    end
  }
end