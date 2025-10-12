# MATH orientation

Cross product and orientation helpers used by geometry and intersection logic.

Source anchors
- [AETHR.MATH:crossProduct()](../../dev/MATH_.lua:29)
- [AETHR.MATH:direction()](../../dev/MATH_.lua:96)

Overview

- crossProduct returns the signed area determinant in 2D for three points
  - positive means counterclockwise
  - negative means clockwise
  - zero means colinear
- direction wraps the classic orientation test and maps the sign to codes
  - 0 collinear
  - 1 clockwise
  - 2 counterclockwise

Flow of orientation

```mermaid
flowchart TD
  P1[point p1] --> DET[crossProduct determinant]
  P2[point p2] --> DET
  P3[point p3] --> DET
  DET --> SIGN[sign of value]
  SIGN -->|gt 0| CCW[counterclockwise]
  SIGN -->|lt 0| CW[clockwise]
  SIGN -->|eq 0| COL[colinear]
```

direction return mapping

```mermaid
flowchart LR
  DET[crossProduct sign] -->|gt 0| OUT2[return 2]
  DET -->|lt 0| OUT1[return 1]
  DET -->|eq 0| OUT0[return 0]
```

Sequence of use in geometry

```mermaid
sequenceDiagram
  participant M as MATH
  participant P as POLY
  P->>M: crossProduct p1 p2 p3
  M-->>P: signed value
  P->>M: direction a b c
  M-->>P: 0 or 1 or 2
  P-->>P: branch in intersection or hull logic
```

Implementation notes

- Coordinate convention
  - crossProduct accepts tables with x and z or x and y
  - for each point z is preferred and y is used as fallback
  - implementation computes determinant using x and z or y mapping
- Numerical stability
  - Very small magnitudes are not explicitly epsilon clamped in direction
  - If robust colinearity is needed, consider pre scaling or using an epsilon compare on the returned crossProduct value
- Return codes
  - direction returns integer codes instead of boolean flags to simplify branching
  - 0 collinear, 1 clockwise, 2 counterclockwise

Mermaid sketches

- Orientation decision

```mermaid
flowchart TD
  A[p1 p2 p3] --> CP[crossProduct]
  CP --> S[sign test]
  S --> C0[colinear]
  S --> C1[clockwise]
  S --> C2[counterclockwise]
```

- Integration point with polygon intersection

```mermaid
flowchart TD
  SEG[segment pairs] --> ORI[direction at endpoints]
  ORI --> BR[branch for general case and special colinear case]
  BR --> RES[intersection decision]
```

Validation checklist

- cross product anchor: [dev/MATH_.lua](../../dev/MATH_.lua:29)
- direction anchor: [dev/MATH_.lua](../../dev/MATH_.lua:96)

Related docs

- POLY overview and geometry flows: [docs/poly/README.md](../poly/README.md)

Conventions

- Mermaid fenced blocks use GitHub Mermaid parser
- Labels inside brackets avoid double quotes and parentheses
- Links use relative paths for repository portability