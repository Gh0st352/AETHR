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
flowchart LR
  %% Groupings
  subgraph INSTANCE [Instance creation]
    N[New instance]
    C[Clone CONFIG defaults]
    ID[Apply mission id]
    SD[Resolve savegame dir]
    PC[Compute CONFIG paths]
  end

  subgraph MODULES [Modules wiring]
    AM[Attach modules from AETHR MODULES]
    BR[Wire backrefs and siblings]
    RT[Return instance]
  end

  %% Flow
  N --> C --> ID --> SD --> PC --> AM --> BR --> RT

  %% Class assignments (house buckets)
  class N,RT class_result;
  class C,ID,SD,PC,AM,BR class_step;
```

# Init orchestration

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart
  %% Main container
  subgraph INIT [Initialization]
    I[Init]
    subgraph STORAGE [Storage prep]
      P1[Ensure storage folders]
    end
    subgraph MODS [Modules]
      L1[CONFIG initConfig]
      Z1[ZONE_MANAGER initMizZoneData]
      W1[WORLD initWorldDivisions]
      W2[WORLD initActiveDivisions]
      W3[WORLD initMizFileCache]
    end
    subgraph ZONES [Zone drawing and pairing]
      ZB[ZONE_MANAGER game bounds and arrows]
      T1[WORLD initTowns and ZONE_MANAGER pairTowns]
    end
    subgraph PERSIST [Persistence]
      US[Load and save USERSTORAGE]
      CS[saveConfig]
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
```

# Runtime sequence during Init

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
sequenceDiagram
  participant A as AETHR
  participant C as CONFIG
  participant Z as ZONE_MANAGER
  participant W as WORLD

  A->>C: initConfig
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