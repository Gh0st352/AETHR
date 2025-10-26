# Town spawns: per-zone and all-zones

This document explains how town filler groups are spawned via ZONE_MANAGER using SPAWNER's DB cluster helper.

### Primary anchors
- [AETHR.ZONE_MANAGER:spawnTownsZone()](https://github.com/Gh0st352/AETHR/blob/main/dev/ZONE_MANAGER.lua#L1170)
- [AETHR.ZONE_MANAGER:spawnTownsAllZones()](https://github.com/Gh0st352/AETHR/blob/main/dev/ZONE_MANAGER.lua#L1208)
- [AETHR.ZONE_MANAGER:spawnTownsCircle()](https://github.com/Gh0st352/AETHR/blob/main/dev/ZONE_MANAGER.lua#L1238)
- [AETHR.ZONE_MANAGER:pairTowns()](https://github.com/Gh0st352/AETHR/blob/main/dev/ZONE_MANAGER.lua#L183)
- [AETHR.SPAWNER:spawnDBClusterFill()](https://github.com/Gh0st352/AETHR/blob/main/dev/SPAWNER.lua#L2170)
- [AETHR.SPAWNER:enqueueGenerateDynamicSpawner()](https://github.com/Gh0st352/AETHR/blob/main/dev/SPAWNER.lua#L520)
- [WORLD towns clustering](../world/towns.md)
- [CONFIG defaults: DefaultRedCountry / DefaultBlueCountry](https://github.com/Gh0st352/AETHR/blob/main/dev/CONFIG_.lua#L177)
- Last updated: 2025-10-26

### Preconditions
- ZONE_MANAGER has populated [DATA.MIZ_ZONES](../zone_manager/zone_data.md) and paired towns via [pairTowns](https://github.com/Gh0st352/AETHR/blob/main/dev/ZONE_MANAGER.lua#L183).
- WORLD has town clusters available; see [docs/world/towns.md](../world/towns.md).
- SPAWNER has at least one dynamic spawner registered under type "Town" (in [SPAWNER.DATA.dynamicSpawners.Town](../spawner/README.md)) or you pass one explicitly.

# Per-zone flow

Entry: [AETHR.ZONE_MANAGER:spawnTownsZone()](https://github.com/Gh0st352/AETHR/blob/main/dev/ZONE_MANAGER.lua#L1169)

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  ST1["spawnTownsZone(zoneName,countryID,minTownRadius,spawner?,spawnChance?,maxTownRadius?)"] --> ST2["resolve zone from DATA.MIZ_ZONES"]
  ST2 --> ST3{zone exists?}
  ST3 -- "no" --> STX[return self]
  ST3 -- "yes" --> ST4[iterate zone.townsDB]
  ST4 --> ST5{"minTownRadius <= town.Radius <= maxTownRadius"}
  ST5 -- "no" --> ST4
  ST5 -- "yes" --> ST6[roll spawnChance if nil]
  ST6 --> ST7{"math.random() <= spawnChance"}
  ST7 -- "no" --> ST4
  ST7 -- "yes" --> ST8["pick or use dynamicSpawner (Town)"]
  ST8 --> ST9["SPAWNER.spawnDBClusterFill(town,countryID,spawner)"]
  ST9 --> ST4
  ST4 --> ST10[return self]
  class ST2,ST4,ST8 class_compute;
  class ST3,ST5,ST7 class_decision;
  class ST1,ST6,ST9 class_step;
  class STX,ST10 class_result;
```

# All-zones flow

Entry: [AETHR.ZONE_MANAGER:spawnTownsAllZones()](https://github.com/Gh0st352/AETHR/blob/main/dev/ZONE_MANAGER.lua#L1214)

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  SAZ1["spawnTownsAllZones(minTownRadius,spawner?,spawnChance?,maxTownRadius?)"] --> C0[read REDSTART and BLUESTART from CONFIG MAIN MIZ_ZONES]
  subgraph "Config"
    C0 --> C1[DefaultRedCountry, DefaultBlueCountry]
  end
  subgraph "Iterate zones"
    C1 --> R1["for each red start zone: spawnTownsZone(z, redCountry, minTownRadius, spawner, spawnChance, maxTownRadius)"]
    C1 --> B1["for each blue start zone: spawnTownsZone(z, blueCountry, minTownRadius, spawner, spawnChance, maxTownRadius)"]
  end
  R1 --> OUT[return self]
  B1 --> OUT
  class C0,C1 class_io;
  class R1,B1 class_step;
  class OUT class_result;
```

# Circle-based flow

Entry: [AETHR.ZONE_MANAGER:spawnTownsCircle()](https://github.com/Gh0st352/AETHR/blob/main/dev/ZONE_MANAGER.lua#L1238)

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  SC1["spawnTownsCircle(vec2,radius,countryID,minTownRadius?,maxTownRadius?,spawner?,spawnChance?)"] --> SC2["iterate WORLD.DATA.townClusterDB"]
  SC2 --> SC3{"minTownRadius <= town.Radius <= maxTownRadius"}
  SC3 -- "no" --> SC2
  SC3 -- "yes" --> SC4{"distance2(town.Center, vec2) <= radius^2"}
  SC4 -- "no" --> SC2
  SC4 -- "yes" --> SC5[roll spawnChance if nil]
  SC5 --> SC6{"math.random() <= spawnChance"}
  SC6 -- "no" --> SC2
  SC6 -- "yes" --> SC7["pick or use dynamicSpawner (Town)"]
  SC7 --> SC8["SPAWNER.spawnDBClusterFill(town,countryID,spawner)"]
  SC8 --> SC2
  SC2 --> OUT[return self]
  class SC2,SC7 class_compute;
  class SC3,SC4,SC6 class_decision;
  class SC1,SC5,SC8 class_step;
  class OUT class_result;
```

# Runtime sequence (enqueue to world spawn)

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
sequenceDiagram
  participant ZM as ZONE_MANAGER
  participant SP as SPAWNER
  participant BR as BRAIN
  participant WL as WORLD

  note over ZM: For each selected town cluster
  ZM->>SP: spawnDBClusterFill(cluster, countryID, spawner)
  SP-->>SP: enqueueGenerateDynamicSpawner(..., autoSpawn=true)
  BR->>SP: generateDynamicSpawner(params)
  SP-->>SP: buildSpawnGroups
  BR->>SP: spawnDynamicSpawner (auto spawn)
  SP->>WL: coalition.addGroup per group - push to spawnQueue
```

# Determinism and controls

- spawnDBClusterFill enqueues jobs with autoSpawn set; generation itself can be deterministic when a seed is provided on the dynamic spawner and determinism is enabled. See:
  - [AETHR.SPAWNER:generateDynamicSpawner()](https://github.com/Gh0st352/AETHR/blob/main/dev/SPAWNER.lua#L563) and [AETHR.UTILS:withSeed()](https://github.com/Gh0st352/AETHR/blob/main/dev/UTILS.lua#L242)
  - SPAWNER deterministic config fields (Enabled, Warmup, ReseedAfter) in [SPAWNER.DATA.CONFIG.Deterministic](https://github.com/Gh0st352/AETHR/blob/main/dev/SPAWNER.lua#L103)

# Notes and guardrails

- minTownRadius and maxTownRadius filter town clusters by size; bounds are inclusive. If maxTownRadius is nil it defaults to math.huge.
- spawnChance defaults to a random draw per town when nil; pass an explicit 0..1 to control density.
- When spawner is nil, one is chosen from SPAWNER.DATA.dynamicSpawners.Town using utilities.
- Countries: for all-zones flow, sides use CONFIG defaults; for per-zone, pass countryID explicitly.
- Placement respects NOGO surfaces and optional restricted polygons; see [SPAWNER NOGO](../spawner/nogo.md).

# Example

Lua (inside mission setup or script):

```lua
-- Ensure towns are paired
AETHR.ZONE_MANAGER:pairTowns()

-- Spawn towns across configured starter zones, 500m <= town radius <= 2000m, 50% chance
local minTownRadius = 500
local maxTownRadius = 2000
local spawnChance = 0.5
AETHR.ZONE_MANAGER:spawnTownsAllZones(minTownRadius, nil, spawnChance, maxTownRadius)

-- Spawn towns within a 10km circle around a point for RED, 300m <= radius <= 1500m, 60% chance
local center = { x = 250000, y = 350000 }
local radius = 10000
local countryID = AETHR.CONFIG.MAIN.DefaultRedCountry
AETHR.ZONE_MANAGER:spawnTownsCircle(center, radius, countryID, 300, 1500, nil, 0.6)
```

# Cross-links

- Airbases: [zone_manager/airbases.md](./airbases.md)
- WORLD towns: [world/towns.md](../world/towns.md)
- SPAWNER helpers: [spawner/auxiliary.md](../spawner/auxiliary.md)