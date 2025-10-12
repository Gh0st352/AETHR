# Game bounds: master polygon, out of bounds, and gaps

This document details the computation of:
- Master in bounds polygon from zone edges
- Out of bounds hull quads with optional densification
- Center cutout polygon and in–out gap polygons

Primary anchors:
- [AETHR.ZONE_MANAGER:getOutOfBounds()](../../dev/ZONE_MANAGER.lua:799)
- [AETHR.ZONE_MANAGER:_buildBorderExclude()](../../dev/ZONE_MANAGER.lua:356)
- [AETHR.ZONE_MANAGER:_collectPolygonsFromZones()](../../dev/ZONE_MANAGER.lua:385)
- [AETHR.ZONE_MANAGER:_flattenUniquePoints()](../../dev/ZONE_MANAGER.lua:410)
- [AETHR.ZONE_MANAGER:_processHullLoop()](../../dev/ZONE_MANAGER.lua:449)
- [AETHR.ZONE_MANAGER:getPolygonCutout()](../../dev/ZONE_MANAGER.lua:565)
- [AETHR.ZONE_MANAGER:generateGameBoundData()](../../dev/ZONE_MANAGER.lua:895)

Related dependencies:
- [dev/CONFIG_.lua](../../dev/CONFIG_.lua)
- [dev/POLY.lua](../../dev/POLY.lua)


## End to end pipeline

Entry point: [AETHR.ZONE_MANAGER:generateGameBoundData()](../../dev/ZONE_MANAGER.lua:895)

```mermaid
flowchart TD
  P1[generateGameBoundData] --> P2[getMasterZonePolygon]
  P2 --> P3[getOutOfBounds no sample]
  P3 --> P4[centerPoly from getPolygonCutout on HullPolysNoSample]
  P4 --> P5[getOutOfBounds with config samples and snap]
  P5 --> P6[find overlaid polygon gaps]
  P6 --> P7[ensure convex gaps]
  P7 --> P8[reverse vertex order to concave]
  P8 --> P9[store results in DATA GAME_BOUNDS]
```

Outputs stored in:
- DATA.GAME_BOUNDS.outOfBounds.HullPolysNoSample
- DATA.GAME_BOUNDS.outOfBounds.HullPolysWithSample
- DATA.GAME_BOUNDS.outOfBounds.centerPoly
- DATA.GAME_BOUNDS.inBounds.polyLines and polyVerts
- DATA.GAME_BOUNDS.inOutBoundsGaps.overlaid, .convex, .concave


## Computing out of bounds hull tiles

Entry point: [AETHR.ZONE_MANAGER:getOutOfBounds()](../../dev/ZONE_MANAGER.lua:799)

Behavior summary:
- Resolve world bounds from configuration
- Build exclude set of shared border vertices
- Collect zone polygons after excluding border vertices
- Fallback to a flat vertex set when polygons are invalid
- Build unique points and compute hull
- Process hull loop into outward quads and store

```mermaid
flowchart TD
  O1[getOutOfBounds] --> O2[resolve worldBounds by theater]
  O2 --> O3[zonesTable equals DATA MIZ_ZONES]
  O3 --> O4[build exclude set of shared border vertices]
  O4 --> O5[collect polygons from zones excluding keys]
  O5 --> O6{any valid polygons}
  O6 -->|no| O7[flat collect all zone vertices as one polygon]
  O6 -->|yes| O8[continue]
  O7 --> O9[append flat if has three points]
  O8 --> O10[flatten to unique points with fallback to zone vertices]
  O10 --> O11{enough points}
  O11 -->|no| O12[fallback to bounds polygon or return self]
  O11 -->|yes| O13[compute hull concave then convex fallback]
  O13 --> O14[process hull loop into outward quads]
  O14 --> O15[store into HullPolysWithSample or NoSample]
  O15 --> O16[return self]
```

Key helpers:
- Exclude set: [AETHR.ZONE_MANAGER:_buildBorderExclude()](../../dev/ZONE_MANAGER.lua:356)
- Collect polygons: [AETHR.ZONE_MANAGER:_collectPolygonsFromZones()](../../dev/ZONE_MANAGER.lua:385)
- Unique points: [AETHR.ZONE_MANAGER:_flattenUniquePoints()](../../dev/ZONE_MANAGER.lua:410)
- Hull processing: [AETHR.ZONE_MANAGER:_processHullLoop()](../../dev/ZONE_MANAGER.lua:449)
- Geometry hulls and bounds conversion: [dev/POLY.lua](../../dev/POLY.lua)


## Excluding shared border vertices

Entry point: [AETHR.ZONE_MANAGER:_buildBorderExclude()](../../dev/ZONE_MANAGER.lua:356)

```mermaid
flowchart LR
  X1[_buildBorderExclude] --> X2[iterate zones with BorderingZones]
  X2 --> X3[for each border append ZoneLine endpoints]
  X2 --> X4[for each border append NeighborLine endpoints]
  X3 --> X5[build key x y with precision]
  X4 --> X5
  X5 --> X6[return exclude map]
```

Purpose:
- Prevents shared edges from contributing to the master perimeter hull by removing their endpoints from candidate polygons


## Collecting polygons after exclude

Entry point: [AETHR.ZONE_MANAGER:_collectPolygonsFromZones()](../../dev/ZONE_MANAGER.lua:385)

