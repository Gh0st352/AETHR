# AETHR CONFIG world bounds and divisions

How worldBounds and worldDivisionArea drive grid generation, AABB caching, activation against zones, and persistence.

# Source anchors

- Config fields
  - worldDivisionArea default at [dev/CONFIG_.lua](https://github.com/Gh0st352/AETHR/blob/main/dev/CONFIG_.lua#L244)
  - worldBounds theaters at [dev/CONFIG_.lua](https://github.com/Gh0st352/AETHR/blob/main/dev/CONFIG_.lua#L245)
- World generation and activation
  - [AETHR.WORLD:generateWorldDivisions()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L1156)
  - [AETHR.WORLD:initWorldDivisions()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L1176)
  - [AETHR.WORLD:buildWorldDivAABBCache()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L1206)
  - [AETHR.WORLD:checkDivisionsInZones()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L1328)
  - [AETHR.WORLD:generateActiveDivisions()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L1067)
- Persistence
  - [AETHR.WORLD:loadWorldDivisions()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L1096)
  - [AETHR.WORLD:saveWorldDivisions()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L1112)
  - [AETHR.WORLD:loadWorldDivisionsAABB()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L1126)
  - [AETHR.WORLD:saveWorldDivisionsAABB()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L1140)

# Overview

- worldBounds selects theater coordinate ranges for X and Z
- worldDivisionArea determines target area per grid division in square meters
- WORLD converts bounds to a polygon, divides it into rectangular divisions, assigns IDs, and caches AABB for fast spatial tests
- Divisions are marked active when they overlap mission zones

# Generation pipeline

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TB
  subgraph GEN_PIPE [Generation pipeline]
    WB[CONFIG MAIN worldBounds THEATER] --> BP[POLY convertBoundsToPolygon]
    WDA[CONFIG MAIN worldDivisionArea] --> DP[POLY dividePolygon by area]
    BP --> DP
    DP --> DIVS[worldDivisions with IDs]
    DIVS --> AABB[buildWorldDivAABBCache]
    DIVS --> SAVE[saveWorldDivisions]
    AABB --> SAVE_AABB[saveWorldDivisionsAABB]
  end

  classDef node class_node
  class WB,BP,WDA,DP,DIVS,AABB,SAVE,SAVE_AABB node
```

# Initialization and reuse

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
sequenceDiagram
  participant W as WORLD
  W->>W: initWorldDivisions
  alt divisions on disk
    W->>W: loadWorldDivisions
  else missing
    W->>W: generateWorldDivisions
    W->>W: saveWorldDivisions
  end
  alt aabb on disk
    W->>W: loadWorldDivisionsAABB
  else missing
    W->>W: buildWorldDivAABBCache
    W->>W: saveWorldDivisionsAABB
  end
```

# Activation against zones

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TB
  subgraph ACTIVATION["Activation against zones"]
    DIVS[worldDivisions] --> GRID[initGrid metrics]
    ZONES[MIZ_ZONES polygons] --> INDEX[buildZoneCellIndex]
    GRID --> INDEX
    INDEX --> TEST[checkDivisionsInZones overlap tests]
    TEST --> ACTIVE[generateActiveDivisions saveDivisions]
  end

  class DIVS,GRID,ZONES,INDEX,TEST,ACTIVE class_step;
```

# Key logic details

- [AETHR.WORLD:generateWorldDivisions()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L1156)
  - Uses POLY helpers to convert config bounds to a polygon and divide it by area
  - Assigns numeric ID and sets active to false

- [AETHR.WORLD:buildWorldDivAABBCache()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L1206)
  - Computes minX maxX minZ maxZ for each division corners and stores in DATA.worldDivAABB

- [AETHR.WORLD:checkDivisionsInZones()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L1328)
  - Builds a zone cell index from zone polygons using grid metrics
  - Performs bounding box rejection then polygon overlap to set div.active

- [AETHR.WORLD:generateActiveDivisions()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L1067)
  - Populates DATA.saveDivisions with active divisions

# Persistence locations

- Divisions file: [CONFIG.MAIN.STORAGE.FILENAMES.WORLD_DIVISIONS_FILE](https://github.com/Gh0st352/AETHR/blob/main/dev/CONFIG_.lua#L222) under PATHS.CONFIG_FOLDER
- AABB file: [CONFIG.MAIN.STORAGE.FILENAMES.WORLD_DIVISIONS_AABB](https://github.com/Gh0st352/AETHR/blob/main/dev/CONFIG_.lua#L221) under PATHS.CONFIG_FOLDER

# Theater configuration

- Supported theaters are listed at [dev/CONFIG_.lua](https://github.com/Gh0st352/AETHR/blob/main/dev/CONFIG_.lua#L246)
- THEATER is set at instance creation when available in env.mission; see [AETHR:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L141)

# Validation checklist

- worldDivisionArea defined at [dev/CONFIG_.lua](https://github.com/Gh0st352/AETHR/blob/main/dev/CONFIG_.lua#L244)
- worldBounds theaters block at [dev/CONFIG_.lua](https://github.com/Gh0st352/AETHR/blob/main/dev/CONFIG_.lua#L246)
- Generation function at [AETHR.WORLD:generateWorldDivisions()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L1156)
- Activation and zone overlap at [AETHR.WORLD:checkDivisionsInZones()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L1328)
- AABB cache at [AETHR.WORLD:buildWorldDivAABBCache()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L1206)
- Persistence methods at [dev/WORLD.lua](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L1096)

# Related breakouts

- Paths and filenames: [paths_and_filenames.md](./paths_and_filenames.md)
- Zone paint and bounds: [zone_paint_and_bounds.md](./zone_paint_and_bounds.md)
- Init and persistence: [init_and_persistence.md](./init_and_persistence.md)