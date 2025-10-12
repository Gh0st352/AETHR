# AETHR SPAWNER zones and divisions

Covered functions
- [AETHR.SPAWNER:generateSpawnerZones()](dev/SPAWNER.lua:2012)
- [AETHR.SPAWNER:weightZones()](dev/SPAWNER.lua:2148)
- [AETHR.SPAWNER:pairSpawnerWorldDivisions()](dev/SPAWNER.lua:723)
- [AETHR.SPAWNER:pairSpawnerActiveZones()](dev/SPAWNER.lua:760)
- [AETHR.SPAWNER:pairSpawnerZoneDivisions()](dev/SPAWNER.lua:803)
- [AETHR.SPAWNER:determineZoneDivObjects()](dev/SPAWNER.lua:857)

1. Zone generation and weighting
The spawner constructs a main zone and subzones, then assigns weights to each. Generation avoids restricted zones when provided to POLY utilities. See [dev/POLY.lua](dev/POLY.lua).

```mermaid
flowchart TD
  Z0[generateSpawnerZones] --> Z1[reset subzones]
  Z1 --> Z2[create main zone object]
  Z2 --> Z3[compute sub zone minimum radius]
  Z3 --> Z4[call POLY generateSubCircles]
  Z4 --> Z5[instantiate spawner sub zone objects]
  Z5 --> W0[weightZones]
  W0 --> W1[compute sub weights as area over main area]
  W1 --> W2[set main weight to one minus sum of subs]
```

2. Pairing to divisions
The spawner pairs against MIZ zones when available, otherwise world divisions. Results populate dynamicSpawner.worldDivisions and per zone worldDivisions.

```mermaid
flowchart TD
  P0[start pairing] --> P1[any MIZ zones]
  P1 -- yes --> A0[pairSpawnerActiveZones]
  P1 -- no --> W2x[pairSpawnerWorldDivisions]
  A0 --> W3[worldDivisions set from active MIZ zone divisions]
  W2x --> W3
  W3 --> ZD[pairSpawnerZoneDivisions]
  ZD --> ZDm[filter divisions for main zone]
  ZD --> ZDs[filter divisions for each sub zone]
  ZDm --> OUT[zone worldDivisions assigned]
  ZDs --> OUT
```

3. Object collection per sub zone
For each sub zone and its divisions, objects are collected into zoneDivSceneryObjects, zoneDivStaticObjects, and zoneDivBaseObjects using AABB prefilter and optional full include optimization. Config switches: [UseDivisionAABBReject](dev/SPAWNER.lua:96), [UseDivisionAABBFullInclude](dev/SPAWNER.lua:97). Cooperative yielding: [AETHR.SPAWNER:_maybeYield()](dev/SPAWNER.lua:255).

```mermaid
flowchart TB
  S0[start collect] --> L0[for each sub zone]
  L0 --> L1[for each division]
  L1 --> AABB0[AABB available and reject enabled]
  AABB0 -- yes --> REJ[circle vs AABB distance greater than radius squared]
  REJ -- yes --> SKIP[skip division]
  REJ -- no --> INC[full include enabled]
  AABB0 -- no --> INC
  INC -- yes --> ALL[append all objects from division lists]
  INC -- no --> PO[per object distance within radius squared]
  PO --> ADD[append passing objects into zone lists]
  ALL --> NEXT[next division]
  ADD --> NEXT
  SKIP --> NEXT
  NEXT --> Y0[maybe yield]
  Y0 -- yes --> Y1[yield]
  Y0 -- no --> L1
```

Notes
- Division object sources come from WORLD databases for scenery, static, and base objects.
- Full include treats a division as entirely inside when all AABB corners lie inside the sub zone circle.
- Distance checks use squared distances to avoid square roots.