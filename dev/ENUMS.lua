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
---@field TextStrings AETHR.ENUMS.TextStrings Common user-facing text strings.
---@field Countries table DCS country.id mapping.
---@field Skill AETHR.ENUMS.Skill AI skill level strings.
---@field spawnTypes AETHR.ENUMS.spawnTypes
---@field spawnTypesPrio AETHR.ENUMS.spawnTypesPrio
---@field dynamicSpawnerTypes AETHR.ENUMS.dynamicSpawnerTypes
---@field FSM AETHR.ENUMS.FSM FSM sentinel values.
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
---@field FARP integer Forward arming and refueling point sentinel (-1)

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
---@field NIL string Sentinel "nil" representing undefined surface type

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
---@field CONTESTED integer Contested coalition sentinel (3)

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


--- DCS country.id mapping table (see AETHR.ENUMS.Countries value). Not enumerated here.


---@class AETHR.ENUMS.Skill
--- AI skill level strings.
---@field Excellent string "Excellent"
---@field High string "High"
---@field Good string "Good"
---@field Average string "Average"
---@field Random string "Random"
---@field Player string "Player"

---@class AETHR.ENUMS.spawnTypes
---@field Ships string "Ships"
---@field UnarmedShips string "Unarmed ships"
---@field ArmedShips string "Armed ships"
---@field LightArmedShips string "Light armed ships"
---@field HeavyArmedShips string "Heavy armed ships"
---@field Corvettes string "Corvettes"
---@field Frigates string "Frigates"
---@field Destroyers string "Destroyers"
---@field Cruisers string "Cruisers"
---@field AircraftCarriers string "Aircraft Carriers"
---@field GroundUnits string "Ground Units"
---@field Infantry string "Infantry"
---@field LightArmoredUnits string "LightArmoredUnits"
---@field IFV string "IFV"
---@field APC string "APC"
---@field Artillery string "Artillery"
---@field MLRS string "MLRS"
---@field HeavyArmoredUnits string "HeavyArmoredUnits"
---@field ModernTanks string "Modern Tanks"
---@field OldTanks string "Old Tanks"
---@field Tanks string "Tanks"
---@field Buildings string "Buildings"
---@field Fortifications string "Fortifications"
---@field GroundVehicles string "Ground vehicles"
---@field AAA string "AAA"
---@field AA_flak string "AA_flak"
---@field Static_AAA string "Static AAA"
---@field Mobile_AAA string "Mobile AAA"
---@field UnarmedVehicles string "Unarmed vehicles"
---@field Cars string "Cars"
---@field Trucks string "Trucks"
---@field SamElements string "SAM elements"
---@field IRGuidedSam string "IR Guided SAM"
---@field SR_SAM string "SR SAM"
---@field MR_SAM string "MR SAM"
---@field LR_SAM string "LR SAM"
---@field ArmedGroundUnits string "Armed ground units"
---@field MANPADS string "MANPADS"
---@field RocketAttack string "Rocket Attack Valid AirDefence"
---@field ArmedVehicles string "Armed vehicles"
---@field CRAM string "C-RAM"
---@field AirDefenceVehicles string "Air Defence vehicles"
---@field SAM_CC string "SAM CC"
---@field SAM string "SAM"
---@field human_vehicle string "human_vehicle"
---@field WS_Type string "</WSTYPE>"
---@field ATGM string "ATGM"
---@field EWR string "EWR"
---@field IndirectFire string "Indirect fire"
---@field All string "All"
---@field Datalink string "Datalink"
---@field SAM_LL string "SAM LL"
---@field MANPADS_AUX string "MANPADS AUX"
---@field SAM_TR string "SAM TR"
---@field Vehicles string "Vehicles"
---@field SAM_AUX string "SAM AUX"
---@field Armored_Vehicles string "Armored vehicles"
---@field SAM_SR string "SAM SR"
---@field New_Infantry string "New infantry"
---@field AA_missile string "AA_missile"
---@field SAM_related string "SAM related"
---@field GroundUnits_NonAirDefence string "Ground Units Non Airdefence"
---@field AntiAir_ArmedVehicles string "AntiAir Armed Vehicles"
---@field Infantry_Carriers string "Infantry carriers"
---@field Air_Defence string "Air Defence"
---@field NonAndLightArmoredUnits string "NonAndLightArmoredUnits"
---@field NonArmoredUnits string "NonArmoredUnits"
---@field ArmedAirDefence string "Armed Air Defence"
---@field Prone string "Prone"

