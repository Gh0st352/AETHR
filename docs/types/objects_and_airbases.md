# TYPES objects and airbases

Anchors
- [AETHR._FoundObject:New()](../../dev/customTypes.lua:198)
- [AETHR._foundObject:New()](../../dev/customTypes.lua:578)
- [AETHR._airbase:New()](../../dev/customTypes.lua:432)

Overview
- _FoundObject is a lightweight container for engine object id, desc, and position.
- _foundObject safely introspects a live engine object via pcall, capturing metadata, group context, and position where available.
- _airbase is a normalized descriptor for Airbase state with coordinates, coalition, and runway info.

_foundObject introspection sequence
```mermaid
sequenceDiagram
  participant C as Caller
  participant FO as _foundObject
  participant ENG as Engine object
  C->>FO: New(ENG)
  rect rgb(245,245,245)
    FO->>ENG: pcall getCallsign
    FO->>ENG: pcall getCategory
    FO->>ENG: pcall getCategoryEx
    FO->>ENG: pcall getCoalition
    FO->>ENG: pcall getCountry
    FO->>ENG: pcall getDesc
    FO->>ENG: pcall getID
    FO->>ENG: pcall getName
    FO->>ENG: pcall getPoint
    FO->>ENG: pcall getObjectID
  end
  alt group available
    FO->>ENG: pcall getGroup
    ENG-->>FO: GroupRef
    FO->>GroupRef: pcall getName
    FO->>GroupRef: pcall getUnits
    loop units
      FO->>Unit: pcall getName
      Unit-->>FO: unitName
    end
  end
  FO-->>C: instance with meta, position, group names, AETHR nest
```

_foundObject fields overview
```mermaid
flowchart TD
  F[_foundObject] --> META[callsign category categoryEx coalition country]
  F --> GEO[position _vec3]
  F --> IDS[id name ObjectID]
  F --> STATE[isActive isAlive isDead isBroken isEffective sensors]
  F --> GRP[groupName groupUnitNames]
  F --> NEST[AETHR spawned divisionID groundUnitID]
```

FoundObject lightweight container
```mermaid
flowchart LR
  FO2[_FoundObject] --> id[id]
  FO2 --> desc[desc]
  FO2 --> pos[position _vec3]
```

Airbase descriptor
```mermaid
flowchart TD
  AB[_airbase] --> IDS[id id_]
  AB --> POS[coordinates x y z]
  AB --> DESC[description]
  AB --> N[name]
  AB --> CAT[category categoryText]
  AB --> COA[coalition previousCoalition]
  AB --> RUN[runways maxRunwayLength longestRunway]
  AB --> ZN[zoneName zoneObject]
```

Usage notes
- _foundObject safely degrades when engine APIs are missing or throw; all lookups are pcalled.
- Group metadata collection is conditional and robust to absent group or unit functions.
- Airbase zoneName and zoneObject connect to [_MIZ_ZONE](../../dev/customTypes.lua:283) when available.

Source anchors
- [AETHR._foundObject:New()](../../dev/customTypes.lua:578), [AETHR._FoundObject:New()](../../dev/customTypes.lua:198)
- [AETHR._airbase:New()](../../dev/customTypes.lua:432)