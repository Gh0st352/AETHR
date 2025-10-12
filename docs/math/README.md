# AETHR MATH diagrams and flows

Primary anchors
- [AETHR.MATH:crossProduct()](../../dev/MATH_.lua:29)
- [AETHR.MATH:computeRatio()](../../dev/MATH_.lua:43)
- [AETHR.MATH:distanceSquared()](../../dev/MATH_.lua:58)
- [AETHR.MATH:dot()](../../dev/MATH_.lua:75)
- [AETHR.MATH:direction()](../../dev/MATH_.lua:96)
- [AETHR.MATH:almostEqual()](../../dev/MATH_.lua:118)
- [AETHR.MATH:pointsEqual()](../../dev/MATH_.lua:129)
- [AETHR.MATH:turnAngle()](../../dev/MATH_.lua:142)
- [AETHR.MATH:centroid()](../../dev/MATH_.lua:157)
- [AETHR.MATH:generateNominal()](../../dev/MATH_.lua:181)
- [AETHR.MATH:randomDecimalBetween()](../../dev/MATH_.lua:215)
- [AETHR.MATH:generateNudge()](../../dev/MATH_.lua:233)
- [AETHR.MATH:degreeToRadian()](../../dev/MATH_.lua:252)

Breakout documents
- Orientation: [docs/math/orientation.md](orientation.md)
- Vectors and angles: [docs/math/vectors.md](vectors.md)
- Equality and centroid: [docs/math/equality_and_centroid.md](equality_and_centroid.md)
- Randomization helpers: [docs/math/randomization.md](randomization.md)
- Degree and turn angle notes: [docs/math/angles.md](angles.md)

Documents and indices
- Master diagrams index: [docs/README.md](../README.md)
- POLY: [docs/poly/README.md](../poly/README.md)
- SPAWNER: [docs/spawner/README.md](../spawner/README.md)
- ZONE_MANAGER: [docs/zone_manager/README.md](../zone_manager/README.md)

Overview relationships

```mermaid
flowchart LR
  DS[distanceSquared] --> P2S[pointToSegmentSquared in POLY]
  DOT[dot] --> P2S
  CP[crossProduct] --> ORI[orientation in POLY]
  DIR[direction] --> INT[isIntersect in POLY]
  CE[centroid] --> POLYHULL[concaveHull convexHull]
  TN[turnAngle] --> HULL[concaveHull ordering]
  AE[almostEqual] --> PE[pointsEqual]
  GN[generateNominal] --> SPWN[spawner generated values]
  RN[randomBetween] --> SPWN
  GZ[generateNudge] --> SPWN
  DR[degreeToRadian] --> ANG[angle math helpers]
```

Geometry helper usage

```mermaid
sequenceDiagram
  participant P as POLY
  participant M as MATH
  P->>M: distanceSquared(ax,ay,bx,by)
  M-->>P: dx2 plus dy2
  P->>M: dot(ax,ay,bx,by)
  M-->>P: scalar value
  P->>M: crossProduct(p1,p2,p3)
  M-->>P: signed determinant
  P->>M: direction(a,b,c)
  M-->>P: 0 or 1 or 2
  P->>M: centroid(pts)
  M-->>P: cx cy
  P->>M: turnAngle(prev,cur,cand)
  M-->>P: angle 0..2pi
```

Spawner numeric generation

```mermaid
flowchart TD
  BASE[base settings] --> NOM[generateNominal]
  NOM --> RNG[randomDecimalBetween]
  RNG --> NUDGE[generateNudge]
  NUDGE --> OUT[actual and thresholds]
```

Algorithm sketches

- Orientation and intersection

```mermaid
flowchart TD
  A[p1 p2 p3] --> CP[crossProduct]
  CP --> SIGN[sign of determinant]
  SIGN --> ORIENT[CW CCW or colinear]
  ORIENT --> USE[branch for intersection tests]
```

- Centroid of point set

```mermaid
flowchart LR
  PTS[normalized points] --> SUM[accumulate x and y]
  SUM --> CNT[count points]
  CNT --> AVG[divide sums by count]
  AVG --> RET[return centroid]
```

Key anchors in consumers
- POLY: [pointToSegmentSquared](../../dev/POLY.lua:1149), [getEquallySpacedPoints](../../dev/POLY.lua:1074), [isWithinOffset](../../dev/POLY.lua:1106), [concaveHull](../../dev/POLY.lua:1309), [convexHull](../../dev/POLY.lua:1461)
- SPAWNER types and counts: see [docs/spawner/types_and_counts.md](../spawner/types_and_counts.md) and [docs/spawner/pipeline.md](../spawner/pipeline.md)

Notes
- Mermaid labels avoid double quotes and parentheses.
- All diagrams use GitHub Mermaid fenced blocks.