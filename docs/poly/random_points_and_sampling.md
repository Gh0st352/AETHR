# POLY random points and sampling

Point in circle tests, uniform sampling in a circle and polygon, and triangle utilities for area-weighted sampling.

# Source anchors
- [AETHR.POLY:pointInCircle()](../../dev/POLY.lua:248)
- [AETHR.POLY:getRandomVec2inCircle()](../../dev/POLY.lua:276)
- [AETHR.POLY:triSample()](../../dev/POLY.lua:308)
- [AETHR.POLY:triAreaAbs()](../../dev/POLY.lua:320)
- [AETHR.POLY:pointInTriangle()](../../dev/POLY.lua:329)
- [AETHR.POLY:getRandomVec2inPolygon()](../../dev/POLY.lua:343)
- Helpers: [AETHR.POLY:normalizePoint()](../../dev/POLY.lua:236), [AETHR.MATH:distanceSquared()](../../dev/MATH_.lua:58)

# Overview
- pointInCircle checks membership using squared distance to avoid sqrt
- getRandomVec2inCircle returns uniform samples in a disk or annulus via r^2 uniform then sqrt
- getRandomVec2inPolygon uses convexity fixing with ensureConvexN, then ear clipping to triangulate, then area-weighted triangle selection, then barycentric sampling via triSample; includes robust fallbacks
- pointInTriangle tests using sign of orientation relative to triangle edges with an epsilon

# pointInCircle flow

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  IN[vec2 center radius] --> VAL[validate inputs]
  VAL --> NORM[normalize p and c to x y]
  NORM --> D2[compute distanceSquared p c]
  D2 --> CMP[compare to r squared]
  CMP --> OUT[return d2 le r2]

  subgraph "Validate"
    VAL
  end
  subgraph "Compute"
    NORM
    D2
    CMP
  end
  subgraph "Return"
    OUT
  end

  class IN class_io;
  class VAL,NORM,D2,CMP class_step;
  class OUT class_result;
```

# getRandomVec2inCircle flow

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  IN[R center minRadius opt] --> EDGE[R le 0]
  EDGE -->|yes| RETC[return normalized center]
  EDGE -->|no| C[norm center to x y]
  C --> CLAMP[clamp inner radius to 0..R]
  CLAMP --> U[uniform u in 0..1]
  U --> RAD["r sqrt(r0^2 plus u (R^2 minus r0^2))"]
  RAD --> ANG[theta 2 pi random]
  ANG --> XY[x y from r theta]
  XY --> OUT[return sample point]

  subgraph "Validate"
    EDGE
    C
    CLAMP
  end
  subgraph "Sample radius/angle"
    U
    RAD
    ANG
  end
  subgraph "Construct"
    XY
    RETC
    OUT
  end

  class IN class_io;
  class EDGE,C,CLAMP,U,RAD,ANG,XY class_step;
  class RETC,OUT class_result;
  class EDGE class_decision;
```

# Ear clipping and area-weighted sampling in polygon

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  IN[vertices] --> TRIV[handle 0 1 2 cases]
  TRIV -->|0| Z0[return 0 0]
  TRIV -->|1| Z1[return normalized vertex]
  TRIV -->|2| MID[midpoint]
  TRIV --> NORM[norm all to x y]
  NORM --> ORDER[ensureConvexN]
  ORDER --> NCHK[n lt 3]
  NCHK -->|yes| CTR[getCenterPoint]
  NCHK -->|no| EARS[ear clipping loop]
  EARS --> TRI[list of triangles]
  TRI --> AREA[compute tri areas and sum]
  AREA --> PICK[pick random triangle by cumulative area]
  PICK --> SAMPLE[triSample inside triangle]
  SAMPLE --> RET[return point]
  EARS -->|none built| REJ[rejection in AABB then PIP test]
  REJ --> RET2[return candidate or center fallback]

  subgraph "Trivial cases"
    Z0
    Z1
    MID
  end
  subgraph "Normalize and order"
    NORM
    ORDER
  end
  subgraph "Triangulate"
    EARS
    TRI
  end
  subgraph "Area-weighted choice"
    AREA
    PICK
    SAMPLE
  end
  subgraph "Return"
    CTR
    RET
    REJ
    RET2
  end

  class IN class_io;
  class TRIV,NORM,ORDER,NCHK,EARS,TRI,AREA,PICK,SAMPLE,REJ,CTR class_step;
  class RET,RET2,Z0,Z1,MID class_result;
  class NCHK class_decision;
```

# pointInTriangle flow

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  IN[p a b c] --> ORI1[orientation a b p]
  IN --> ORI2[orientation b c p]
  IN --> ORI3[orientation c a p]
  ORI1 --> SIGN[sign mix with eps]
  ORI2 --> SIGN
  ORI3 --> SIGN
  SIGN --> RES[not both positive and negative]
  RES --> OUT[inside or on edge]

  subgraph "Orientations"
    ORI1
    ORI2
    ORI3
  end
  subgraph "Evaluate"
    SIGN
    RES
  end
  subgraph "Return"
    OUT
  end

  class IN class_io;
  class ORI1,ORI2,ORI3,SIGN,RES class_step;
  class OUT class_result;
```

# Sequence usage

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
sequenceDiagram
  participant Z as ZONE_MANAGER
  participant P as POLY
  Z->>P: getRandomVec2inPolygon vertices
  P-->>Z: uniformly distributed interior sample
  Z->>P: getRandomVec2inCircle R center r0
  P-->>Z: uniform disk or annulus sample
  Z->>P: pointInCircle p c R
  P-->>Z: boolean
```

# Implementation notes
- getRandomVec2inPolygon
  - Normalizes coordinates to x y and attempts to fix ordering with [AETHR.POLY:ensureConvexN()](../../dev/POLY.lua:863)
  - Triangulation via ear clipping uses convexity and interior point checks with [AETHR.POLY:pointInTriangle()](../../dev/POLY.lua:329)
  - Triangle selection is proportional to area using a single random in summed area space; sampling within a triangle uses [AETHR.POLY:triSample()](../../dev/POLY.lua:308)
  - If triangulation fails or total area is zero, uses AABB rejection or centers as fallbacks via [AETHR.POLY:getCenterPoint()](../../dev/POLY.lua:1779)
- Stability
  - pointInTriangle uses a small epsilon to be robust to nearly colinear edges
  - Barycentric sampling triSample reflects across diagonal when u plus v greater than 1 to keep uniform

# Validation checklist
- pointInCircle: [dev/POLY.lua](../../dev/POLY.lua:248)
- getRandomVec2inCircle: [dev/POLY.lua](../../dev/POLY.lua:276)
- triSample: [dev/POLY.lua](../../dev/POLY.lua:308)
- triAreaAbs: [dev/POLY.lua](../../dev/POLY.lua:320)
- pointInTriangle: [dev/POLY.lua](../../dev/POLY.lua:329)
- getRandomVec2inPolygon: [dev/POLY.lua](../../dev/POLY.lua:343)

# Related docs
- Intersections and orientation: [docs/poly/intersections_and_orientation.md](./intersections_and_orientation.md)
- Bounds and divisions: [docs/poly/bounds_and_divisions.md](./bounds_and_divisions.md)

# Conventions
- Mermaid fenced blocks use GitHub Mermaid parser
- Subgraph labels use double quotes per [docs/_mermaid/README.md](../_mermaid/README.md)
- Labels inside brackets avoid double quotes and parentheses
- Links use relative paths for repository portability