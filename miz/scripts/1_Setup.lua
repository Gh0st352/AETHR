G_AETHR = AETHR:New():Init()
G_AETHR:SaveConfig()

local _shapeID = 2023
local _divs = G_AETHR.LEARNED_DATA.worldDivisions
local _R = 0.5
local _G = 0.5
local _B = 0.5

for i = 1, #_divs do
    trigger.action.markupToAll(7, -1, _shapeID, {x = _divs[i][4].x, y = 0, z = _divs[i][4].z}, {x = _divs[i][3].x, y = 0, z = _divs[i][3].z}, {x = _divs[i][2].x, y = 0, z = _divs[i][2].z}, {x = _divs[i][1].x, y = 0, z = _divs[i][1].z}, { _R, _G, _B, 0.8 }, { _R + 0.2, _G + 0.4, _B + 0.8 ,0.3}, 4, true)
    _shapeID = _shapeID + 1

    _R = _R + 0.01
    _G = _G + 0.01
    _B = _B + 0.01
end

local pause = ""
