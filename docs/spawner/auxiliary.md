# AETHR SPAWNER auxiliary logic flows

This file documents additional logic sequences defined in [dev/SPAWNER.lua](../../dev/SPAWNER.lua) to ensure complete coverage.

Covered functions
- Wrapper sequencing
  - [AETHR.SPAWNER:generateSpawnerGroups()](../../dev/SPAWNER.lua:660)
  - [AETHR.SPAWNER:rollGroupPlacement()](../../dev/SPAWNER.lua:670)
- Spawner lifecycle helpers
  - [AETHR.SPAWNER:newDynamicSpawner()](../../dev/SPAWNER.lua:467)
  - [AETHR.SPAWNER:assembleUnitsForGroup()](../../dev/SPAWNER.lua:358)
  - [AETHR.SPAWNER:spawnAirbaseFill()](../../dev/SPAWNER.lua:2169)


1) generateSpawnerGroups wrapper

```mermaid
flowchart TB
  G0[start generateSpawnerGroups] --> G1[rollSpawnGroups]
  G1 --> G2[rollGroupPlacement]
  G2 --> OUT[return self]
```

- rollSpawnGroups: see [types_and_counts.md](docs/spawner/types_and_counts.md) for type pool seeding and group typing.
- rollGroupPlacement: wrapper sequence documented below and detailed in [placement.md](docs/spawner/placement.md).


2) rollGroupPlacement wrapper

```mermaid
flowchart TB
  RP0[start rollGroupPlacement] --> D0[pairSpawnerZoneDivisions]
  D0 --> O0[determineZoneDivObjects]
  O0 --> C0[generateVec2GroupCenters]
  C0 --> U0[generateVec2UnitPos]
  U0 --> OUT[return self]
```

- Each step is documented with detailed flows in:
  - Zone division pairing and object collection: [zones_and_divisions.md](docs/spawner/zones_and_divisions.md)
  - Placement loops and grid hashing: [placement.md](docs/spawner/placement.md)


3) newDynamicSpawner

```mermaid
flowchart TB
  N0[start newDynamicSpawner] --> N1[compose name from COUNTERS.DYNAMIC_SPAWNERS]
  N1 --> N2[increment COUNTERS.DYNAMIC_SPAWNERS]
  N2 --> N3[AETHR._dynamicSpawner.New]
  N3 --> N4[register in DATA.dynamicSpawners by type and name]
  N4 --> OUT[return dynamicSpawner]
```

References
- Entry: [AETHR.SPAWNER:newDynamicSpawner()](../../dev/SPAWNER.lua:467)


4) assembleUnitsForGroup

```mermaid
flowchart TB
  A0[start assembleUnitsForGroup] --> A1[init empty units list]
  A1 --> A2[iterate UnitNames]
  A2 --> A3[lookup in DATA.generatedUnits by unit name]
  A3 --> C0{found}
  C0 -- yes --> A4[append prototype to units list]
  C0 -- no --> A5[skip unknown name]
  A4 --> NXT[next name]
  A5 --> NXT
  NXT --> OUT[return units list]
```

References
- Entry: [AETHR.SPAWNER:assembleUnitsForGroup()](../../dev/SPAWNER.lua:358)


5) spawnAirbaseFill

```mermaid
flowchart TB
  S0[start spawnAirbaseFill] --> S1[airbaseVec2 from longestRunway position x z]
  S1 --> S2[minRad equals runway length divided by two]
  S2 --> S3[maxRad equals runway length]
  S3 --> S4[nominalRadius equals average of minRad and maxRad]
  S4 --> S5[enqueueGenerateDynamicSpawner with autoSpawn true]
  S5 --> OUT[return self]
```

References
- Entry: [AETHR.SPAWNER:spawnAirbaseFill()](../../dev/SPAWNER.lua:2169)
- Enqueue: [AETHR.SPAWNER:enqueueGenerateDynamicSpawner()](../../dev/SPAWNER.lua:520)


Notes
- Wrapper diagrams ensure high level readability across files while detailed decision logic remains in specialized documents:
  - Type and count flows: [types_and_counts.md](docs/spawner/types_and_counts.md)
  - Zones and divisions: [zones_and_divisions.md](docs/spawner/zones_and_divisions.md)
  - Placement and NOGO checks: [placement.md](docs/spawner/placement.md), [nogo.md](docs/spawner/nogo.md)
  - Build and world actions: [spawn_despawn.md](docs/spawner/spawn_despawn.md)
  - Async job lifecycle and yielding: [async.md](docs/spawner/async.md)