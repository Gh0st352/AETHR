# AETHR SPAWNER diagrams index

Primary module entry: [AETHR.SPAWNER:generateDynamicSpawner()](https://github.com/Gh0st352/AETHR/blob/main/dev/SPAWNER.lua#L563)

Documents
- Pipeline overview: [pipeline.md](./pipeline.md)
- Zones and divisions: [zones_and_divisions.md](./zones_and_divisions.md)
- Placement logic: [placement.md](./placement.md)
- Types and counts: [types_and_counts.md](./types_and_counts.md)
- Build, spawn, despawn: [spawn_despawn.md](./spawn_despawn.md)
- NOGO checks: [nogo.md](./nogo.md)
- Async jobs: [async.md](./async.md)

# End to end relationship

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart LR
  subgraph "Generation flow"
    direction LR
    P[Pipeline] --> Z[Zones and divisions]
    P --> T[Types and counts]
    Z --> L[Placement]
    T --> L
    L --> S[Spawn and despawn]
  end

  subgraph "Support & controls"
    direction TB
    N[NOGO checks] -.-> L
    A[Async jobs] -.-> P
  end

  class P,Z,L,T,S,A,N class_step;
```

# Sequence overview

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
sequenceDiagram
  participant Caller
  participant SP as SPAWNER
  participant W as WORLD
  participant ZM as ZONE_MANAGER
  participant U as UTILS

  Caller->>SP: generateDynamicSpawner
  alt deterministic enabled with seed
    SP->>U: withSeed(seed)
  else nondeterministic
    Note over SP: run without seeded RNG
  end

  SP->>SP: generateSpawnerZones
  alt MIZ zones exist
    SP->>ZM: pairSpawnerActiveZones
  else no MIZ zones
    SP->>W: pairSpawnerWorldDivisions
  end
  SP->>SP: pairSpawnerZoneDivisions
  SP->>SP: determineZoneDivObjects
  SP->>SP: generateSpawnAmounts and _Jiggle
  SP->>SP: rollSpawnGroups and rollGroupPlacement
  SP->>SP: buildSpawnGroups
  SP->>W: spawnDynamicSpawner
  W-->>SP: queue for activation
```

# Key anchors
- Deterministic scope: [AETHR.UTILS:withSeed()](https://github.com/Gh0st352/AETHR/blob/main/dev/UTILS.lua#L242)
- Zone generation: [AETHR.SPAWNER:generateSpawnerZones()](https://github.com/Gh0st352/AETHR/blob/main/dev/SPAWNER.lua#L2012)
- Pair to divisions: [AETHR.SPAWNER:pairSpawnerWorldDivisions()](https://github.com/Gh0st352/AETHR/blob/main/dev/SPAWNER.lua#L723), [AETHR.SPAWNER:pairSpawnerActiveZones()](https://github.com/Gh0st352/AETHR/blob/main/dev/SPAWNER.lua#L760)
- Group type pools: [AETHR.SPAWNER:seedTypes()](https://github.com/Gh0st352/AETHR/blob/main/dev/SPAWNER.lua#L1804), [AETHR.SPAWNER:generateGroupTypes()](https://github.com/Gh0st352/AETHR/blob/main/dev/SPAWNER.lua#L1600)
- Counts and balancing: [AETHR.SPAWNER:generateSpawnAmounts()](https://github.com/Gh0st352/AETHR/blob/main/dev/SPAWNER.lua#L1918), [AETHR.SPAWNER:_Jiggle()](https://github.com/Gh0st352/AETHR/blob/main/dev/SPAWNER.lua#L1978)
- Placement loops: [AETHR.SPAWNER:generateVec2GroupCenters()](https://github.com/Gh0st352/AETHR/blob/main/dev/SPAWNER.lua#L1067), [AETHR.SPAWNER:generateVec2UnitPos()](https://github.com/Gh0st352/AETHR/blob/main/dev/SPAWNER.lua#L1301)
- NOGO checks: [AETHR.SPAWNER:checkIsInNOGO()](https://github.com/Gh0st352/AETHR/blob/main/dev/SPAWNER.lua#L2085), [AETHR.POLY:pointInPolygon()](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L66)
- Async enqueue: [AETHR.SPAWNER:enqueueGenerateDynamicSpawner()](https://github.com/Gh0st352/AETHR/blob/main/dev/SPAWNER.lua#L520)
- Auxiliary logic wrappers and utilities: [auxiliary.md](./auxiliary.md)