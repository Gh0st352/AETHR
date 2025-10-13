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
%%{init: {"theme": "base", "themeVariables": {"primaryColor":"#e6f3ff","primaryBorderColor":"#0066cc","primaryTextColor":"#000","lineColor":"#495057","textColor":"#000","fontSize":"14px"}}}%%
flowchart LR
  %% Logical groupings
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
    P1[Phase 1 construct submodules]
    P2[Phase 2 wire backrefs and siblings]
  end

  N --> I
  I --> SC
  SC --> ID
  ID --> WD
  WD --> JP
  JP --> TH
  TH --> ML
  ML --> P1
  P1 --> P2
  P2 --> RT[Return instance]

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
  class I,SC,ID,WD,JP,TH,ML,P1,P2 process

  %% Subgraph styles
  style SETUP fill:#f9f9f9,stroke:#ccc,stroke-width:2px
  style CONFIG_PATHS fill:#f9f9f9,stroke:#ccc,stroke-width:2px
  style MODULES fill:#fff0e6,stroke:#ff9900,stroke-width:2px
  style Legend fill:#f9f9f9,stroke:#ccc,stroke-width:1px,stroke-dasharray: 5 5
```

Sequence details

```mermaid
%%{init: {"theme":"base","themeVariables":{"actorBkg":"#e6f3ff","actorTextColor":"#000","lineColor":"#495057","signalColor":"#0066cc","signalTextColor":"#000","fontSize":"14px"}}}%%
sequenceDiagram
  participant A as AETHR
  participant C as CONFIG
  participant F as FILEOPS

  Note over A,C,F: Legend: ->> call; -->> return; alt/else branch; loop iteration

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