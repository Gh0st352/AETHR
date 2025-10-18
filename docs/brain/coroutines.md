# AETHR BRAIN coroutines

## Entry anchors
- [AETHR.BRAIN:doRoutine()](https://github.com/Gh0st352/AETHR/blob/main/dev/BRAIN.lua#L176)
- [dev/BRAIN.lua](https://github.com/Gh0st352/AETHR/blob/main/dev/BRAIN.lua#L56) coroutines table
- [dev/BRAIN.lua](https://github.com/Gh0st352/AETHR/blob/main/dev/BRAIN.lua#L149) BackgroundLoopInterval

## Purpose
The coroutine runner executes periodic routines based on interval and phase with safe creation resume and cleanup. BackgroundLoopInterval controls tick cadence.

# Flow: doRoutine

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TB
  subgraph DO ["doRoutine flow"]
    DR1[increment counter] --> DR2[compute interval and phase]
    DR2 --> DR3{matches interval window}
    DR3 -- "no" --> DR0[return self]
    DR3 -- "yes" --> DR4[set counter to zero]
    DR4 --> DR5
    subgraph THREAD ["Thread lifecycle"]
      DR5{thread missing or dead}
      DR6[create coroutine from routineFn with args]
      DR7[keep existing thread]
      DR8[status suspended]
      DR9[resume thread]
      DR10{resume ok}
      DR11[log error and clear thread]
      DR12[continue]
      DR13{thread dead}
      DR14[clear thread]
      DR5 -- "yes" --> DR6
      DR5 -- "no" --> DR7
      DR6 --> DR8
      DR7 --> DR8
      DR8 --> DR9
      DR9 --> DR10
      DR10 -- "no" --> DR11
      DR10 -- "yes" --> DR12
      DR12 --> DR13
      DR13 -- "yes" --> DR14
      DR13 -- "no" --> DR0
    end
  end

  class DR1,DR2,DR3,DR0,DR4,DR5,DR6,DR7,DR8,DR9,DR10,DR11,DR12,DR13,DR14 class_step;
  class DO class_compute;
```

# Sequence: background usage

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
sequenceDiagram
  participant BR as BRAIN
  participant FN as routineFn
  loop background ticks
    BR->>BR: doRoutine per descriptor
    BR->>FN: execute step until yield or complete
  end
```

# Configured descriptors
- [dev/BRAIN.lua](https://github.com/Gh0st352/AETHR/blob/main/dev/BRAIN.lua#L58) saveGroundUnits interval 10 phase 9 yield 5
- [dev/BRAIN.lua](https://github.com/Gh0st352/AETHR/blob/main/dev/BRAIN.lua#L67) updateZoneOwnership interval 10 phase 2 yield 5
- [dev/BRAIN.lua](https://github.com/Gh0st352/AETHR/blob/main/dev/BRAIN.lua#L76) updateAirfieldOwnership interval 10 phase 0 yield 5
- [dev/BRAIN.lua](https://github.com/Gh0st352/AETHR/blob/main/dev/BRAIN.lua#L85) updateZoneColors interval 10 phase 4 yield 5
- [dev/BRAIN.lua](https://github.com/Gh0st352/AETHR/blob/main/dev/BRAIN.lua#L94) updateZoneArrows interval 10 phase 6 yield 10
- [dev/BRAIN.lua](https://github.com/Gh0st352/AETHR/blob/main/dev/BRAIN.lua#L103) updateGroundUnitsDB interval 30 phase 8 yield 10
- [dev/BRAIN.lua](https://github.com/Gh0st352/AETHR/blob/main/dev/BRAIN.lua#L112) spawnGroundGroups interval 10 phase 3 yield 3
- [dev/BRAIN.lua](https://github.com/Gh0st352/AETHR/blob/main/dev/BRAIN.lua#L121) despawnGroundGroups interval 10 phase 1 yield 3
- [dev/BRAIN.lua](https://github.com/Gh0st352/AETHR/blob/main/dev/BRAIN.lua#L130) spawnerGenerationQueue interval 10 phase 12 yield 10
- [dev/BRAIN.lua](https://github.com/Gh0st352/AETHR/blob/main/dev/BRAIN.lua#L139) processFSMQueue interval 10 phase 5 yield 10

# Descriptors subgraph

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart LR
  subgraph Descriptors ["Configured coroutine descriptors"]
    D1[saveGroundUnits int 10 phase 9 yield 5]
    D2[updateZoneOwnership int 10 phase 2 yield 5]
    D3[updateAirfieldOwnership int 10 phase 0 yield 5]
    D4[updateZoneColors int 10 phase 4 yield 5]
    D5[updateZoneArrows int 10 phase 6 yield 10]
    D6[updateGroundUnitsDB int 30 phase 8 yield 10]
    D7[spawnGroundGroups int 10 phase 3 yield 3]
    D8[despawnGroundGroups int 10 phase 1 yield 3]
    D9[spawnerGenerationQueue int 10 phase 12 yield 10]
    D10[processFSMQueue int 10 phase 5 yield 10]
  end
  class D1,D2,D3,D4,D5,D6,D7,D8,D9,D10 class_step;
```

# Cross links
- Module index: [docs/brain/README.md](docs/brain/README.md)
- Scheduler: [docs/brain/scheduler.md](docs/brain/scheduler.md)
- Data structures: [docs/brain/data_structures.md](docs/brain/data_structures.md)