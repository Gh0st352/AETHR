---@class AETHR.ENUMS
--- Safe, editor-friendly enumeration table for AETHR.
--- Provides fallbacks when running outside the DCS engine so files can be
--- statically analyzed and load without runtime globals.
---@field ObjectCategory AETHR.ENUMS.ObjectCategory DCS Object.Category mapping.
---@field UnitCategory AETHR.ENUMS.UnitCategory DCS Unit.Category mapping.
---@field GroupCategory AETHR.ENUMS.GroupCategory DCS Group.Category mapping.
---@field AirbaseCategory AETHR.ENUMS.AirbaseCategory DCS Airbase.Category mapping.
---@field SurfaceType AETHR.ENUMS.SurfaceType DCS land.SurfaceType mapping.
---@field Events AETHR.ENUMS.Events DCS world.event constants.
---@field Coalition AETHR.ENUMS.Coalition Coalition sides; includes AETHR sentinel ALL (-1).
---@field Phonetic AETHR.ENUMS.Phonetic NATO phonetic alphabet strings.
---@field LineTypes AETHR.ENUMS.LineTypes Line rendering styles.
---@field MarkerTypes AETHR.ENUMS.MarkerTypes Marker shape types for F10 drawing.
---@diagnostic disable: undefined-global

---@class AETHR.ENUMS.ObjectCategory
---@field UNIT integer DCS Object.Category.UNIT
---@field WEAPON integer DCS Object.Category.WEAPON
---@field STATIC integer DCS Object.Category.STATIC
---@field SCENERY integer DCS Object.Category.SCENERY
---@field BASE integer DCS Object.Category.BASE

---@class AETHR.ENUMS.UnitCategory
---@field AIRPLANE integer Fixed‑wing aircraft units (Unit.Category.AIRPLANE)
---@field HELICOPTER integer Rotary‑wing aircraft units (Unit.Category.HELICOPTER)
---@field GROUND_UNIT integer Ground units (Unit.Category.GROUND_UNIT)
---@field SHIP integer Naval units (Unit.Category.SHIP)
---@field STRUCTURE integer Static structures (Unit.Category.STRUCTURE)

---@class AETHR.ENUMS.GroupCategory
---@field AIRPLANE integer Groups of fixed‑wing aircraft (Group.Category.AIRPLANE)
---@field HELICOPTER integer Groups of helicopters (Group.Category.HELICOPTER)
---@field GROUND integer Ground unit groups (Group.Category.GROUND)
---@field SHIP integer Naval groups (Group.Category.SHIP)

---@class AETHR.ENUMS.AirbaseCategory
---@field AIRDROME integer Land airfields (Airbase.Category.AIRDROME)
---@field HELIPAD integer Helipads (Airbase.Category.HELIPAD)
---@field SHIP integer Ships acting as airbases (Airbase.Category.SHIP)

---@class AETHR.ENUMS.SurfaceType
---@field LAND integer Natural land surface
---@field SHALLOW_WATER integer Shallow water areas
---@field WATER integer Deep/open water
---@field ROAD integer Road surface
---@field RUNWAY integer Runway surface

