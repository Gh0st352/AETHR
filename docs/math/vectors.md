# MATH vectors

Distance, dot product, and turn angle helpers used by geometry flows.

Source anchors
- [AETHR.MATH:distanceSquared()](../../dev/MATH_.lua:58)
- [AETHR.MATH:dot()](../../dev/MATH_.lua:75)
- [AETHR.MATH:turnAngle()](../../dev/MATH_.lua:142)

Overview

- distanceSquared computes squared Euclidean distance without square root
- dot computes scalar projection magnitude between two vectors
- turnAngle returns a positive normalized angle from segment prev to cur to candidate cand in radians 0 to 2 pi

# distanceSquared flow

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  subgraph "Inputs"
    IN[ax ay bx by]
  end
  subgraph "Delta"
    DX[dx ax minus bx]
    DY[dy ay minus by]
  end
  subgraph "Squares and sum"
    SQ[dx times dx]
    SQY[dy times dy]
    SUM[return dx2 plus dy2]
  end
  IN --> DX
  IN --> DY
  DX --> SQ
  DY --> SQY
  SQ --> SUM
  SQY --> SUM
  class IN class_io;
  class DX,DY,SQ,SQY class_compute;
  class SUM class_result;
```

# dot flow

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  subgraph "Inputs"
    IN[ax ay bx by]
  end
  IN --> MULX[ax times bx]
  IN --> MULY[ay times by]
  MULX --> SUM[return mulx plus muly]
  MULY --> SUM
  class IN class_io;
  class MULX,MULY class_compute;
  class SUM class_result;
```

# turnAngle flow

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  subgraph "Vectors"
    IN[prev cur cand]
    V1[v1 cur minus prev]
    V2[v2 cand minus cur]
  end
  subgraph "Angles"
    A1[a1 atan2 v1]
    A2[a2 atan2 v2]
  end
  subgraph "Delta and wraps"
    D[d a2 minus a1]
    N1[if d le minus pi add 2pi]
    N2[if d gt pi sub 2pi]
    N3[if d lt 0 add 2pi]
  end
  IN --> V1
  IN --> V2
  V1 --> A1
  V2 --> A2
  A1 --> D
  A2 --> D
  D --> N1
  N1 --> N2
  N2 --> N3
  N3 --> OUT[return d]
  class IN class_io;
  class V1,V2,A1,A2 class_compute;
  class D,N1,N2,N3 class_step;
  class OUT class_result;
```

# Sequence usage in POLY

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
sequenceDiagram
  participant P as POLY
  participant M as MATH
  P->>M: distanceSquared ax ay bx by
  M-->>P: dx2 plus dy2
  P->>M: dot ax ay bx by
  M-->>P: scalar value
  P->>M: turnAngle prev cur cand
  M-->>P: angle 0..2pi
```

# Implementation notes

- distanceSquared avoids sqrt for ordering comparisons and threshold checks
- dot is used for projections, angle tests, and segment relations
- turnAngle normalization
  - compute raw difference a2 minus a1
  - wrap to minus pi to pi
  - if negative add full turn to get 0..2pi

# Validation checklist

- distanceSquared: [dev/MATH_.lua](../../dev/MATH_.lua:58)
- dot: [dev/MATH_.lua](../../dev/MATH_.lua:75)
- turnAngle: [dev/MATH_.lua](../../dev/MATH_.lua:142)

# Related docs

- Orientation helpers: [docs/math/orientation.md](./orientation.md)
- POLY consumers: [docs/poly/README.md](../poly/README.md)

# Conventions

- Mermaid fenced blocks use GitHub Mermaid parser
- Labels inside brackets avoid double quotes and parentheses
- Links use relative paths for repository portability
## Ratio helper computeRatio

Anchor
- [AETHR.MATH:computeRatio()](../../dev/MATH_.lua:43)

Purpose
- Returns a normalized ratio in 0..1 between two magnitudes, guarding zero
- Used by POLY offset checks to scale confirmation thresholds by line length similarity

# Flow

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  subgraph "Inputs"
    IN[A and B]
  end
  IN --> Z{A eq 0 or B eq 0}
  Z -->|yes| R0[return 0]
  Z -->|no| CMP{A gt B}
  CMP -->|yes| R1[return B over A]
  CMP -->|no| R2[return A over B]
  class IN class_io;
  class Z,CMP class_decision;
  class R0,R1,R2 class_result;
```

# Sequence usage in POLY isWithinOffset

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
sequenceDiagram
  participant P as POLY
  participant M as MATH
  P->>M: computeRatio lineLength A lineLength B
  M-->>P: ratio 0..1
  P-->>P: threshold DesiredPoints times ratio
```

# Validation checklist
- computeRatio: [dev/MATH_.lua](../../dev/MATH_.lua:43)
- isWithinOffset usage: [dev/POLY.lua](../../dev/POLY.lua:1109)