---@class AETHR.ENUMS.spawnTypesPrio
---@field Ships integer "Ships"
---@field UnarmedShips integer "Unarmed ships"
---@field ArmedShips integer "Armed ships"
---@field LightArmedShips integer "Light armed ships"
---@field HeavyArmedShips integer "Heavy armed ships"
---@field Corvettes integer "Corvettes"
---@field Frigates integer "Frigates"
---@field Destroyers integer "Destroyers"
---@field Cruisers integer "Cruisers"
---@field AircraftCarriers integer "Aircraft Carriers"
---@field GroundUnits integer "Ground Units"
---@field Infantry integer "Infantry"
---@field LightArmoredUnits integer "LightArmoredUnits"
---@field IFV integer "IFV"
---@field APC integer "APC"
---@field Artillery integer "Artillery"
---@field MLRS integer "MLRS"
---@field HeavyArmoredUnits integer "HeavyArmoredUnits"
---@field ModernTanks integer "Modern Tanks"
---@field OldTanks integer "Old Tanks"
---@field Tanks integer "Tanks"
---@field Buildings integer "Buildings"
---@field Fortifications integer "Fortifications"
---@field GroundVehicles integer "Ground vehicles"
---@field AAA integer "AAA"
---@field AA_flak integer "AA_flak"
---@field Static_AAA integer "Static AAA"
---@field Mobile_AAA integer "Mobile AAA"
---@field UnarmedVehicles integer "Unarmed vehicles"
---@field Cars integer "Cars"
---@field Trucks integer "Trucks"
---@field SamElements integer "SAM elements"
---@field IRGuidedSam integer "IR Guided SAM"
---@field SR_SAM integer "SR SAM"
---@field MR_SAM integer "MR SAM"
---@field LR_SAM integer "LR SAM"
---@field ArmedGroundUnits integer "Armed ground units"
---@field MANPADS integer "MANPADS"
---@field RocketAttack integer "Rocket Attack Valid AirDefence"
---@field ArmedVehicles integer "Armed vehicles"
---@field CRAM integer "C-RAM"
---@field Prone integer "Prone"
---@field AirDefenceVehicles integer "Air Defence vehicles"
---@field SAM_CC integer "SAM CC"
---@field SAM integer "SAM"
---@field human_vehicle integer "human_vehicle"
---@field WS_Type integer "</WSTYPE>"
---@field ATGM integer "ATGM"
---@field EWR integer "EWR"
---@field IndirectFire integer "Indirect fire"
---@field All integer "All"
---@field Datalink integer "Datalink"
---@field SAM_LL integer "SAM LL"
---@field MANPADS_AUX integer "MANPADS AUX"
---@field SAM_TR integer "SAM TR"
---@field Vehicles integer "Vehicles"
---@field SAM_AUX integer "SAM AUX"
---@field Armored_Vehicles integer "Armored vehicles"
---@field SAM_SR integer "SAM SR"
---@field New_Infantry integer "New infantry"
---@field AA_missile integer "AA_missile"
---@field SAM_related integer "SAM related"
---@field GroundUnits_NonAirDefence integer "Ground Units Non Airdefence"
---@field AntiAir_ArmedVehicles integer "AntiAir Armed Vehicles"
---@field Infantry_Carriers integer "Infantry carriers"
---@field Air_Defence integer "Air Defence"
---@field NonAndLightArmoredUnits integer "NonAndLightArmoredUnits"
---@field NonArmoredUnits integer "NonArmoredUnits"
---@field ArmedAirDefence integer "Armed Air Defence"

---@class AETHR.ENUMS.dynamicSpawnerTypes
---@field Airbase string "Airbase"
---@field Zone string "Zone"
---@field Point string "Point"

---@class AETHR.ENUMS.FSM
---@field NONE string Sentinel value for "no state".
---@field ASYNC string Sentinel value for "asynchronous state".
---@field onBefore string
---@field onLeave string
---@field WaitingOnLeave string
---@field onEnter string
---@field on string
---@field WaitingOnEnter string
---@field onAfter string
---@field onStateChange string

