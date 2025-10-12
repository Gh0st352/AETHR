# WORLD initialization flows

Primary anchors
- [AETHR.WORLD:initWorldDivisions()](dev/WORLD.lua:1176)
- [AETHR.WORLD:initActiveDivisions()](dev/WORLD.lua:1083)
- [AETHR.WORLD:initMizFileCache()](dev/WORLD.lua:90)
- [AETHR.WORLD:getAirbases()](dev/WORLD.lua:428)

End-to-end initialization chain

```mermaid
flowchart LR
  W1[initWorldDivisions] --> W2[initActiveDivisions]
  W2 --> W3[initMizFileCache]
  W3 --> W4[getAirbases]
```

## initWorldDivisions

Initializes and persists world division definitions and their AABB cache.

```mermaid
flowchart TD
  I0[[initWorldDivisions]] --> LWD{loadWorldDivisions exists?}
  LWD -- yes --> SDivs[assign DATA.worldDivisions]
  LWD -- no --> GWD[generateWorldDivisions] --> SWD[saveWorldDivisions]
  SDivs --> LAA{loadWorldDivisionsAABB exists?}
  LAA -- yes --> SAABB[assign DATA.worldDivAABB]
  LAA -- no --> BAABB[buildWorldDivAABBCache] --> SAABBF[saveWorldDivisionsAABB]
  SAABB --> IRET([return self])
  SAABBF --> IRET
```

Anchors
- [AETHR.WORLD:generateWorldDivisions()](dev/WORLD.lua:1156)
- [AETHR.WORLD:saveWorldDivisions()](dev/WORLD.lua:1113)
- [AETHR.WORLD:loadWorldDivisionsAABB()](dev/WORLD.lua:1126)
- [AETHR.WORLD:buildWorldDivAABBCache()](dev/WORLD.lua:1206)
- [AETHR.WORLD:saveWorldDivisionsAABB()](dev/WORLD.lua:1141)

See also: [docs/world/divisions.md](docs/world/divisions.md)

## initActiveDivisions

Loads previously saved active divisions or computes by intersecting divisions with MIZ zones.

```mermaid
flowchart TD
  A0[[initActiveDivisions]] --> LAD{loadActiveDivisions exists?}
  LAD -- yes --> ASAVE[assign DATA.saveDivisions]
  LAD -- no --> GAD[generateActiveDivisions] --> SAD[saveActiveDivisions]
  ASAVE --> ARET([return self])
  SAD --> ARET
```

Anchors
- [AETHR.WORLD:loadActiveDivisions()](dev/WORLD.lua:1045)
- [AETHR.WORLD:generateActiveDivisions()](dev/WORLD.lua:1067)
- [AETHR.WORLD:saveActiveDivisions()](dev/WORLD.lua:1057)

See also: [docs/world/divisions.md](docs/world/divisions.md)

## initMizFileCache

Atomically loads all required caches or rebuilds from `env.mission` then saves.

```mermaid
flowchart TD
  I0[[initMizFileCache]] --> L0[getStoredMizFileCache]
  L0 --> C{all parts present?}
  C -- yes --> A0[assign DATA caches] --> RET([return self])
  C -- no --> G0[generateMizFileCache] --> S0[saveMizFileCache] --> RET
```

Anchors
- [AETHR.WORLD:getStoredMizFileCache()](dev/WORLD.lua:109)
- [AETHR.WORLD:generateMizFileCache()](dev/WORLD.lua:187)
- [AETHR.WORLD:saveMizFileCache()](dev/WORLD.lua:145)

See also: [docs/world/miz_cache.md](docs/world/miz_cache.md)

## getAirbases

Queries engine airbases, normalizes descriptors, computes runway stats, and associates each airbase to a MIZ zone if its position lies inside the zone polygon.

```mermaid
flowchart TD
  GA[[getAirbases]] --> Q[world getAirbases]
  Q --> L[for each airbase]
  L --> D[get desc, position p, coalition]
  D --> RT[runway stats: max length, longest runway]
  RT --> ASSIGN[build AETHR._airbase data object]
  ASSIGN --> ZCHK{any MIZ_ZONES?}
  ZCHK -- yes --> INZ[find zone where POLY PointWithinShape uses pos and zone.vertices]
  ZCHK -- no --> SKIPZ[no zone association]
  INZ --> CREATE[AETHR._airbase New]
  SKIPZ --> CREATE
  CREATE --> LINK[link _airbase to zone.Airbases and DATA.AIRBASES]
  LINK --> NEXT[loop]
  NEXT --> RET([return self])
```

Key details
- Zone inclusion test: [AETHR.POLY:PointWithinShape](dev/POLY.lua)
- Zone map: `ZONE_MANAGER.DATA.MIZ_ZONES[zoneName]`
- Airbase object stored under `DATA.AIRBASES[displayName]`

Anchor
- [AETHR.WORLD:getAirbases()](dev/WORLD.lua:428)

## Initialization sequence with modules

```mermaid
sequenceDiagram
  participant A as AETHR
  participant W as WORLD
  participant F as FILEOPS
  participant P as POLY
  participant Z as ZONE_MANAGER
  participant E as Engine

  A->>W: initWorldDivisions
  W->>F: loadWorldDivisions / saveWorldDivisions
  W->>P: convertBoundsToPolygon, dividePolygon, build AABB
  A->>W: initActiveDivisions
  W->>F: loadActiveDivisions / saveActiveDivisions
  A->>W: initMizFileCache
  W->>F: getStoredMizFileCache / saveMizFileCache
  W->>E: scan env.mission during generation
  A->>W: getAirbases
  W->>E: getAirbases
  W->>E: getDesc
  W->>E: getRunways
  W->>E: getCoalition
  W->>Z: zone lookup and assignment
```

## Anchor index

- [AETHR.WORLD:initWorldDivisions()](dev/WORLD.lua:1176)
- [AETHR.WORLD:initActiveDivisions()](dev/WORLD.lua:1083)
- [AETHR.WORLD:initMizFileCache()](dev/WORLD.lua:90)
- [AETHR.WORLD:getAirbases()](dev/WORLD.lua:428)