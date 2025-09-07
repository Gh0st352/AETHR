--Initialization script for the Mission lua Environment (SSE)

-- MOOSE_DYNAMIC_LOADER = "C:/Users/Administrator/Documents/DCSScripting/Moose_Dynamic_Loader.lua"
-- MOOSE_DEVELOPMENT_FOLDER = "C:/Users/Administrator/Documents/DCSScripting"

AETHR_ROOT_FOLDER 		    = "C:/Users/Administrator/Documents/AETHR"

AETHR_DEVELOPMENT_FOLDER    = AETHR_ROOT_FOLDER  .. "/dev"
AETHR_LIBRARIES_FOLDER      = AETHR_ROOT_FOLDER  .. "/lib"
AETHR_DEBUG_FOLDER 		    = AETHR_ROOT_FOLDER  .. "/Debugger"
AETHR_MIZ_FOLDER            = AETHR_ROOT_FOLDER  .. "/miz"

AETHR_MODULES_FOLDER 		= AETHR_DEBUG_FOLDER  .. "/Modules"
AETHR_DYNAMIC_LOADER_FOLDER = AETHR_DEBUG_FOLDER .. "/DynamicLoaders"

AETHR_DYNAMIC_LOADER     = AETHR_DYNAMIC_LOADER_FOLDER .. "/AETHR_Dynamic_Loader.lua"


dofile('Scripts/ScriptingSystem.lua')


package.cpath = package.cpath .. ';C:/Users/Administrator/.vscode/extensions/tangzx.emmylua-0.9.28-win32-x64/debugger/emmy/windows/x64/?.dll'
local dbg = require('emmy_core')
dbg.tcpConnect('localhost', 9966)


--Sanitize Mission Scripting environment
--This makes unavailable some unsecure functions. 
--Mission downloaded from server to client may contain potentialy harmful lua code that may use these functions.
--You can remove the code below and make availble these functions at your own risk.

local function sanitizeModule(name)
	-- _G[name] = nil
	-- package.loaded[name] = nil
end

do
	-- sanitizeModule('os')
	-- sanitizeModule('io')
	-- sanitizeModule('lfs')
	-- _G['require'] = nil
	-- _G['loadlib'] = nil
	-- _G['package'] = nil
end
