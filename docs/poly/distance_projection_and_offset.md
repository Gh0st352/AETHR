# POLY distance, projection, and offset

Squared distance to segment, dot based projection, interior sampling along segments, and approximate line offset checks.

Source anchors
- [AETHR.POLY:lineLength()](../../dev/POLY.lua:1056)
- [AETHR.POLY:getEquallySpacedPoints()](../../dev/POLY.lua:1074)
- [AETHR.POLY:isWithinOffset()](../../dev/POLY.lua:1106)
- [AETHR.POLY:pointToSegmentSquared()](../../dev/POLY.lua:1148)
- Related MATH: [AETHR.MATH:distanceSquared()](../../dev/MATH_.lua:58), [AETHR.MATH:dot()](../../dev/MATH_.lua:75), [AETHR.MATH:computeRatio()](../../dev/MATH_.lua:43)

# Overview
- lineLength returns Euclidean length of a segment
- getEquallySpacedPoints returns interior samples at equal parametric spacing
- pointToSegmentSquared computes squared distance from a point to the closest point on a segment using projection and clamping
- isWithinOffset tests if two segments are approximately within a given offset by sampling and counting confirmations scaled by a ratio of lengths

# pointToSegmentSquared flow

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  IN[px py ax ay bx by] --> L2[l2 distanceSquared a b]
  L2 --> S{l2 eq 0}
  S -->|yes| RET0[return distanceSquared p a]
  S -->|no| T[param t dot over l2]
  T --> CLAMP[t clamp 0..1]
  CLAMP --> PROJ[projection ax plus t times ab]
  PROJ --> RET[return distanceSquared p proj]

  subgraph "Degenerate"
    S
    RET0
  end
  subgraph "Projection"
    T
    CLAMP
    PROJ
  end

  class IN class_io;
  class L2 class_compute;
  class S class_decision;
  class T,CLAMP,PROJ class_step;
  class RET0,RET class_result;
```

# getEquallySpacedPoints flow

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  IN[line P1 P2 N] --> LOOP[i 1..N]
  LOOP --> T[t i over N plus 1]
  T --> LERP[lerp x y at t]
  LERP --> PUSH[push point]
  PUSH --> LOOP
  LOOP -->|done| OUT[return points]

  subgraph "Loop"
    LOOP
    T
    LERP
    PUSH
  end

  class IN class_io;
  class LOOP,T,LERP,PUSH class_step;
  class OUT class_result;
```

# isWithinOffset flow

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  IN[LineA LineB Offset] --> N[DesiredPoints 11]
  N --> LEN[lineLength of A and B]
  LEN --> R[ratio computeRatio lenA lenB]
  R --> TH[threshold N times ratio]
  TH --> CHECKA[check points A vs B]
  TH --> CHECKB[check points B vs A]
  CHECKA --> RESA[ticker reaches threshold]
  CHECKB --> RESB[ticker reaches threshold]
  RESA --> ANY[true if either direction true]
  RESB --> ANY
  ANY --> OUT[return boolean]

  subgraph "Prepare"
    N
    LEN
    R
    TH
  end
  subgraph "Check A"
    CHECKA
    RESA
  end
  subgraph "Check B"
    CHECKB
    RESB
  end

  class IN class_io;
  class N,LEN,R,TH,CHECKA,CHECKB class_step;
  class RESA,RESB class_decision;
  class ANY,OUT class_result;
```

# Sequence usage

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
sequenceDiagram
  participant Z as ZONE_MANAGER
  participant P as POLY
  participant M as MATH
  Z->>P: isWithinOffset LineA LineB Offset
  P->>P: getEquallySpacedPoints line
  P->>P: pointToSegmentSquared for each sample
  P->>M: computeRatio lenA lenB
  M-->>P: ratio 0..1
  P-->>Z: boolean within offset
```

# Implementation notes
- pointToSegmentSquared uses projection parameter t = dot(pa, ba) over l2 and clamps to the closed segment
- isWithinOffset sampling density and the ratio threshold control sensitivity; confirmation counts scale with relative lengths
- lineLength is only used to compute the ratio driver for confirmation threshold in isWithinOffset

# Validation checklist
- lineLength: [dev/POLY.lua](../../dev/POLY.lua:1056)
- getEquallySpacedPoints: [dev/POLY.lua](../../dev/POLY.lua:1074)
- isWithinOffset: [dev/POLY.lua](../../dev/POLY.lua:1106)
- pointToSegmentSquared: [dev/POLY.lua](../../dev/POLY.lua:1148)

# Related docs
- Intersections and orientation: [docs/poly/intersections_and_orientation.md](./intersections_and_orientation.md)
- Point-in-polygon and overlaps: [docs/poly/point_in_polygon_and_overlap.md](./point_in_polygon_and_overlap.md)

# Conventions
- Mermaid fenced blocks use GitHub Mermaid parser
- Labels inside brackets avoid double quotes and parentheses
- Links use relative paths for repository portability