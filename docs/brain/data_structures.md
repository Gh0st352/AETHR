# AETHR BRAIN data structures

## Entry anchors
- [AETHR.ScheduledTask](https://github.com/Gh0st352/AETHR/blob/main/dev/BRAIN.lua#L22)
- [AETHR.CoroutineDescriptor](https://github.com/Gh0st352/AETHR/blob/main/dev/BRAIN.lua#L37)
- [AETHR.BRAIN.DATA](https://github.com/Gh0st352/AETHR/blob/main/dev/BRAIN.lua#L52)
- [BackgroundLoopInterval](https://github.com/Gh0st352/AETHR/blob/main/dev/BRAIN.lua#L149)

# Class model

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
classDiagram
  %% Simplified property types to avoid parser issues with punctuation/generics
  class BRAIN_DATA {
    Schedulers: map
    SchedulerIDCounter: int
    coroutines: map
    BackgroundLoopInterval: number
  }
  class ScheduledTask {
    active: boolean
    running: boolean
    nextRun: number
    lastRun: number
    iterations: int
    taskFunction: function
    functionArgs: array
    repeatInterval: number
    delay: number
    repeating: boolean
    stopTime: number
    stopAfterIterations: int
  }
  class CoroutineDescriptor {
    interval: number
    phase: int
    counter: int
    thread: thread
    yieldThreshold: int
    yieldCounter: int
    desc: string
  }
  BRAIN_DATA o-- ScheduledTask
  BRAIN_DATA o-- CoroutineDescriptor

  %% Use shared class buckets (no inline colors)
  class BRAIN_DATA class_data
  class ScheduledTask class_data
  class CoroutineDescriptor class_data
```

# Default coroutine descriptors
- saveGroundUnits: interval 10, phase 9, yield 5 [dev/BRAIN.lua](https://github.com/Gh0st352/AETHR/blob/main/dev/BRAIN.lua#L58)
- updateZoneOwnership: interval 10, phase 2, yield 5 [dev/BRAIN.lua](https://github.com/Gh0st352/AETHR/blob/main/dev/BRAIN.lua#L67)
- updateAirfieldOwnership: interval 10, phase 0, yield 5 [dev/BRAIN.lua](https://github.com/Gh0st352/AETHR/blob/main/dev/BRAIN.lua#L76)
- updateZoneColors: interval 10, phase 4, yield 5 [dev/BRAIN.lua](https://github.com/Gh0st352/AETHR/blob/main/dev/BRAIN.lua#L85)
- updateZoneArrows: interval 10, phase 6, yield 10 [dev/BRAIN.lua](https://github.com/Gh0st352/AETHR/blob/main/dev/BRAIN.lua#L94)
- updateGroundUnitsDB: interval 30, phase 8, yield 10 [dev/BRAIN.lua](https://github.com/Gh0st352/AETHR/blob/main/dev/BRAIN.lua#L103)
- spawnGroundGroups: interval 10, phase 3, yield 3 [dev/BRAIN.lua](https://github.com/Gh0st352/AETHR/blob/main/dev/BRAIN.lua#L112)
- despawnGroundGroups: interval 10, phase 1, yield 3 [dev/BRAIN.lua](https://github.com/Gh0st352/AETHR/blob/main/dev/BRAIN.lua#L121)
- spawnerGenerationQueue: interval 10, phase 12, yield 10 [dev/BRAIN.lua](https://github.com/Gh0st352/AETHR/blob/main/dev/BRAIN.lua#L130)
- processFSMQueue: interval 10, phase 5, yield 10 [dev/BRAIN.lua](https://github.com/Gh0st352/AETHR/blob/main/dev/BRAIN.lua#L139)

# Flow: New instance

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TB
  subgraph NEW ["BRAIN New instance flow"]
    N1[call BRAIN New]
    N2[create instance with parent AETHR and _cache]
    N3[set metatable with __index self]
    N4[return instance]
    N1 --> N2 --> N3 --> N4
  end

  class N1,N2,N3,N4 class_step;
  class NEW class_compute;
```

# Cross links
- Module index: [docs/brain/README.md](docs/brain/README.md)
- Scheduler: [docs/brain/scheduler.md](docs/brain/scheduler.md)
- Coroutines: [docs/brain/coroutines.md](docs/brain/coroutines.md)
- Watchers: [docs/brain/watchers.md](docs/brain/watchers.md)