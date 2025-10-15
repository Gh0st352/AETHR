# AETHR BRAIN diagrams index

Primary module anchors
- [AETHR.BRAIN:New()](../../dev/BRAIN.lua:158)
- [AETHR.BRAIN:doRoutine()](../../dev/BRAIN.lua:176)
- [AETHR.BRAIN:buildWatcher()](../../dev/BRAIN.lua:242)
- [AETHR.BRAIN:scheduleTask()](../../dev/BRAIN.lua:277)
- [AETHR.BRAIN:runScheduledTasks()](../../dev/BRAIN.lua:306)

Documents
- [docs/brain/scheduler.md](docs/brain/scheduler.md)
- [docs/brain/coroutines.md](docs/brain/coroutines.md)
- [docs/brain/watchers.md](docs/brain/watchers.md)
- [docs/brain/data_structures.md](docs/brain/data_structures.md)

Overview relationships

```mermaid
%%{init: {"theme":"base", "themeVariables": {"primaryColor":"#f5f5f5"}}}%%
flowchart

  %% Logical core: BRAIN and its areas
  subgraph CORE [BRAIN core areas]
    style CORE fill:#f5f5f5,stroke:#bfbfbf,stroke-width:2px
    BR[BRAIN module]
    SC[Scheduler]
    CO[Coroutines]
    WT[Watchers]
    BR --> SC
    BR --> CO
    BR --> WT
  end

  %% Effects and downstream systems
  subgraph EFFECTS [Runtime effects]
    style EFFECTS fill:#fff2cc,stroke:#d4b86f,stroke-width:2px
    SC --> ST[Scheduled tasks]
    CO --> WL[WORLD updates]
    WT -.-> WL
    WL -.-> SP[Spawner jobs]
    WL -.-> ZM[Zone manager reactions]
    ZM -.-> WT
  end

  classDef nodeStyle fill:#f5f5f5,stroke:#bfbfbf,stroke-width:1px
  class BR,SC,CO,WT,ST,WL,SP,ZM nodeStyle
```

Runtime sequence overview

```mermaid
%%{init: {"theme":"base"}}%%
sequenceDiagram
  %% background rect improves contrast on dark docs
  rect rgba(255,255,255,0.75)
    participant A as AETHR
    participant BR as BRAIN
    participant WL as WORLD
    participant ZM as ZONE_MANAGER
    participant SP as SPAWNER
    A->>BR: New
    BR-->>BR: init DATA and descriptors
    ZM->>BR: buildWatcher for coalition and ownedBy
    BR-->>WL: on change call ownership handlers
    loop background loop
      BR->>BR: doRoutine per descriptor
      BR-->>WL: call update ownership colors arrows when due
    end
    WL->>BR: scheduleTask for spawner queues
    BR->>BR: runScheduledTasks
    BR-->>SP: dispatch spawn and despawn
  end
```

Cross-module indexes
- SPAWNER: [docs/spawner/README.md](docs/spawner/README.md)
- WORLD: [docs/world/README.md](docs/world/README.md)
- ZONE_MANAGER: [docs/zone_manager/README.md](docs/zone_manager/README.md)

Key anchors
- Scheduler core: [AETHR.BRAIN:scheduleTask()](../../dev/BRAIN.lua:277), [AETHR.BRAIN:runScheduledTasks()](../../dev/BRAIN.lua:306)
- Coroutine runner: [AETHR.BRAIN:doRoutine()](../../dev/BRAIN.lua:176)
- Watcher utility: [AETHR.BRAIN:buildWatcher()](../../dev/BRAIN.lua:242)
- Constructor: [AETHR.BRAIN:New()](../../dev/BRAIN.lua:158)