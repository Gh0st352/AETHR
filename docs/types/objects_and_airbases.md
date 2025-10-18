# TYPES objects and airbases

Anchors
- [AETHR._FoundObject:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L198)
- [AETHR._foundObject:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L578)
- [AETHR._airbase:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L432)

Overview
- _FoundObject is a lightweight container for engine object id, desc, and position.
- _foundObject safely introspects a live engine object via pcall, capturing metadata, group context, and position where available.
- _airbase is a normalized descriptor for Airbase state with coordinates, coalition, and runway info.

# _foundObject introspection sequence
```mermaid
%% shared theme: docs/_mermaid/theme.json %%
sequenceDiagram
  participant C as Caller
  participant FO as _foundObject
  participant ENG as Engine object
  C->>FO: New(ENG)
  opt core metadata retrieval
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

# _foundObject fields overview
```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  subgraph F_SCOPE ["_foundObject (fields)"]
    F[_foundObject]
    subgraph IDS_G ["Identifiers"]
      IDS[id name ObjectID]
    end
    subgraph META_G ["Metadata"]
      META[callsign category categoryEx coalition country]
    end
    subgraph GEO_G ["Geometry"]
      GEO[position _vec3]
    end
    subgraph STATE_G ["State flags"]
      STATE[isActive isAlive isDead isBroken isEffective sensors]
    end
    subgraph GROUP_G ["Group context"]
      GRP[groupName groupUnitNames]
    end
    subgraph NEST_G ["AETHR nesting"]
      NEST[AETHR spawned divisionID groundUnitID]
    end
    F --> IDS
    F --> META
    F --> GEO
    F --> STATE
    F --> GRP
    F --> NEST
  end
  class F,IDS,META,GEO,STATE,GRP,NEST class_data;
```

# FoundObject lightweight container
```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart LR
  FO2[_FoundObject] --> id[id]
  FO2 --> desc[desc]
  FO2 --> pos[position _vec3]
  class FO2,id,desc,pos class_data;
```

# Airbase descriptor
```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  AB[_airbase] --> IDS[id id_]
  AB --> POS[coordinates x y z]
  AB --> DESC[description]
  AB --> N[name]
  AB --> CAT[category categoryText]
  AB --> COA[coalition previousCoalition]
  AB --> RUN[runways maxRunwayLength longestRunway]
  AB --> ZN[zoneName zoneObject]
  class AB,IDS,POS,DESC,N,CAT,COA,RUN,ZN class_data;
```

# Usage notes
- _foundObject safely degrades when engine APIs are missing or throw; all lookups are pcalled.
- Group metadata collection is conditional and robust to absent group or unit functions.
- Airbase zoneName and zoneObject connect to [_MIZ_ZONE](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L283) when available.

# Source anchors
- [AETHR._foundObject:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L578), [AETHR._FoundObject:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L198)
- [AETHR._airbase:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L432)