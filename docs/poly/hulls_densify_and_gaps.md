# POLY hulls densify and gaps

Concave and convex hull construction, hull edge densification and snapping, segment intersection helpers, and overlay gap detection.

# Source anchors
- [AETHR.POLY:concaveHull()](../../dev/POLY.lua:1308)
- [AETHR.POLY:convexHull()](../../dev/POLY.lua:1460)
- [AETHR.POLY:segmentIntersectsAny()](../../dev/POLY.lua:1533)
- [AETHR.POLY:densifyHullEdges()](../../dev/POLY.lua:1556)
- [AETHR.POLY:findOverlaidPolygonGaps()](../../dev/POLY.lua:1618)

# Overview
- concaveHull builds a hull by iteratively selecting neighbors among k nearest points with angle ordering; increases k on failure and verifies all points inside
- convexHull is a monotone chain fallback to produce a convex envelope when concave hull fails
- segmentIntersectsAny checks whether a proposed edge intersects any existing hull edges excluding adjacent or shared endpoints
- densifyHullEdges samples interior points along each hull edge and snaps them to nearest original polygon segments when within snap distance
- findOverlaidPolygonGaps identifies polygonal gaps created where a smaller polygon overlays edges of a larger polygon within a tolerance

# concaveHull flow

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  IN[pts and opts] --> K[compute k from opts or proportion of N]
  K --> START[choose leftmost lowest point]
  START --> LOOP[iterate neighbors]
  LOOP --> ORDER[sort neighbors by turn angle from prev to current]
  ORDER --> PICK[pick first that does not intersect existing edges]
  PICK --> CLOSE[pick equals start and step ge 3]
  CLOSE -->|yes| VERIFY[verify all pts inside hull]
  VERIFY -->|yes| OUT[return hull]
  VERIFY -->|no| INC[increase k and retry]
  CLOSE -->|no| ADV[append and advance]
  ADV --> LOOP
  PICK -->|none| INC
  INC --> FAIL[k gt N minus 1 then fallback]
  FAIL --> CH[convexHull]

  subgraph "Init"
    IN
    K
    START
  end
  subgraph "Neighbor selection"
    LOOP
    ORDER
    PICK
  end
  subgraph "Close/Verify"
    CLOSE
    VERIFY
    ADV
  end
  subgraph "Fallback"
    FAIL
    CH
  end

  class IN class_io;
  class K,START,LOOP,ORDER,PICK,ADV,INC class_step;
  class CLOSE,VERIFY,FAIL class_decision;
  class OUT class_result;
  class CH class_compute;
```

# convexHull flow

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  IN[points] --> SORT[sort by x then y]
  SORT --> LOWER[build lower chain]
  LOWER --> UPPER[build upper chain]
  UPPER --> MERGE[merge chains omit duplicates]
  MERGE --> OUT[return convex hull]

  subgraph "Sort"
    SORT
  end
  subgraph "Build"
    LOWER
    UPPER
    MERGE
  end
  subgraph "Return"
    OUT
  end

  class IN class_io;
  class SORT,LOWER,UPPER,MERGE class_step;
  class OUT class_result;
```

# segmentIntersectsAny flow

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  IN[a b hull] --> LOOP[for i to n minus 1]
  LOOP --> EDG[evaluate c d]
  EDG --> SKIP[skip if shares endpoints within eps]
  SKIP --> TEST[segmentsIntersect a b c d]
  TEST -->|true| YES[return true]
  TEST -->|false| NEXT[next]
  NEXT -->|done| NO[return false]

  subgraph "Loop"
    LOOP
    EDG
    SKIP
    NEXT
  end
  subgraph "Test"
    TEST
    YES
    NO
  end

  class IN class_io;
  class LOOP,EDG,SKIP,NEXT class_step;
  class TEST class_decision;
  class YES,NO class_result;
```

# densifyHullEdges flow

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  IN[hull polygons samples snap] --> PREP[origLines from polygons]
  PREP --> EACH[for each edge append vertex]
  EACH --> SAMP[getEquallySpacedPoints]
  SAMP --> NN[find nearest original line and d2]
  NN --> THR[d2 le snapThreshold2]
  THR -->|yes| PROJ[project sample to line by dot over l2 clamp t]
  THR -->|no| KEEP[keep sample point]
  PROJ --> PUSH[insert projected]
  KEEP --> PUSH2[insert sample]
  PUSH --> LOOP[next edge]
  PUSH2 --> LOOP
  LOOP -->|done| OUT[return newHull]

  subgraph "Prepare"
    PREP
    EACH
  end
  subgraph "Sample"
    SAMP
  end
  subgraph "Project/Snap"
    NN
    THR
    PROJ
    KEEP
  end
  subgraph "Finalize"
    PUSH
    PUSH2
    LOOP
    OUT
  end

  class IN class_io;
  class PREP,EACH,SAMP,NN,PROJ,KEEP,PUSH,PUSH2,LOOP class_step;
  class THR class_decision;
  class OUT class_result;
```

# findOverlaidPolygonGaps flow

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  IN[smaller larger offset] --> IDX[convert larger to lines and build index of small matches within offset]
  IDX --> SAN[sanitize indexes choose shorter direction CW or CCW]
  SAN --> ASSEM[assemble gaps by collecting small vertices along selected order]
  ASSEM --> REORD[reorder gaps to master smaller order]
  REORD --> OUT[return gap polygons]

  subgraph "Index"
    IDX
    SAN
  end
  subgraph "Assemble"
    ASSEM
    REORD
  end
  subgraph "Return"
    OUT
  end

  class IN class_io;
  class IDX,SAN,ASSEM,REORD class_step;
  class OUT class_result;
```

# Sequence usage

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
sequenceDiagram
  participant Z as ZONE_MANAGER
  participant P as POLY
  Z->>P: concaveHull pts opts
  alt concave hull succeeds
    P-->>Z: hull
  else fallback
    P->>P: convexHull points
    P-->>Z: convex hull
  end
  Z->>P: densifyHullEdges hull polygons samples snap
  P-->>Z: newHull with snapped samples
  Z->>P: findOverlaidPolygonGaps small large offset
  P-->>Z: array of gap polygons
```

# Implementation notes
- concaveHull uses neighbor ordering by [AETHR.MATH:turnAngle](../../dev/MATH_.lua:157) to enforce a forward sweep; verifies non crossing with segmentsIntersect
- densifyHullEdges prebuilds all original polygon segments once for nearest neighbor snapping using pointToSegmentSquared and projection parameter t
- findOverlaidPolygonGaps chooses the shorter direction through matched small vertices to assemble contiguous gap sequences and reorders them to match the master polygon

# Validation checklist
- concaveHull: [dev/POLY.lua](../../dev/POLY.lua:1308)
- convexHull: [dev/POLY.lua](../../dev/POLY.lua:1460)
- segmentIntersectsAny: [dev/POLY.lua](../../dev/POLY.lua:1533)
- densifyHullEdges: [dev/POLY.lua](../../dev/POLY.lua:1556)
- findOverlaidPolygonGaps: [dev/POLY.lua](../../dev/POLY.lua:1618)

# Related docs
- Intersections and orientation: [docs/poly/intersections_and_orientation.md](./intersections_and_orientation.md)
- Convert and order: [docs/poly/convert_and_order.md](./convert_and_order.md)

# Conventions
- Mermaid fenced blocks use GitHub Mermaid parser
- Subgraph labels use double quotes per [docs/_mermaid/README.md](../_mermaid/README.md)
- Labels inside brackets avoid double quotes and parentheses
- Links use relative paths for repository portability