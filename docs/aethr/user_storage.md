# AETHR user storage lifecycle

Primary anchors
- [AETHR:loadUSERSTORAGE()](../../dev/AETHR.lua:344)
- [AETHR:saveUSERSTORAGE()](../../dev/AETHR.lua:361)
- [FILEOPS loadData call site](../../dev/AETHR.lua:347)
- [FILEOPS saveData call site](../../dev/AETHR.lua:362)
- [USER_FOLDER path reference](../../dev/AETHR.lua:348)
- [USER_STORAGE_FILE name reference](../../dev/AETHR.lua:349)
- [USERSTORAGE assignment](../../dev/AETHR.lua:352)

Overview
User specific data is persisted to and loaded from a configured folder and filename using FILEOPS helpers. On init the framework loads data into memory and immediately saves back to ensure structures exist and paths are created.

Flowchart

```mermaid
%%{init: {"theme":"base","themeVariables":{"primaryColor":"#e6f3ff","primaryBorderColor":"#0066cc","lineColor":"#495057","textColor":"#e9ecef","fontSize":"14px"}}}%%
flowchart
  %% Group: Load path (main flow -> IO -> decision)
  subgraph LOAD ["User storage load"]
    direction
    L_load["loadUSERSTORAGE"] --> IO_CALL["FILEOPS loadData"]

    %% IO area
    subgraph FILEOPS ["FILEOPS (IO)"]
      IO_CALL --> CK_data{"Data present?"}
    end

    %% Results area
    subgraph RESULTS ["Results"]
      CK_data -- "yes" --> AS_assign["Assign to USERSTORAGE"]
      CK_data -- "no" --> SK_skip["Skip assign - keep defaults"]
      AS_assign --> RT_return["Return self"]
      SK_skip --> RT_return
    end
  end

  %% Styles (house color system)
  classDef core fill:#e6f3ff,stroke:#0066cc,stroke-width:2px,color:#000
  classDef process fill:#cce5ff,stroke:#0066cc,color:#000
  classDef decision fill:#fff0e6,stroke:#ff9900,color:#000

  %% Apply classes
  class L_load,RT_return core
  class IO_CALL,AS_assign,SK_skip process
  class CK_data decision

  %% Subgraph styles
  style LOAD fill:#f8f9fa,stroke:#495057,stroke-width:2px
  style FILEOPS fill:#e9ecef,stroke:#6c757d,stroke-width:2px
  style RESULTS fill:#f0f0f0,stroke:#6c757d,stroke-width:2px
```

Sequence timeline

```mermaid
%%{init: {"theme":"base","themeVariables":{"actorBkg":"#e6f3ff","actorTextColor":"#0a0a0aff","lineColor":"#495057","signalColor":"#0066cc","signalTextColor":"#070707ff","textColor":"#222222ff","fontSize":"14px"}}}%%
sequenceDiagram
  participant A as "AETHR"
  participant F as "FILEOPS"

  %% Background for readability on dark docs theme
  rect rgba(255,255,255,0.75)
    rect rgb(230,243,255)
      A->>F: loadData USER_FOLDER USER_STORAGE_FILE
      alt file exists
        rect rgb(235,245,235)
          F-->>A: table userData
          A->>A: USERSTORAGE = userData
        end
      else no data
        rect rgb(255,250,240)
          F-->>A: nil
        end
      end
    end
    A-->>A: return self
  end
```

Save flow

```mermaid
%%{init: {"theme":"base","themeVariables":{"primaryColor":"#ffffffff","primaryBorderColor":"#0066cc","lineColor":"#495057","textColor":"#1a1a1aff","fontSize":"14px"}}}%%
flowchart TB
  %% Group: Save path
  subgraph SAVE ["User storage save"]
    direction TB
    S_save["saveUSERSTORAGE"] --> IO_SAVE["FILEOPS saveData"]
    subgraph FILEOPS_SAVE ["FILEOPS (IO)"]
      IO_SAVE --> RT_save["Return self"]
    end
  end

  %% Styles
  classDef core fill:#e6f3ff,stroke:#0066cc,stroke-width:2px,color:#000
  classDef process fill:#cce5ff,stroke:#0066cc,color:#000

  %% Apply classes
  class S_save,RT_save core
  class IO_SAVE process

  %% Subgraph styles
  style SAVE fill:#f8f9fa,stroke:#495057,stroke-width:2px
  style FILEOPS_SAVE fill:#e9ecef,stroke:#6c757d,stroke-width:2px
```

Sequence timeline for save

```mermaid
%%{init: {"theme":"base","themeVariables":{"actorBkg":"#e6f3ff","actorTextColor":"#030303ff","lineColor":"#495057","signalColor":"#0066cc","signalTextColor":"#242424ff","textColor":"#000000ff","fontSize":"14px"}}}%%
sequenceDiagram
  participant A as "AETHR"
  participant F as "FILEOPS"

  rect rgba(255,255,255,0.75)
    rect rgb(255,243,205)
      A->>F: saveData USER_FOLDER USER_STORAGE_FILE USERSTORAGE
    end
    A-->>A: return self
  end
```

Paths and filenames
- Folder path from [self.CONFIG.MAIN.STORAGE.PATHS.USER_FOLDER](../../dev/AETHR.lua:348)
- Filename from [self.CONFIG.MAIN.STORAGE.FILENAMES.USER_STORAGE_FILE](../../dev/AETHR.lua:349)
- Data table is [self.USERSTORAGE](../../dev/AETHR.lua:56) assigned on load at [assignment site](../../dev/AETHR.lua:352)

Notes
- Calls are safe to invoke even when files do not exist; load will return nil and save will create files as needed
- Ensure upstream init created user folder PATHS entry during [AETHR:Init() paths caching](./init.md)
- FILEOPS implementation details and error handling are documented in [docs/fileops/README.md](../fileops/README.md)

Source anchors
- [loadUSERSTORAGE entry](../../dev/AETHR.lua:344)
- [FILEOPS loadData](../../dev/AETHR.lua:347)
- [USER_FOLDER path read](../../dev/AETHR.lua:348)
- [USER_STORAGE_FILE name read](../../dev/AETHR.lua:349)
- [assign USERSTORAGE](../../dev/AETHR.lua:352)
- [saveUSERSTORAGE entry](../../dev/AETHR.lua:361)
- [FILEOPS saveData](../../dev/AETHR.lua:362)