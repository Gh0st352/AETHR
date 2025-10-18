# Zone data lifecycle and normalization

This document captures the end-to-end data flows for mission trigger zones managed by [dev/ZONE_MANAGER.lua](../../dev/ZONE_MANAGER.lua), with clickable anchors to the core logic:
- [AETHR.ZONE_MANAGER:initMizZoneData()](https://github.com/Gh0st352/AETHR/blob/main/dev/ZONE_MANAGER.lua#L122)
- [AETHR.ZONE_MANAGER:getStoredMizZoneData()](https://github.com/Gh0st352/AETHR/blob/main/dev/ZONE_MANAGER.lua#L141)
- [AETHR.ZONE_MANAGER:saveMizZoneData()](https://github.com/Gh0st352/AETHR/blob/main/dev/ZONE_MANAGER.lua#L152)
- [AETHR.ZONE_MANAGER:generateMizZoneData()](https://github.com/Gh0st352/AETHR/blob/main/dev/ZONE_MANAGER.lua#L205)
- [AETHR.ZONE_MANAGER:_normalizeMizZones()](https://github.com/Gh0st352/AETHR/blob/main/dev/ZONE_MANAGER.lua#L53)
- [AETHR.ZONE_MANAGER:pairActiveDivisions()](https://github.com/Gh0st352/AETHR/blob/main/dev/ZONE_MANAGER.lua#L161)
- [AETHR.ZONE_MANAGER:pairTowns()](https://github.com/Gh0st352/AETHR/blob/main/dev/ZONE_MANAGER.lua#L182)

### Related dependencies:
- [dev/CONFIG_.lua](../../dev/CONFIG_.lua)
- [dev/FILEOPS_.lua](../../dev/FILEOPS_.lua)
- [dev/WORLD.lua](../../dev/WORLD.lua)
- [dev/POLY.lua](../../dev/POLY.lua)

### Notes:
- All bracket labels in diagrams avoid double quotes and parentheses for Mermaid compatibility.


# Initialization flow

### Entry point: [AETHR.ZONE_MANAGER:initMizZoneData()](https://github.com/Gh0st352/AETHR/blob/main/dev/ZONE_MANAGER.lua#L122)

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart LR
  A[initMizZoneData] --> B[load stored via FILEOPS]
  subgraph "Load path"
    B -->|found| C[assign DATA MIZ_ZONES]
    C --> D[normalize zones]
    D --> E{changed}
    E -->|yes| F[saveMizZoneData]
    E -->|no| G[done]
  end
  subgraph "Generate path"
    B -->|not found| H[generateMizZoneData]
    H --> I[WORLD getAirbases]
    I --> J[saveMizZoneData]
    J --> K[done]
  end
  class A,B,C,D,F,H,I,J class_step;
  class E class_decision;
  class G,K class_result;
  class I class_io;
```

### Key steps and anchors:
- Load stored: [AETHR.ZONE_MANAGER:getStoredMizZoneData()](https://github.com/Gh0st352/AETHR/blob/main/dev/ZONE_MANAGER.lua#L141)
- Normalize if loaded: [AETHR.ZONE_MANAGER:_normalizeMizZones()](https://github.com/Gh0st352/AETHR/blob/main/dev/ZONE_MANAGER.lua#L53)
- Generate if not found: [AETHR.ZONE_MANAGER:generateMizZoneData()](https://github.com/Gh0st352/AETHR/blob/main/dev/ZONE_MANAGER.lua#L205)
- Persist: [AETHR.ZONE_MANAGER:saveMizZoneData()](https://github.com/Gh0st352/AETHR/blob/main/dev/ZONE_MANAGER.lua#L152)
- Airbases collection uses WORLD helpers: [dev/WORLD.lua](../../dev/WORLD.lua)


# Generation flow

Constructor and bordering determination: [AETHR.ZONE_MANAGER:generateMizZoneData()](https://github.com/Gh0st352/AETHR/blob/main/dev/ZONE_MANAGER.lua#L205)

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  G1[generateMizZoneData] --> G2[resolve zone names from arg or CONFIG]
  G2 --> G3{zone names empty}
  subgraph "Empty input"
    G3 -->|yes| G4[return self]
  end
  subgraph "Construct zones"
    G3 -->|no| G5[read env mission zones]
    G5 --> G6[loop zone names]
    G6 --> G7[find matching env zone by name]
    G7 --> G8[construct _MIZ_ZONE via ctor]
    G8 --> G9[store in DATA MIZ_ZONES]
    G9 --> G10[determine bordering zones]
    G10 --> G11[return self]
  end
  class G1,G2,G5,G6,G7,G8,G9,G10 class_step;
  class G3 class_decision;
  class G4,G11 class_result;
  class G5 class_io;
```

### Highlights:
- Looks up env zones from the DCS mission scripting env.
- Constructs mission zones using the module local or global constructor, then computes bordering relationships:
  - Bordering detection: [AETHR.ZONE_MANAGER:determineBorderingZones()](https://github.com/Gh0st352/AETHR/blob/main/dev/ZONE_MANAGER.lua#L232)


# Normalization flow

Field canonicalization and derived lines: [AETHR.ZONE_MANAGER:_normalizeMizZones()](https://github.com/Gh0st352/AETHR/blob/main/dev/ZONE_MANAGER.lua#L53)

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart LR
  N1[_normalizeMizZones] --> N2[iterate zones]
  subgraph "Field canonicalization"
    N2 --> N3[verticies to vertices]
    N2 --> N4[activeDivsions to activeDivisions]
  end
  subgraph "Derived geometry"
    N2 --> N5{LinesVec2 missing}
    N5 -->|yes and POLY available| N6[convert polygon to lines]
    N5 -->|no| N7[skip]
    N6 --> N8[set changed true]
  end
  N3 --> N8
  N4 --> N8
  N8 --> N9[return changed]
  class N1,N2,N3,N4,N8 class_step;
  class N5 class_decision;
  class N6 class_compute;
  class N9 class_result;
```

### Derived computation relies on geometry helpers:
- Convert to lines uses POLY utilities: [dev/POLY.lua](../../dev/POLY.lua)


# Persistence helpers

## Load stored mission zones: [AETHR.ZONE_MANAGER:getStoredMizZoneData()](https://github.com/Gh0st352/AETHR/blob/main/dev/ZONE_MANAGER.lua#L141)

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart LR
  L1[getStoredMizZoneData] --> L2[resolve storage path and file]
  L2 --> L3[FILEOPS loadData]
  L3 --> L4{data}
  L4 -->|present| L5[return data]
  L4 -->|nil| L6[return nil]
  class L1,L2,L3 class_step;
  class L2,L3 class_io;
  class L4 class_decision;
  class L5,L6 class_result;
```

## Save mission zones: [AETHR.ZONE_MANAGER:saveMizZoneData()](https://github.com/Gh0st352/AETHR/blob/main/dev/ZONE_MANAGER.lua#L152)

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart LR
  S1[saveMizZoneData] --> S2[resolve storage path and file]
  S2 --> S3[FILEOPS saveData with DATA MIZ_ZONES]
  S3 --> S4[return]
  class S1,S2,S3 class_step;
  class S2,S3 class_io;
  class S4 class_result;
```


# Zone pairing helpers

## Active world divisions by polygon overlap: [AETHR.ZONE_MANAGER:pairActiveDivisions()](https://github.com/Gh0st352/AETHR/blob/main/dev/ZONE_MANAGER.lua#L161)

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  D1[pairActiveDivisions] --> D2[read WORLD saveDivisions]
  D2 --> D3[for each zone]
  D3 --> D4[for each division]
  D4 --> D5{polygons overlap}
  D5 -->|yes| D6[add division to zone activeDivisions]
  D5 -->|no| D7[next]
  D6 --> D7
  D7 --> D8[return self]
  class D1,D2,D3,D4,D6,D7 class_step;
  class D2 class_io;
  class D5 class_decision;
  class D8 class_result;
```

## Towns contained by point in polygon: [AETHR.ZONE_MANAGER:pairTowns()](https://github.com/Gh0st352/AETHR/blob/main/dev/ZONE_MANAGER.lua#L182)

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  T1[pairTowns] --> T2[read WORLD townClusterDB]
  T2 --> T3[for each zone]
  T3 --> T4[for each cluster]
  T4 --> T5{cluster center inside zone polygon}
  T5 -->|yes| T6[add to zone townsDB]
  T5 -->|no| T7[next]
  T6 --> T7
  T7 --> T8[return self]
  class T1,T2,T3,T4,T6,T7 class_step;
  class T2 class_io;
  class T5 class_decision;
  class T8 class_result;
```

## Geometry predicates used here are implemented in POLY:
- Overlap and point tests: [dev/POLY.lua](../../dev/POLY.lua)


# Anchor index

- [AETHR.ZONE_MANAGER:initMizZoneData()](https://github.com/Gh0st352/AETHR/blob/main/dev/ZONE_MANAGER.lua#L122)
- [AETHR.ZONE_MANAGER:getStoredMizZoneData()](https://github.com/Gh0st352/AETHR/blob/main/dev/ZONE_MANAGER.lua#L141)
- [AETHR.ZONE_MANAGER:saveMizZoneData()](https://github.com/Gh0st352/AETHR/blob/main/dev/ZONE_MANAGER.lua#L152)
- [AETHR.ZONE_MANAGER:generateMizZoneData()](https://github.com/Gh0st352/AETHR/blob/main/dev/ZONE_MANAGER.lua#L205)
- [AETHR.ZONE_MANAGER:_normalizeMizZones()](https://github.com/Gh0st352/AETHR/blob/main/dev/ZONE_MANAGER.lua#L53)
- [AETHR.ZONE_MANAGER:pairActiveDivisions()](https://github.com/Gh0st352/AETHR/blob/main/dev/ZONE_MANAGER.lua#L161)
- [AETHR.ZONE_MANAGER:pairTowns()](https://github.com/Gh0st352/AETHR/blob/main/dev/ZONE_MANAGER.lua#L182)