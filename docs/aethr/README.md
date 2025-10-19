# AETHR overview and diagrams

## Primary entry points
- [AETHR:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L65)
- [AETHR:Init()](https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L199)
- [AETHR:Start()](https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L252)
- [AETHR:BackgroundProcesses()](https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L267)
- [AETHR:setupWatchers()](https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L334)
- [AETHR:loadUSERSTORAGE()](https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L344)
- [AETHR:saveUSERSTORAGE()](https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L361)
- [AETHR.MODULES](https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L40)

## Documents
- Module indices: [docs/README.md](../README.md)
- WORLD module: [docs/world/README.md](../world/README.md)
- ZONE_MANAGER module: [docs/zone_manager/README.md](../zone_manager/README.md)
- SPAWNER module: [docs/spawner/README.md](../spawner/README.md)
- BRAIN module: [docs/brain/README.md](../brain/README.md)
- AI module: [docs/ai/README.md](../ai/README.md)

## Breakout pages
- Instance creation: [instance_creation.md](./instance_creation.md)
- Modules wiring: [modules_wiring.md](./modules_wiring.md)
- Init orchestration: [init.md](./init.md)
- Startup and watchers: [startup_and_watchers.md](./startup_and_watchers.md)
- Background processes: [background_processes.md](./background_processes.md)
- User storage: [user_storage.md](./user_storage.md)


# Instance creation and wiring


```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart
  %% Groupings
  subgraph INSTANCE [Instance creation]
    N[<a href='https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L65'>New instance</a>]
    C[Clone <a href='https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L73'>CONFIG defaults</a>]
    ID[Apply <a href='https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L80'>mission id</a>]
    SD[Resolve <a href='https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L111'>savegame dir</a>]
    PC[Compute <a href='https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L121'>CONFIG paths</a>]
  end

  subgraph MODULES [Modules wiring]
    AM[Attach modules from <a href='https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L40'>AETHR.MODULES</a>]
    BR[Wire backrefs and siblings]
    RT[<a href='https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L65'>Return instance</a>]
  end

  %% Flow
  N --> C --> ID --> SD --> PC --> AM --> BR --> RT

  %% Class assignments (house buckets)
  class N,RT class_result;
  class C,ID,SD,PC,AM,BR class_step;

  click N "https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L65" "AETHR:New"
  click C "https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L73" "shallow_copy / CONFIG defaults"
  click ID "https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L80" "mission id select"
  click SD "https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L111" "SAVEGAME_DIR resolve"
  click PC "https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L121" "CONFIG folder path compute"
  click AM "https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L40" "AETHR.MODULES"
  click BR "https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L172" "Phase 2 wire backrefs and siblings"
  click RT "https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L65" "return instance"
```

# Init orchestration

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart
  %% Main container
  subgraph INIT [Initialization]
    I[<a href='https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L199'>Init</a>]
    subgraph STORAGE [Storage prep]
      P1[<a href='https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L208'>Ensure storage folders</a>]
    end
    subgraph MODS [Modules]
      L1[CONFIG <a href='https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L219'>initConfig</a>]
      Z1[ZONE_MANAGER <a href='https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L220'>initMizZoneData</a>]
      W1[WORLD <a href='https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L221'>initWorldDivisions</a>]
      W2[WORLD <a href='https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L222'>initActiveDivisions</a>]
      W3[WORLD <a href='https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L223'>initMizFileCache</a>]
    end
    subgraph ZONES [Zone drawing and pairing]
      ZB[ZONE_MANAGER <a href='https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L230'>game bounds and arrows</a>]
      T1[WORLD <a href='https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L230'>initTowns</a> and ZONE_MANAGER <a href='https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L230'>pairTowns</a>]
    end
    subgraph PERSIST [Persistence]
      US[<a href='https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L241'>Load and save USERSTORAGE</a>]
      CS[<a href='https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L243'>saveConfig</a>]
    end

    %% Flow
    I --> P1
    P1 --> L1
    L1 --> Z1
    Z1 --> W1
    W1 --> W2
    W2 --> W3
    W3 --> ZB
    ZB --> T1
    T1 --> US
    US --> CS
  end

  %% Class assignments (house buckets)
  class I,CS class_result;
  class P1,L1,Z1,W1,W2,W3,ZB,T1,US class_step;

  click I "https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L199" "AETHR:Init"
  click P1 "https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L208" "Ensure storage folders"
  click L1 "https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L219" "CONFIG:initConfig (call site)"
  click Z1 "https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L220" "ZONE_MANAGER:initMizZoneData"
  click W1 "https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L221" "WORLD:initWorldDivisions"
  click W2 "https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L222" "WORLD:initActiveDivisions"
  click W3 "https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L223" "WORLD:initMizFileCache"
  click ZB "https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L230" "Zone drawing and pairing"
  click T1 "https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L230" "initTowns / pairTowns"
  click US "https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L241" "load/save USERSTORAGE"
  click CS "https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L243" "saveConfig"
