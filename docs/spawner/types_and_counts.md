# AETHR SPAWNER types and counts

Covered functions
- Seeding and resolution
  - [AETHR.SPAWNER:seedTypes()](../../dev/SPAWNER.lua:1804)
  - [AETHR.SPAWNER:_resolveTypesForAttribute()](../../dev/SPAWNER.lua:1748)
  - [AETHR.SPAWNER:_toSpawnAttr()](../../dev/SPAWNER.lua:1712)
  - [AETHR.SPAWNER:_attrToEnumKey()](../../dev/SPAWNER.lua:1721)
- Group type generation
  - [AETHR.SPAWNER:generateGroupTypes()](../../dev/SPAWNER.lua:1600)
  - [AETHR.SPAWNER:rollSpawnGroups()](../../dev/SPAWNER.lua:1588)
- Counts and balancing
  - [AETHR.SPAWNER:generateSpawnAmounts()](../../dev/SPAWNER.lua:1918)
  - [AETHR.SPAWNER:rollSpawnGroupSizes()](../../dev/SPAWNER.lua:1876)
  - [AETHR.SPAWNER:_Jiggle()](../../dev/SPAWNER.lua:1978)
  - [AETHR.SPAWNER:_RollUpdates()](../../dev/SPAWNER.lua:2002)

1. Type seeding and attribute resolution

The spawner builds per-run type pools on each dynamic spawner to determine which unit attributes and concrete types can be drawn.

```mermaid
flowchart TB
  S0[start seedTypes] --> R0[for each spawnTypes entry on dynamicSpawner]
  R0 --> R1[resolve typesDB for attribute via _resolveTypesForAttribute]
  R1 --> C0{typesDB non-empty}
  C0 -- yes --> P1[add key to _typesPool; set actual to zero; record source tag]
  C0 -- no --> PX[exclude from pools]
  P1 --> CL[classify limited or non-limited into _limitedTypesPool or _nonLimitedTypesPool]
  PX --> N0[next type]
  CL --> N0
  N0 --> EX[for each extraTypes entry]
  EX --> EXR[resolve typesDB for extra attr; keep counters; do not add to draw pools]
  EXR --> DONE[end]
```

Resolution strategy in [AETHR.SPAWNER:_resolveTypesForAttribute()](../../dev/SPAWNER.lua:1748):
- Primary: WORLD prioritized bucket where the unit’s highest-priority attribute equals the target.
- Cross-bucket: scan other prioritized buckets in descending priority; include units whose attributes include target.
- Last resort: global attribute map in WORLD.
- Returns empty map when nothing matches.

Helpers:
- [AETHR.SPAWNER:_toSpawnAttr()](../../dev/SPAWNER.lua:1712) maps enum key or display string to canonical attribute.
- [AETHR.SPAWNER:_attrToEnumKey()](../../dev/SPAWNER.lua:1721) caches reverse mapping to enum key for priority ordering.

Notes
- Each typeData tracks actual draws this run and a max. Limited types are removed from the limited pool when actual reaches max.
- Extra types contribute only after a group’s core types are chosen and do not participate in pool exhaustion.

2. Group type generation

For each subzone and each group size setting, concrete unit types are selected from the seeded pools and extras are appended.

```mermaid
flowchart TB
  G0[start generateGroupTypes] --> Z0[for each subZone in dynamicSpawner.zones.sub]
  Z0 --> O0[determine iteration order: groupSizesPrio or sorted size keys]
  O0 --> L0[for each size in order]
  L0 --> GS[groupSizeConfig equals zone.groupSettings at size]
  GS --> L1[repeat for numGroups]
  L1 --> L2[init UnitTypes list and SpecificTypes list]
  L2 --> D0{limited pool has keys}
  D0 -- yes --> P0[pick random type key from limited pool]
  D0 -- no --> D1{non-limited pool has keys}
  D1 -- yes --> P1[pick random type key from non-limited pool]
  D1 -- no --> S1[stop filling this group]
  P0 --> C1[choose specific type from spawnTypes key typesDB]
  P1 --> C1
  C1 --> C2{specific exists}
  C2 -- yes --> APP[append to UnitTypes and SpecificTypes; inc actual; if actual==max drop from limited pool]
  C2 -- no --> RM[remove empty key from both pools]
  APP --> NXT[next unit slot up to group size]
  RM --> NXT
  NXT --> L3[after core types, append extraTypes min counts if candidate pools non-empty]
  L3 --> SET[set groupSizeConfig.generatedGroupTypes and generatedGroupUnitTypes]
  SET --> NEXTG[next group or size]
```

Outputs
- For each groupSizeConfig, fields are populated:
  - generatedGroupTypes: list of attribute keys per group.
  - generatedGroupUnitTypes: list of concrete unit type names per group.

3. Spawn amount computation and distribution

