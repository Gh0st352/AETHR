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

# almostEqual flow

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  subgraph "Inputs and compute"
    IN[a b eps opt]
    DEF[eps default 1e-9]
  end
  IN --> DEF
  DEF --> ABS[abs a minus b]
  ABS --> CMP[abs le eps]
  CMP --> OUT[return boolean]
  class IN class_io;
  class DEF,ABS class_compute;
  class CMP class_decision;
  class OUT class_result;
```

# pointsEqual flow

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  subgraph "Point presence check"
    IN[p1 p2 eps opt]
    NIL[check p1 and p2]
  end
  IN --> NIL
  NIL -->|either nil| FALSE[return false]
  NIL -->|both present| X[self almostEqual p1 x p2 x]
  X --> Y[self almostEqual p1 y p2 y]
  Y --> OUT[return x and y result]
  class IN class_io;
  class NIL class_decision;
  class X,Y class_compute;
  class FALSE,OUT class_result;
```

# centroid flow

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  subgraph "Centroid computation"
    IN[pts array]
    EMPTY[if empty return 0 0]
    SUM[sum x and y]
    DIV[divide by count]
  end
  IN --> EMPTY
  EMPTY --> SUM
  SUM --> DIV
  DIV --> OUT[return cx cy]
  class IN class_io;
  class SUM,DIV class_compute;
  class EMPTY class_decision;
  class OUT class_result;
```

# Sequence usage in POLY and ZONE_MANAGER

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
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

# Implementation notes

- eps tolerance
  - Default epsilon is 1e-9 which is adequate for typical map scale units
  - For larger scale or accumulated sums use a slightly larger epsilon
- centroid
  - Implements arithmetic mean not polygon area centroid
  - For polygon centroid by area use a shoelace based method in geometry code

# Validation checklist

- almostEqual: [dev/MATH_.lua](../../dev/MATH_.lua:118)
- pointsEqual: [dev/MATH_.lua](../../dev/MATH_.lua:129)
- centroid: [dev/MATH_.lua](../../dev/MATH_.lua:157)

# Related docs

- Geometry consumers and hulls: [docs/poly/README.md](../poly/README.md)
- Orientation helpers: [docs/math/orientation.md](./orientation.md)

# Conventions

- Mermaid fenced blocks use GitHub Mermaid parser
- Labels inside brackets avoid double quotes and parentheses
- Links use relative paths for repository portability