# MATH orientation

Cross product and orientation helpers used by geometry and intersection logic.

Source anchors
- [AETHR.MATH:crossProduct()](../../dev/MATH_.lua:29)
- [AETHR.MATH:direction()](../../dev/MATH_.lua:96)

# Overview

- crossProduct returns the signed area determinant in 2D for three points
  - positive means counterclockwise
  - negative means clockwise
  - zero means colinear
- direction wraps the classic orientation test and maps the sign to codes
  - 0 collinear
  - 1 clockwise
  - 2 counterclockwise

# Flow of orientation

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  subgraph "Inputs"
    P1[point p1]
    P2[point p2]
    P3[point p3]
  end
  P1 --> DET[crossProduct determinant]
  P2 --> DET
  P3 --> DET
  DET --> SIGN[sign of value]
  SIGN -->|gt 0| CCW[counterclockwise]
  SIGN -->|lt 0| CW[clockwise]
  SIGN -->|eq 0| COL[colinear]
  class P1,P2,P3 class_io;
  class DET class_compute;
  class SIGN class_decision;
  class CCW,CW,COL class_result;
```

# direction return mapping

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart LR
  subgraph "Return mapping"
    DET[crossProduct sign]
    OUT2[return 2]
    OUT1[return 1]
    OUT0[return 0]
  end
  DET -->|gt 0| OUT2
  DET -->|lt 0| OUT1
  DET -->|eq 0| OUT0
  class DET class_compute;
  class OUT2,OUT1,OUT0 class_result;
```

# Sequence of use in geometry

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
sequenceDiagram
  participant M as MATH
  participant P as POLY
  P->>M: crossProduct p1 p2 p3
  M-->>P: signed value
  P->>M: direction a b c
  M-->>P: 0 or 1 or 2
  P-->>P: branch in intersection or hull logic
```

# Implementation notes

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

# Mermaid sketches

## - Orientation decision

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  subgraph "Orientation decision"
    A[p1 p2 p3]
    CP[crossProduct]
    S[sign test]
  end
  A --> CP
  CP --> S
  S --> C0[colinear]
  S --> C1[clockwise]
  S --> C2[counterclockwise]
  class A class_io;
  class CP class_compute;
  class S class_decision;
  class C0,C1,C2 class_result;
```

## - Integration point with polygon intersection

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  subgraph "Segments"
    SEG[segment pairs]
  end
  subgraph "Orientation"
    ORI[direction at endpoints]
  end
  subgraph "Branching"
    BR[branch for general case and special colinear case]
    RES[intersection decision]
  end
  SEG --> ORI
  ORI --> BR
  BR --> RES
  class SEG class_io;
  class ORI class_compute;
  class BR class_decision;
  class RES class_result;
```

# Validation checklist

- cross product anchor: [dev/MATH_.lua](../../dev/MATH_.lua:29)
- direction anchor: [dev/MATH_.lua](../../dev/MATH_.lua:96)

# Related docs

- POLY overview and geometry flows: [docs/poly/README.md](../poly/README.md)

# Conventions

- Mermaid fenced blocks use GitHub Mermaid parser
- Labels inside brackets avoid double quotes and parentheses
- Links use relative paths for repository portability