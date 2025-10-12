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

distanceSquared flow

```mermaid
flowchart TD
  IN[ax ay bx by] --> DX[dx ax minus bx]
  IN --> DY[dy ay minus by]
  DX --> SQ[dx times dx]
  DY --> SQY[dy times dy]
  SQ --> SUM[return dx2 plus dy2]
  SQY --> SUM
```

dot flow

```mermaid
flowchart TD
  IN[ax ay bx by] --> MULX[ax times bx]
  IN --> MULY[ay times by]
  MULX --> SUM[return mulx plus muly]
  MULY --> SUM
```

turnAngle flow

```mermaid
flowchart TD
  IN[prev cur cand] --> V1[v1 cur minus prev]
  IN --> V2[v2 cand minus cur]
  V1 --> A1[a1 atan2 v1]
  V2 --> A2[a2 atan2 v2]
  A1 --> D[d a2 minus a1]
  A2 --> D
  D --> N1[if d le minus pi add 2pi]
  N1 --> N2[if d gt pi sub 2pi]
  N2 --> N3[if d lt 0 add 2pi]
  N3 --> OUT[return d]
```

Sequence usage in POLY

```mermaid
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

Implementation notes

- distanceSquared avoids sqrt for ordering comparisons and threshold checks
- dot is used for projections, angle tests, and segment relations
- turnAngle normalization
  - compute raw difference a2 minus a1
  - wrap to minus pi to pi
  - if negative add full turn to get 0..2pi

Validation checklist

- distanceSquared: [dev/MATH_.lua](../../dev/MATH_.lua:58)
- dot: [dev/MATH_.lua](../../dev/MATH_.lua:75)
- turnAngle: [dev/MATH_.lua](../../dev/MATH_.lua:142)

Related docs

- Orientation helpers: [docs/math/orientation.md](./orientation.md)
- POLY consumers: [docs/poly/README.md](../poly/README.md)

Conventions

- Mermaid fenced blocks use GitHub Mermaid parser
- Labels inside brackets avoid double quotes and parentheses
- Links use relative paths for repository portability
## Ratio helper computeRatio

Anchor
- [AETHR.MATH:computeRatio()](../../dev/MATH_.lua:43)

Purpose
- Returns a normalized ratio in 0..1 between two magnitudes, guarding zero
- Used by POLY offset checks to scale confirmation thresholds by line length similarity

Flow

```mermaid
flowchart TD
  IN[A and B] --> Z{A eq 0 or B eq 0}
  Z -->|yes| R0[return 0]
  Z -->|no| CMP{A gt B}
  CMP -->|yes| R1[return B over A]
  CMP -->|no| R2[return A over B]
```

Sequence usage in POLY isWithinOffset

```mermaid
sequenceDiagram
  participant P as POLY
  participant M as MATH
  P->>M: computeRatio lineLength A lineLength B
  M-->>P: ratio 0..1
  P-->>P: threshold DesiredPoints times ratio
```

Validation checklist
- computeRatio: [dev/MATH_.lua](../../dev/MATH_.lua:43)
- isWithinOffset usage: [dev/POLY.lua](../../dev/POLY.lua:1109)