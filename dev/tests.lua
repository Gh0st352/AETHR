--- Simple test utilities for quick smoke checks in-editor and in-mission.
--- @module "dev.tests"
---@diagnostic disable: undefined-global
--- Run a basic AETHR smoke test that logs a message via UTILS.
--- @function AETHR:testfunc
--- @return nil
function AETHR:testfunc()
    if self and self.UTILS and type(self.UTILS.debugInfo) == "function" then
        self.UTILS:debugInfo("AETHR:testfunc invoked - basic smoke test")
    else
        -- Fallback to env.info if available
        if type(env) == "table" and type(env.info) == "function" then
            pcall(function() env.info("AETHR:testfunc invoked - basic smoke test (fallback)") end)
        end
    end
end
