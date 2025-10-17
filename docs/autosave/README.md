# AETHR AUTOSAVE diagrams and flows

### Primary anchors
- [AETHR.AUTOSAVE:New()](../../dev/autosave.lua:19)

### Related anchors
- Module injection during instance creation: [AETHR:New() Phase 1 construct submodules](../../dev/AETHR.lua:155)
- Module backrefs wiring: [AETHR:New() Phase 2 wire back references](../../dev/AETHR.lua:172)
- File persistence helpers used across modules: [AETHR.FILEOPS:saveData()](../../dev/FILEOPS_.lua:155), [AETHR.FILEOPS:loadData()](../../dev/FILEOPS_.lua:173)

### Documents and indices
- Master diagrams index: [docs/README.md](../README.md)
- AETHR overview: [docs/aethr/README.md](../aethr/README.md)
- FILEOPS: [docs/fileops/README.md](../fileops/README.md)
- WORLD: [docs/world/README.md](../world/README.md)

### Purpose
- AUTOSAVE is a dedicated submodule entry point for persistence oriented tasks. It is injected into the AETHR instance and can orchestrate save and restore operations leveraging FILEOPS and IO routines.
- Current code exposes the constructor. Scheduling and hooks can be added through BRAIN or WORLD watchers in future iterations.

# Injection lifecycle

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart LR
  subgraph INJ ["Injection lifecycle"]
    M[AETHR.MODULES]
    N[New instance]
    subgraph CONSTRUCT ["Construction"]
      P1[Construct submodules]
      AU[AUTOSAVE bound to AETHR]
    end
    P2[Wire backrefs and siblings]
    RT[Ready for use]
    M --> N
    N --> P1
    P1 --> AU
    AU --> P2
    P2 --> RT
  end
  class M class_data;
  class N,P1,P2 class_step;
  class AU,RT class_result;
```

### Where in code
- [AETHR:New() construct loop](../../dev/AETHR.lua:155)
- [AETHR:New() wire loop](../../dev/AETHR.lua:172)
- [AETHR.AUTOSAVE:New()](../../dev/autosave.lua:19)

# Runtime interactions (planned)

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
sequenceDiagram
  participant A as AETHR
  participant AU as AUTOSAVE
  participant F as FILEOPS
  participant IO as IO
  participant BR as BRAIN
  A->>AU: New with parent
  note over AU: Future scheduled tasks can be registered via BRAIN
  alt periodic autosave triggered
    BR-->>AU: invoke periodic autosave
    AU->>F: saveData(target, file)
    F->>IO: store dataset
    AU-->>A: report success or error
  else idle
    AU-->>A: no-op
  end
```

# High level autosave concept flow

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TB
  subgraph LOOP ["Autosave loop"]
    subgraph GATE ["Gate"]
      TICK[background tick]
      CHECK{should autosave now?}
      TICK --> CHECK
      CHECK -- "no" --> WAIT[wait]
    end
    subgraph PERSIST_FLOW ["Persist snapshot"]
      SNAP[prepare snapshot tables]
      PERSIST[FILEOPS saveData via IO store]
      LOG[debug info when enabled]
      DONE[done]
      CHECK -- "yes" --> SNAP
      SNAP --> PERSIST
      PERSIST --> LOG
      LOG --> DONE
    end
  end
  class TICK,LOG class_tracker;
  class CHECK class_decision;
  class WAIT,SNAP class_step;
  class PERSIST class_io;
  class DONE class_result;
```

### Notes
- Diagrams begin with the shared theme marker and contain no inline colors or style directives.
- Subgraphs use quoted labels; nodes use class buckets only: class_io, class_compute, class_data, class_tracker, class_decision, class_result, class_step.
- Sequence diagrams use structural blocks (alt/else/loop) and no rect color backdrops; background and styling come from the shared theme.
- This page documents the current constructor entry point and the intended orchestration patterns. Update anchors and add flows as AUTOSAVE gains runtime orchestration.