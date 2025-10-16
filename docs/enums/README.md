# AETHR ENUMS overview and usage diagrams

Primary anchors
- Root table initialization: [AETHR.ENUMS](../../dev/ENUMS.lua:337)
- Line styles: [AETHR.ENUMS.LineTypes](../../dev/ENUMS.lua:452)
- Marker shapes: [AETHR.ENUMS.MarkerTypes](../../dev/ENUMS.lua:461)
- Coalition constants: [AETHR.ENUMS.Coalition](../../dev/ENUMS.lua:418)
- Surface types: [AETHR.ENUMS.SurfaceType](../../dev/ENUMS.lua:365)
- DCS events: [AETHR.ENUMS.Events](../../dev/ENUMS.lua:374)
- Countries map: [AETHR.ENUMS.Countries](../../dev/ENUMS.lua:481)
- AI skill levels: [AETHR.ENUMS.Skill](../../dev/ENUMS.lua:483)
- Spawner categories: [AETHR.ENUMS.spawnTypes](../../dev/ENUMS.lua:490)
- Spawner category priority: [AETHR.ENUMS.spawnTypesPrio](../../dev/ENUMS.lua:562)
- Dynamic spawner types: [AETHR.ENUMS.dynamicSpawnerTypes](../../dev/ENUMS.lua:632)
- FSM sentinels: [AETHR.ENUMS.FSM](../../dev/ENUMS.lua:638)
- Restricted town types: [AETHR.ENUMS.restrictedTownTypes](../../dev/ENUMS.lua:650)

Documents and indices
- Master diagrams index: [docs/README.md](../README.md)
- AETHR overview: [docs/aethr/README.md](../aethr/README.md)
- SPAWNER: [docs/spawner/README.md](../spawner/README.md)
- ZONE_MANAGER: [docs/zone_manager/README.md](../zone_manager/README.md)
- WORLD: [docs/world/README.md](../world/README.md)
- MARKERS: [docs/markers/README.md](../markers/README.md)

Overview relationships

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart LR
  subgraph ENUMS [ENUMS]
    E[ENUMS root]
    LT[LineTypes]
    MT[MarkerTypes]
    CO[Coalition]
    ST[SurfaceType]
    EV[Events]
    CT[Countries]
    SK[Skill]
    SP[spawnTypes]
    SPQ[spawnTypesPrio]
    DST[dynamicSpawnerTypes]
    FSM[FSM]
    RTT[restrictedTownTypes]
  end

  subgraph Consumers [Consumers]
    subgraph WORLD [WORLD]
      W[WORLD]
    end
    subgraph ZM [ZONE_MANAGER]
      ZM[ZONE_MANAGER]
    end
    subgraph SPNR [SPAWNER]
      SPN[SPAWNER]
    end
    subgraph MK [MARKERS]
      MK[MARKERS]
    end
  end

  %% Edges
  E --> LT
  E --> MT
  E --> CO
  E --> ST
  E --> EV
  E --> CT
  E --> SK
  E --> SP
  E --> SPQ
  E --> DST
  E --> FSM
  E --> RTT

  MT -.-> MK
  LT -.-> MK
  CO -.-> W
  CO -.-> ZM
  ST -.-> ZM
  SP -.-> SPN
  SPQ -.-> SPN
  DST -.-> SPN
  SK -.-> SPN

  %% Class bucket assignments
  class E,LT,MT,CO,ST,EV,CT,SK,SP,SPQ,DST,FSM,RTT class-data;
  class W,ZM,SPN,MK class-compute;
```

Lookup and usage sequence

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
sequenceDiagram
  participant ZM as ZONE_MANAGER
  participant W as WORLD
  participant SP as SPAWNER
  participant MK as MARKERS
  participant EN as ENUMS

  ZM->>EN: SurfaceType, Coalition
  W->>EN: Coalition
  SP->>EN: spawnTypes, spawnTypesPrio, dynamicSpawnerTypes, Skill
  MK->>EN: MarkerTypes, LineTypes
```

Anchors in consuming modules
- MARKERS uses shapes and lines: [AETHR.MARKERS:drawPolygon()](../../dev/MARKERS.lua:85), [AETHR.MARKERS:drawArrow()](../../dev/MARKERS.lua:176)
- ZONE_MANAGER ownership integration: [AETHR.ZONE_MANAGER:initWatcher_AirbaseOwnership()](../../dev/ZONE_MANAGER.lua:1103), [AETHR.ZONE_MANAGER:initWatcher_ZoneOwnership()](../../dev/ZONE_MANAGER.lua:1113)
- WORLD ownership texts and updates: [AETHR.WORLD:updateZoneArrows()](../../dev/WORLD.lua:730)
- SPAWNER types and priorities: [AETHR.SPAWNER:seedTypes()](../../dev/SPAWNER.lua:1804), [AETHR.SPAWNER:generateGroupTypes()](../../dev/SPAWNER.lua:1600)

Notes
- ENUMS provides engine constant pass-throughs; when running outside DCS, ensure the environment provides required globals or inject stubs.
- Mermaid labels avoid double quotes and parentheses. All diagrams use GitHub Mermaid fenced blocks.
## Breakout documents

Focused ENUMS analysis pages with Mermaid diagrams and cross-module anchors.

- Categories: [categories.md](./categories.md)
- Lines and markers: [lines_and_markers.md](./lines_and_markers.md)
- Coalition and text strings: [coalition_and_text.md](./coalition_and_text.md)
- Surface types and NOGO: [surface_types.md](./surface_types.md)
- Spawn types and priority: [spawn_types.md](./spawn_types.md)

High-level usage map

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart LR
  subgraph ENUMS [ENUMS]
    EN[ENUMS]
    CO[Coalition]
    TS[TextStrings]
    LT[LineTypes]
    MT[MarkerTypes]
    ST[SurfaceType]
    SP[spawnTypes]
    SPQ[spawnTypesPrio]
    DST[dynamicSpawnerTypes]
  end

  subgraph Consumers [Consumers]
    W[WORLD ownership]
    ZM[ZONE_MANAGER render]
    MK[MARKERS draw]
    SPNR[SPAWNER NOGO]
  end

  EN --> CO
  EN --> TS
  EN --> LT
  EN --> MT
  EN --> ST
  EN --> SP
  EN --> SPQ
  EN --> DST

  CO -.-> W
  TS -.-> W
  LT -.-> ZM
  MT -.-> MK
  ST -.-> SPNR
  SP -.-> SPNR
  SPQ -.-> SPNR
  DST -.-> SPNR

  class EN,CO,TS,LT,MT,ST,SP,SPQ,DST class-data;
  class W,ZM,SPNR,MK class-compute;
```