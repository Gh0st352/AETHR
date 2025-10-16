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
%% shared theme: docs/_mermaid/theme.json %%
flowchart LR
  subgraph LOAD [User storage load]
    L_load[loadUSERSTORAGE] --> IO_CALL[FILEOPS loadData]

    subgraph FILEOPS [FILEOPS (IO)]
      IO_CALL --> CK_data{Data present?}
    end

    subgraph RESULTS [Results]
      CK_data -- "yes" --> AS_assign[Assign to USERSTORAGE]
      CK_data -- "no" --> SK_skip[Skip assign - keep defaults]
      AS_assign --> RT_return[Return self]
      SK_skip --> RT_return
    end
  end

  class L_load,RT_return class-result
  class IO_CALL,AS_assign,SK_skip class-step
  class CK_data class-decision
```

Sequence timeline

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
sequenceDiagram
  participant A as AETHR
  participant F as FILEOPS

  A->>F: loadData USER_FOLDER USER_STORAGE_FILE
  alt file exists
    F-->>A: table userData
    A->>A: USERSTORAGE = userData
  else no data
    F-->>A: nil
  end
  A-->>A: return self
```

Save flow

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TB
  subgraph SAVE [User storage save]
    S_save[saveUSERSTORAGE] --> IO_SAVE[FILEOPS saveData]
    subgraph FILEOPS_SAVE [FILEOPS (IO)]
      IO_SAVE --> RT_save[Return self]
    end
  end

  class S_save,RT_save class-result
  class IO_SAVE class-step
```

Sequence timeline for save

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
sequenceDiagram
  participant A as AETHR
  participant F as FILEOPS

  A->>F: saveData USER_FOLDER USER_STORAGE_FILE USERSTORAGE
  A-->>A: return self
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