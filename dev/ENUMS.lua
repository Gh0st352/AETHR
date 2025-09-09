--- @class AETHR.ENUMS
--- @brief Safe, editor-friendly enumeration table for AETHR.
--- Provides fallbacks when running outside the DCS engine so files can be
--- statically analyzed and load without runtime globals.
---@diagnostic disable: undefined-global
local function safe_lookup(path, fallback)
    -- path: string like "Object.Category.UNIT"
    -- fallback: value to return if lookup fails
    local cur = _G
    for part in string.gmatch(path, "[^%.]+") do
        if type(cur) ~= "table" then return fallback end
        cur = cur[part]
        if cur == nil then return fallback end
    end
    return cur
end

AETHR.ENUMS = {
    ObjectCategory = {
        UNIT = safe_lookup("Object.Category.UNIT", 0),
        WEAPON = safe_lookup("Object.Category.WEAPON", 1),
        STATIC = safe_lookup("Object.Category.STATIC", 2),
        SCENERY = safe_lookup("Object.Category.SCENERY", 3),
        BASE = safe_lookup("Object.Category.BASE", 4),
    },
    UnitCategory = {
        AIRPLANE = safe_lookup("Unit.Category.AIRPLANE", 0),
        HELICOPTER = safe_lookup("Unit.Category.HELICOPTER", 1),
        GROUND_UNIT = safe_lookup("Unit.Category.GROUND_UNIT", 2),
        SHIP = safe_lookup("Unit.Category.SHIP", 3),
        STRUCTURE = safe_lookup("Unit.Category.STRUCTURE", 4),
    },
    GroupCategory = {
        AIRPLANE = safe_lookup("Group.Category.AIRPLANE", 0),
        HELICOPTER = safe_lookup("Group.Category.HELICOPTER", 1),
        GROUND = safe_lookup("Group.Category.GROUND", 2),
        SHIP = safe_lookup("Group.Category.SHIP", 3),
    },
    AirbaseCategory = {
        AIRDROME = safe_lookup("Airbase.Category.AIRDROME", 0),
        HELIPAD = safe_lookup("Airbase.Category.HELIPAD", 1),
        SHIP = safe_lookup("Airbase.Category.SHIP", 2),
    },
    SurfaceType = {
        LAND = safe_lookup("land.SurfaceType.LAND", 0),
        SHALLOW_WATER = safe_lookup("land.SurfaceType.SHALLOW_WATER", 1),
        WATER = safe_lookup("land.SurfaceType.WATER", 2),
        ROAD = safe_lookup("land.SurfaceType.ROAD", 3),
        RUNWAY = safe_lookup("land.SurfaceType.RUNWAY", 4),
    },
    Events = {
        -- Use safe_lookup to avoid load-time errors outside DCS
        S_EVENT_SHOT = safe_lookup("world.event.S_EVENT_SHOT", 0),
        S_EVENT_HIT = safe_lookup("world.event.S_EVENT_HIT", 1),
        S_EVENT_TAKEOFF = safe_lookup("world.event.S_EVENT_TAKEOFF", 2),
        S_EVENT_LAND = safe_lookup("world.event.S_EVENT_LAND", 3),
        S_EVENT_CRASH = safe_lookup("world.event.S_EVENT_CRASH", 4),
        S_EVENT_EJECTION = safe_lookup("world.event.S_EVENT_EJECTION", 5),
        S_EVENT_REFUELING = safe_lookup("world.event.S_EVENT_REFUELING", 6),
        S_EVENT_DEAD = safe_lookup("world.event.S_EVENT_DEAD", 7),
        S_EVENT_PILOT_DEAD = safe_lookup("world.event.S_EVENT_PILOT_DEAD", 8),
        S_EVENT_BASE_CAPTURED = safe_lookup("world.event.S_EVENT_BASE_CAPTURED", 9),
        S_EVENT_MISSION_START = safe_lookup("world.event.S_EVENT_MISSION_START", 10),
        S_EVENT_MISSION_END = safe_lookup("world.event.S_EVENT_MISSION_END", 11),
        S_EVENT_TOOK_CONTROL = safe_lookup("world.event.S_EVENT_TOOK_CONTROL", 12),
        S_EVENT_REFUELING_STOP = safe_lookup("world.event.S_EVENT_REFUELING_STOP", 13),
        S_EVENT_BIRTH = safe_lookup("world.event.S_EVENT_BIRTH", 14),
        S_EVENT_HUMAN_FAILURE = safe_lookup("world.event.S_EVENT_HUMAN_FAILURE", 15),
        S_EVENT_ENGINE_STARTUP = safe_lookup("world.event.S_EVENT_ENGINE_STARTUP", 16),
        S_EVENT_ENGINE_SHUTDOWN = safe_lookup("world.event.S_EVENT_ENGINE_SHUTDOWN", 17),
        S_EVENT_PLAYER_ENTER_UNIT = safe_lookup("world.event.S_EVENT_PLAYER_ENTER_UNIT", 18),
        S_EVENT_PLAYER_LEAVE_UNIT = safe_lookup("world.event.S_EVENT_PLAYER_LEAVE_UNIT", 19),
        S_EVENT_PLAYER_COMMENT = safe_lookup("world.event.S_EVENT_PLAYER_COMMENT", 20),
        S_EVENT_SHOOTING_START = safe_lookup("world.event.S_EVENT_SHOOTING_START", 21),
        S_EVENT_SHOOTING_END = safe_lookup("world.event.S_EVENT_SHOOTING_END", 22),
        S_EVENT_MARK_ADDED = safe_lookup("world.event.S_EVENT_MARK_ADDED", 23),
        S_EVENT_MARK_CHANGE = safe_lookup("world.event.S_EVENT_MARK_CHANGE", 24),
        S_EVENT_MARK_REMOVED = safe_lookup("world.event.S_EVENT_MARK_REMOVED", 25),
        S_EVENT_KILL = safe_lookup("world.event.S_EVENT_KILL", 26),
        S_EVENT_SCORE = safe_lookup("world.event.S_EVENT_SCORE", 27),
        S_EVENT_UNIT_LOST = safe_lookup("world.event.S_EVENT_UNIT_LOST", 28),
        S_EVENT_LANDING_AFTER_EJECTION = safe_lookup("world.event.S_EVENT_LANDING_AFTER_EJECTION", 29),
        S_EVENT_PARATROOPER_LENDING = safe_lookup("world.event.S_EVENT_PARATROOPER_LENDING", 30),
        S_EVENT_DISCARD_CHAIR_AFTER_EJECTION = safe_lookup("world.event.S_EVENT_DISCARD_CHAIR_AFTER_EJECTION", 31),
        S_EVENT_WEAPON_ADD = safe_lookup("world.event.S_EVENT_WEAPON_ADD", 32),
        S_EVENT_TRIGGER_ZONE = safe_lookup("world.event.S_EVENT_TRIGGER_ZONE", 33),
        S_EVENT_LANDING_QUALITY_MARK = safe_lookup("world.event.S_EVENT_LANDING_QUALITY_MARK", 34),
        S_EVENT_BDA = safe_lookup("world.event.S_EVENT_BDA", 35),
        S_EVENT_AI_ABORT_MISSION = safe_lookup("world.event.S_EVENT_AI_ABORT_MISSION", 36),
        S_EVENT_DAYNIGHT = safe_lookup("world.event.S_EVENT_DAYNIGHT", 37),
        S_EVENT_FLIGHT_TIME = safe_lookup("world.event.S_EVENT_FLIGHT_TIME", 38),
        S_EVENT_PLAYER_SELF_KILL_PILOT = safe_lookup("world.event.S_EVENT_PLAYER_SELF_KILL_PILOT", 39),
        S_EVENT_PLAYER_CAPTURE_AIRFIELD = safe_lookup("world.event.S_EVENT_PLAYER_CAPTURE_AIRFIELD", 40),
        S_EVENT_EMERGENCY_LANDING = safe_lookup("world.event.S_EVENT_EMERGENCY_LANDING", 41),
    },
    Coalition = {
        NEUTRAL = safe_lookup("coalition.side.NEUTRAL", 0),
        RED = safe_lookup("coalition.side.RED", 1),
        BLUE = safe_lookup("coalition.side.BLUE", 2),
        ALL = -1,
    },
    Phonetic = {
        A = 'Alpha',
        B = 'Bravo',
        C = 'Charlie',
        D = 'Delta',
        E = 'Echo',
        F = 'Foxtrot',
        G = 'Golf',
        H = 'Hotel',
        I = 'India',
        J = 'Juliett',
        K = 'Kilo',
        L = 'Lima',
        M = 'Mike',
        N = 'November',
        O = 'Oscar',
        P = 'Papa',
        Q = 'Quebec',
        R = 'Romeo',
        S = 'Sierra',
        T = 'Tango',
        U = 'Uniform',
        V = 'Victor',
        W = 'Whiskey',
        X = 'Xray',
        Y = 'Yankee',
        Z = 'Zulu',
    },
    LineTypes = {
        NoLine = 0,
        Solid = 1,
        Dashed = 2,
        Dotted = 3,
        DashDot = 4,
        LongDash = 5,
        TwoDash = 6
    },
    MarkerTypes = {
        Line = 1,
        Circle = 2,
        Rect = 3,
        Arrow = 4,
        Text = 5,
        Quad = 6,
        Freeform = 7,
        MizMark = 8,
    },
}
