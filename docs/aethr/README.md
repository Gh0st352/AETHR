# AETHR overview and diagrams

Primary entry points
- [AETHR:New()](../../dev/AETHR.lua:65)
- [AETHR:Init()](../../dev/AETHR.lua:199)
- [AETHR:Start()](../../dev/AETHR.lua:252)
- [AETHR:BackgroundProcesses()](../../dev/AETHR.lua:267)
- [AETHR:setupWatchers()](../../dev/AETHR.lua:334)
- [AETHR:loadUSERSTORAGE()](../../dev/AETHR.lua:344)
- [AETHR:saveUSERSTORAGE()](../../dev/AETHR.lua:361)
- [AETHR.MODULES](../../dev/AETHR.lua:40)

Documents
- Module indices: [docs/README.md](../README.md)
- WORLD module: [docs/world/README.md](../world/README.md)
- ZONE_MANAGER module: [docs/zone_manager/README.md](../zone_manager/README.md)
- SPAWNER module: [docs/spawner/README.md](../spawner/README.md)
- BRAIN module: [docs/brain/README.md](../brain/README.md)
- AI module: [docs/ai/README.md](../ai/README.md)

Breakout pages
- Instance creation: [instance_creation.md](./instance_creation.md)
- Modules wiring: [modules_wiring.md](./modules_wiring.md)
- Init orchestration: [init.md](./init.md)
- Startup and watchers: [startup_and_watchers.md](./startup_and_watchers.md)
- Background processes: [background_processes.md](./background_processes.md)
- User storage: [user_storage.md](./user_storage.md)
Instance creation and wiring

```mermaid
%%{init: {"theme": "base", "themeVariables": {"primaryColor":"#e6f3ff","primaryBorderColor":"#0066cc","primaryTextColor":"#000","lineColor":"#495057","textColor":"#000","fontSize":"14px"}}}%%
flowchart LR
  %% Logical groupings
  subgraph CONFIG_PATHS [Config and paths]
    C[Clone CONFIG defaults]
    ID[Apply mission id]
    SD[Resolve savegame dir]
    PC[Compute CONFIG paths]
  end

  subgraph MODULES [Modules]
    AM[Attach modules from AETHR MODULES]
    BR[Wire backrefs and siblings]
  end

  N[New instance] --> C
  C --> ID
  ID --> SD
  SD --> PC
  PC --> AM
  AM --> BR
  BR --> RT[Return instance]

  %% Legend
  subgraph Legend [Legend]
    L1[Core (entry/return)]
    L2[Process step]
    L1 -- "control flow" --> L2
  end

  %% Styles
  classDef core fill:#e6f3ff,stroke:#0066cc,stroke-width:2px,color:#000
  classDef process fill:#cce5ff,stroke:#0066cc,color:#000

  %% Apply classes
  class N,RT core
  class C,ID,SD,PC,AM,BR process

  %% Subgraph styles
  style CONFIG_PATHS fill:#f9f9f9,stroke:#ccc,stroke-width:2px
  style MODULES fill:#fff0e6,stroke:#ff9900,stroke-width:2px
  style Legend fill:#f9f9f9,stroke:#ccc,stroke-width:1px,stroke-dasharray: 5 5
```

Init orchestration

```mermaid
%%{init: {"theme": "base", "themeVariables": {"primaryColor":"#e6f3ff","primaryBorderColor":"#0066cc","primaryTextColor":"#000","lineColor":"#495057","textColor":"#000","fontSize":"14px"}}}%%
flowchart LR
  %% Logical groupings
  subgraph PREP [Preparation]
    P1[Ensure storage folders]
  end

  subgraph INIT_MODS [Initialize modules]
    L1[CONFIG initConfig]
    Z1[ZONE_MANAGER initMizZoneData]
    W1[WORLD initWorldDivisions]
    W2[WORLD initActiveDivisions]
    W3[WORLD initMizFileCache]
  end

  subgraph ZONES [Zones]
    ZB[ZONE_MANAGER game bounds and arrows]
    T1[WORLD initTowns and ZONE_MANAGER pairTowns]
  end

  subgraph PERSIST [Persistence]
    US[Load and save USERSTORAGE]
    CS[saveConfig]
  end

  I[Init] --> P1
  P1 --> L1
  L1 --> Z1
  Z1 --> W1
  W1 --> W2
  W2 --> W3
  W3 --> ZB
  ZB --> T1
  T1 --> US
  US --> CS

  %% Legend
  subgraph Legend [Legend]
    Lg1[Core (entry/exit)]
    Lg2[Process step]
    Lg1 -- "control flow" --> Lg2
  end

  %% Styles
  classDef core fill:#e6f3ff,stroke:#0066cc,stroke-width:2px,color:#000
  classDef process fill:#cce5ff,stroke:#0066cc,color:#000

  %% Apply classes
  class I,CS core
  class P1,L1,Z1,W1,W2,W3,ZB,T1,US process

  %% Subgraph styles
  style PREP fill:#f9f9f9,stroke:#ccc,stroke-width:2px
  style INIT_MODS fill:#f9f9f9,stroke:#ccc,stroke-width:2px
  style ZONES fill:#fff0e6,stroke:#ff9900,stroke-width:2px
  style PERSIST fill:#f8f9fa,stroke:#495057,stroke-width:2px
  style Legend fill:#f9f9f9,stroke:#ccc,stroke-width:1px,stroke-dasharray: 5 5
```