---@class AETHR.ENUMS.Events
---@field S_EVENT_SHOT integer Weapon fired
---@field S_EVENT_HIT integer Hit registered on an object
---@field S_EVENT_TAKEOFF integer Unit took off
---@field S_EVENT_LAND integer Unit landed
---@field S_EVENT_CRASH integer Unit crashed
---@field S_EVENT_EJECTION integer Pilot ejected
---@field S_EVENT_REFUELING integer AAR refueling started
---@field S_EVENT_DEAD integer Unit destroyed
---@field S_EVENT_PILOT_DEAD integer Pilot killed
---@field S_EVENT_BASE_CAPTURED integer Base captured by coalition
---@field S_EVENT_MISSION_START integer Mission start (fires before scripts load)
---@field S_EVENT_MISSION_END integer Mission end (fires before scripts load)
---@field S_EVENT_TOOK_CONTROL integer Player took control of a unit/group
---@field S_EVENT_REFUELING_STOP integer AAR refueling stopped
---@field S_EVENT_BIRTH integer Object created/spawned
---@field S_EVENT_HUMAN_FAILURE integer Player‑induced failure
---@field S_EVENT_ENGINE_STARTUP integer Engine startup
---@field S_EVENT_ENGINE_SHUTDOWN integer Engine shutdown
---@field S_EVENT_PLAYER_ENTER_UNIT integer Player entered unit
---@field S_EVENT_PLAYER_LEAVE_UNIT integer Player left unit
---@field S_EVENT_PLAYER_COMMENT integer F10 map note/comment added by player
---@field S_EVENT_SHOOTING_START integer Unit started shooting
---@field S_EVENT_SHOOTING_END integer Unit stopped shooting
---@field S_EVENT_MARK_ADDED integer F10 mark added
---@field S_EVENT_MARK_CHANGE integer F10 mark modified
---@field S_EVENT_MARK_REMOVED integer F10 mark removed
---@field S_EVENT_KILL integer Kill credited
---@field S_EVENT_SCORE integer Score event
---@field S_EVENT_UNIT_LOST integer Unit lost or removed from roster
---@field S_EVENT_LANDING_AFTER_EJECTION integer Parachutist landed after ejection
---@field S_EVENT_PARATROOPER_LENDING integer Paratrooper landed (DCS spelling)
---@field S_EVENT_DISCARD_CHAIR_AFTER_EJECTION integer Ejection seat discarded
---@field S_EVENT_WEAPON_ADD integer Weapon object added/spawned
---@field S_EVENT_TRIGGER_ZONE integer Trigger zone related event
---@field S_EVENT_LANDING_QUALITY_MARK integer Landing quality mark/grade
---@field S_EVENT_BDA integer Battle Damage Assessment event
---@field S_EVENT_AI_ABORT_MISSION integer AI aborted mission
---@field S_EVENT_DAYNIGHT integer Day/Night transition
---@field S_EVENT_FLIGHT_TIME integer Flight time bookkeeping event
---@field S_EVENT_PLAYER_SELF_KILL_PILOT integer Player self‑kill of pilot
---@field S_EVENT_PLAYER_CAPTURE_AIRFIELD integer Player captured an airfield
---@field S_EVENT_EMERGENCY_LANDING integer Emergency landing or ditch

---@class AETHR.ENUMS.Coalition
---@field NEUTRAL integer Neutral coalition (coalition.side.NEUTRAL)
---@field RED integer Red coalition (coalition.side.RED)
---@field BLUE integer Blue coalition (coalition.side.BLUE)
---@field ALL integer Special sentinel meaning "all coalitions" (-1)

---@class AETHR.ENUMS.Phonetic
---@field A string "Alpha"
---@field B string "Bravo"
---@field C string "Charlie"
---@field D string "Delta"
---@field E string "Echo"
---@field F string "Foxtrot"
---@field G string "Golf"
---@field H string "Hotel"
---@field I string "India"
---@field J string "Juliett"
---@field K string "Kilo"
---@field L string "Lima"
---@field M string "Mike"
---@field N string "November"
---@field O string "Oscar"
---@field P string "Papa"
---@field Q string "Quebec"
---@field R string "Romeo"
---@field S string "Sierra"
---@field T string "Tango"
---@field U string "Uniform"
---@field V string "Victor"
---@field W string "Whiskey"
---@field X string "Xray"
---@field Y string "Yankee"
---@field Z string "Zulu"

---@class AETHR.ENUMS.LineTypes
---@field NoLine integer No line drawn
---@field Solid integer Solid line
---@field Dashed integer Dashed line
---@field Dotted integer Dotted line
---@field DashDot integer Dash‑dot line
---@field LongDash integer Long dash line
---@field TwoDash integer Double dash line

