---@diagnostic disable: undefined-global

env.info( '*** AETHR DYNAMIC INCLUDE START *** ' )

local base = _G

__AETHR = {}

__AETHR.Include = function( IncludeFile )
	if not __AETHR.Includes[ IncludeFile ] then
		__AETHR.Includes[IncludeFile] = IncludeFile
		local f = assert( base.loadfile( IncludeFile ) )
		if f == nil then
			error ("AETHR: Could not load AETHR file " .. IncludeFile )
		else
			env.info( "AETHR: " .. IncludeFile .. " dynamically loaded." )
			return f()
		end
	end
end

__AETHR.Includes = {}

__AETHR.Include( AETHR_MODULES_FOLDER .. '/Modules_AETHR.lua' )


