# AETHR AUTOSAVE diagrams and flows

Primary anchors
- [AETHR.AUTOSAVE:New()](dev/autosave.lua:19)

Related anchors
- Module injection during instance creation: [AETHR:New() Phase 1 construct submodules](dev/AETHR.lua:155)
- Module backrefs wiring: [AETHR:New() Phase 2 wire back references](dev/AETHR.lua:172)
- File persistence helpers used across modules: [AETHR.FILEOPS:saveData()](dev/FILEOPS_.lua:155), [AETHR.FILEOPS:loadData()](dev/FILEOPS_.lua:173)

Documents and indices
- Master diagrams index: [docs/README.md](../README.md)
- AETHR overview: [docs/aethr/README.md](../aethr/README.md)
- FILEOPS: [docs/fileops/README.md](../fileops/README.md)
- WORLD: [docs/world/README.md](../world/README.md)

Purpose
- AUTOSAVE is a dedicated submodule entry point for persistence oriented tasks. It is injected into the AETHR instance and can orchestrate save and restore operations leveraging FILEOPS and IO routines.
- Current code exposes the constructor. Scheduling and hooks can be added through BRAIN or WORLD watchers in future iterations.

Injection lifecycle

```mermaid
flowchart LR
  M[AETHR.MODULES] --> N[New instance]
  N --> P1[Construct submodules]
  P1 --> AU[AUTOSAVE:New bound to AETHR]
  AU --> P2[Wire backrefs and siblings]
  P2 --> RT[Ready for use]
```

Where in code
- [AETHR:New() construct loop](dev/AETHR.lua:155)
- [AETHR:New() wire loop](dev/AETHR.lua:172)
- [AETHR.AUTOSAVE:New()](dev/autosave.lua:19)

Runtime interactions (planned)

```mermaid
sequenceDiagram
  participant A as AETHR
  participant AU as AUTOSAVE
  participant F as FILEOPS
  participant IO as IO
  participant BR as BRAIN
  A->>AU: New with parent
  note over AU: Future scheduled tasks can be registered via BRAIN
  BR-->>AU: invoke periodic autosave
  AU->>F: saveData target folder and file
  F->>IO: store dataset
  AU-->>A: report success or error
```

High level autosave concept flow

```mermaid
flowchart TD
  TICK[background tick] --> CHECK[should autosave now?]
  CHECK -->|no| WAIT[wait]
  CHECK -->|yes| SNAP[prepare snapshot tables]
  SNAP --> PERSIST[FILEOPS saveData via IO store]
  PERSIST --> LOG[debug info when enabled]
  LOG --> DONE[done]
```

Notes
- Mermaid labels avoid double quotes and parentheses.
- All diagrams use GitHub Mermaid fenced blocks.
- This page documents the current constructor entry point and the intended orchestration patterns to keep parity with other module docs. When implementation expands, update anchors and add specific flows for each autosave operation.