---@class AETHR.ENUMS.MarkerTypes
---@field Line integer Straight line
---@field Circle integer Circle
---@field Rect integer Rectangle
---@field Arrow integer Arrow
---@field Text integer Text label
---@field Quad integer Quadrilateral
---@field Freeform integer Freeform polygon
---@field MizMark integer Mission Editor mark style

---@class AETHR.ENUMS.TextStrings
---@field capturedBy string "has been captured by "
---@field contestedBy string "is contested by "
---@field Teams table


---@class AETHR.ENUMS.Countries table DCS country.id mapping.


---@class AETHR.ENUMS.Skill table AI skill level strings.
---@field Excellent string "Excellent"
---@field High string "High"
---@field Good string "Good"
---@field Average string "Average"
---@field Random string "Random"
---@field Player string "Player"


---@type AETHR.ENUMS
AETHR.ENUMS = {

    ObjectCategory = {
        UNIT = Object.Category.UNIT,
        WEAPON = Object.Category.WEAPON,
        STATIC = Object.Category.STATIC,
        SCENERY = Object.Category.SCENERY,
        BASE = Object.Category.BASE
    },
    UnitCategory = {
        AIRPLANE = Unit.Category.AIRPLANE,
        HELICOPTER = Unit.Category.HELICOPTER,
        GROUND_UNIT = Unit.Category.GROUND_UNIT,
        SHIP = Unit.Category.SHIP,
        STRUCTURE = Unit.Category.STRUCTURE
    },
    GroupCategory = {
        AIRPLANE = Group.Category.AIRPLANE,
        HELICOPTER = Group.Category.HELICOPTER,
        GROUND = Group.Category.GROUND,
        SHIP = Group.Category.SHIP,
        FARP = -1,
    },
    AirbaseCategory = {
        AIRDROME = Airbase.Category.AIRDROME,
        HELIPAD = Airbase.Category.HELIPAD,
        SHIP = Airbase.Category.SHIP
    },
    SurfaceType = {
        LAND = land.SurfaceType.LAND,
        SHALLOW_WATER = land.SurfaceType.SHALLOW_WATER,
        WATER = land.SurfaceType.WATER,
        ROAD = land.SurfaceType.ROAD,
        RUNWAY = land.SurfaceType.RUNWAY,
        NIL = "nil" -- Represents an undefined or non-existent surface type,
    },
    Events = {
        S_EVENT_SHOT = world.event.S_EVENT_SHOT,
        S_EVENT_HIT = world.event.S_EVENT_HIT,
        S_EVENT_TAKEOFF = world.event.S_EVENT_TAKEOFF,
        S_EVENT_LAND = world.event.S_EVENT_LAND,
        S_EVENT_CRASH = world.event.S_EVENT_CRASH,
        S_EVENT_EJECTION = world.event.S_EVENT_EJECTION,
        S_EVENT_REFUELING = world.event.S_EVENT_REFUELING,
        S_EVENT_DEAD = world.event.S_EVENT_DEAD,
        S_EVENT_PILOT_DEAD = world.event.S_EVENT_PILOT_DEAD,
        S_EVENT_BASE_CAPTURED = world.event.S_EVENT_BASE_CAPTURED,
        S_EVENT_MISSION_START = world.event.S_EVENT_MISSION_START, -- currently can not be caught in script due to happens before script load
        S_EVENT_MISSION_END = world.event.S_EVENT_MISSION_END,     -- currently can not be caught in script due to happens before script load
        S_EVENT_TOOK_CONTROL = world.event.S_EVENT_TOOK_CONTROL,
        S_EVENT_REFUELING_STOP = world.event.S_EVENT_REFUELING_STOP,
        S_EVENT_BIRTH = world.event.S_EVENT_BIRTH,
        S_EVENT_HUMAN_FAILURE = world.event.S_EVENT_HUMAN_FAILURE,
        S_EVENT_ENGINE_STARTUP = world.event.S_EVENT_ENGINE_STARTUP,
        S_EVENT_ENGINE_SHUTDOWN = world.event.S_EVENT_ENGINE_SHUTDOWN,
        S_EVENT_PLAYER_ENTER_UNIT = world.event.S_EVENT_PLAYER_ENTER_UNIT,
        S_EVENT_PLAYER_LEAVE_UNIT = world.event.S_EVENT_PLAYER_LEAVE_UNIT,
        S_EVENT_PLAYER_COMMENT = world.event.S_EVENT_PLAYER_COMMENT,
        S_EVENT_SHOOTING_START = world.event.S_EVENT_SHOOTING_START,
        S_EVENT_SHOOTING_END = world.event.S_EVENT_SHOOTING_END,
        S_EVENT_MARK_ADDED = world.event.S_EVENT_MARK_ADDED,
        S_EVENT_MARK_CHANGE = world.event.S_EVENT_MARK_CHANGE,
        S_EVENT_MARK_REMOVED = world.event.S_EVENT_MARK_REMOVED,
        S_EVENT_KILL = world.event.S_EVENT_KILL,
        S_EVENT_SCORE = world.event.S_EVENT_SCORE,
        S_EVENT_UNIT_LOST = world.event.S_EVENT_UNIT_LOST,
        S_EVENT_LANDING_AFTER_EJECTION = world.event.S_EVENT_LANDING_AFTER_EJECTION,
        S_EVENT_PARATROOPER_LENDING = world.event.S_EVENT_PARATROOPER_LENDING,
        S_EVENT_DISCARD_CHAIR_AFTER_EJECTION = world.event.S_EVENT_DISCARD_CHAIR_AFTER_EJECTION,
        S_EVENT_WEAPON_ADD = world.event.S_EVENT_WEAPON_ADD,
        S_EVENT_TRIGGER_ZONE = world.event.S_EVENT_TRIGGER_ZONE,
        S_EVENT_LANDING_QUALITY_MARK = world.event.S_EVENT_LANDING_QUALITY_MARK,
        S_EVENT_BDA = world.event.S_EVENT_BDA,
        S_EVENT_AI_ABORT_MISSION = world.event.S_EVENT_AI_ABORT_MISSION,
        S_EVENT_DAYNIGHT = world.event.S_EVENT_DAYNIGHT,
        S_EVENT_FLIGHT_TIME = world.event.S_EVENT_FLIGHT_TIME,
        S_EVENT_PLAYER_SELF_KILL_PILOT = world.event.S_EVENT_PLAYER_SELF_KILL_PILOT,
        S_EVENT_PLAYER_CAPTURE_AIRFIELD = world.event.S_EVENT_PLAYER_CAPTURE_AIRFIELD,
        S_EVENT_EMERGENCY_LANDING = world.event.S_EVENT_EMERGENCY_LANDING, -- useful event to handle when a bot ditches, and "group dead" condition can't be met
    },
    Coalition = {
        NEUTRAL = coalition.side.NEUTRAL,
        RED = coalition.side.RED,
        BLUE = coalition.side.BLUE,
        ALL = -1,
        CONTESTED = 3,
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
    MarkerTypes = { --- Marker shape types.
        Line = 1,
        Circle = 2,
        Rect = 3,
        Arrow = 4,
        Text = 5,
        Quad = 6,
        Freeform = 7,
        MizMark = 8,
    },
    TextStrings = {
        capturedBy = "has been captured by ",
        contestedBy = "is contested by ",
        Teams = {
            REDFOR = "REDFOR",
            BLUFOR = "BLUFOR",
            NEUTRAL = "Neutral",
            CONTESTED = "REDFOR and BLUFOR",
        },
    },
    Countries = country.id,
    Skill = {
        Excellent = "Excellent",
        High = "High",
        Good = "Good",
        Average = "Average",
        Random = "Random",
        Player = "Player",
    },
}
