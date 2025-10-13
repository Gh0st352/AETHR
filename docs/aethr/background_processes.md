# AETHR background processes loop

Primary anchors
- [AETHR:BackgroundProcesses()](../../dev/AETHR.lua:267)
- [now capture](../../dev/AETHR.lua:269)
- [updateAirbaseOwnership routine](../../dev/AETHR.lua:275)
- [updateZoneOwnership routine](../../dev/AETHR.lua:281)
- [updateZoneColors routine](../../dev/AETHR.lua:287)
- [updateZoneArrows routine](../../dev/AETHR.lua:293)
- [updateGroundUnitsDB routine](../../dev/AETHR.lua:299)
- [spawnGroundGroups routine](../../dev/AETHR.lua:305)
- [despawnGroundGroups routine](../../dev/AETHR.lua:311)
- [spawnerGenerationQueue routine](../../dev/AETHR.lua:317)
- [FSM processQueue routine](../../dev/AETHR.lua:323)
- [runScheduledTasks tick](../../dev/AETHR.lua:327)
- [next invocation return](../../dev/AETHR.lua:328)

Overview
[AETHR:BackgroundProcesses()](../../dev/AETHR.lua:267) is the timer scheduled loop that advances world state, spawner pipelines, and FSM transitions on a steady cadence. It uses BRAIN.doRoutine to rate limit individual jobs and returns the absolute mission time for the next invocation.

Loop flow

```mermaid
%%{init: {"theme": "base", "themeVariables": {"primaryColor":"#e6f3ff","primaryBorderColor":"#0066cc","primaryTextColor":"#000","lineColor":"#495057","textColor":"#000","fontSize":"14px"}}}%%
flowchart LR
  %% Logical groupings
  subgraph WORLD [WORLD]
    R1[Airbase ownership]
    R2[Zone ownership]
    R3[Zone colors]
    R4[Zone arrows]
    R5[Ground units DB]
  end
  subgraph SPAWNER [SPAWNER]
    R6[Spawn groups]
    R7[Despawn groups]
    R8[Spawner generation queue]
  end
  subgraph FSM [FSM]
    R9[FSM queue process]
  end
  subgraph BRAIN [BRAIN]
    RS[Run scheduled tasks]
  end

  BP[BackgroundProcesses] --> N[now timestamp]
  N --> R1
  R1 --> R2
  R2 --> R3
  R3 --> R4
  R4 --> R5
  R5 --> R6
  R6 --> R7
  R7 --> R8
  R8 --> R9
  R9 --> RS
  RS --> NX[Return next time]



  %% Styles
  classDef core fill:#e6f3ff,stroke:#0066cc,stroke-width:2px,color:#000
  classDef process fill:#cce5ff,stroke:#0066cc,color:#000

  %% Apply classes
  class BP,NX core
  class N,R1,R2,R3,R4,R5,R6,R7,R8,R9,RS process

  %% Subgraph styles
  style WORLD fill:#e6ffe6,stroke:#009900,stroke-width:2px
  style SPAWNER fill:#fff0e6,stroke:#ff9900,stroke-width:2px
  style FSM fill:#f8f9fa,stroke:#495057,stroke-width:2px
  style BRAIN fill:#fff3cd,stroke:#ffc107,stroke-width:2px
```

Coroutine scheduling timeline

```mermaid
%%{init: {"theme":"base","themeVariables":{"actorBkg":"#e6f3ff","actorTextColor":"#000","lineColor":"#495057","signalColor":"#0066cc","signalTextColor":"#000","fontSize":"14px"}}}%%
sequenceDiagram
  participant A as AETHR
  participant B as BRAIN
  participant W as WORLD
  participant F as FSM


  A->>A: now = timer.getTime

  rect rgb(230,243,255)
    A->>B: doRoutine updateAirfieldOwnership with W.updateAirbaseOwnership
    A->>B: doRoutine updateZoneOwnership with W.updateZoneOwnership
    A->>B: doRoutine updateZoneColors with W.updateZoneColors
    A->>B: doRoutine updateZoneArrows with W.updateZoneArrows
    A->>B: doRoutine updateGroundUnitsDB with W.updateGroundUnitsDB
  end

  rect rgb(255,240,230)
    A->>B: doRoutine spawnGroundGroups with W.spawnGroundGroups
    A->>B: doRoutine despawnGroundGroups with W.despawnGroundGroups
    A->>B: doRoutine spawnerGenerationQueue with W.spawnerGenerationQueue
  end

  rect rgb(249,249,249)
    A->>B: doRoutine processFSMQueue with F.processQueue
  end

  rect rgb(255,243,205)
    A->>B: runScheduledTasks tick 2
  end

  A-->>A: return now plus interval
```

Cadence and re-scheduling
- The function must return the next absolute time, calculated as [now plus interval](../../dev/AETHR.lua:328)
- The interval is read from [self.BRAIN.DATA.BackgroundLoopInterval](../../dev/AETHR.lua:328) with a fallback to 0.5 when missing

Notes
- Each doRoutine call wraps a unit of work with BRAIN controls for pacing and error isolation
- FSM processing is invoked after world and spawner jobs to progress pending transitions
- The tick parameter for [runScheduledTasks](../../dev/AETHR.lua:327) is 2, establishing the per loop task budget

Source anchors
- [BackgroundProcesses entry](../../dev/AETHR.lua:267)
- [doRoutine airbase](../../dev/AETHR.lua:275)
- [doRoutine zone](../../dev/AETHR.lua:281)
- [doRoutine colors](../../dev/AETHR.lua:287)
- [doRoutine arrows](../../dev/AETHR.lua:293)
- [doRoutine ground db](../../dev/AETHR.lua:299)
- [doRoutine spawn](../../dev/AETHR.lua:305)
- [doRoutine despawn](../../dev/AETHR.lua:311)
- [doRoutine spawner gen](../../dev/AETHR.lua:317)
- [doRoutine fsm queue](../../dev/AETHR.lua:323)
- [runScheduledTasks](../../dev/AETHR.lua:327)
- [return next time](../../dev/AETHR.lua:328)

