# WORLD divisions and activation

This document covers generation of world divisions, AABB caching, active division determination by zone overlap, and optional map marking.

Primary anchors
- Init orchestration: [AETHR.WORLD:initWorldDivisions()](dev/WORLD.lua:1176), [AETHR.WORLD:initActiveDivisions()](dev/WORLD.lua:1083)
- IO helpers: [AETHR.WORLD:loadWorldDivisions()](dev/WORLD.lua:1098), [AETHR.WORLD:saveWorldDivisions()](dev/WORLD.lua:1113), [AETHR.WORLD:loadWorldDivisionsAABB()](dev/WORLD.lua:1126), [AETHR.WORLD:saveWorldDivisionsAABB()](dev/WORLD.lua:1141), [AETHR.WORLD:loadActiveDivisions()](dev/WORLD.lua:1045), [AETHR.WORLD:saveActiveDivisions()](dev/WORLD.lua:1057)
- Generation and caches: [AETHR.WORLD:generateWorldDivisions()](dev/WORLD.lua:1156), [AETHR.WORLD:buildWorldDivAABBCache()](dev/WORLD.lua:1206)
- Active selection: [AETHR.WORLD:checkDivisionsInZones()](dev/WORLD.lua:1328), [AETHR.WORLD:generateActiveDivisions()](dev/WORLD.lua:1067)
- Grid helpers: [AETHR.WORLD:initGrid()](dev/WORLD.lua:1236), [AETHR.WORLD:buildZoneCellIndex()](dev/WORLD.lua:1268)
- Debug map paint: [AETHR.WORLD:markWorldDivisions()](dev/WORLD.lua:284)

## Initialization flows

initWorldDivisions

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

initActiveDivisions

```mermaid
flowchart TD
  A0[[initActiveDivisions]] --> LAD{loadActiveDivisions exists?}
  LAD -- yes --> ASAVE[assign DATA.saveDivisions]
  LAD -- no --> GAD[generateActiveDivisions] --> SAD[saveActiveDivisions]
  ASAVE --> ARET([return self])
  SAD --> ARET
```

## Active division determination

checkDivisionsInZones performs a cell-accelerated overlap test between each division and nearby zones. It builds a grid from the first division’s corners and indexes zones into grid cell buckets to limit polygon tests to local candidates.

```mermaid
flowchart TD
  C0[[checkDivisionsInZones]] --> G0[initGrid from Divisions]
  G0 --> ZI[buildZoneCellIndex from Zones using grid]
  ZI --> L1[for each division]
  L1 --> CEN[centroid cx,cz]
  CEN --> IDX[col,row from grid]
  IDX --> BBOX[build division bbox and div polygon]
  BBOX --> CANDS[get candidate zone entries at col,row]
  CANDS --> OVL{any bbox overlap?}
  OVL -- no --> NEXT[div.active=false; next div]
  OVL -- yes --> POLY[polygon overlap test]
  POLY -- true --> ACT[div.active=true]
  POLY -- false --> NEXT
  ACT --> NEXT
  NEXT --> DONE([return Divisions])
```

Grid helpers

```mermaid
flowchart LR
  IG[[initGrid]] --> M[minX and minZ from corner 1]
  M --> DX[dx from corner 2 minus corner 1]
  M --> DZ[dz from corner 4 minus corner 1]
  DX --> GRT[_Grid New with inverses]
  DZ --> GRT
```

```mermaid
flowchart LR
  BZ[[buildZoneCellIndex]] --> B0[for each zone compute bbox]
  B0 --> P0[collect polygon x and y from vertices]
  P0 --> C0[map bbox min and max to grid column and row bounds]
  C0 --> A0[assign entry into each covered cell list]
```

## Activation pipeline and optional markup

generateActiveDivisions computes active flags via intersection and fills `DATA.saveDivisions`. markWorldDivisions can be used to visualize active divisions.

```mermaid
flowchart TD
  GAD[[generateActiveDivisions]] --> CDZ[checkDivisionsInZones for Divisions and Zones]
  CDZ --> LOOP[for each division if active then set saveDivisions ID to div]
  LOOP --> GADRET([return self])
```

```mermaid
flowchart TD
  MWD[[markWorldDivisions]] --> LUP[loop saveDivisions]
  LUP --> VEC[build Vec3 from div corners]
  VEC --> MC[compute colors, border, alpha]
  MC --> TA[trigger markupToAll polygon]
  TA --> INC[shapeID++ and counters++]
  INC --> MWDRET([return self])
```

## Anchor index

- Orchestration
  - [AETHR.WORLD:initWorldDivisions()](dev/WORLD.lua:1176), [AETHR.WORLD:initActiveDivisions()](dev/WORLD.lua:1083)
- IO
  - [AETHR.WORLD:loadWorldDivisions()](dev/WORLD.lua:1098), [AETHR.WORLD:saveWorldDivisions()](dev/WORLD.lua:1113)
  - [AETHR.WORLD:loadWorldDivisionsAABB()](dev/WORLD.lua:1126), [AETHR.WORLD:saveWorldDivisionsAABB()](dev/WORLD.lua:1141)
  - [AETHR.WORLD:loadActiveDivisions()](dev/WORLD.lua:1045), [AETHR.WORLD:saveActiveDivisions()](dev/WORLD.lua:1057)
- Logic
  - [AETHR.WORLD:generateWorldDivisions()](dev/WORLD.lua:1156), [AETHR.WORLD:buildWorldDivAABBCache()](dev/WORLD.lua:1206)
  - [AETHR.WORLD:checkDivisionsInZones()](dev/WORLD.lua:1328), [AETHR.WORLD:generateActiveDivisions()](dev/WORLD.lua:1067)
  - [AETHR.WORLD:initGrid()](dev/WORLD.lua:1236), [AETHR.WORLD:buildZoneCellIndex()](dev/WORLD.lua:1268)
- Markup
  - [AETHR.WORLD:markWorldDivisions()](dev/WORLD.lua:284)