```mermaid
flowchart LR
  C1[_collectPolygonsFromZones] --> C2[for each zone take vertices]
  C2 --> C3[skip vertex keys present in exclude]
  C3 --> C4[accumulate poly if at least 3 vertices]
  C4 --> C5[return list of polygons]
```


## Flattening to unique points

Entry point: [AETHR.ZONE_MANAGER:_flattenUniquePoints()](../../dev/ZONE_MANAGER.lua:410)

```mermaid
flowchart TD
  U1[_flattenUniquePoints] --> U2[insert unique points by x y]
  U2 --> U3{count less than 3}
  U3 -->|yes| U4[include any zone vertices not yet included]
  U3 -->|no| U5[proceed]
  U4 --> U6[return allPoints]
  U5 --> U6[return allPoints]
```


## Hull loop to outward quads

Entry point: [AETHR.ZONE_MANAGER:_processHullLoop()](../../dev/ZONE_MANAGER.lua:449)

Behavior summary:
- Optional densification of hull edges using samples and snapping
- Compute centroid of the hull
- For each hull vertex, cast outward ray to world bounds and capture intersection
- Form quads between consecutive hull vertices and their outward intersections
- Store the resulting list depending on whether sampling was enabled

```mermaid
flowchart TD
  H1[_processHullLoop] --> H2[optional densify hull edges]
  H2 --> H3[compute centroid]
  H3 --> H4[for each vertex compute outward direction]
  H4 --> H5[intersect ray with world bounds or clamp]
  H5 --> H6[assemble outward intersection list]
  H6 --> H7[for each consecutive pair build quad]
  H7 --> H8[store in HullPolysWithSample or NoSample]
  H8 --> H9[return self]
```

Geometry dependencies:
- Densify edges, centroid, bounds intersection: [dev/POLY.lua](../../dev/POLY.lua)


## Center cutout polygon

Entry point: [AETHR.ZONE_MANAGER:getPolygonCutout()](../../dev/ZONE_MANAGER.lua:565)

Behavior summary:
- Normalize input polygons to a canonical point form
- Build undirected edge counts
- Boundary edges are those seen once
- Walk boundary edges to form closed loops
- Outer loop is largest area; holes are loops whose centroid lies inside the outer
- Return the largest hole loop or fallback to second largest

```mermaid
flowchart TD
  K1[getPolygonCutout] --> K2[normalize polygons]
  K2 --> K3[build undirected edge counts and points map]
  K3 --> K4[collect edges with single occurrence]
  K4 --> K5[walk boundary edges into loops]
  K5 --> K6[sort loops by area desc]
  K6 --> K7[pick outer as largest]
  K7 --> K8[collect hole candidates by centroid inside outer]
  K8 --> K9[choose largest hole or fallback]
  K9 --> K10[return hole points or nil]
```


## Configuration inputs

- Theater bounds used by out of bounds:
  - [AETHR.CONFIG.MAIN.worldBounds](../../dev/CONFIG_.lua:245)
- Game bounds rendering and sampling configuration:
  - [AETHR.CONFIG.MAIN.Zone.gameBounds.getOutOfBounds.samplesPerEdge](../../dev/CONFIG_.lua:327)
  - [AETHR.CONFIG.MAIN.Zone.gameBounds.getOutOfBounds.useHoleSinglePolygon](../../dev/CONFIG_.lua:329)
  - [AETHR.CONFIG.MAIN.Zone.gameBounds.getOutOfBounds.snapDistance](../../dev/CONFIG_.lua:330)
- Line and fill colors for game bounds markers:
  - [AETHR.CONFIG.MAIN.Zone.gameBounds.LineColors](../../dev/CONFIG_.lua:322)
  - [AETHR.CONFIG.MAIN.Zone.gameBounds.FillColors](../../dev/CONFIG_.lua:323)
  - [AETHR.CONFIG.MAIN.Zone.gameBounds.LineAlpha](../../dev/CONFIG_.lua:325)
  - [AETHR.CONFIG.MAIN.Zone.gameBounds.FillAlpha](../../dev/CONFIG_.lua:324)
  - [AETHR.CONFIG.MAIN.Zone.gameBounds.lineType](../../dev/CONFIG_.lua:326)


## Anchor index

- [AETHR.ZONE_MANAGER:generateGameBoundData()](../../dev/ZONE_MANAGER.lua:895)
- [AETHR.ZONE_MANAGER:getOutOfBounds()](../../dev/ZONE_MANAGER.lua:799)
- [AETHR.ZONE_MANAGER:_buildBorderExclude()](../../dev/ZONE_MANAGER.lua:356)
- [AETHR.ZONE_MANAGER:_collectPolygonsFromZones()](../../dev/ZONE_MANAGER.lua:385)
- [AETHR.ZONE_MANAGER:_flattenUniquePoints()](../../dev/ZONE_MANAGER.lua:410)
- [AETHR.ZONE_MANAGER:_processHullLoop()](../../dev/ZONE_MANAGER.lua:449)
- [AETHR.ZONE_MANAGER:getPolygonCutout()](../../dev/ZONE_MANAGER.lua:565)
- [dev/POLY.lua](../../dev/POLY.lua)
- [dev/CONFIG_.lua](../../dev/CONFIG_.lua)