# TYPES bounds and world structures

Anchors
- [AETHR._WorldBoundsAxis:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L51)
- [AETHR._WorldBounds:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L68)
- [AETHR._WorldDivision:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L159)
- [AETHR._ZoneCellEntry:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L178)
- [_GameBounds structure](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L795)

Overview
- [_WorldBoundsAxis](../../dev/customTypes.lua) encapsulates min and max along one axis with safe defaults.
- [_WorldBounds](../../dev/customTypes.lua) composes X and Z axes into a theater bound descriptor for world space.
- [_WorldDivision](../../dev/customTypes.lua) describes rectangular grid cells used for spatial partitioning.
- [_ZoneCellEntry](../../dev/customTypes.lua) pairs a polygon with its axis aligned bounding box for coarse checks.
- [_GameBounds](../../dev/customTypes.lua) aggregates in bounds and out of bounds polygons used by zone manager and markers.

# Mermaid flow overview
```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  subgraph AXIS ["_WorldBoundsAxis New"]
    WBAX[_WorldBoundsAxis New]
    MIN[min default 0]
    MAX[max default 0]
    WBAX --> MIN
    WBAX --> MAX
  end

  subgraph BOUNDS ["_WorldBounds New"]
    WB[_WorldBounds New]
    XAX[X axis bounds]
    ZAX[Z axis bounds]
    WB --> XAX
    WB --> ZAX
  end

  subgraph DIVISION ["_WorldDivision New"]
    WD[_WorldDivision New]
    ID[ID default 0]
    ACT[active default false]
    CNR[corners vec2xz list]
    HGT[height optional]
    WD --> ID
    WD --> ACT
    WD --> CNR
    WD --> HGT
  end

  subgraph ZCE_SCOPE ["_ZoneCellEntry New"]
    ZCE[_ZoneCellEntry New]
    BB[bbox BBox]
    POLY[poly vec2 list]
    ZCE --> BB
    ZCE --> POLY
  end

  subgraph GAME_BOUNDS ["_GameBounds"]
    GB[_GameBounds]
    OOB[outOfBounds sets]
    IB[inBounds sets]
    GAPS[inOutBoundsGaps sets]
    GB --> OOB
    GB --> IB
    GB --> GAPS
  end

  class WBAX,MIN,MAX,WB,XAX,ZAX,WD,ID,ACT,CNR,HGT,ZCE,BB,POLY,GB,OOB,IB,GAPS class_data;
```

# World bounds to polygon rendering
- World bounds polygons are derived for visualization and clipping using POLY helpers:
  - [AETHR.POLY:convertBoundsToPolygon()](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L1039)

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
sequenceDiagram
  participant C as Caller
  participant T as TYPES
  participant P as POLY
  C->>T: create _WorldBoundsAxis for X and Z
  C->>T: create _WorldBounds with X Z
  C->>P: convertBoundsToPolygon(WorldBounds)
  P-->>C: vertices for drawing and clipping
```

# Division grid concept
- Divisions represent coarse spatial buckets for world lookups, overlays, and spawning.
- Each [_WorldDivision](../../dev/customTypes.lua) stores 4 corners in XZ for quick polygon tests and intersections.

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart LR
  subgraph WORLD_BOUNDS ["World bounds to divisions"]
    WB[World bounds] --> DIVS[Compute divisions]
  end

  subgraph DIVS_SCOPE ["Division instances"]
    WD1[_WorldDivision 1]
    WD2[_WorldDivision 2]
    WDn[_WorldDivision n]
    DIVS --> WD1
    DIVS --> WD2
    DIVS --> WDn
  end

  subgraph CELL_REF ["Zone cells"]
    ZCE1[ZoneCellEntry]
    ZCE2[ZoneCellEntry]
    WD1 -.-> ZCE1
    WD2 -.-> ZCE2
  end

  class WB,DIVS,WD1,WD2,WDn,ZCE1,ZCE2,WORLD_BOUNDS,DIVS_SCOPE,CELL_REF class_data;
```

# Key constructors and defaults
- Axis: [AETHR._WorldBoundsAxis:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L51) initializes min and max to 0 when nil.
- Bounds: [AETHR._WorldBounds:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L68) defaults each axis via axis constructor.
- Division: [AETHR._WorldDivision:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L159) defaults ID 0, active false, empty corners.
- Zone cell entry: [AETHR._ZoneCellEntry:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L178) defaults bbox to [AETHR._BBox:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L136) and empty polygon.

# Related anchors
- [AETHR._BBox:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L136)
- [AETHR._vec2xz:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L542), [AETHR._vec2:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L522)
- [_GameBounds fields](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L795)