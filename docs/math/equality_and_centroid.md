# MATH equality and centroid

Tolerance based equality for numbers and points, and centroid computation for point sets.

Source anchors
- [AETHR.MATH:almostEqual()](../../dev/MATH_.lua:118)
- [AETHR.MATH:pointsEqual()](../../dev/MATH_.lua:129)
- [AETHR.MATH:centroid()](../../dev/MATH_.lua:157)

Overview

- almostEqual compares two numbers within an absolute epsilon tolerance
- pointsEqual uses almostEqual on x and y to compare two points
- centroid computes arithmetic mean of a set of points

almostEqual flow

```mermaid
flowchart TD
  IN[a b eps opt] --> DEF[eps default 1e-9]
  DEF --> ABS[abs a minus b]
  ABS --> CMP[abs le eps]
  CMP --> OUT[return boolean]
```

pointsEqual flow

```mermaid
flowchart TD
  IN[p1 p2 eps opt] --> NIL[check p1 and p2]
  NIL -->|either nil| FALSE[return false]
  NIL -->|both present| X[self almostEqual p1 x p2 x]
  X --> Y[self almostEqual p1 y p2 y]
  Y --> OUT[return x and y result]
```

centroid flow

```mermaid
flowchart TD
  IN[pts array] --> EMPTY[if empty return 0 0]
  EMPTY --> SUM[sum x and y]
  SUM --> DIV[divide by count]
  DIV --> OUT[return cx cy]
```

Sequence usage in POLY and ZONE_MANAGER

```mermaid
sequenceDiagram
  participant P as POLY
  participant M as MATH
  participant Z as ZONE_MANAGER
  P->>M: pointsEqual p1 p2 eps
  M-->>P: boolean
  P->>M: centroid pts
  M-->>P: cx cy
  Z->>M: almostEqual a b eps
  M-->>Z: boolean
```

Implementation notes

- eps tolerance
  - Default epsilon is 1e-9 which is adequate for typical map scale units
  - For larger scale or accumulated sums use a slightly larger epsilon
- centroid
  - Implements arithmetic mean not polygon area centroid
  - For polygon centroid by area use a shoelace based method in geometry code

Validation checklist

- almostEqual: [dev/MATH_.lua](../../dev/MATH_.lua:118)
- pointsEqual: [dev/MATH_.lua](../../dev/MATH_.lua:129)
- centroid: [dev/MATH_.lua](../../dev/MATH_.lua:157)

Related docs

- Geometry consumers and hulls: [docs/poly/README.md](../poly/README.md)
- Orientation helpers: [docs/math/orientation.md](./orientation.md)

Conventions

- Mermaid fenced blocks use GitHub Mermaid parser
- Labels inside brackets avoid double quotes and parentheses
- Links use relative paths for repository portability