---@class AETHR.ENUMS.restrictedTownTypes

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
    spawnTypes = {
        Ships = "Ships",
        UnarmedShips = "Unarmed ships",
        ArmedShips = "Armed ships",
        LightArmedShips = "Light armed ships",
        HeavyArmedShips = "Heavy armed ships",
        Corvettes = "Corvettes",
        Frigates = "Frigates",
        Destroyers = "Destroyers",
        Cruisers = "Cruisers",
        AircraftCarriers = "Aircraft Carriers",
        GroundUnits = "Ground Units",
        Infantry = "Infantry",
        LightArmoredUnits = "LightArmoredUnits",
        IFV = "IFV",
        APC = "APC",
        Artillery = "Artillery",
        MLRS = "MLRS",
        HeavyArmoredUnits = "HeavyArmoredUnits",
        ModernTanks = "Modern Tanks",
        OldTanks = "Old Tanks",
        Tanks = "Tanks",
        Buildings = "Buildings",
        Fortifications = "Fortifications",
        GroundVehicles = "Ground vehicles",
        AAA = "AAA",
        AA_flak = "AA_flak",
        Static_AAA = "Static AAA",
        Mobile_AAA = "Mobile AAA",
        UnarmedVehicles = "Unarmed vehicles",
        Cars = "Cars",
        Trucks = "Trucks",
        SamElements = "SAM elements",
        IRGuidedSam = "IR Guided SAM",
        SR_SAM = "SR SAM", ---short range sam
        MR_SAM = "MR SAM", ---mid range sam
        LR_SAM = "LR SAM", ---long range sam
        ArmedGroundUnits = "Armed ground units",
        MANPADS = "MANPADS",
        RocketAttack = "Rocket Attack Valid AirDefence",
        ArmedVehicles = "Armed vehicles",
        CRAM = "C-RAM",
        Prone = "Prone",
        AirDefenceVehicles = "Air Defence vehicles", ---THESE ARE EWR
        SAM_CC = "SAM CC",
        SAM = "SAM",
        human_vehicle = "human_vehicle", --KRAZ
        WS_Type = "</WSTYPE>",           --- B8M1, tt + HL
        ATGM = "ATGM",
        EWR = "EWR",
        IndirectFire = "Indirect fire",
        All = "All",
        Datalink = "Datalink",
        SAM_LL = "SAM LL",
        MANPADS_AUX = "MANPADS AUX",
        SAM_TR = "SAM TR", ---track radars
        Vehicles = "Vehicles",
        SAM_AUX = "SAM AUX",
        Armored_Vehicles = "Armored vehicles",
        SAM_SR = "SAM SR",             ---search radars
        New_Infantry = "New infantry", ---these are MANPADS
        AA_missile = "AA_missile",     ---mostly SAM  launchers
        SAM_related = "SAM related",
        GroundUnits_NonAirDefence = "Ground Units Non Airdefence",
        AntiAir_ArmedVehicles = "AntiAir Armed Vehicles",
        Infantry_Carriers = "Infantry carriers",
        Air_Defence = "Air Defence",
        NonAndLightArmoredUnits = "NonAndLightArmoredUnits",
        NonArmoredUnits = "NonArmoredUnits",
        ArmedAirDefence = "Armed Air Defence",
    },
    spawnTypesPrio = {
        Ships = 910,
        UnarmedShips = 920,
        ArmedShips = 930,
        LightArmedShips = 940,
        HeavyArmedShips = 950,
        Corvettes = 960,
        Frigates = 970,
        Destroyers = 980,
        Cruisers = 990,
        AircraftCarriers = 1000,
        GroundUnits = 350,
        Infantry = 370,
        LightArmoredUnits = 400,
        IFV = 530,
        APC = 540,
        Artillery = 510,
        MLRS = 520,
        HeavyArmoredUnits = 450,
        ModernTanks = 570,
        OldTanks = 560,
        Tanks = 550,
        Buildings = 650,
        Fortifications = 600,
        GroundVehicles = 300,
        AAA = 710,
        AA_flak = 730,
        Static_AAA = 720,
        Mobile_AAA = 750,
        UnarmedVehicles = 210,
        Cars = 250,
        Trucks = 270,
        SamElements = 800,
        IRGuidedSam = 890,
        SR_SAM = 860, ---short range sam
        MR_SAM = 870, ---mid range sam
        LR_SAM = 880, ---long range sam
        ArmedGroundUnits = 320,
        MANPADS = 891,
        RocketAttack = 260,
        ArmedVehicles = 250,
        CRAM = 760,
        Prone = 10,
        AirDefenceVehicles = 10, ---THESE ARE EWR
        SAM_CC = 10,
        SAM = 790,
        human_vehicle = 20, --KRAZ
        WS_Type = 30,       --- B8M1, tt + HL
        ATGM = 270,
        EWR = 900,
        IndirectFire = 40,
        All = 10,
        Datalink = 100,
        SAM_LL = 830,
        MANPADS_AUX = 850,
        SAM_TR = 840, ---track radars
        Vehicles = 290,
        SAM_AUX = 810,
        Armored_Vehicles = 220,
        SAM_SR = 820,       ---search radars
        New_Infantry = 340, ---these are MANPADS
        AA_missile = 770,   ---mostly SAM  launchers
        SAM_related = 780,
        GroundUnits_NonAirDefence = 190,
        AntiAir_ArmedVehicles = 80,
        Infantry_Carriers = 490,
        Air_Defence = 200,
        NonAndLightArmoredUnits = 180,
        NonArmoredUnits = 170,
        ArmedAirDefence = 210,
    },
    dynamicSpawnerTypes = {
        Airbase = "Airbase",
        Zone = "Zone",
        Point = "Point",
    },
    FSM = {
        onBefore = "onbefore",
        onLeave = "onleave",
        WaitingOnLeave = "WaitingOnLeave",
        onEnter = "onenter",
        on = "on",
        WaitingOnEnter = "WaitingOnEnter",
        onAfter = "onafter",
        onStateChange = "onstatechange",
        ASYNC = "async",
        NONE = "none",
    },
    restrictedTownTypes = {
        ["A_BLOCK"] = "A_BLOCK",
        ["A_FRWD"] = "A_FRWD",
        ["A_LEFT"] = "A_LEFT",
        ["A_RIGHT"] = "A_RIGHT",
        ["AIRBASE_BARRELS_01"] = "AIRBASE_BARRELS_01",
        ["AIRBASE_BARRELS_02"] = "AIRBASE_BARRELS_02",
        ["AIRBASE_VOR"] = "AIRBASE_VOR",
        ["B_BLOCK"] = "B_BLOCK",
        ["B_FRWD"] = "B_FRWD",
        ["B_LEFT"] = "B_LEFT",
        ["B_RIGHT"] = "B_RIGHT",
        ["BAK_NEW"] = "BAK_NEW",
        ["BASCETBALL"] = "BASCETBALL",
        ["BLK_LIGHT_POLE"] = "BLK_LIGHT_POLE",
        ["C_BLOCK"] = "C_BLOCK",
        ["C_LEFT"] = "C_LEFT",
        ["C_RIGHT"] = "C_RIGHT",
        ["D_BLOCK"] = "D_BLOCK",
        ["D_FRWD"] = "D_FRWD",
        ["D_LEFT"] = "D_LEFT",
        ["D_RIGHT"] = "D_RIGHT",
        ["DIRECTIONAL_APPROACH_ELEVATED_GREEN"] = "DIRECTIONAL_APPROACH_ELEVATED_GREEN",
        ["DIRECTIONAL_APPROACH_LIGHTS"] = "DIRECTIONAL_APPROACH_LIGHTS",
        ["DIRECTIONAL_APPROACH_LIGHTS_RED"] = "DIRECTIONAL_APPROACH_LIGHTS_RED",
        ["E_BLOCK"] = "E_BLOCK",
        ["E_LEFT"] = "E_LEFT",
        ["E_RIGHT"] = "E_RIGHT",
        ["F_BLOCK"] = "F_BLOCK",
        ["FOOTBALL"] = "FOOTBALL",
        ["IN_PAVEMENT_BI_DERECTIONAL_WHITE_ORANGE"] = "IN_PAVEMENT_BI_DERECTIONAL_WHITE_ORANGE",
        ["IN_PAVEMENT_BI_DERECTIONAL_WHITE_WHITE"] = "IN_PAVEMENT_BI_DERECTIONAL_WHITE_WHITE",
        ["MBY_SMALLLAMP_01"] = "MBY_SMALLLAMP_01",
        ["MOST(ROAD)BIG"] = "MOST(ROAD)BIG",
        ["MOST(ROAD)BIG_END"] = "MOST(ROAD)BIG_END",
        ["MOST(ROAD)SMALL"] = "MOST(ROAD)SMALL",
        ["MOST(ROAD)SMALL-A"] = "MOST(ROAD)SMALL-A",
        ["MST(ROAD)SMALL"] = "MST(ROAD)SMALL",
        ["STOP_LIGHT_RED"] = "STOP_LIGHT_RED",
        ["TAXIWAY_LIGHT_BLUE"] = "TAXIWAY_LIGHT_BLUE",
        ["TENNIS"] = "TENNIS",
    },
}
