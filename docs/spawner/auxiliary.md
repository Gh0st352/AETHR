# AETHR SPAWNER auxiliary logic flows

This file documents additional logic sequences defined in [dev/SPAWNER.lua](../../dev/SPAWNER.lua) to ensure complete coverage.

# Covered functions
- Wrapper sequencing
  - [AETHR.SPAWNER:generateSpawnerGroups()](../../dev/SPAWNER.lua:660)
  - [AETHR.SPAWNER:rollGroupPlacement()](../../dev/SPAWNER.lua:670)
- Spawner lifecycle helpers
  - [AETHR.SPAWNER:newDynamicSpawner()](../../dev/SPAWNER.lua:467)
  - [AETHR.SPAWNER:assembleUnitsForGroup()](../../dev/SPAWNER.lua:358)
  - [AETHR.SPAWNER:spawnAirbaseFill()](../../dev/SPAWNER.lua:2169)


# 1) generateSpawnerGroups wrapper

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TB
  subgraph "Wrapper"
    direction TB
    G0[start generateSpawnerGroups] --> G1[rollSpawnGroups]
    G1 --> G2[rollGroupPlacement]
  end
  G2 --> OUT[return self]
  class G0 class_io;
  class G1,G2 class_step;
  class OUT class_result;
```

- rollSpawnGroups: see [types_and_counts.md](./types_and_counts.md) for type pool seeding and group typing.
- rollGroupPlacement: wrapper sequence documented below and detailed in [placement.md](./placement.md).


# 2) rollGroupPlacement wrapper

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TB
  subgraph "Wrapper"
    direction TB
    RP0[start rollGroupPlacement] --> D0[pairSpawnerZoneDivisions]
    D0 --> O0[determineZoneDivObjects]
    O0 --> C0[generateVec2GroupCenters]
    C0 --> U0[generateVec2UnitPos]
  end
  U0 --> OUT[return self]
  class RP0 class_io;
  class D0,O0,C0,U0 class_step;
  class OUT class_result;
```

- Each step is documented with detailed flows in:
  - Zone division pairing and object collection: [zones_and_divisions.md](./zones_and_divisions.md)
  - Placement loops and grid hashing: [placement.md](./placement.md)


# 3) newDynamicSpawner

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TB
  N0[start newDynamicSpawner] --> N1[compose name from COUNTERS.DYNAMIC_SPAWNERS]
  subgraph "Name and counter"
    direction TB
    N1 --> N2[increment COUNTERS.DYNAMIC_SPAWNERS]
  end
  N2 --> N3[AETHR._dynamicSpawner.New]
  subgraph "Registry"
    direction TB
    N3 --> N4[register in DATA.dynamicSpawners by type and name]
  end
  N4 --> OUT[return dynamicSpawner]
  class N0 class_io;
  class N1,N2,N4 class_step;
  class N3 class_compute;
  class OUT class_result;
```

References
- Entry: [AETHR.SPAWNER:newDynamicSpawner()](../../dev/SPAWNER.lua:467)


# 4) assembleUnitsForGroup

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TB
  A0[start assembleUnitsForGroup] --> A1[init empty units list]
  subgraph "Iterate names"
    direction TB
    A1 --> A2[iterate UnitNames]
    A2 --> A3[lookup in DATA.generatedUnits by unit name]
    A3 --> C0{found}
    C0 -- yes --> A4[append prototype to units list]
    C0 -- no --> A5[skip unknown name]
    A4 --> NXT[next name]
    A5 --> NXT
  end
  NXT --> OUT[return units list]
  class A0 class_io;
  class A1,A2,A3,A4,A5,NXT class_step;
  class C0 class_decision;
  class OUT class_result;
```

References
- Entry: [AETHR.SPAWNER:assembleUnitsForGroup()](../../dev/SPAWNER.lua:358)


# 5) spawnAirbaseFill

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TB
  S0[start spawnAirbaseFill] --> S1[airbaseVec2 from longestRunway position x z]
  subgraph "Radius derivation"
    direction TB
    S1 --> S2[minRad equals runway length divided by two]
    S2 --> S3[maxRad equals runway length]
    S3 --> S4[nominalRadius equals average of minRad and maxRad]
  end
  S4 --> S5[enqueueGenerateDynamicSpawner with autoSpawn true]
  S5 --> OUT[return self]
  class S0 class_io;
  class S1,S2,S3,S4,S5 class_step;
  class OUT class_result;
```

# References
- Entry: [AETHR.SPAWNER:spawnAirbaseFill()](../../dev/SPAWNER.lua:2169)
- Enqueue: [AETHR.SPAWNER:enqueueGenerateDynamicSpawner()](../../dev/SPAWNER.lua:520)


# Notes
- Wrapper diagrams ensure high level readability across files while detailed decision logic remains in specialized documents:
  - Type and count flows: [types_and_counts.md](./types_and_counts.md)
  - Zones and divisions: [zones_and_divisions.md](./zones_and_divisions.md)
  - Placement and NOGO checks: [placement.md](./placement.md), [nogo.md](./nogo.md)
  - Build and world actions: [spawn_despawn.md](./spawn_despawn.md)
  - Async job lifecycle and yielding: [async.md](./async.md)