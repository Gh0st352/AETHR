# MATH angles

Degree to radian conversion and relation to turn angle normalization.

Source anchors
- [AETHR.MATH:degreeToRadian()](../../dev/MATH_.lua:252)
- Reference for wrap logic: [AETHR.MATH:turnAngle()](../../dev/MATH_.lua:142)

Overview

- degreeToRadian converts a degree value to radians with input coercion and clamping to 0..360
- turnAngle returns a positive normalized angle in 0..2pi via wrapping steps after atan2 differences

degreeToRadian flow

```mermaid
flowchart TD
  IN[degrees any] --> NUM[tonumber or 0]
  NUM --> CL1[if lt 0 set 0]
  CL1 --> CL2[if gt 360 set 360]
  CL2 --> RAD[return math rad degrees]
```

Relation to turnAngle

```mermaid
flowchart TD
  SEG[segments prev to cur and cur to cand] --> A1[atan2 of v1]
  SEG --> A2[atan2 of v2]
  A1 --> D[delta a2 minus a1]
  A2 --> D
  D --> WR1[wrap if d le minus pi add 2pi]
  WR1 --> WR2[wrap if d gt pi sub 2pi]
  WR2 --> WR3[wrap if d lt 0 add 2pi]
  WR3 --> OUT[return 0..2pi]
```

Sequence usage

```mermaid
sequenceDiagram
  participant U as User code
  participant M as MATH
  U->>M: degreeToRadian deg
  M-->>U: rad
  U->>M: turnAngle prev cur cand
  M-->>U: normalized angle 0..2pi
```

Implementation notes

- degreeToRadian
  - Coerces arbitrary input to number and defaults to 0 when invalid
  - Clamps to 0..360 range before applying math rad
- turnAngle
  - Normalizes delta of direction angles to a positive range using three wrap conditions
  - Produces angles suitable for ordering and sweep decisions

Validation checklist

- degreeToRadian: [dev/MATH_.lua](../../dev/MATH_.lua:252)
- turnAngle reference: [dev/MATH_.lua](../../dev/MATH_.lua:142)

Related docs

- Vectors and angle delta: [docs/math/vectors.md](./vectors.md)
- Orientation helpers: [docs/math/orientation.md](./orientation.md)

Conventions

- Mermaid fenced blocks use GitHub Mermaid parser
- Labels inside brackets avoid double quotes and parentheses
- Links use relative paths for repository portability