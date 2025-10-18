# AETHR TYPES data structures and flows

### Primary constructors and anchors
- Basic geometry and containers
  - [AETHR._vec3:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L114)
  - [AETHR._vec2:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L522)
  - [AETHR._vec2xz:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L542)
  - [AETHR._ColorRGBA:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L27)
  - [AETHR._BBox:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L136)
  - [AETHR._ZoneCellEntry:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L178)
  - [AETHR._WorldBoundsAxis:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L51), [AETHR._WorldBounds:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L68)
- Mission and world descriptors
  - [AETHR._MIZ_ZONE:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L283)
  - [AETHR._WorldDivision:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L159)
  - [AETHR._Grid:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L330)
  - [AETHR._BorderInfo:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L232)
  - [AETHR._airbase:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L432)
  - [AETHR._FoundObject:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L198), [AETHR._foundObject:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L578)
- Markers and drawing
  - [AETHR._Marker:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L375)
- Spawner ecosystem
  - [AETHR._dynamicSpawner:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L868)
  - [AETHR._spawnerZone:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L1177)
  - [AETHR._spawnSettings:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L1401)
  - [AETHR._spawnerTypeConfig:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L1444)
  - [AETHR._circle:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L1471)

### Documents and indices
- Master diagrams index: [docs/README.md](../README.md)
- WORLD: [docs/world/README.md](../world/README.md)
- ZONE_MANAGER: [docs/zone_manager/README.md](../zone_manager/README.md)
- SPAWNER: [docs/spawner/README.md](../spawner/README.md)
- MARKERS: [docs/markers/README.md](../markers/README.md)
- POLY: [docs/poly/README.md](../poly/README.md)
- MATH: [docs/math/README.md](../math/README.md)

# Core relationships

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart LR
  subgraph TYPES ["Core Types"]
    Z[_MIZ_ZONE] --> BIF[_BorderInfo]
    Z --> L2[LinesVec2]
    Z --> AB[_airbase]
    WD[_WorldDivision] --> G[_Grid]

    DS[_dynamicSpawner] --> SZ[_spawnerZone]
    SZ --> SS[_spawnSettings]
    DS --> STC[_spawnerTypeConfig]
    SZ --> C[_circle]
    FO[_FoundObject]
    MK[_Marker]
  end

  subgraph INTEGRATIONS ["Integrations"]
    WORLD[WORLD DBs]
    MARKERS[MARKERS]
  end

  FO -.-> WORLD
  MK -.-> MARKERS

  class Z,BIF,L2,AB,WD,G,DS,SZ,SS,STC,C,FO,MK class_data;
  class WORLD,MARKERS class_compute;
```

# Spawner data flow at a glance

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
sequenceDiagram
  participant DS as _dynamicSpawner
  participant SZ as _spawnerZone
  participant SS as _spawnSettings
  participant STC as _spawnerTypeConfig

  DS->>DS: setNumSpawnZones(...)
  DS->>DS: setSpawnAmount(...)
  DS->>DS: _seedRollUpdates()
  DS->>DS: _introduceRandomness()
  DS->>DS: _distributeDifference()
  DS->>DS: _assignAndUpdateSubZones()
  loop per zone
    DS->>SZ: _UpdateGenThresholds()
    SZ-->>SS: thresholds updated (over/under Nom/Min/Max)
  end
  DS-->>STC: type limits and pools
```

# _zone and border structures

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  subgraph ZONE ["Zone structures"]
    ZC[_MIZ_ZONE] --> Lines[LinesVec2]
    ZC --> Towns[townsDB]
    ZC --> Divs[activeDivisions]
    ZC --> ABs[Airbases]
  end

  subgraph BORDER ["Borders"]
    BORDERS[BorderingZones map] --> BI[_BorderInfo]
    BI --> ZLine[ZoneLine]
    BI --> NLine[NeighborLine]
    BI --> Arrow[ArrowTip ArrowEnd]
  end

  ZC --> BORDERS

  class ZC,Lines,Towns,Divs,ABs,BORDERS,BI,ZLine,NLine,Arrow class_data;
```

# Airbase descriptor fields

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart LR
  AB[_airbase] --> ID[id, id_]
  AB --> POS[coordinates _vec3]
  AB --> DESC[description]
  AB --> N[name category categoryText]
  AB --> COA[coalition previousCoalition]
  AB --> RW[runways longestRunway maxRunwayLength]
  AB --> ZN[zoneName zoneObject]

  class AB,ID,POS,DESC,N,COA,RW,ZN class_data;
```

# Grid and world division

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  WD[_WorldDivision] --> ID2[ID active]
  WD --> CNR["corners[4]"]
  WD --> HT[height]
  WD --> G2[_Grid]
  G2 --> ORG[minX minZ]
  G2 --> STEP[dx dz invDx invDz]
  G2 --> COR[corners]

  class WD,ID2,CNR,HT,G2,ORG,STEP,COR class_data;
```

# Marker structure

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart LR
  MK[_Marker] --> id[markID]
  MK --> str[label string]
  MK --> pos[vec2Origin radius]
  MK --> style_[lineType lineColor fillColor coalition]
  MK --> verts[freeFormVec2Table]

  class MK,id,str,pos,style_,verts class_data;
```

# Found object container

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  FO[_foundObject] --> meta[callsign category country coalition]
  FO --> geo[position _vec3]
  FO --> group[groupName groupUnitNames]
  FO --> ids[id ObjectID name]
  FO --> state[isActive isAlive isDead etc]
  FO --> nest[AETHR.spawned divisionID groundUnitID]

  class FO,meta,geo,group,ids,state,nest class_data;
```

# Key anchors by area
- Zones and borders
  - [AETHR._MIZ_ZONE:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L283), [AETHR._BorderInfo:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L232)
- World and grid
  - [AETHR._WorldDivision:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L159), [AETHR._Grid:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L330), [AETHR._ZoneCellEntry:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L178)
- Spawner ecosystem
  - [AETHR._dynamicSpawner:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L868), [AETHR._spawnerZone:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L1177), [AETHR._spawnSettings:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L1401), [AETHR._spawnerTypeConfig:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L1444), [AETHR._circle:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L1471)
- Markers and IO-facing
  - [AETHR._Marker:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L375), [AETHR._FoundObject:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L198), [AETHR._airbase:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L432)

### Notes
- Mermaid labels avoid double quotes and parentheses.
- All diagrams use GitHub Mermaid fenced blocks.
## Breakout documents

- Constructors and vectors: [docs/types/constructors_and_vectors.md](constructors_and_vectors.md)
- Colors, markers, and grid: [docs/types/colors_markers_and_grid.md](colors_markers_and_grid.md)
- Bounds and world: [docs/types/bounds_and_world.md](bounds_and_world.md)
- Borders and zones: [docs/types/borders_and_zones.md](borders_and_zones.md)
- Objects and airbases: [docs/types/objects_and_airbases.md](objects_and_airbases.md)
- Scheduler and circle: [docs/types/scheduler_and_circle.md](scheduler_and_circle.md)
- Spawner ecosystem: [docs/types/spawner_types.md](spawner_types.md)