The main zone computes the total target count, subzones receive nudged targets, then a balancing pass jitters distribution.

```mermaid
flowchart TB
  A0[start generateSpawnAmounts] --> M0[read main base settings from dynamicSpawner: min nominal max nudgeFactor]
  M0 --> M1[mainZone setSpawnAmounts then rollSpawnAmounts]
  M1 --> CAVG[avg = main.generated.actual / numSubZones]
  CAVG --> B0[spawnsMin and spawnsMax from avg with ratio bounds and per-zone caps]
  B0 --> S0[for each subZone: set base.nominal=min=max around avg; nudgeFactor from main via MATH.generateNudge]
  S0 --> S1[subZone setSpawnAmounts then rollSpawnAmounts]
  S1 --> J0[call _Jiggle to rebalance]
  J0 --> DONE[end]
```

4. Jiggle and update chain

Rebalancing iterates a number of times equal to main.generated.nudgeReciprocal and applies a fixed method chain on the dynamic spawner.

```mermaid
sequenceDiagram
  participant SPAWNER
  participant DSP as _dynamicSpawner
  SPAWNER->>DSP: _Jiggle
  loop n times main.generated.nudgeReciprocal
    SPAWNER->>DSP: _seedRollUpdates()
    DSP-->>DSP: internal selection of subzones to adjust
    SPAWNER->>DSP: _introduceRandomness()
    DSP-->>DSP: perturb targets within ratios
    SPAWNER->>DSP: _distributeDifference()
    DSP-->>DSP: conserve total across subzones
    SPAWNER->>DSP: _assignAndUpdateSubZones()
    DSP-->>DSP: commit per-subzone generated counts
  end
```

Group size allocation after counts
- [AETHR.SPAWNER:rollSpawnGroupSizes()](../../dev/SPAWNER.lua:1876) converts each subzone’s generated count into discrete groups at sizes listed in groupSizesPrio, greedily filling larger sizes first.

5. Notes and guardrails

- Pool separation: dynamicSpawner._limitedTypesPool vs _nonLimitedTypesPool; only limited pool enforces per-type caps.
- Fallback: when limited pool empties, non-limited pool supplies additional units until both pools are exhausted.
- Extras: appended after core selection; they do not consume the limited/non-limited pools.
- Deterministic execution: if enabled with a seed, all random draws in the outer pipeline run under [AETHR.UTILS:withSeed()](../../dev/UTILS.lua:242), ensuring repeatable group typing and counts for the same seed.

6. Additional logic diagrams

6.1 Attribute resolution flow for [AETHR.SPAWNER:_resolveTypesForAttribute()](../../dev/SPAWNER.lua:1748)

```mermaid
flowchart TB
  R0[start _resolveTypesForAttribute targetKeyOrAttr] --> N0[normalize to attribute via _toSpawnAttr]
  N0 --> P0{primary bucket has entries}
  P0 -- yes --> OUTP[return primary with source primary]
  P0 -- no --> C0[collect cross bucket by descending priority using spawnTypesPrio]
  C0 --> C1{collected non empty}
  C1 -- yes --> OUTC[return collected with source cross]
  C1 -- no --> G0{global attribute map has entries}
  G0 -- yes --> OUTG[return global with source global]
  G0 -- no --> OUTE[return empty with source empty]
```

Notes
- Priority ordering uses reverse map from attribute name to enum key via [AETHR.SPAWNER:_attrToEnumKey()](../../dev/SPAWNER.lua:1721).


6.2 rollSpawnGroups wrapper [AETHR.SPAWNER:rollSpawnGroups()](../../dev/SPAWNER.lua:1588)

```mermaid
flowchart TB
  RS0[start rollSpawnGroups] --> RS1[seedTypes]
  RS1 --> RS2[generateGroupTypes]
  RS2 --> OUT[return self]
```


6.3 Group size allocation flow [AETHR.SPAWNER:rollSpawnGroupSizes()](../../dev/SPAWNER.lua:1876)

```mermaid
flowchart TB
  GS0[start rollSpawnGroupSizes] --> Z0[for each subZone]
  Z0 --> O0[read groupSizesPrio and spawnSettings.generated.actual]
  O0 --> L0[for each size in priority order]
  L0 --> Q0[numGroups equals floor of remaining over size]
  Q0 --> C0{numGroups greater than zero}
  C0 -- yes --> U0[set groupSettings at size .size and .numGroups; subtract allocated]
  C0 -- no --> SKIP[no allocation for this size]
  U0 --> NXT[next size]
  SKIP --> NXT
  NXT --> OUT[end]
```

Determinism note
- When deterministic mode is enabled, upstream random draws for typing and counts execute under [AETHR.UTILS:withSeed()](../../dev/UTILS.lua:242), as documented in [pipeline.md](docs/spawner/pipeline.md).
