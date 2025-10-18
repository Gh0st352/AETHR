# WORLD initialization flows

Primary anchors
- [AETHR.WORLD:initWorldDivisions()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L1176)
- [AETHR.WORLD:initActiveDivisions()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L1083)
- [AETHR.WORLD:initMizFileCache()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L90)
- [AETHR.WORLD:getAirbases()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L428)

# End-to-end initialization chain

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart LR
  W1[initWorldDivisions] --> W2[initActiveDivisions]
  W2 --> W3[initMizFileCache]
  W3 --> W4[getAirbases]

  class W1,W2,W3,W4 class_step;
```

## initWorldDivisions

Initializes and persists world division definitions and their AABB cache.

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  I0[[initWorldDivisions]] --> LWD{loadWorldDivisions exists?}
  LWD -- "yes" --> SDivs[assign DATA.worldDivisions]
  LWD -- "no" --> GWD[generateWorldDivisions] --> SWD[saveWorldDivisions]
  SDivs --> LAA{loadWorldDivisionsAABB exists?}
  LAA -- "yes" --> SAABB[assign DATA.worldDivAABB]
  LAA -- "no" --> BAABB[buildWorldDivAABBCache] --> SAABBF[saveWorldDivisionsAABB]
  SAABB --> IRET([return self])
  SAABBF --> IRET

  class LWD class_decision;
  class IRET class_result;
  class I0,GWD,SWD,BAABB,SAABBF class_step;
  class SDivs,SAABB class_data;
```

### Anchors
- [AETHR.WORLD:generateWorldDivisions()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L1156)
- [AETHR.WORLD:saveWorldDivisions()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L1113)
- [AETHR.WORLD:loadWorldDivisionsAABB()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L1126)
- [AETHR.WORLD:buildWorldDivAABBCache()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L1206)
- [AETHR.WORLD:saveWorldDivisionsAABB()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L1141)

See also: [docs/world/divisions.md](docs/world/divisions.md)

## initActiveDivisions

Loads previously saved active divisions or computes by intersecting divisions with MIZ zones.

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  A0[[initActiveDivisions]] --> LAD{loadActiveDivisions exists?}
  LAD -- "yes" --> ASAVE[assign DATA.saveDivisions]
  LAD -- "no" --> GAD[generateActiveDivisions] --> SAD[saveActiveDivisions]
  ASAVE --> ARET([return self])
  SAD --> ARET

  class LAD class_decision;
  class ARET class_result;
  class A0,GAD,SAD class_step;
  class ASAVE class_data;
```

### Anchors
- [AETHR.WORLD:loadActiveDivisions()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L1045)
- [AETHR.WORLD:generateActiveDivisions()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L1067)
- [AETHR.WORLD:saveActiveDivisions()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L1057)

See also: [docs/world/divisions.md](docs/world/divisions.md)

## initMizFileCache

Atomically loads all required caches or rebuilds from `env.mission` then saves.

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  I0[[initMizFileCache]] --> L0[getStoredMizFileCache]
  L0 --> C{all parts present?}
  C -- "yes" --> A0[assign DATA caches] --> RET([return self])
  C -- "no" --> G0[generateMizFileCache] --> S0[saveMizFileCache] --> RET

  class C class_decision;
  class RET class_result;
  class I0,L0,G0,S0 class_step;
  class A0 class_data;
```

### Anchors
- [AETHR.WORLD:getStoredMizFileCache()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L109)
- [AETHR.WORLD:generateMizFileCache()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L187)
- [AETHR.WORLD:saveMizFileCache()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L145)

See also: [docs/world/miz_cache.md](docs/world/miz_cache.md)

## getAirbases

Queries engine airbases, normalizes descriptors, computes runway stats, and associates each airbase to a MIZ zone if its position lies inside the zone polygon.

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  GA[[getAirbases]] --> Q[world getAirbases]
  Q --> L[for each airbase]
  subgraph "Per-airbase processing"
    L --> D[get desc, position p, coalition]
    D --> RT[runway stats: max length, longest runway]
    RT --> ASSIGN[build AETHR._airbase data object]
    ASSIGN --> ZCHK{any MIZ_ZONES?}
    ZCHK -- "yes" --> INZ[find zone where POLY PointWithinShape uses pos and zone.vertices]
    ZCHK -- "no" --> SKIPZ[no zone association]
    INZ --> CREATE[AETHR._airbase New]
    SKIPZ --> CREATE
    CREATE --> LINK[link _airbase to zone.Airbases and DATA.AIRBASES]
    LINK --> NEXT[loop]
  end
  NEXT --> RET([return self])

  class ZCHK class_decision;
  class RET class_result;
  class GA,Q,L,D,RT,INZ,SKIPZ,LINK,NEXT class_step;
  class ASSIGN,CREATE class_data;
```

### Key details
- Zone inclusion test: [AETHR.POLY:PointWithinShape](../../dev/POLY.lua)
- Zone map: `ZONE_MANAGER.DATA.MIZ_ZONES[zoneName]`
- Airbase object stored under `DATA.AIRBASES[displayName]`

### Anchor
- [AETHR.WORLD:getAirbases()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L428)

## Initialization sequence with modules

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
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

- [AETHR.WORLD:initWorldDivisions()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L1176)
- [AETHR.WORLD:initActiveDivisions()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L1083)
- [AETHR.WORLD:initMizFileCache()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L90)
- [AETHR.WORLD:getAirbases()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L428)