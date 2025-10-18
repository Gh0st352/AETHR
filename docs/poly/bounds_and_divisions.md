# POLY bounds and divisions

Converting axis aligned bounds to a polygon, dividing a quadrilateral into a grid, and computing polygon area.

Source anchors
- [AETHR.POLY:convertBoundsToPolygon()](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L1039)
- [AETHR.POLY:dividePolygon()](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L753)
- [AETHR.POLY:polygonArea()](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L826)
- Related: [AETHR.POLY:ensureConvex()](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L846)

Overview
- convertBoundsToPolygon builds a 4 corner polygon [minX,minZ] [maxX,minZ] [maxX,maxZ] [minX,maxZ] and enforces convexity
- dividePolygon splits a quad into rows and columns informed by area and aspect ratio, interpolating the four edges to generate cell polygons
- polygonArea computes area using the shoelace formula on normalized x y coordinates

# convertBoundsToPolygon flow

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  IN[bounds Xmin Xmax Zmin Zmax] --> QUAD[build 4 corners]
  QUAD --> CONV[ensureConvex]
  CONV --> OUT[return 4 point polygon]

  class IN class_io;
  class QUAD class_step;
  class CONV class_compute;
  class OUT class_result;
```

# dividePolygon flow

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  IN[quad and targetArea] --> AREA[total area by polygonArea]
  AREA --> CNT[cell count round total over target]
  CNT --> EDGES[left right edges]
  CNT --> ASPECT[compute width height ratio]
  ASPECT --> SHAPE[cols ceil sqrt count times ratio and rows ceil count over cols adjust]
  SHAPE --> GEN[for each row and col interpolate edges]
  GEN --> OUT[list of cell corner quads]

  subgraph "Sizing"
    AREA
    CNT
    ASPECT
  end
  subgraph "Layout"
    EDGES
    SHAPE
  end
  subgraph "Generate"
    GEN
    OUT
  end

  class IN class_io;
  class AREA,CNT,ASPECT,SHAPE,GEN class_step;
  class EDGES class_data;
  class OUT class_result;
```

# polygonArea flow

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  IN[vertices] --> NORM[normalize to x y]
  NORM --> LOOP[for i sum xi yj minus xj yi]
  LOOP --> ABS[abs sum]
  ABS --> RET[return area over 2]

  subgraph "Accumulate"
    LOOP
    ABS
  end

  class IN class_io;
  class NORM,LOOP class_step;
  class ABS class_compute;
  class RET class_result;
```

# Sequence usage

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
sequenceDiagram
  participant W as WORLD
  participant P as POLY
  W->>P: convertBoundsToPolygon bounds
  P-->>W: 4 point convex polygon
  W->>P: dividePolygon polygon targetArea
  P-->>W: array of cell polygons
```

# Implementation notes
- convertBoundsToPolygon
  - Produces consistent corner order bottom left bottom right top right top left
  - Uses ensureConvex to swap vertices if any cross sign checks disagree
- dividePolygon
  - Chooses rows and cols to cover count while approximating the aspect ratio
  - Interpolates along both pairs of opposite edges per row and per column
- polygonArea
  - Normalizes each input vertex to {x,y} allowing inputs that carry y or z

# Validation checklist
- convertBoundsToPolygon: [dev/POLY.lua](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L1039)
- dividePolygon: [dev/POLY.lua](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L753)
- polygonArea: [dev/POLY.lua](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L826)

# Related docs
- Convert and order: [docs/poly/convert_and_order.md](./convert_and_order.md)
- Intersections and orientation: [docs/poly/intersections_and_orientation.md](./intersections_and_orientation.md)

# Conventions
- Mermaid fenced blocks use GitHub Mermaid parser
- Labels inside brackets avoid double quotes and parentheses
- Links use relative paths for repository portability