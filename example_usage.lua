-- Example of using AETHR.pSQL to insert a record

-- Load the pSQL module (assuming it's in the same directory or loaded elsewhere)
-- require("pSQL")

-- First, configure the database connection
AETHR.pSQL.setConfig("localhost", 5432, "testDB", "your_username", "your_password", 30)

-- Create a new pSQL instance
local db = AETHR.pSQL.new()

-- Connect to the database
local success, err = db:connect()
if not success then
    print("Connection failed:", err)
    return
end

print("Connected to database successfully")

-- Prepare the INSERT SQL statement
local field1_value = "Sample Value 1"
local field2_value = "Sample Value 2"

-- Basic SQL escape function to prevent SQL injection
local function escapeSql(str)
    if type(str) == "string" then
        return "'" .. str:gsub("'", "''") .. "'"
    elseif type(str) == "number" then
        return tostring(str)
    else
        return "NULL"
    end
end

-- Create the INSERT statement
local sql = string.format("INSERT INTO testTB (Field1, Field2) VALUES (%s, %s)", 
                         escapeSql(field1_value), 
                         escapeSql(field2_value))

print("Executing SQL:", sql)

-- Execute the query
local result, err = db:query(sql)
if result then
    print("Record inserted successfully!")
    print("Database response:", result)
else
    print("Query failed:", err)
end

-- Close the connection
db:close()
print("Connection closed")

-- Example with multiple records
print("\n--- Inserting multiple records ---")
local db2 = AETHR.pSQL.new()
local success2, err2 = db2:connect()

if success2 then
    local records = {
        {"John Doe", "Manager"},
        {"Jane Smith", "Developer"},
        {"Bob Johnson", "Analyst"}
    }
    
    for i, record in ipairs(records) do
        local sql_multi = string.format("INSERT INTO testTB (Field1, Field2) VALUES (%s, %s)", 
                                       escapeSql(record[1]), 
                                       escapeSql(record[2]))
        
        local result_multi, err_multi = db2:query(sql_multi)
        if result_multi then
            print("Record " .. i .. " inserted:", record[1] .. ", " .. record[2])
        else
            print("Failed to insert record " .. i .. ":", err_multi)
        end
    end
    
    db2:close()
else
    print("Second connection failed:", err2)
end
