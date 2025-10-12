# POLY point in polygon and overlap

Ray casting point-in-polygon, polygon overlap, and circle vs polygon overlap checks.

Source anchors
- [AETHR.POLY:pointInPolygon()](../../dev/POLY.lua:66)
- [AETHR.POLY:polygonsOverlap()](../../dev/POLY.lua:92)
- [AETHR.POLY:circleOverlapPoly()](../../dev/POLY.lua:120)
- Helpers referenced: [AETHR.POLY:normalizePoint()](../../dev/POLY.lua:236), [AETHR.POLY:segmentsIntersect()](../../dev/POLY.lua:44), [AETHR.POLY:pointToSegmentSquared()](../../dev/POLY.lua:1148)

Overview
- pointInPolygon uses horizontal ray casting toggling an inside flag on each edge crossing
- polygonsOverlap checks either polygon having a vertex inside the other, else any edge pair intersection
- circleOverlapPoly handles single vertex, segment, interior center, vertex within radius, and edge proximity via point to segment distance

pointInPolygon flow

```mermaid
flowchart TD
  IN[pt and poly] --> INIT[inside false set j n]
  INIT --> LOOP[for each i 1..n]
  LOOP --> EDGE[edge i and j endpoints]
  EDGE --> CROSS[ray crosses edge]
  CROSS -->|yes| TOG[toggle inside]
  CROSS -->|no| KEEP[no change]
  TOG --> ADV[j set i]
  KEEP --> ADV
  ADV --> NEXT[next i]
  NEXT -->|done| OUT[return inside]
```

polygonsOverlap flow

```mermaid
flowchart TD
  IN[A and B arrays] --> VA[any A vertex in B]
  VA -->|yes| TRUE[return true]
  VA -->|no| VB[any B vertex in A]
  VB -->|yes| TRUE
  VB -->|no| EDGES[check all edge pairs]
  EDGES --> SINT[segmentsIntersect any]
  SINT -->|yes| TRUE
  SINT -->|no| FALSE[return false]
```

circleOverlapPoly flow

```mermaid
flowchart TD
  IN[radius center polygon] --> VALID[validate and normalize]
  VALID --> N1[n equals 1 check vertex distance]
  N1 --> DEC1[within r2]
  VALID --> N2[n equals 2 check point to segment]
  N2 --> DEC2[within r2]
  VALID --> INP[center inside polygon]
  INP -->|yes| TRUE[return true]
  VALID --> VERTS[any vertex within radius]
  VERTS -->|yes| TRUE
  VALID --> EDGES[edge distance check]
  EDGES -->|any le r2| TRUE
  EDGES -->|none| FALSE[return false]
```

Sequence usage

```mermaid
sequenceDiagram
  participant Z as ZONE_MANAGER
  participant P as POLY
  Z->>P: pointInPolygon pt poly
  P-->>Z: boolean inside
  Z->>P: polygonsOverlap A B
  P-->>Z: boolean overlap
  Z->>P: circleOverlapPoly r center B
  P-->>Z: boolean overlap
```

Implementation notes
- pointInPolygon supports points using y or z as vertical coordinate; y is preferred when present
- polygonsOverlap uses [AETHR.POLY:segmentsIntersect()](../../dev/POLY.lua:44) for edge checks after vertex tests
- circleOverlapPoly
  - Uses [AETHR.POLY:normalizePoint()](../../dev/POLY.lua:236) for consistent xy handling
  - Distance to edges uses [AETHR.POLY:pointToSegmentSquared()](../../dev/POLY.lua:1148)
  - Early returns for degenerate polygons with n equals 1 and n equals 2

Validation checklist
- pointInPolygon: [dev/POLY.lua](../../dev/POLY.lua:66)
- polygonsOverlap: [dev/POLY.lua](../../dev/POLY.lua:92)
- circleOverlapPoly: [dev/POLY.lua](../../dev/POLY.lua:120)

Related docs
- Intersections and orientation: [docs/poly/intersections_and_orientation.md](./intersections_and_orientation.md)
- Distance and offset helpers: [docs/poly/distance_projection_and_offset.md](./distance_projection_and_offset.md)

Conventions
- Mermaid fenced blocks use GitHub Mermaid parser
- Labels inside brackets avoid double quotes and parentheses
- Links use relative paths for repository portability