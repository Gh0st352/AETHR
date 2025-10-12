# TYPES bounds and world structures

Anchors
- [AETHR._WorldBoundsAxis:New()](../../dev/customTypes.lua:51)
- [AETHR._WorldBounds:New()](../../dev/customTypes.lua:68)
- [AETHR._WorldDivision:New()](../../dev/customTypes.lua:159)
- [AETHR._ZoneCellEntry:New()](../../dev/customTypes.lua:178)
- [_GameBounds structure](../../dev/customTypes.lua:795)

Overview
- [_WorldBoundsAxis](../../dev/customTypes.lua) encapsulates min and max along one axis with safe defaults.
- [_WorldBounds](../../dev/customTypes.lua) composes X and Z axes into a theater bound descriptor for world space.
- [_WorldDivision](../../dev/customTypes.lua) describes rectangular grid cells used for spatial partitioning.
- [_ZoneCellEntry](../../dev/customTypes.lua) pairs a polygon with its axis aligned bounding box for coarse checks.
- [_GameBounds](../../dev/customTypes.lua) aggregates in bounds and out of bounds polygons used by zone manager and markers.

Mermaid flow overview
```mermaid
flowchart TD
  WBAX[_WorldBoundsAxis New] --> MIN[min default 0]
  WBAX --> MAX[max default 0]

  WB[_WorldBounds New] --> XAX[X axis bounds]
  WB --> ZAX[Z axis bounds]

  WD[_WorldDivision New] --> ID[ID default 0]
  WD --> ACT[active default false]
  WD --> CNR[corners vec2xz list]
  WD --> HGT[height optional]

  ZCE[_ZoneCellEntry New] --> BB[bbox BBox]
  ZCE --> POLY[poly vec2 list]

  GB[_GameBounds] --> OOB[outOfBounds sets]
  GB --> IB[inBounds sets]
  GB --> GAPS[inOutBoundsGaps sets]
```

World bounds to polygon rendering
- World bounds polygons are derived for visualization and clipping using POLY helpers:
  - [AETHR.POLY:convertBoundsToPolygon()](../../dev/POLY.lua:1039)

```mermaid
sequenceDiagram
  participant C as Caller
  participant T as TYPES
  participant P as POLY
  C->>T: create _WorldBoundsAxis for X and Z
  C->>T: create _WorldBounds with X Z
  C->>P: convertBoundsToPolygon(WorldBounds)
  P-->>C: vertices for drawing and clipping
```

Division grid concept
- Divisions represent coarse spatial buckets for world lookups, overlays, and spawning.
- Each [_WorldDivision](../../dev/customTypes.lua) stores 4 corners in XZ for quick polygon tests and intersections.

```mermaid
flowchart LR
  WB[World bounds] --> DIVS[Compute divisions]
  DIVS --> WD1[_WorldDivision 1]
  DIVS --> WD2[_WorldDivision 2]
  DIVS --> WDn[_WorldDivision n]
  WD1 -.-> ZCE1[ZoneCellEntry]
  WD2 -.-> ZCE2[ZoneCellEntry]
```

Key constructors and defaults
- Axis: [AETHR._WorldBoundsAxis:New()](../../dev/customTypes.lua:51) initializes min and max to 0 when nil.
- Bounds: [AETHR._WorldBounds:New()](../../dev/customTypes.lua:68) defaults each axis via axis constructor.
- Division: [AETHR._WorldDivision:New()](../../dev/customTypes.lua:159) defaults ID 0, active false, empty corners.
- Zone cell entry: [AETHR._ZoneCellEntry:New()](../../dev/customTypes.lua:178) defaults bbox to [AETHR._BBox:New()](../../dev/customTypes.lua:136) and empty polygon.

Related anchors
- [AETHR._BBox:New()](../../dev/customTypes.lua:136)
- [AETHR._vec2xz:New()](../../dev/customTypes.lua:542), [AETHR._vec2:New()](../../dev/customTypes.lua:522)
- [_GameBounds fields](../../dev/customTypes.lua:795)