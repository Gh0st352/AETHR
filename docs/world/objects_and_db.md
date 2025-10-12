# WORLD object search and ground databases

Primary anchors
- Search volumes:
  - [AETHR.WORLD:searchObjectsBox()](dev/WORLD.lua:334)
  - [AETHR.WORLD:searchObjectsSphere()](dev/WORLD.lua:384)
- Division retrieval and per-division caches:
  - [AETHR.WORLD:objectsInDivision()](dev/WORLD.lua:1382)
  - [AETHR.WORLD:_initObjectsInDivisions()](dev/WORLD.lua:1395)
  - [AETHR.WORLD:initSceneryInDivisions()](dev/WORLD.lua:1433)
  - [AETHR.WORLD:initBaseInDivisions()](dev/WORLD.lua:1442)
  - [AETHR.WORLD:initStaticInDivisions()](dev/WORLD.lua:1451)
- Ground DB rebuild:
  - [AETHR.WORLD:updateGroundUnitsDB()](dev/WORLD.lua:860)

Related helpers
- Geometries: [dev/POLY.lua](dev/POLY.lua)
- Enums: [dev/ENUMS.lua](dev/ENUMS.lua)
- Storage: [dev/FILEOPS_.lua](dev/FILEOPS_.lua)
- Utils: [dev/UTILS.lua](dev/UTILS.lua)

## Search volumes

searchObjectsBox computes a world volume from 2D corners and a height, then iterates engine objects via callback. Keys prefer unit name, then ID, then engine id_, else tostring fallback.

```mermaid
flowchart TD
  SOB[[searchObjectsBox]] --> BX[self POLY getBoxPoints]
  BX --> VOL[self POLY createBox]
  VOL --> FOUND[found table]
  FOUND --> CBK[ifFound derive key and wrap to _foundObject]
  CBK --> WS[pcall world searchObjects category vol ifFound]
  WS --> RET[return found]
```

searchObjectsSphere creates a spherical volume, same key semantics.

```mermaid
flowchart TD
  SOS[[searchObjectsSphere]] --> SV[self POLY createSphere with center radius y]
  SV --> FOUND[found table and ifFound callback]
  FOUND --> WS[pcall world searchObjects category vol ifFound]
  WS --> RET[return found]
```

## Division retrieval

objectsInDivision convenience: build a box from a division’s corners and search for category.

```mermaid
flowchart LR
  OID[[objectsInDivision]] --> G[lookup DATA.worldDivisions by division ID]
  G --> CHK{division exists}
  CHK -->|no| RETX[return empty]
  CHK -->|yes| SB[searchObjectsBox for category using div corners and height or 2000] --> RET[return found]
```

## Per-division cache initialization

_initObjectsInDivisions hydrates per-division object maps from storage if present; otherwise computes and persists split chunks.

```mermaid
flowchart TD
  IOI[[_initObjectsInDivisions]] --> L[for each active division id in DATA.saveDivisions]
  L --> PATH[build path root slash id and file name from category and basename]
  PATH --> TRY[self FILEOPS loadandJoinData file dir]
  TRY --> C{objs exists?}
  C -->|no| SCAN[objectsInDivision for id and category]
  SCAN --> SAVE[splitAndSaveData for objs file dir saveChunks]
  C -->|yes| USE[use loaded objs]
  SAVE --> SET[set targetField for id to objs or empty]
  USE --> SET
  SET --> NEXT[loop]
  NEXT --> RET[return self]
```

Specializations
- Scenery: [AETHR.WORLD:initSceneryInDivisions()](dev/WORLD.lua:1433)
- Base: [AETHR.WORLD:initBaseInDivisions()](dev/WORLD.lua:1442)
- Static: [AETHR.WORLD:initStaticInDivisions()](dev/WORLD.lua:1451)

## Ground DB rebuild (incremental, coroutine-friendly)

updateGroundUnitsDB walks a slice of active divisions per invocation, searching UNITs, updating `groundUnitsDB`, and rebuilding `groundGroupsDB` at the end of a full pass. Progress is tracked in a persistent state (either coroutine-owned or module cache).

```mermaid
flowchart TD
  GDB[[updateGroundUnitsDB]] --> PRE[guard no active divisions then return]
  PRE --> ST[state based on coroutine or cache]
  ST --> IDS{state.ids set?}
  IDS -->|no| BIDS[collect and sort division IDs then index to one]
  IDS -->|yes| SIDX[compute start index and end index from state and slice]
  BIDS --> SIDX
  SIDX --> LOOP[for each i from start index to end index]
  LOOP --> SCAN[searchObjectsBox for UNIT using div corners and height or 2000]
  SCAN --> INS[for each found annotate spawned and division ID then update groundDB]
  INS --> YL1[maybeYield]
  YL1 --> NEXT
  NEXT --> ADV[advance state index to end index plus one]
  ADV --> FULL{index past ids}
  FULL -->|no| RET1[return self]
  FULL -->|yes| REBLD[rebuild groundGroupsDB by group name and prune dead]
  REBLD --> RST[reset state ids and index]
  RST --> RET2[return self]
```

Sequence and yields

```mermaid
sequenceDiagram
  participant W as WORLD
  participant E as Engine
  participant U as UTILS
  W->>W: ensure/saveDivisions present
  W->>W: prepare coroutine state and division ID slice
  W->>E: world searchObjects UNIT vol ifFound per division
  W-->>W: update groundUnitsDB and annotate objects
  W->>U: debugInfoRate progress and conditional yields
  opt end of pass
    W-->>W: rebuild groundGroupsDB and prune dead
  end
```

## Anchor index

- Search
  - [AETHR.WORLD:searchObjectsBox()](dev/WORLD.lua:334)
  - [AETHR.WORLD:searchObjectsSphere()](dev/WORLD.lua:384)
- Division helpers
  - [AETHR.WORLD:objectsInDivision()](dev/WORLD.lua:1382)
  - [AETHR.WORLD:_initObjectsInDivisions()](dev/WORLD.lua:1395)
  - [AETHR.WORLD:initSceneryInDivisions()](dev/WORLD.lua:1433)
  - [AETHR.WORLD:initBaseInDivisions()](dev/WORLD.lua:1442)
  - [AETHR.WORLD:initStaticInDivisions()](dev/WORLD.lua:1451)
- Ground DB
  - [AETHR.WORLD:updateGroundUnitsDB()](dev/WORLD.lua:860)