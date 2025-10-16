# AETHR instance creation and configuration

Primary anchors
- [AETHR:New()](../../dev/AETHR.lua:65)
- [local function shallow_copy](../../dev/AETHR.lua:73)
- [local id assignment](../../dev/AETHR.lua:80)
- [SAVEGAME_DIR resolve](../../dev/AETHR.lua:111)
- [CONFIG_FOLDER path compute](../../dev/AETHR.lua:121)
- [Theater capture](../../dev/AETHR.lua:140)
- [Build modulesList](../../dev/AETHR.lua:148)
- [Phase 1 module construction](../../dev/AETHR.lua:155)
- [Phase 2 backrefs and siblings](../../dev/AETHR.lua:172)

Overview
The constructor [AETHR:New()](../../dev/AETHR.lua:65) creates an instance table with metatable inheritance, clones mutable config subtables, applies mission id, resolves a writable directory, computes config paths, optionally captures current theater, and wires modules for the instance.

Instance creation flow

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart LR
  subgraph SETUP [Instance setup]
    N[New called]
    I[Create instance table]
  end

  subgraph CONFIG_PATHS [Config and paths]
    SC[Clone config subtables]
    ID[Select mission id]
    WD[Resolve savegame dir]
    JP[Compute config folder path]
    TH[Capture theater if available]
  end

  subgraph MODULES [Modules]
    ML[Build modules list]

    subgraph P1GRP [Phase 1 (construct)]
      P1[Phase 1 construct submodules]
    end

    subgraph P2GRP [Phase 2 (wire)]
      P2[Phase 2 wire backrefs and siblings]
    end

    RT[Return instance]
  end

  %% Flow (linear for readability)
  N --> I --> SC --> ID --> WD --> JP --> TH --> ML --> P1 --> P2 --> RT

  %% House class buckets
  class N,RT class-result;
  class I,SC,ID,WD,JP,TH,ML,P1,P2 class-step;
```

Sequence details

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
sequenceDiagram
  participant A as AETHR
  participant C as CONFIG
  participant F as FILEOPS

  A->>A: shallow copy of CONFIG tables
  A->>A: set mission id

  alt lfs writedir available
    A->>A: set SAVEGAME_DIR from lfs
  else fallback
    A->>A: keep existing SAVEGAME_DIR or empty
  end

  alt FILEOPS joinPaths present
    A->>F: joinPaths to compute CONFIG folder
  else fallback
    A->>A: concat path segments using separator
  end

  A->>A: capture theater if env present

  loop modules list
    A->>A: Phase 1 construct or reuse module
  end

  loop modules list
    A->>A: Phase 2 wire backrefs and siblings
  end

  A-->>A: return instance
```

Notes and edge cases
- If [self.CONFIG](../../dev/AETHR.lua:86) is not a table, a minimal structure is created to avoid nil indexing.
- When [FILEOPS joinPaths](../../dev/AETHR.lua:121) is not available, a separator from [package.config](../../dev/AETHR.lua:132) is used for a safe fallback.
- Module wiring is two-pass to allow submodules to reference siblings without order constraints; see [Phase 1](../../dev/AETHR.lua:155) and [Phase 2](../../dev/AETHR.lua:172).

Source anchors
- [AETHR:New()](../../dev/AETHR.lua:65)
- [shallow_copy](../../dev/AETHR.lua:73)
- [mission id select](../../dev/AETHR.lua:80)
- [SAVEGAME_DIR resolve](../../dev/AETHR.lua:111)
- [CONFIG folder path compute](../../dev/AETHR.lua:121)
- [theater capture](../../dev/AETHR.lua:140)
- [modules list build](../../dev/AETHR.lua:148)
- [Phase 1 loop](../../dev/AETHR.lua:155)
- [Phase 2 loop](../../dev/AETHR.lua:172)