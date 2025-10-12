# POLY bounds and divisions

Converting axis aligned bounds to a polygon, dividing a quadrilateral into a grid, and computing polygon area.

Source anchors
- [AETHR.POLY:convertBoundsToPolygon()](../../dev/POLY.lua:1039)
- [AETHR.POLY:dividePolygon()](../../dev/POLY.lua:753)
- [AETHR.POLY:polygonArea()](../../dev/POLY.lua:826)
- Related: [AETHR.POLY:ensureConvex()](../../dev/POLY.lua:846)

Overview
- convertBoundsToPolygon builds a 4 corner polygon [minX,minZ] [maxX,minZ] [maxX,maxZ] [minX,maxZ] and enforces convexity
- dividePolygon splits a quad into rows and columns informed by area and aspect ratio, interpolating the four edges to generate cell polygons
- polygonArea computes area using the shoelace formula on normalized x y coordinates

convertBoundsToPolygon flow

```mermaid
flowchart TD
  IN[bounds Xmin Xmax Zmin Zmax] --> QUAD[build 4 corners]
  QUAD --> CONV[ensureConvex]
  CONV --> OUT[return 4 point polygon]
```

dividePolygon flow

```mermaid
flowchart TD
  IN[quad and targetArea] --> AREA[total area by polygonArea]
  AREA --> CNT[cell count round total over target]
  CNT --> EDGES[left right edges]
  CNT --> ASPECT[compute width height ratio]
  ASPECT --> SHAPE[cols ceil sqrt count times ratio and rows ceil count over cols adjust]
  SHAPE --> GEN[for each row and col interpolate edges]
  GEN --> OUT[list of cell corner quads]
```

polygonArea flow

```mermaid
flowchart TD
  IN[vertices] --> NORM[normalize to x y]
  NORM --> LOOP[for i sum xi yj minus xj yi]
  LOOP --> ABS[abs sum]
  ABS --> RET[return area over 2]
```

Sequence usage

```mermaid
sequenceDiagram
  participant W as WORLD
  participant P as POLY
  W->>P: convertBoundsToPolygon bounds
  P-->>W: 4 point convex polygon
  W->>P: dividePolygon polygon targetArea
  P-->>W: array of cell polygons
```

Implementation notes
- convertBoundsToPolygon
  - Produces consistent corner order bottom left bottom right top right top left
  - Uses ensureConvex to swap vertices if any cross sign checks disagree
- dividePolygon
  - Chooses rows and cols to cover count while approximating the aspect ratio
  - Interpolates along both pairs of opposite edges per row and per column
- polygonArea
  - Normalizes each input vertex to {x,y} allowing inputs that carry y or z

Validation checklist
- convertBoundsToPolygon: [dev/POLY.lua](../../dev/POLY.lua:1039)
- dividePolygon: [dev/POLY.lua](../../dev/POLY.lua:753)
- polygonArea: [dev/POLY.lua](../../dev/POLY.lua:826)

Related docs
- Convert and order: [docs/poly/convert_and_order.md](./convert_and_order.md)
- Intersections and orientation: [docs/poly/intersections_and_orientation.md](./intersections_and_orientation.md)

Conventions
- Mermaid fenced blocks use GitHub Mermaid parser
- Labels inside brackets avoid double quotes and parentheses
- Links use relative paths for repository portability