# AETHR POLY diagrams and flows

### Primary anchors
- [AETHR.POLY:segmentsIntersect()](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L44)
- [AETHR.POLY:pointInPolygon()](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L66)
- [AETHR.POLY:polygonsOverlap()](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L92)
- [AETHR.POLY:circleOverlapPoly()](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L120)
- [AETHR.POLY:orientation()](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L180)
- [AETHR.POLY:onSegment()](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L193)
- [AETHR.POLY:convertLinesToPolygon()](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L582)
- [AETHR.POLY:convertPolygonToLines()](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L737)
- [AETHR.POLY:dividePolygon()](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L753)
- [AETHR.POLY:polygonArea()](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L826)
- [AETHR.POLY:ensureConvexN()](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L863)
- [AETHR.POLY:getEquallySpacedPoints()](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L1074)
- [AETHR.POLY:isWithinOffset()](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L1106)
- [AETHR.POLY:pointToSegmentSquared()](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L1148)
- [AETHR.POLY:getMidpoint()](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L1171)
- [AETHR.POLY:calculateLineSlope()](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L1188)
- [AETHR.POLY:isIntersect()](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L1249)
- [AETHR.POLY:concaveHull()](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L1308)
- [AETHR.POLY:convexHull()](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L1461)
- [AETHR.POLY:intersectRayToBounds()](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L1491)
- [AETHR.POLY:densifyHullEdges()](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L1556)
- [AETHR.POLY:findOverlaidPolygonGaps()](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L1618)
- [AETHR.POLY:reorderSlaveToMaster()](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L1705)
- [AETHR.POLY:reverseVertOrder()](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L1761)
- [AETHR.POLY:getCenterPoint()](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L1779)
- [AETHR.POLY:getCentroidPoint()](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L1830)
- [AETHR.POLY:convertBoundsToPolygon()](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L1039)
- [AETHR.POLY:pointInCircle()](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L248)
- [AETHR.POLY:getRandomVec2inCircle()](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L276)
- [AETHR.POLY:getRandomVec2inPolygon()](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L343)

### Breakout documents
- Intersections and orientation: [docs/poly/intersections_and_orientation.md](intersections_and_orientation.md)
- Point in polygon and overlap: [docs/poly/point_in_polygon_and_overlap.md](point_in_polygon_and_overlap.md)
- Distance, projection, and offset: [docs/poly/distance_projection_and_offset.md](distance_projection_and_offset.md)
- Random points and sampling: [docs/poly/random_points_and_sampling.md](random_points_and_sampling.md)
- Convert and order: [docs/poly/convert_and_order.md](convert_and_order.md)
- Bounds and divisions: [docs/poly/bounds_and_divisions.md](bounds_and_divisions.md)
- Hulls densify and gaps: [docs/poly/hulls_densify_and_gaps.md](hulls_densify_and_gaps.md)
- Rays, midpoints, and slopes: [docs/poly/rays_midpoints_and_slopes.md](rays_midpoints_and_slopes.md)

### Documents and indices
- Master diagrams index: [docs/README.md](../README.md)
- ZONE_MANAGER: [docs/zone_manager/README.md](../zone_manager/README.md)
- WORLD: [docs/world/README.md](../world/README.md)

# Core geometry relationships

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart LR
  subgraph "Hull processing"
    CH[concaveHull] --> HULL[processed hull]
    CV[convexHull] -.-> HULL
    DEN[densifyHullEdges] --> HULL
  end
  subgraph "Division"
    CBB[convertBoundsToPolygon] --> DIV[dividePolygon]
    DIV --> GRID[division grid]
  end
  subgraph "Overlap and gaps"
    FOG[findOverlaidPolygonGaps] --> GAPS[gap polygons]
  end
  CPL[convertPolygonToLines] --> L2P[convertLinesToPolygon]
  PIP[pointInPolygon] --> POLYOV[polygonsOverlap]
  SEG[segmentsIntersect] --> POLYOV
  P2S[pointToSegmentSquared] --> IOFF[isWithinOffset]
  ESP[getEquallySpacedPoints] --> IOFF

  class GRID,HULL,GAPS class_data;
  class CH,CV,DEN,DIV,CBB,PIP,POLYOV,SEG,CPL,L2P,P2S,ESP,IOFF class_compute;