```

# Runtime sequence during Init

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
sequenceDiagram
  participant A as AETHR
  participant C as CONFIG
  participant Z as ZONE_MANAGER
  participant W as WORLD

  A->>C: [Test URL](https://www.google.com)
  %% initConfig
  A->>Z: initMizZoneData
  A->>W: initWorldDivisions
  A->>W: initActiveDivisions
  A->>W: initMizFileCache

  alt zones present
    A->>Z: initZoneArrows
    A->>Z: initGameZoneBoundaries
    A->>Z: drawMissionZones
    A->>Z: drawGameBounds
    A->>Z: drawZoneArrows
    A->>Z: pairActiveDivisions
    A->>W: initTowns
    A->>Z: pairTowns
  end

  A->>A: loadUSERSTORAGE
  A->>A: saveUSERSTORAGE
  A->>C: saveConfig

 %% click A "https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L199" "AETHR:Init (call site)"
 %% click C "https://github.com/Gh0st352/AETHR/blob/main/dev/CONFIG_.lua#L364" "CONFIG:initConfig"
 %% click Z "https://github.com/Gh0st352/AETHR/blob/main/dev/ZONE_MANAGER.lua#L931" "ZONE_MANAGER"
 %% click W "https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L1156" "WORLD"
```

# Background processes loop

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
sequenceDiagram
  participant A as AETHR
  participant B as BRAIN
  participant W as WORLD
  participant Z as ZONE_MANAGER

  A->>B: schedule BackgroundProcesses
  loop background loop
    opt World updates
      B->>W: updateAirbaseOwnership
      B->>W: updateZoneOwnership
      B->>W: updateZoneColors
      B->>W: updateZoneArrows
      B->>W: updateGroundUnitsDB
    end
    opt Spawner jobs
      B->>W: spawnGroundGroups
      B->>W: despawnGroundGroups
      B->>W: spawnerGenerationQueue
    end
    opt FSM processing
      B->>A: FSM queue process
    end
    B->>B: runScheduledTasks
  end

  %% click A "https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L252" "AETHR:Start"
  %% click B "https://github.com/Gh0st352/AETHR/blob/main/dev/BRAIN.lua" "BRAIN module"
  %% click W "https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua" "WORLD module"
  %% click Z "https://github.com/Gh0st352/AETHR/blob/main/dev/ZONE_MANAGER.lua" "ZONE_MANAGER module"
```

# Key anchors
- Construction and wiring
  - [AETHR:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L65), [AETHR.MODULES](https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L40)
- Initialization flow
  - [AETHR:Init()](https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L199)
- Startup and watchers
  - [AETHR:Start()](https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L252), [AETHR:setupWatchers()](https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L334)
- Background loop
  - [AETHR:BackgroundProcesses()](https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L267)
- User storage
  - [AETHR:loadUSERSTORAGE()](https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L344), [AETHR:saveUSERSTORAGE()](https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L361)

# Source references
- CONFIG interactions: [AETHR.CONFIG:initConfig()](https://github.com/Gh0st352/AETHR/blob/main/dev/CONFIG_.lua#L364), [AETHR.CONFIG:saveConfig()](https://github.com/Gh0st352/AETHR/blob/main/dev/CONFIG_.lua#L404)
- WORLD ownership updates: [AETHR.WORLD:updateAirbaseOwnership()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L501), [AETHR.WORLD:updateZoneOwnership()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L633), [AETHR.WORLD:updateZoneColors()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L683), [AETHR.WORLD:updateZoneArrows()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L730)
- WORLD divisions: [AETHR.WORLD:generateWorldDivisions()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L1156)
- ZONE manager arrows and bounds: [AETHR.ZONE_MANAGER:drawZoneArrows()](https://github.com/Gh0st352/AETHR/blob/main/dev/ZONE_MANAGER.lua#L1025), [AETHR.ZONE_MANAGER:drawGameBounds()](https://github.com/Gh0st352/AETHR/blob/main/dev/ZONE_MANAGER.lua#L931)

# Notes
- Mermaid labels avoid double quotes and parentheses to satisfy renderer constraints.
- All diagrams use GitHub Mermaid fenced blocks.