Runtime sequence during Init

```mermaid
%%{init: {"theme":"base","themeVariables":{"actorBkg":"#e6f3ff","actorTextColor":"#000","lineColor":"#495057","signalColor":"#0066cc","signalTextColor":"#000","fontSize":"14px"}}}%%
sequenceDiagram
  participant A as AETHR
  participant C as CONFIG
  participant Z as ZONE_MANAGER
  participant W as WORLD

  Note over A,C,Z,W: Legend: ->> call; -->> return; alt/else branch; loop iteration

  A->>C: initConfig
  A->>Z: initMizZoneData
  A->>W: initWorldDivisions
  A->>W: initActiveDivisions
  A->>W: initMizFileCache
  alt zones present
    A->>Z: initZoneArrows
    A->>Z: initGameZoneBoundaries
    A->>Z: drawMissionZones and drawGameBounds and drawZoneArrows
    A->>Z: pairActiveDivisions
    A->>W: initTowns
    A->>Z: pairTowns
  end
  A->>A: loadUSERSTORAGE
  A->>A: saveUSERSTORAGE
  A->>C: saveConfig
```

Background processes loop

```mermaid
%%{init: {"theme":"base","themeVariables":{"actorBkg":"#e6f3ff","actorTextColor":"#000","lineColor":"#495057","signalColor":"#0066cc","signalTextColor":"#000","fontSize":"14px"}}}%%
sequenceDiagram
  participant A as AETHR
  participant B as BRAIN
  participant W as WORLD
  participant Z as ZONE_MANAGER

  Note over A,B,W,Z: Legend: ->> call; -->> return; loop = iteration

  A->>B: schedule BackgroundProcesses
  loop background loop
    B->>W: updateAirbaseOwnership
    B->>W: updateZoneOwnership
    B->>W: updateZoneColors
    B->>W: updateZoneArrows
    B->>W: updateGroundUnitsDB
    B->>W: spawnGroundGroups and despawnGroundGroups
    B->>A: FSM queue process
    B->>W: spawnerGenerationQueue
    B->>B: runScheduledTasks
  end
```

Key anchors
- Construction and wiring
  - [AETHR:New()](../../dev/AETHR.lua:65), [AETHR.MODULES](../../dev/AETHR.lua:40)
- Initialization flow
  - [AETHR:Init()](../../dev/AETHR.lua:199)
- Startup and watchers
  - [AETHR:Start()](../../dev/AETHR.lua:252), [AETHR:setupWatchers()](../../dev/AETHR.lua:334)
- Background loop
  - [AETHR:BackgroundProcesses()](../../dev/AETHR.lua:267)
- User storage
  - [AETHR:loadUSERSTORAGE()](../../dev/AETHR.lua:344), [AETHR:saveUSERSTORAGE()](../../dev/AETHR.lua:361)

Source references
- CONFIG interactions: [AETHR.CONFIG:initConfig()](../../dev/CONFIG_.lua:364), [AETHR.CONFIG:saveConfig()](../../dev/CONFIG_.lua:404)
- WORLD ownership updates: [AETHR.WORLD:updateAirbaseOwnership()](../../dev/WORLD.lua:501), [AETHR.WORLD:updateZoneOwnership()](../../dev/WORLD.lua:633), [AETHR.WORLD:updateZoneColors()](../../dev/WORLD.lua:683), [AETHR.WORLD:updateZoneArrows()](../../dev/WORLD.lua:730)
- WORLD divisions: [AETHR.WORLD:generateWorldDivisions()](../../dev/WORLD.lua:1156)
- ZONE manager arrows and bounds: [AETHR.ZONE_MANAGER:drawZoneArrows()](../../dev/ZONE_MANAGER.lua:1025), [AETHR.ZONE_MANAGER:drawGameBounds()](../../dev/ZONE_MANAGER.lua:931)

Notes
- Mermaid labels avoid double quotes and parentheses to satisfy renderer constraints.
- All diagrams use GitHub Mermaid fenced blocks.