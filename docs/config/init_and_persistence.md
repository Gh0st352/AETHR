# AETHR CONFIG init and persistence

Deep-dive breakout for initialization, load and save logic in CONFIG. Targets stability, guards, and interactions with FILEOPS and UTILS.

Source anchors

- [AETHR.CONFIG:initConfig()](../../dev/CONFIG_.lua:364)
- [AETHR.CONFIG:loadConfig()](../../dev/CONFIG_.lua:380)
- [AETHR.CONFIG:saveConfig()](../../dev/CONFIG_.lua:404)
- [AETHR:Init()](../../dev/AETHR.lua:199)
- [AETHR.FILEOPS:loadData()](../../dev/FILEOPS_.lua:173), [AETHR.FILEOPS:saveData()](../../dev/FILEOPS_.lua:155)
- [AETHR.UTILS:debugInfo()](../../dev/UTILS.lua:79)

Overview

initConfig performs a best effort load of persisted MAIN configuration and falls back to persisting defaults when not present. All operations are guarded to avoid nil dereferences and sandbox issues.

Init chain context

```mermaid
flowchart LR
  AETHR_Init[AETHR Init] --> CONFIG_init[CONFIG initConfig]
  CONFIG_init --> TryLoad[Try loadConfig]
  TryLoad -->|ok and table| Replace[Replace MAIN with loaded]
  TryLoad -->|nil or error| Persist[Persist defaults via saveConfig]
  Replace --> ReturnSelf[return self]
  Persist --> ReturnSelf
```

Sequence of calls

```mermaid
sequenceDiagram
  participant A as AETHR
  participant C as CONFIG
  participant F as FILEOPS
  participant U as UTILS
  A->>C: initConfig
  C->>C: pcall loadConfig
  alt loaded table
    C-->>C: MAIN = loaded
  else not found or error
    C->>C: pcall saveConfig
    opt save failed
      C->>U: debugInfo Failed saving config
    end
  end
  A-->>A: continue Init sequence
```

Guarding and failure modes

- loadConfig returns nil when STORAGE or PATHS or filenames are missing
- saveConfig returns false on guard failure or FILEOPS save error
- Both load and save are wrapped in pcall to avoid breaking mission startup flow
- Debug logging is conditional via DEBUG_ENABLED and routed through UTILS

Data resolved at AETHR construction

- [AETHR:New()](../../dev/AETHR.lua:65) resolves SAVEGAME_DIR and computes CONFIG_FOLDER path using [AETHR.FILEOPS:joinPaths()](../../dev/FILEOPS_.lua:37)
- [AETHR:Init()](../../dev/AETHR.lua:199) ensures subfolder directories exist via [AETHR.FILEOPS:ensureDirectory()](../../dev/FILEOPS_.lua:46) and caches PATHS

Detailed logic per function

[AETHR.CONFIG:initConfig()](../../dev/CONFIG_.lua:364)
- Calls loadConfig in protected mode
- On table result, replaces self.MAIN with persisted data
- Otherwise attempts to persist current defaults
- Returns self for chaining

[AETHR.CONFIG:loadConfig()](../../dev/CONFIG_.lua:380)
- Guards against missing self.MAIN.STORAGE.PATHS
- Resolves mapPath and filename from PATHS.CONFIG_FOLDER and FILENAMES.AETHER_CONFIG_FILE
- Delegates to [AETHR.FILEOPS:loadData()](../../dev/FILEOPS_.lua:173)
- Returns table on success or nil on failure

[AETHR.CONFIG:saveConfig()](../../dev/CONFIG_.lua:404)
- Guards against missing self.MAIN.STORAGE.PATHS
- Resolves mapPath and filename as above
- Delegates to [AETHR.FILEOPS:saveData()](../../dev/FILEOPS_.lua:155) inside pcall
- On error, logs via [AETHR.UTILS:debugInfo()](../../dev/UTILS.lua:79) when available
- Returns true on success, false on error

Error handling matrix

```mermaid
flowchart TD
  G[Guards present] --> LD[loadData call]
  LD -->|returns table| OK[Use loaded]
  LD -->|nil or error| SV[save defaults]
  SV -->|save ok| RET[return self]
  SV -->|save error| LOG[emit debugInfo]
  LOG --> RET
```

Persistence file and directory

- Directory resolution: PATHS.CONFIG_FOLDER built from SAVEGAME_DIR ROOT_FOLDER CONFIG_FOLDER
- Filename: FILENAMES.AETHER_CONFIG_FILE set to AETHR_Config.lua
- Files are Lua-serialized via IO helpers behind FILEOPS

Notes on design decisions

- Treat missing config as first run and seed disk with stable defaults
- Prefer minimal deps inside CONFIG; all file logic is in FILEOPS
- Use shallow instance copies to avoid prototype mutation during [AETHR:New()](../../dev/AETHR.lua:65)

Related breakouts

- Paths and filenames: [paths_and_filenames.md](./paths_and_filenames.md)
- Main schema: [main_schema.md](./main_schema.md)
- Save chunks strategy: [save_chunks.md](./save_chunks.md)

Validation checklist

- Code anchors verified against current HEAD
  - [AETHR.CONFIG:initConfig()](../../dev/CONFIG_.lua:364)
  - [AETHR.CONFIG:loadConfig()](../../dev/CONFIG_.lua:380)
  - [AETHR.CONFIG:saveConfig()](../../dev/CONFIG_.lua:404)
  - [AETHR:Init()](../../dev/AETHR.lua:199)

Conventions

- Mermaid fenced blocks with GitHub parser
- Labels avoid double quotes and parentheses inside brackets
- All links use relative paths for portability