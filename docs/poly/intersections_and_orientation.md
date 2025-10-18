# POLY intersections and orientation

Core line intersection routines and orientation helpers used across polygon processing.

# Source anchors
- [AETHR.POLY:segmentsIntersect()](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L44)
- [AETHR.POLY:orientation()](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L180)
- [AETHR.POLY:isIntersect()](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L1249)
- [AETHR.POLY:onLine()](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L1286)
- Reference orientation test: [AETHR.MATH:direction()](https://github.com/Gh0st352/AETHR/blob/main/dev/MATH_.lua#L96)

# Overview
- orientation returns the signed area determinant for three points
  - gt 0 counterclockwise, lt 0 clockwise, 0 colinear
- segmentsIntersect implements the classic general-case intersection test with colinear on-segment checks
- isIntersect is a line object variant using MATH:direction and onLine for robust handling
- onLine checks bounding box inclusion for a colinear point relative to a segment

# Orientation flow

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  IN[a b c] --> DET["(b minus a) cross (c minus a)"]
  DET --> S{sign}
  S -->|gt 0| CCW[counterclockwise]
  S -->|lt 0| CW[clockwise]
  S -->|eq 0| COL[colinear]

  subgraph "Evaluate"
    DET
    S
  end
  subgraph "Classify"
    CCW
    CW
    COL
  end

  class IN class_io;
  class DET class_compute;
  class S class_decision;
  class CCW,CW,COL class_result;
```

# segmentsIntersect flow

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  IN[p1 p2 q1 q2] --> O1[orientation p1 p2 q1]
  IN --> O2[orientation p1 p2 q2]
  IN --> O3[orientation q1 q2 p1]
  IN --> O4[orientation q1 q2 p2]

  O1 --> GEN{opposite signs?}
  O2 --> GEN
  O3 --> GEN
  O4 --> GEN
  GEN -->|yes| TRUE[true]

  O1 --> C1{o1 eq 0 and onSegment p1 q1 p2}
  O2 --> C2{o2 eq 0 and onSegment p1 q2 p2}
  O3 --> C3{o3 eq 0 and onSegment q1 p1 q2}
  O4 --> C4{o4 eq 0 and onSegment q1 p2 q2}
  C1 --> TRUE
  C2 --> TRUE
  C3 --> TRUE
  C4 --> TRUE

  TRUE --> OUT[return true]
  GEN -->|no| OUT2[return false]

  subgraph "Orientations"
    O1
    O2
    O3
    O4
  end
  subgraph "Colinear checks"
    C1
    C2
    C3
    C4
  end
  subgraph "Return"
    OUT
    OUT2
  end

  class IN class_io;
  class O1,O2,O3,O4 class_compute;
  class GEN,C1,C2,C3,C4 class_decision;
  class OUT,OUT2,TRUE class_result;
```

# isIntersect flow

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  IN[l1.p1 l1.p2 l2.p1 l2.p2] --> D1[direction l1.p1 l1.p2 l2.p1]
  IN --> D2[direction l1.p1 l1.p2 l2.p2]
  IN --> D3[direction l2.p1 l2.p2 l1.p1]
  IN --> D4[direction l2.p1 l2.p2 l1.p2]

  D1 --> GEN{d1 neq d2 and d3 neq d4}
  D2 --> GEN
  D3 --> GEN
  D4 --> GEN
  GEN -->|yes| TRUE[return true]

  D1 --> C1{d1 eq 0 and onLine l1 l2.p1}
  D2 --> C2{d2 eq 0 and onLine l1 l2.p2}
  D3 --> C3{d3 eq 0 and onLine l2 l1.p1}
  D4 --> C4{d4 eq 0 and onLine l2 l1.p2}
  C1 --> TRUE
  C2 --> TRUE
  C3 --> TRUE
  C4 --> TRUE

  GEN -->|no| OUT[return false]

  subgraph "Directions"
    D1
    D2
    D3
    D4
  end
  subgraph "Colinear on-line checks"
    C1
    C2
    C3
    C4
  end
  subgraph "Return"
    TRUE
    OUT
  end

  class IN class_io;
  class D1,D2,D3,D4 class_compute;
  class GEN,C1,C2,C3,C4 class_decision;
  class TRUE,OUT class_result;
```

# Sequence usage

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
sequenceDiagram
  participant P as POLY
  participant M as MATH
  P->>P: segmentsIntersect p1 p2 q1 q2
  P->>P: onSegment checks for colinear cases
  P->>P: orientation for determinant sign
  P->>M: direction for object based isIntersect
  M-->>P: 0 or 1 or 2
  P-->>P: boolean intersection result
```

# Implementation notes
- segmentsIntersect uses [AETHR.POLY:orientation()](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L180) and [AETHR.POLY:onSegment()](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L1286)
- isIntersect uses [AETHR.MATH:direction()](https://github.com/Gh0st352/AETHR/blob/main/dev/MATH_.lua#L96) and [AETHR.POLY:onLine()](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L1286)
- orientation normalizes points to {x,y} via [AETHR.POLY:normalizePoint()](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L236)

# Validation checklist
- segmentsIntersect: [dev/POLY.lua](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L44)
- orientation: [dev/POLY.lua](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L180)
- isIntersect: [dev/POLY.lua](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L1249)
- onLine: [dev/POLY.lua](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L1286)

# Related docs
- Distance and projections: [docs/poly/distance_projection_and_offset.md](./distance_projection_and_offset.md)
- Point in polygon: [docs/poly/point_in_polygon_and_overlap.md](./point_in_polygon_and_overlap.md)

# Conventions
- Mermaid fenced blocks use GitHub Mermaid parser
- Subgraph labels use double quotes per [docs/_mermaid/README.md](../_mermaid/README.md)
- Labels inside brackets avoid double quotes and parentheses
- Links use relative paths for repository portability