# AETHR CONFIG diagrams and flows

# Primary anchors
- [AETHR.CONFIG:initConfig()](https://github.com/Gh0st352/AETHR/blob/main/dev/CONFIG_.lua#L364)
- [AETHR.CONFIG:loadConfig()](https://github.com/Gh0st352/AETHR/blob/main/dev/CONFIG_.lua#L380)
- [AETHR.CONFIG:saveConfig()](https://github.com/Gh0st352/AETHR/blob/main/dev/CONFIG_.lua#L404)

# Related code anchors
- AETHR paths at creation: [AETHR:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L65), [dev/AETHR.lua](https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L125)
- FILE I/O: [AETHR.FILEOPS:loadData()](https://github.com/Gh0st352/AETHR/blob/main/dev/FILEOPS_.lua#L173), [AETHR.FILEOPS:saveData()](https://github.com/Gh0st352/AETHR/blob/main/dev/FILEOPS_.lua#L155)
- Debug logging: [AETHR.UTILS:debugInfo()](https://github.com/Gh0st352/AETHR/blob/main/dev/UTILS.lua#L79)

# Documents and indices
- Master diagrams index: [docs/README.md](../README.md)
- AETHR overview: [docs/aethr/README.md](../aethr/README.md)

# Init and persistence flow

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TB
  subgraph INIT_FLOW [Init and persistence flow]
    I[initConfig] --> T[Try loadConfig]
    T -- "ok and table" --> R[Replace MAIN with loaded]
    T -- "nil or error" --> P[Persist defaults via saveConfig]
    R --> RET[return self]
    P --> RET
  end

  class I,T,R,P class_step;
  class RET class_result;
```

# Storage guards and calls

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
sequenceDiagram
  participant C as CONFIG
  participant F as FILEOPS
  participant U as UTILS
  C->>C: loadConfig
  alt guards pass
    C->>F: loadData CONFIG_FOLDER AETHR_Config.lua
    F-->>C: table or nil
    alt loaded table
      C-->>C: MAIN = loaded
    else not found or error
      C->>F: saveData CONFIG_FOLDER AETHR_Config.lua MAIN
      F-->>C: ok or error
      alt save error
        C->>U: debugInfo Failed saving config
      end
    end
  else guards fail
    C-->>C: return nil or false
  end
```

# Paths and filenames resolution

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TB
  subgraph PATHS_FLOW["Paths and filenames resolution"]
    N[New instance] --> JP[joinPaths SAVEGAME_DIR ROOT_FOLDER CONFIG_FOLDER]
    JP --> CF[CONFIG.PATHS.CONFIG_FOLDER]
    CF --> L1[loadConfig uses path and AETHER_CONFIG_FILE]
    CF --> S1[saveConfig uses path and AETHER_CONFIG_FILE]
  end

  class N,JP,CF,L1,S1 class_step;
```

# Source anchors
- [AETHR.CONFIG:initConfig()](https://github.com/Gh0st352/AETHR/blob/main/dev/CONFIG_.lua#L364)
- [AETHR.CONFIG:loadConfig()](https://github.com/Gh0st352/AETHR/blob/main/dev/CONFIG_.lua#L380)
- [AETHR.CONFIG:saveConfig()](https://github.com/Gh0st352/AETHR/blob/main/dev/CONFIG_.lua#L404)
- [AETHR:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L65)
- [AETHR.FILEOPS:joinPaths()](https://github.com/Gh0st352/AETHR/blob/main/dev/FILEOPS_.lua#L37)
- [AETHR.FILEOPS:loadData()](https://github.com/Gh0st352/AETHR/blob/main/dev/FILEOPS_.lua#L173)
- [AETHR.FILEOPS:saveData()](https://github.com/Gh0st352/AETHR/blob/main/dev/FILEOPS_.lua#L155)
- [AETHR.UTILS:debugInfo()](https://github.com/Gh0st352/AETHR/blob/main/dev/UTILS.lua#L79)

# Notes
- Mermaid labels avoid double quotes and parentheses.
- All diagrams use GitHub Mermaid fenced blocks.
## Breakout documents

Detailed CONFIG analysis pages with Mermaid diagrams and sequence charts.

- Init and persistence: [init_and_persistence.md](./init_and_persistence.md)
- Paths and filenames: [paths_and_filenames.md](./paths_and_filenames.md)
- Main schema: [main_schema.md](./main_schema.md)
- Flags and counters: [flags_counters.md](./flags_counters.md)
- Zone paint and bounds: [zone_paint_and_bounds.md](./zone_paint_and_bounds.md)
- World bounds and divisions: [world_bounds_and_divisions.md](./world_bounds_and_divisions.md)
- OutText settings: [out_text.md](./out_text.md)
- Save chunks strategy: [save_chunks.md](./save_chunks.md)

# High-level overview

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TB
  subgraph START [Startup overview]
    New[AETHR New] --> Paths[Compute CONFIG PATHS]
    Init[AETHR Init] --> Zones[ZONE_MANAGER init]
    Init --> World[WORLD init divisions and caches]
    Init --> Config[CONFIG initConfig]
    Config --> Load[loadConfig]
    Load -- "ok table" --> Use[Use loaded MAIN]
    Load -- "nil" --> Save[saveConfig defaults]
  end

  class New,Paths,Init,Zones,World,Config,Load class_step;
  class Use,Save class_result;
```