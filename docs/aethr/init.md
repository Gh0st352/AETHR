# AETHR initialization orchestration

Primary anchors
- [AETHR:Init()](../../dev/AETHR.lua:199)
- [Iterate SUB_FOLDERS and ensureDirectory](../../dev/AETHR.lua:208)
- [PATHS cache assignment](../../dev/AETHR.lua:214)
- [CONFIG initConfig](../../dev/AETHR.lua:219)
- [ZONE_MANAGER initMizZoneData](../../dev/AETHR.lua:220)
- [WORLD initWorldDivisions](../../dev/AETHR.lua:221)
- [WORLD initActiveDivisions](../../dev/AETHR.lua:222)
- [WORLD initMizFileCache](../../dev/AETHR.lua:223)
- [LEARN_WORLD_OBJECTS conditional](../../dev/AETHR.lua:225)
- [Zones present conditional and drawing](../../dev/AETHR.lua:230)
- [loadUSERSTORAGE](../../dev/AETHR.lua:241)
- [saveUSERSTORAGE](../../dev/AETHR.lua:242)
- [CONFIG saveConfig](../../dev/AETHR.lua:243)

Overview
The initializer [AETHR:Init()](../../dev/AETHR.lua:199) prepares storage directories, caches resolved paths, initializes configuration and world data, optionally performs world object learning, performs zone drawing and pairing when zones are present, and persists both user storage and config.

Flowchart

```mermaid
flowchart LR
  I[Init] --> S[Defensive checks]
  S --> SF[Iterate sub folders]
  SF --> ED[Ensure directories]
  ED --> PC[Cache PATHS into CONFIG]
  PC --> C[CONFIG initConfig]
  C --> Z[ZONE_MANAGER initMizZoneData]
  Z --> W1[WORLD initWorldDivisions]
  W1 --> W2[WORLD initActiveDivisions]
  W2 --> W3[WORLD initMizFileCache]
  W3 --> LWO[Optional learn world objects]
  LWO --> ZP[If zones present do zone flows]
  ZP --> US[load and save USERSTORAGE]
  US --> CS[saveConfig]
```

Sequence timeline

```mermaid
sequenceDiagram
  participant A as AETHR
  participant F as FILEOPS
  participant C as CONFIG
  participant Z as ZONE_MANAGER
  participant W as WORLD
  A->>A: read SUB_FOLDERS
  loop each folder
    A->>F: joinPaths to build full path
    A->>A: cache PATHS entry
    A->>F: ensureDirectory best effort
  end
  A->>C: initConfig
  A->>Z: initMizZoneData
  A->>W: initWorldDivisions
  A->>W: initActiveDivisions
  A->>W: initMizFileCache
  alt LEARN_WORLD_OBJECTS flag true
    A->>W: initSceneryInDivisions
    A->>W: initBaseInDivisions
    A->>W: initStaticInDivisions
  end
  alt zones present
    A->>Z: initZoneArrows
    A->>Z: initGameZoneBoundaries
    A->>Z: drawMissionZones
    A->>Z: drawGameBounds
    A->>Z: drawZoneArrows
    A->>Z: pairActiveDivisions
    A->>W: initTowns
    A->>Z: pairTowns
  end
  A->>A: loadUSERSTORAGE
  A->>A: saveUSERSTORAGE
  A->>C: saveConfig
```

Key branches
- Object learning controlled by [self.CONFIG.MAIN.FLAGS.LEARN_WORLD_OBJECTS](../../dev/AETHR.lua:225) to avoid heavy scans unless requested.
- Zone drawing and pairing guarded by [sumTable of MIZ_ZONES](../../dev/AETHR.lua:230) to skip work when no zones.

Source anchors
- [AETHR:Init()](../../dev/AETHR.lua:199)
- [subFolders iteration](../../dev/AETHR.lua:208)
- [PATHS cache write](../../dev/AETHR.lua:214)
- [initConfig](../../dev/AETHR.lua:219)
- [initMizZoneData](../../dev/AETHR.lua:220)
- [initWorldDivisions](../../dev/AETHR.lua:221)
- [initActiveDivisions](../../dev/AETHR.lua:222)
- [initMizFileCache](../../dev/AETHR.lua:223)
- [LEARN_WORLD_OBJECTS block](../../dev/AETHR.lua:225)
- [zones present block](../../dev/AETHR.lua:230)
- [loadUSERSTORAGE](../../dev/AETHR.lua:241)
- [saveUSERSTORAGE](../../dev/AETHR.lua:242)
- [saveConfig](../../dev/AETHR.lua:243)