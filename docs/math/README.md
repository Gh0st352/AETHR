# AETHR MATH diagrams and flows

## Primary anchors
- [AETHR.MATH:crossProduct()](https://github.com/Gh0st352/AETHR/blob/main/dev/MATH_.lua#L29)
- [AETHR.MATH:computeRatio()](https://github.com/Gh0st352/AETHR/blob/main/dev/MATH_.lua#L43)
- [AETHR.MATH:distanceSquared()](https://github.com/Gh0st352/AETHR/blob/main/dev/MATH_.lua#L58)
- [AETHR.MATH:dot()](https://github.com/Gh0st352/AETHR/blob/main/dev/MATH_.lua#L75)
- [AETHR.MATH:direction()](https://github.com/Gh0st352/AETHR/blob/main/dev/MATH_.lua#L96)
- [AETHR.MATH:almostEqual()](https://github.com/Gh0st352/AETHR/blob/main/dev/MATH_.lua#L118)
- [AETHR.MATH:pointsEqual()](https://github.com/Gh0st352/AETHR/blob/main/dev/MATH_.lua#L129)
- [AETHR.MATH:turnAngle()](https://github.com/Gh0st352/AETHR/blob/main/dev/MATH_.lua#L142)
- [AETHR.MATH:centroid()](https://github.com/Gh0st352/AETHR/blob/main/dev/MATH_.lua#L157)
- [AETHR.MATH:generateNominal()](https://github.com/Gh0st352/AETHR/blob/main/dev/MATH_.lua#L181)
- [AETHR.MATH:randomDecimalBetween()](https://github.com/Gh0st352/AETHR/blob/main/dev/MATH_.lua#L215)
- [AETHR.MATH:generateNudge()](https://github.com/Gh0st352/AETHR/blob/main/dev/MATH_.lua#L233)
- [AETHR.MATH:degreeToRadian()](https://github.com/Gh0st352/AETHR/blob/main/dev/MATH_.lua#L252)

## Breakout documents
- Orientation: [docs/math/orientation.md](orientation.md)
- Vectors and angles: [docs/math/vectors.md](vectors.md)
- Equality and centroid: [docs/math/equality_and_centroid.md](equality_and_centroid.md)
- Randomization helpers: [docs/math/randomization.md](randomization.md)
- Degree and turn angle notes: [docs/math/angles.md](angles.md)

## Documents and indices
- Master diagrams index: [docs/README.md](../README.md)
- POLY: [docs/poly/README.md](../poly/README.md)
- SPAWNER: [docs/spawner/README.md](../spawner/README.md)
- ZONE_MANAGER: [docs/zone_manager/README.md](../zone_manager/README.md)

# Overview relationships

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
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

# Geometry helper usage

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
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

# Spawner numeric generation

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  BASE[base settings] --> NOM[generateNominal]
  NOM --> RNG[randomDecimalBetween]
  RNG --> NUDGE[generateNudge]
  NUDGE --> OUT[actual and thresholds]
```

# Algorithm sketches

## - Orientation and intersection

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  A[p1 p2 p3] --> CP[crossProduct]
  CP --> SIGN[sign of determinant]
  SIGN --> ORIENT[CW CCW or colinear]
  ORIENT --> USE[branch for intersection tests]
```

## - Centroid of point set

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart LR
  PTS[normalized points] --> SUM[accumulate x and y]
  SUM --> CNT[count points]
  CNT --> AVG[divide sums by count]
  AVG --> RET[return centroid]
```

# Key anchors in consumers
- POLY: [pointToSegmentSquared](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L1149), [getEquallySpacedPoints](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L1074), [isWithinOffset](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L1106), [concaveHull](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L1309), [convexHull](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L1461)
- SPAWNER types and counts: see [docs/spawner/types_and_counts.md](../spawner/types_and_counts.md) and [docs/spawner/pipeline.md](../spawner/pipeline.md)

# Notes
- Mermaid labels avoid double quotes and parentheses.
- All diagrams use GitHub Mermaid fenced blocks.