```

# Module interactions

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
sequenceDiagram
  participant Z as ZONE_MANAGER
  participant P as POLY
  participant W as WORLD
  Z->>P: convertPolygonToLines, ensureConvexN, isWithinOffset
  Z->>P: concaveHull, densifyHullEdges, findOverlaidPolygonGaps
  W->>P: convertBoundsToPolygon, dividePolygon
  P-->>Z: processed hulls and gaps
  P-->>W: division grid and bounds polygon
```

# Algorithm: pointInPolygon

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  S[Start] --> J[Set j = n]
  subgraph "Iteration"
    J --> L[Loop i from 1..n]
    L --> C[Edge crosses horizontal ray?]
    C -->|yes| T[Toggle inside flag]
    C -->|no| N[No change]
    T --> U[Set j = i]
    N --> U
    U --> L
  end
  L -->|done| R[Return inside]

  class S class_io;
  class R class_result;
  class C class_decision;
  class L,T,N,U,J class_step;
```

# Algorithm: convertLinesToPolygon

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  subgraph "Bootstrap"
    ST[Start] --> TRY[Try each segment as start and orientation]
  end
  subgraph "Walk"
    TRY --> WALK[Walk segments by endpoint proximity]
    WALK --> FOUND[Found connecting segment?]
    FOUND -->|no| FAIL[Fail and try other start]
    FOUND -->|yes| APP[Append vertices and continue]
    APP --> CLOSED[End connects back to start?]
  end
  CLOSED -->|yes| DEDUP[remove_duplicate_vertices]
  CLOSED -->|no| TRY
  subgraph "Finalize"
    DEDUP --> RET[Return ordered polygon]
  end

  class ST,TRY,WALK,APP,DEDUP,RET class_step;
  class FOUND,CLOSED class_decision;
  class RET class_result;
```

# Algorithm: densifyHullEdges

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  IN[hull and polygons] --> E[for each edge]
  subgraph "Sample"
    E --> SAMP[getEquallySpacedPoints]
  end
  subgraph "Snap"
    SAMP --> SNAP[find nearest original segment]
    SNAP --> THR[distance within snapDistance?]
    THR -->|yes| INS[insert projected point]
    THR -->|no| INS2[insert sample point]
  end
  INS --> NEXT[next edge]
  INS2 --> NEXT
  subgraph "Finalize"
    NEXT -->|done| OUT[new hull]
  end

  class IN class_io;
  class OUT class_result;
  class THR class_decision;
  class E,SAMP,SNAP,INS,INS2,NEXT class_step;
```

# Algorithm: concaveHull with convex fallback

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  A[Start] --> K[Set k or concavity]
  subgraph "k-nearest Build"
    K --> LOOP[Build hull by k-nearest]
    LOOP --> CROSS[crossing edges?]
  end
  subgraph "Validate"
    CROSS -->|no| VERIFY[all points inside?]
    VERIFY -->|yes| DONE[return hull]
    VERIFY -->|no| INC[increase k and retry]
  end
  CROSS -->|yes| INC
  INC --> LOOP
  K --> FAIL[exceeds N-1]
  subgraph "Fallback"
    FAIL --> CH[convexHull]
  end

  class A,K,LOOP,INC class_step;
  class CROSS,VERIFY,FAIL class_decision;
  class DONE class_result;
  class CH class_compute;
```

# Algorithm: dividePolygon into grid

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart LR
  subgraph "Sizing"
    TA[polygonArea] --> CNT[count cells]
    CNT --> AR[aspect ratio]
    AR --> RC[rows and cols]
  end
  subgraph "Generate"
    RC --> GEN[interpolate cell corners]
    GEN --> OUT[corners list per cell]
  end

  class OUT class_result;
  class TA,CNT,AR,RC,GEN class_step;
```

# Key anchors
- Bounds conversion: [AETHR.POLY:convertBoundsToPolygon()](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L1039)
- Hull processing: [AETHR.POLY:concaveHull()](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L1308), [AETHR.POLY:convexHull()](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L1461), [AETHR.POLY:densifyHullEdges()](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L1556)
- Gap detection: [AETHR.POLY:findOverlaidPolygonGaps()](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L1618)
- Grid division: [AETHR.POLY:dividePolygon()](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L753)
- Distance helpers: [AETHR.POLY:pointToSegmentSquared()](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L1148), [AETHR.POLY:getEquallySpacedPoints()](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L1074), [AETHR.POLY:isWithinOffset()](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L1106)

# Notes
- Subgraph labels use double quotes per [docs/_mermaid/README.md](../_mermaid/README.md).
- All diagrams use GitHub Mermaid fenced blocks.