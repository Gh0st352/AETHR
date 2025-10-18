# WORLD divisions and activation

This document covers generation of world divisions, AABB caching, active division determination by zone overlap, and optional map marking.

Primary anchors
- Init orchestration: [AETHR.WORLD:initWorldDivisions()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L1176), [AETHR.WORLD:initActiveDivisions()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L1083)
- IO helpers: [AETHR.WORLD:loadWorldDivisions()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L1098), [AETHR.WORLD:saveWorldDivisions()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L1113), [AETHR.WORLD:loadWorldDivisionsAABB()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L1126), [AETHR.WORLD:saveWorldDivisionsAABB()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L1141), [AETHR.WORLD:loadActiveDivisions()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L1045), [AETHR.WORLD:saveActiveDivisions()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L1057)
- Generation and caches: [AETHR.WORLD:generateWorldDivisions()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L1156), [AETHR.WORLD:buildWorldDivAABBCache()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L1206)
- Active selection: [AETHR.WORLD:checkDivisionsInZones()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L1328), [AETHR.WORLD:generateActiveDivisions()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L1067)
- Grid helpers: [AETHR.WORLD:initGrid()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L1236), [AETHR.WORLD:buildZoneCellIndex()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L1268)
- Debug map paint: [AETHR.WORLD:markWorldDivisions()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L284)

# Initialization flows

## initWorldDivisions

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

## initActiveDivisions

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

# Active division determination

## checkDivisionsInZones performs a cell-accelerated overlap test between each division and nearby zones. It builds a grid from the first division’s corners and indexes zones into grid cell buckets to limit polygon tests to local candidates.

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  C0[[checkDivisionsInZones]] --> G0[initGrid from Divisions]
  G0 --> ZI[buildZoneCellIndex from Zones using grid]
  ZI --> L1[for each division]
  subgraph "Per-division loop"
    L1 --> CEN[centroid cx,cz]
    CEN --> IDX[col,row from grid]
    IDX --> BBOX[build division bbox and div polygon]
    BBOX --> CANDS["\1"]
    CANDS --> OVL{any bbox overlap?}
    OVL -- "no" --> NEXT["\1"]
    OVL -- "yes" --> POLY[polygon overlap test]
    POLY -- "true" --> ACT["\1"]
    POLY -- "false" --> NEXT
    ACT --> NEXT
  end
  NEXT --> DONE([return Divisions])

  class OVL class_decision;
  class DONE class_result;
  class C0,G0,ZI,L1,CEN,IDX,BBOX,CANDS,POLY,ACT,NEXT class_step;
```

## Grid helpers

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart LR
  IG[[initGrid]] --> M[minX and minZ from corner 1]
  M --> DX[dx from corner 2 minus corner 1]
  M --> DZ[dz from corner 4 minus corner 1]
  DX --> GRT[_Grid New with inverses]
  DZ --> GRT

  class IG,M,DX,DZ,GRT class_step;
```

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart LR
  BZ[[buildZoneCellIndex]] --> B0[for each zone compute bbox]
  B0 --> P0[collect polygon x and y from vertices]
  P0 --> C0[map bbox min and max to grid column and row bounds]
  C0 --> A0[assign entry into each covered cell list]

  class BZ,B0,P0,C0,A0 class_step;
```

# Activation pipeline and optional markup

## generateActiveDivisions computes active flags via intersection and fills `DATA.saveDivisions`. markWorldDivisions can be used to visualize active divisions.

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  GAD[[generateActiveDivisions]] --> CDZ[checkDivisionsInZones for Divisions and Zones]
  CDZ --> LOOP["for each division: if active then set saveDivisions[id] = div"]
  LOOP --> GADRET([return self])

  class GAD,CDZ,LOOP class_step;
  class GADRET class_result;
```

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  MWD[[markWorldDivisions]] --> LUP[loop saveDivisions]
  LUP --> VEC[build Vec3 from div corners]
  VEC --> MC[compute colors, border, alpha]
  MC --> TA[trigger markupToAll polygon]
  TA --> INC["\1"]
  INC --> MWDRET([return self])

  class MWD,LUP,VEC,MC,TA,INC class_step;
  class MWDRET class_result;
```

## Anchor index

- Orchestration
  - [AETHR.WORLD:initWorldDivisions()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L1176), [AETHR.WORLD:initActiveDivisions()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L1083)
- IO
  - [AETHR.WORLD:loadWorldDivisions()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L1098), [AETHR.WORLD:saveWorldDivisions()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L1113)
  - [AETHR.WORLD:loadWorldDivisionsAABB()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L1126), [AETHR.WORLD:saveWorldDivisionsAABB()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L1141)
  - [AETHR.WORLD:loadActiveDivisions()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L1045), [AETHR.WORLD:saveActiveDivisions()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L1057)
- Logic
  - [AETHR.WORLD:generateWorldDivisions()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L1156), [AETHR.WORLD:buildWorldDivAABBCache()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L1206)
  - [AETHR.WORLD:checkDivisionsInZones()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L1328), [AETHR.WORLD:generateActiveDivisions()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L1067)
  - [AETHR.WORLD:initGrid()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L1236), [AETHR.WORLD:buildZoneCellIndex()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L1268)
- Markup
  - [AETHR.WORLD:markWorldDivisions()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L284)