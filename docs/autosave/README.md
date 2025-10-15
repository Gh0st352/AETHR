# AETHR AUTOSAVE diagrams and flows

Primary anchors
- [AETHR.AUTOSAVE:New()](../../dev/autosave.lua:19)

Related anchors
- Module injection during instance creation: [AETHR:New() Phase 1 construct submodules](../../dev/AETHR.lua:155)
- Module backrefs wiring: [AETHR:New() Phase 2 wire back references](../../dev/AETHR.lua:172)
- File persistence helpers used across modules: [AETHR.FILEOPS:saveData()](../../dev/FILEOPS_.lua:155), [AETHR.FILEOPS:loadData()](../../dev/FILEOPS_.lua:173)

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
%%{init: {"theme":"base", "themeVariables": {"primaryColor":"#f5f5f5"}}}%%
flowchart LR
  subgraph INJ [Injection lifecycle]
    style INJ fill:#ffe6cc,stroke:#d99a5a,stroke-width:2px
    M[AETHR.MODULES]
    N[New instance]
    P1[Construct submodules]
    AU[AUTOSAVE New bound to AETHR]
    P2[Wire backrefs and siblings]
    RT[Ready for use]
    M --> N
    N --> P1
    P1 --> AU
    AU --> P2
    P2 --> RT
  end
  classDef injNode fill:#f5f5f5,stroke:#bfbfbf,stroke-width:1px
  class M,N,P1,AU,P2,RT injNode
```

Where in code
- [AETHR:New() construct loop](../../dev/AETHR.lua:155)
- [AETHR:New() wire loop](../../dev/AETHR.lua:172)
- [AETHR.AUTOSAVE:New()](../../dev/autosave.lua:19)

Runtime interactions (planned)

```mermaid
%%{init: {"theme":"base"}}%%
sequenceDiagram
  rect rgba(255,255,255,0.75)
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
  end
```

High level autosave concept flow

```mermaid
%%{init: {"theme":"base"}}%%
flowchart TB
  subgraph LOOP [Autosave loop]
    style LOOP fill:#e1f5e7,stroke:#8fbf9a,stroke-width:2px
    TICK[background tick]
    CHECK[should autosave now?]
    WAIT[wait]
    SNAP[prepare snapshot tables]
    PERSIST[FILEOPS saveData via IO store]
    LOG[debug info when enabled]
    DONE[done]
    TICK --> CHECK
    CHECK -->|no| WAIT
    CHECK -->|yes| SNAP
    SNAP --> PERSIST
    PERSIST --> LOG
    LOG --> DONE
  end
  classDef loopNode fill:#f5f5f5,stroke:#bfbfbf
  class TICK,CHECK,WAIT,SNAP,PERSIST,LOG,DONE loopNode
```

Notes
- Mermaid labels avoid double quotes and parentheses.
- Diagrams follow the project Mermaid Rules: subgraphs for logical areas, style declarations per subgraph, classDef usage for node palettes, and a contrast-friendly background rect for sequence diagrams.
- This page documents the current constructor entry point and the intended orchestration patterns to keep parity with other module docs. When implementation expands, update anchors and add specific flows for each autosave operation.