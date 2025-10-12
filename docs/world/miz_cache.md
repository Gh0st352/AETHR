# WORLD MIZ cache pipeline

Primary anchors
- Init and storage orchestration:
  - [AETHR.WORLD:initMizFileCache()](../../dev/WORLD.lua:90)
  - [AETHR.WORLD:getStoredMizFileCache()](../../dev/WORLD.lua:109)
  - [AETHR.WORLD:saveMizFileCache()](../../dev/WORLD.lua:145)
- Generation logic:
  - [AETHR.WORLD:generateMizFileCache()](../../dev/WORLD.lua:187)

## Overview

initMizFileCache attempts to load previously persisted caches. If any required piece is missing, it generates fresh data from env.mission and saves.

```mermaid
flowchart TD
  I0[[initMizFileCache]] --> L0[getStoredMizFileCache]
  L0 --> C{all parts present?}
  C -- yes --> A0[assign DATA.mizCacheDB, spawnerTemplateDB, spawnerAttributesDB, _spawnerAttributesDB, spawnerUnitInfoCache] --> RET([return self])
  C -- no --> G0[generateMizFileCache] --> S0[saveMizFileCache] --> RET
```

Expected persisted keys (disk):
- MIZ_CACHE_DB
- SPAWNER_TEMPLATE_DB
- SPAWNER_ATTRIBUTE_DB
- _SPAWNER_ATTRIBUTE_DB
- SPAWNER_UNIT_CACHE_DB

Assignments (in-memory DATA):
- `mizCacheDB`, `spawnerTemplateDB`, `spawnerAttributesDB`, `_spawnerAttributesDB`, `spawnerUnitInfoCache`

## Generation details

generateMizFileCache scans env.mission grouped by coalition and country to build a normalized cache of groups and unit descriptors suitable for spawning logic.

```mermaid
flowchart TD
  G0[[generateMizFileCache]] --> SCAN[scan env mission coalition and country groups]
  SCAN --> META[attach AETHR metadata coalition countryID countryName typeKey]
  META --> MC[cache group in mizCacheDB by groupName]
  MC --> F0{spawnTemplateSearchString matches groupName}
  F0 -- yes --> T0[add to spawnerTemplateDB]
  F0 -- no --> NEXT0[next group]
  T0 --> U0[resolve live group via Group getByName if units available]
  U0 --> L0[loop units]
  L0 --> D0[get unit desc into descUnit]
  D0 --> U1[add spawnerUnitInfoCache for typeName if first time]
  D0 --> A0[for each attribute in descUnit attributes]
  A0 --> A1[write spawnerAttributesDB for attrib and typeName]
  A1 --> P0[track highest attribute priority using ENUMS spawnTypes and spawnTypesPrio]
  P0 --> W0[write to _spawnerAttributesDB at maxAttrib and typeName]
  W0 --> END([return self])
```

Key behaviors
- Group metadata attached (per group):
  - `AETHR.coalition, AETHR.countryID, AETHR.countryName, AETHR.typeKey`
- Template selection:
  - Uses [AETHR.CONFIG.MAIN.spawnTemplateSearchString](../../dev/WORLD.lua:217) to filter group names into `spawnerTemplateDB`.
- Unit descriptor caching:
  - `spawnerUnitInfoCache[typeName] = descUnit` once per typeName.
- Attribute maps:
  - `spawnerAttributesDB[attrib][typeName] = descUnit` for all declared attributes.
  - `_spawnerAttributesDB[maxAttrib][typeName] = descUnit` using priority from `ENUMS.spawnTypes` and `ENUMS.spawnTypesPrio`.

## Persistence

saveMizFileCache writes each cache table to configured filenames under `CONFIG.MAIN.STORAGE.PATHS.LEARNING_FOLDER`. It logs failures via UTILS when DEBUG is enabled.

```mermaid
flowchart LR
  W0[[saveMizFileCache]] --> MCD[MIZ_CACHE_DB <- DATA.mizCacheDB]
  W0 --> STD[SPAWNER_TEMPLATE_DB <- DATA.spawnerTemplateDB]
  W0 --> SAD[SPAWNER_ATTRIBUTE_DB <- DATA.spawnerAttributesDB]
  W0 --> SUD[SPAWNER_UNIT_CACHE_DB <- DATA.spawnerUnitInfoCache]
  W0 --> ISAD[_SPAWNER_ATTRIBUTE_DB <- DATA._spawnerAttributesDB]
```

Storage anchors
- Path root: `CONFIG.MAIN.STORAGE.PATHS.LEARNING_FOLDER`
- Filenames:
  - `CONFIG.MAIN.STORAGE.FILENAMES.MIZ_CACHE_DB`
  - `CONFIG.MAIN.STORAGE.FILENAMES.SPAWNER_TEMPLATE_DB`
  - `CONFIG.MAIN.STORAGE.FILENAMES.SPAWNER_ATTRIBUTE_DB`
  - `CONFIG.MAIN.STORAGE.FILENAMES._SPAWNER_ATTRIBUTE_DB`
  - `CONFIG.MAIN.STORAGE.FILENAMES.SPAWNER_UNIT_CACHE_DB`

## Sequence (engine interactions during generation)

```mermaid
sequenceDiagram
  participant W as WORLD
  participant E as Engine
  participant C as CONFIG
  W->>C: read spawnTemplateSearchString
  W->>E: iterate env.mission.coalition / country / group
  W-->>W: mizCacheDB[groupName] = groupObj (with AETHR metadata)
  W->>E: Group.getByName(groupName)
  alt units available
    W->>E: unit:getDesc()
    W-->>W: spawnerUnitInfoCache[typeName] = desc
    W-->>W: spawnerAttributesDB[attrib][typeName] = desc
    W-->>W: _spawnerAttributesDB[maxAttrib][typeName] = desc
  end
```

## Error handling

- getStoredMizFileCache returns nil unless all parts are present, enforcing atomic load.
- saveMizFileCache uses `UTILS:debugInfo` on per-file failure when DEBUG is enabled.
- generateMizFileCache uses safe pcall wrappers for engine calls (Group.getByName().getUnits()).

## Anchor index

- Orchestration
  - [AETHR.WORLD:initMizFileCache()](../../dev/WORLD.lua:90)
  - [AETHR.WORLD:getStoredMizFileCache()](../../dev/WORLD.lua:109)
  - [AETHR.WORLD:saveMizFileCache()](../../dev/WORLD.lua:145)
- Generation
  - [AETHR.WORLD:generateMizFileCache()](../../dev/WORLD.lua:187)
  - Search string usage: [AETHR.WORLD:generateMizFileCache()](../../dev/WORLD.lua:217)
- Related enums and text
  - Spawn attribute priorities: [AETHR.WORLD:generateMizFileCache()](../../dev/WORLD.lua:255)