# TYPES spawner ecosystem

### Anchors
- [AETHR._dynamicSpawner:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L868)
- Setters:
  - [setNumSpawnZones](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L928)
  - [setSpawnAmount](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L946)
  - [setNamePrefix](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L963)
  - [setSpawnTypeAmount](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L969)
  - [setGroupSizes](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L977)
  - [addExtraTypeToGroups](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L983)
- Internals:
  - [_seedRollUpdates](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L992)
  - [_introduceRandomness](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L1006)
  - [_distributeDifference](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L1036)
  - [_assignAndUpdateSubZones](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L1059)
  - [_thresholdClamp](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L1082)
  - [_confirmTotals](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L1115)
- Zones and settings:
  - [AETHR._spawnerZone:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L1177)
  - [setGroupSpacing](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L1276)
  - [setSpawnAmounts](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L1303)
  - [rollSpawnAmounts](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L1330)
  - [_UpdateGenThresholds](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L1365)
  - [AETHR._spawnSettings:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L1401)
  - [AETHR._spawnerTypeConfig:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L1444)

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