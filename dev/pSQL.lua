AETHR.pSQL = {}
local socket = require("socket")
local http = require("socket.http")

-- Connection configuration
local config = {
    host = "localhost",
    port = 5432,
    database = "",
    user = "",
    password = "",
    timeout = 30
}

-- Set connection parameters
function AETHR.pSQL.setConfig(host, port, database, user, password, timeout)
    config.host = host or config.host
    config.port = port or config.port
    config.database = database or config.database
    config.user = user or config.user
    config.password = password or config.password
    config.timeout = timeout or config.timeout
end

-- Create a connection to pSQL
function AETHR.pSQL.connect()
    local client = socket.tcp()
    if not client then
        return nil, "Failed to create socket"
    end
    
    client:settimeout(config.timeout)
    local success, err = client:connect(config.host, config.port)
    if not success then
        client:close()
        return nil, "Connection failed: " .. (err or "unknown error")
    end
    
    return client, nil
end

-- Send a query to the database
function AETHR.pSQL.query(client, sql)
    if not client then
        return nil, "No client connection"
    end
    
    local message = string.format("Q%s\0", sql)
    local bytes, err = client:send(message)
    if not bytes then
        return nil, "Send failed: " .. (err or "unknown error")
    end
    
    local response, err = client:receive("*a")
    if not response then
        return nil, "Receive failed: " .. (err or "unknown error")
    end
    
    return response, nil
end

-- Close the connection
function AETHR.pSQL.close(client)
    if client then
        client:close()
    end
end
