# AETHR CONFIG diagrams and flows

Primary anchors
- [AETHR.CONFIG:initConfig()](dev/CONFIG_.lua:364)
- [AETHR.CONFIG:loadConfig()](dev/CONFIG_.lua:380)
- [AETHR.CONFIG:saveConfig()](dev/CONFIG_.lua:404)

Related code anchors
- AETHR paths at creation: [AETHR:New()](dev/AETHR.lua:65), [dev/AETHR.lua](dev/AETHR.lua:125)
- FILE I/O: [AETHR.FILEOPS:loadData()](dev/FILEOPS_.lua:173), [AETHR.FILEOPS:saveData()](dev/FILEOPS_.lua:155)
- Debug logging: [AETHR.UTILS:debugInfo()](dev/UTILS.lua:79)

Documents and indices
- Master diagrams index: [docs/README.md](docs/README.md)
- AETHR overview: [docs/aethr/README.md](docs/aethr/README.md)

Init and persistence flow

```mermaid
flowchart LR
  I[initConfig] --> T[Try loadConfig]
  T -->|ok and table| R[Replace MAIN with loaded]
  T -->|nil or error| P[Persist defaults via saveConfig]
  R --> RET[return self]
  P --> RET
```

Storage guards and calls

```mermaid
sequenceDiagram
  participant C as CONFIG
  participant F as FILEOPS
  participant U as UTILS
  C->>C: loadConfig
  alt guards pass
    C->>F: loadData CONFIG_FOLDER AETHR_Config.lua
    F-->>C: table or nil
    opt success path
      C-->>C: MAIN = loaded
    end
    opt failure path
      C->>F: saveData CONFIG_FOLDER AETHR_Config.lua MAIN
      F-->>C: ok or error
      opt error
        C->>U: debugInfo Failed saving config
      end
  else guards fail
    C-->>C: return nil or false
  end
```

Paths and filenames resolution

```mermaid
flowchart LR
  N[New instance] --> JP[joinPaths SAVEGAME_DIR ROOT_FOLDER CONFIG_FOLDER]
  JP --> CF[CONFIG.PATHS.CONFIG_FOLDER]
  CF --> L1[loadConfig uses path and AETHER_CONFIG_FILE]
  CF --> S1[saveConfig uses path and AETHER_CONFIG_FILE]
```

Source anchors
- [AETHR.CONFIG:initConfig()](dev/CONFIG_.lua:364)
- [AETHR.CONFIG:loadConfig()](dev/CONFIG_.lua:380)
- [AETHR.CONFIG:saveConfig()](dev/CONFIG_.lua:404)
- [AETHR:New()](dev/AETHR.lua:65)
- [AETHR.FILEOPS:joinPaths()](dev/FILEOPS_.lua:37)
- [AETHR.FILEOPS:loadData()](dev/FILEOPS_.lua:173)
- [AETHR.FILEOPS:saveData()](dev/FILEOPS_.lua:155)
- [AETHR.UTILS:debugInfo()](dev/UTILS.lua:79)

Notes
- Mermaid labels avoid double quotes and parentheses.
- All diagrams use GitHub Mermaid fenced blocks.