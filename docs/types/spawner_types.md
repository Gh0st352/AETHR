# TYPES spawner ecosystem

### Anchors
- [AETHR._dynamicSpawner:New()](../../dev/customTypes.lua:868)
- Setters:
  - [setNumSpawnZones](../../dev/customTypes.lua:928)
  - [setSpawnAmount](../../dev/customTypes.lua:946)
  - [setNamePrefix](../../dev/customTypes.lua:963)
  - [setSpawnTypeAmount](../../dev/customTypes.lua:969)
  - [setGroupSizes](../../dev/customTypes.lua:977)
  - [addExtraTypeToGroups](../../dev/customTypes.lua:983)
- Internals:
  - [_seedRollUpdates](../../dev/customTypes.lua:992)
  - [_introduceRandomness](../../dev/customTypes.lua:1006)
  - [_distributeDifference](../../dev/customTypes.lua:1036)
  - [_assignAndUpdateSubZones](../../dev/customTypes.lua:1059)
  - [_thresholdClamp](../../dev/customTypes.lua:1082)
  - [_confirmTotals](../../dev/customTypes.lua:1115)
- Zones and settings:
  - [AETHR._spawnerZone:New()](../../dev/customTypes.lua:1177)
  - [setGroupSpacing](../../dev/customTypes.lua:1276)
  - [setSpawnAmounts](../../dev/customTypes.lua:1303)
  - [rollSpawnAmounts](../../dev/customTypes.lua:1330)
  - [_UpdateGenThresholds](../../dev/customTypes.lua:1365)
  - [AETHR._spawnSettings:New()](../../dev/customTypes.lua:1401)
  - [AETHR._spawnerTypeConfig:New()](../../dev/customTypes.lua:1444)

# Overview
- _dynamicSpawner coordinates counts and type distribution across a main zone and multiple sub-zones.
- Setters define nominal ranges and nudge factors. Internals roll values, introduce bounded randomness, clamp thresholds, and confirm totals.
- _spawnerZone stores per-zone weights, spacing, and generated spawn settings, leveraging _spawnSettings for min max nominal with thresholds.
- _spawnerTypeConfig defines per-type limits and pools.

# Spawner orchestration
```mermaid
%% shared theme: docs/_mermaid/theme.json %%
sequenceDiagram
  participant DS as _dynamicSpawner
  participant SZ as _spawnerZone
  participant SS as _spawnSettings
  DS->>DS: setNumSpawnZones(nom, min, max, nudge)
  DS->>DS: setSpawnAmount(nom, min, max, nudge)
  DS->>DS: setNamePrefix(prefix)
  DS->>DS: setSpawnTypeAmount(type, max, limited, min)
  DS->>DS: setGroupSizes(max, min)
  DS->>DS: addExtraTypeToGroups(type, count)

  Note over DS: Prepare distributions per sub-zone
  DS->>DS: _seedRollUpdates()
  DS->>DS: _introduceRandomness()
  DS->>DS: _distributeDifference()
  loop per sub-zone
    DS->>DS: _assignAndUpdateSubZones()
    DS->>SZ: _UpdateGenThresholds()
    SZ-->>SS: thresholds refresh
    DS->>DS: _thresholdClamp(SZ)
  end
  DS-->>DS: _confirmTotals()
```

# Zones and spacing
```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  subgraph SZ_SCOPE ["_spawnerZone New"]
    SZ[_spawnerZone New]
    RADS[nominal min max nudge actual]
    AREA[area diameter]
    WEIGHT[weight]
    CENTER[center vec2]
    GROUPS[groupSettings groupSizesPrio]
    SZ --> RADS
    SZ --> AREA
    SZ --> WEIGHT
    SZ --> CENTER
    SZ --> GROUPS
  end

  subgraph SPACING_SCOPE ["Spacing per group size"]
    SPACING[setGroupSpacing per size]
    Gmin[minGroups]
    Gmax[maxGroups]
    Umin[minUnits]
    Umax[maxUnits]
    Bmin[minBuildings]
    SPACING --> Gmin
    SPACING --> Gmax
    SPACING --> Umin
    SPACING --> Umax
    SPACING --> Bmin
  end

  subgraph SETTINGS_SCOPE ["Spawn settings"]
    BASE[spawnSettings base]
    GEN[spawnSettings generated]
    GROUPS --> SPACING
    SZ --> BASE
    SZ --> GEN
  end

  class SZ,RADS,AREA,WEIGHT,CENTER,GROUPS,SPACING,Gmin,Gmax,Umin,Umax,Bmin,BASE,GEN,SZ_SCOPE,SPACING_SCOPE,SETTINGS_SCOPE class_data;
```

# Spawn settings lifecycle
```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart LR
  subgraph BASE_SCOPE ["setSpawnAmounts (base)"]
    BASE[setSpawnAmounts] --> calcNom[ceil nominal]
    calcNom --> ratios[ratioMax ratioMin]
    ratios --> weighted[weighted actualWeighted divisionFactor]
    weighted --> thresholds1[overNom underNom overMax underMax overMin underMin]
  end

  subgraph GEN_SCOPE ["rollSpawnAmounts (generated)"]
    GEN[rollSpawnAmounts] --> nudge[generateNudge]
    nudge --> genNom[generateNominal]
    genNom --> genBounds[min max]
    genBounds --> genWeighted[weighted divisionFactor actual]
    genWeighted --> thresholds2[overNom underNom overMax underMax overMin underMin]
  end

  UPDATE[_UpdateGenThresholds] --> thresholds2

  class BASE,calcNom,ratios,weighted,thresholds1,GEN,nudge,genNom,genBounds,genWeighted,thresholds2,UPDATE,BASE_SCOPE,GEN_SCOPE class_data;
```

# Key behaviors
- setNumSpawnZones and setSpawnAmount compute final counts using MATH.generateNominal under the hood, with nudge factors to vary around nominal while honoring min and max.
- _introduceRandomness perturbs sub-zone actuals within allowed ranges and the main max constraint.
- _distributeDifference reconciles totals to match the main expected actual.
- _thresholdClamp nudges out-of-bounds sub-zone actuals back toward valid ranges using a randomized index selection.
- _confirmTotals recomputes and stores the aggregate for later verification.

# Related anchors and modules
- MATH randomization helpers indexed under MATH docs:
  - [Randomization helpers](../math/randomization.md)
- WORLD integration of divisions and zone pairing:
  - [Zones and divisions pairing](../spawner/zones_and_divisions.md)