# POLY point in polygon and overlap

Ray casting point-in-polygon, polygon overlap, and circle vs polygon overlap checks.

# Source anchors
- [AETHR.POLY:pointInPolygon()](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L66)
- [AETHR.POLY:polygonsOverlap()](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L92)
- [AETHR.POLY:circleOverlapPoly()](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L120)
- Helpers referenced: [AETHR.POLY:normalizePoint()](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L236), [AETHR.POLY:segmentsIntersect()](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L44), [AETHR.POLY:pointToSegmentSquared()](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L1148)

# Overview
- pointInPolygon uses horizontal ray casting toggling an inside flag on each edge crossing
- polygonsOverlap checks either polygon having a vertex inside the other, else any edge pair intersection
- circleOverlapPoly handles single vertex, segment, interior center, vertex within radius, and edge proximity via point to segment distance

# pointInPolygon flow

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
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

  subgraph "Iteration"
    LOOP
    EDGE
    CROSS
    TOG
    KEEP
    ADV
    NEXT
  end

  class IN class_io;
  class INIT,LOOP,EDGE,TOG,KEEP,ADV,NEXT class_step;
  class CROSS class_decision;
  class OUT class_result;
```

# polygonsOverlap flow

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  IN[A and B arrays] --> VA[any A vertex in B]
  VA -->|yes| TRUE[return true]
  VA -->|no| VB[any B vertex in A]
  VB -->|yes| TRUE
  VB -->|no| EDGES[check all edge pairs]
  EDGES --> SINT[segmentsIntersect any]
  SINT -->|yes| TRUE
  SINT -->|no| FALSE[return false]

  subgraph "Vertex checks"
    VA
    VB
  end
  subgraph "Edge checks"
    EDGES
    SINT
  end
  subgraph "Return"
    TRUE
    FALSE
  end

  class IN class_io;
  class VA,VB,EDGES class_step;
  class SINT class_decision;
  class TRUE,FALSE class_result;
```

# circleOverlapPoly flow

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
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

  subgraph "Validate"
    VALID
  end
  subgraph "Degenerate"
    N1
    DEC1
    N2
    DEC2
  end
  subgraph "Interior/vertices"
    INP
    VERTS
  end
  subgraph "Edges"
    EDGES
  end
  subgraph "Return"
    TRUE
    FALSE
  end

  class IN class_io;
  class VALID,N1,N2,INP,VERTS class_step;
  class DEC1,DEC2,EDGES class_decision;
  class TRUE,FALSE class_result;
```

# Sequence usage

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
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

# Implementation notes
- pointInPolygon supports points using y or z as vertical coordinate; y is preferred when present
- polygonsOverlap uses [AETHR.POLY:segmentsIntersect()](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L44) for edge checks after vertex tests
- circleOverlapPoly
  - Uses [AETHR.POLY:normalizePoint()](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L236) for consistent xy handling
  - Distance to edges uses [AETHR.POLY:pointToSegmentSquared()](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L1148)
  - Early returns for degenerate polygons with n equals 1 and n equals 2

# Validation checklist
- pointInPolygon: [dev/POLY.lua](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L66)
- polygonsOverlap: [dev/POLY.lua](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L92)
- circleOverlapPoly: [dev/POLY.lua](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L120)

# Related docs
- Intersections and orientation: [docs/poly/intersections_and_orientation.md](./intersections_and_orientation.md)
- Distance and offset helpers: [docs/poly/distance_projection_and_offset.md](./distance_projection_and_offset.md)

# Conventions
- Mermaid fenced blocks use GitHub Mermaid parser
- Subgraph labels use double quotes per [docs/_mermaid/README.md](../_mermaid/README.md)
- Labels inside brackets avoid double quotes and parentheses
- Links use relative paths for repository portability