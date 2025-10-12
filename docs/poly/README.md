# AETHR POLY diagrams and flows

Primary anchors
- [AETHR.POLY:segmentsIntersect()](../../dev/POLY.lua:44)
- [AETHR.POLY:pointInPolygon()](../../dev/POLY.lua:66)
- [AETHR.POLY:polygonsOverlap()](../../dev/POLY.lua:93)
- [AETHR.POLY:circleOverlapPoly()](../../dev/POLY.lua:121)
- [AETHR.POLY:orientation()](../../dev/POLY.lua:181)
- [AETHR.POLY:onSegment()](../../dev/POLY.lua:193)
- [AETHR.POLY:convertLinesToPolygon()](../../dev/POLY.lua:583)
- [AETHR.POLY:convertPolygonToLines()](../../dev/POLY.lua:737)
- [AETHR.POLY:dividePolygon()](../../dev/POLY.lua:753)
- [AETHR.POLY:polygonArea()](../../dev/POLY.lua:827)
- [AETHR.POLY:ensureConvexN()](../../dev/POLY.lua:863)
- [AETHR.POLY:getEquallySpacedPoints()](../../dev/POLY.lua:1074)
- [AETHR.POLY:isWithinOffset()](../../dev/POLY.lua:1107)
- [AETHR.POLY:pointToSegmentSquared()](../../dev/POLY.lua:1149)
- [AETHR.POLY:getMidpoint()](../../dev/POLY.lua:1172)
- [AETHR.POLY:calculateLineSlope()](../../dev/POLY.lua:1189)
- [AETHR.POLY:findPerpendicularEndpoints()](../../dev/POLY.lua:1219)
- [AETHR.POLY:isIntersect()](../../dev/POLY.lua:1250)
- [AETHR.POLY:concaveHull()](../../dev/POLY.lua:1309)
- [AETHR.POLY:convexHull()](../../dev/POLY.lua:1461)
- [AETHR.POLY:intersectRayToBounds()](../../dev/POLY.lua:1492)
- [AETHR.POLY:densifyHullEdges()](../../dev/POLY.lua:1556)
- [AETHR.POLY:findOverlaidPolygonGaps()](../../dev/POLY.lua:1618)
- [AETHR.POLY:reorderSlaveToMaster()](../../dev/POLY.lua:1705)
- [AETHR.POLY:reverseVertOrder()](../../dev/POLY.lua:1762)
- [AETHR.POLY:getCenterPoint()](../../dev/POLY.lua:1779)
- [AETHR.POLY:getCentroidPoint()](../../dev/POLY.lua:1830)
- [AETHR.POLY:convertBoundsToPolygon()](../../dev/POLY.lua:1039)
- [AETHR.POLY:pointInCircle()](../../dev/POLY.lua:249)
- [AETHR.POLY:getRandomVec2inCircle()](../../dev/POLY.lua:276)
- [AETHR.POLY:getRandomVec2inPolygon()](../../dev/POLY.lua:343)

Documents and indices
- Master diagrams index: [docs/README.md](docs/README.md)
- ZONE_MANAGER: [docs/zone_manager/README.md](docs/zone_manager/README.md)
- WORLD: [docs/world/README.md](docs/world/README.md)

Core geometry relationships

```mermaid
flowchart LR
  PIP[pointInPolygon] --> POLYOV[polygonsOverlap]
  SEG[segmentsIntersect] --> POLYOV
  CPL[convertPolygonToLines] --> L2P[convertLinesToPolygon]
  DIV[dividePolygon] --> GRID[division grid]
  ENS[ensureConvexN] --> RAND[getRandomVec2inPolygon]
  P2S[pointToSegmentSquared] --> IOFF[isWithinOffset]
  ESP[getEquallySpacedPoints] --> IOFF
  DEN[densifyHullEdges] --> HULL[processed hull]
  CH[concaveHull] --> HULL
  CV[convexHull] -.-> HULL
  FOG[findOverlaidPolygonGaps] --> GAPS[gap polygons]
  CBB[convertBoundsToPolygon] --> DIV
```

Module interactions

```mermaid
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

Algorithm: pointInPolygon

```mermaid
flowchart TD
  S[Start] --> J[Set j = n]
  J --> L[Loop i from 1..n]
  L --> C[Edge crosses horizontal ray?]
  C -->|yes| T[Toggle inside flag]
  C -->|no| N[No change]
  T --> U[Set j = i]
  N --> U
  U --> L
  L -->|done| R[Return inside]
```

Algorithm: convertLinesToPolygon

```mermaid
flowchart TD
  ST[Start] --> TRY[Try each segment as start and orientation]
  TRY --> WALK[Walk segments by endpoint proximity]
  WALK --> FOUND[Found connecting segment?]
  FOUND -->|no| FAIL[Fail and try other start]
  FOUND -->|yes| APP[Append vertices and continue]
  APP --> CLOSED[End connects back to start?]
  CLOSED -->|yes| DEDUP[remove_duplicate_vertices]
  CLOSED -->|no| TRY
  DEDUP --> RET[Return ordered polygon]
```

Algorithm: densifyHullEdges

```mermaid
flowchart TD
  IN[hull and polygons] --> E[for each edge]
  E --> SAMP[getEquallySpacedPoints]
  SAMP --> SNAP[find nearest original segment]
  SNAP --> THR[distance within snapDistance?]
  THR -->|yes| INS[insert projected point]
  THR -->|no| INS2[insert sample point]
  INS --> NEXT[next edge]
  INS2 --> NEXT
  NEXT -->|done| OUT[new hull]
```

Algorithm: concaveHull with convex fallback

```mermaid
flowchart TD
  A[Start] --> K[Set k or concavity]
  K --> LOOP[Build hull by k-nearest]
  LOOP --> CROSS[crossing edges?]
  CROSS -->|yes| INC[increase k and retry]
  CROSS -->|no| VERIFY[all points inside?]
  VERIFY -->|yes| DONE[return hull]
  VERIFY -->|no| INC
  INC --> LOOP
  K --> FAIL[exceeds N-1]
  FAIL --> CH[convexHull]
```

Algorithm: dividePolygon into grid

```mermaid
flowchart LR
  TA[polygonArea] --> CNT[count cells]
  CNT --> AR[aspect ratio]
  AR --> RC[rows and cols]
  RC --> GEN[interpolate cell corners]
  GEN --> OUT[corners list per cell]
```

Key anchors
- Bounds conversion: [AETHR.POLY:convertBoundsToPolygon()](../../dev/POLY.lua:1039)
- Hull processing: [AETHR.POLY:concaveHull()](../../dev/POLY.lua:1309), [AETHR.POLY:convexHull()](../../dev/POLY.lua:1461), [AETHR.POLY:densifyHullEdges()](../../dev/POLY.lua:1556)
- Gap detection: [AETHR.POLY:findOverlaidPolygonGaps()](../../dev/POLY.lua:1618)
- Grid division: [AETHR.POLY:dividePolygon()](../../dev/POLY.lua:753)
- Distance helpers: [AETHR.POLY:pointToSegmentSquared()](../../dev/POLY.lua:1149), [AETHR.POLY:getEquallySpacedPoints()](../../dev/POLY.lua:1074), [AETHR.POLY:isWithinOffset()](../../dev/POLY.lua:1107)

Notes
- Mermaid labels avoid double quotes and parentheses.
- All diagrams use GitHub Mermaid fenced blocks.