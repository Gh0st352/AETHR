# POLY reorder and centroids

Reordering vertex lists to match a master ordering and computing center and centroid points.

### Source anchors
- [AETHR.POLY:reorderSlaveToMaster()](../../dev/POLY.lua:1705)
- [AETHR.POLY:getCenterPoint()](../../dev/POLY.lua:1779)
- [AETHR.POLY:getCentroidPoint()](../../dev/POLY.lua:1830)
- Helpers: [AETHR.POLY:normalizePoint()](../../dev/POLY.lua:236)

### Overview
- reorderSlaveToMaster reorders a slave vertex array to match the order of a master by bucketing slave points using rounded x y keys and walking the master
- getCenterPoint returns a center representative of a set of vertices using simple rules:
  - 0 verts 0,0
  - 1 vert that vertex normalized
  - 2 verts midpoint
  - 3 or more arithmetic centroid
- getCentroidPoint returns the polygon area centroid using the shoelace method with degenerate fallback to arithmetic centroid

# reorderSlaveToMaster flow

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  IN[slave master precision] --> KEY[fmt key x y with precision]
  KEY --> BUCKETS[build buckets for slave by key]
  BUCKETS --> WALK[walk master in order]
  WALK --> PICK[pull next from bucket if present]
  PICK --> OUT[append to output]
  WALK -->|end| RET[return reordered list]

  subgraph "Indexing"
    KEY
    BUCKETS
  end
  subgraph "Walk master"
    WALK
    PICK
    OUT
  end
  subgraph "Return"
    RET
  end

  class IN class_io;
  class KEY,BUCKETS,WALK,PICK,OUT class_step;
  class RET class_result;
```

# getCenterPoint flow

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  IN[vertices] --> CASES{count}
  CASES -->|0| Z[return 0 0]
  CASES -->|1| N[norm single and return]
  CASES -->|2| MID[midpoint]
  CASES -->|3 plus| AVG[arithmetic average x and y]
  MID --> OUT[midpoint]
  AVG --> OUT2[return cx cy]

  subgraph "Cases"
    CASES
    Z
    N
    MID
    AVG
  end
  subgraph "Return"
    OUT
    OUT2
  end

  class IN class_io;
  class CASES class_decision;
  class MID class_step;
  class AVG class_compute;
  class Z,N,OUT,OUT2 class_result;
```

# getCentroidPoint flow

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  IN[vertices] --> CASES{count}
  CASES -->|0| Z[return 0 0]
  CASES -->|1| N[norm single and return]
  CASES -->|2| MID[midpoint]
  CASES -->|3 plus| NORM[norm to x y]
  NORM --> LOOP[shoelace accum A2 cxAcc cyAcc]
  LOOP --> AREA[area equals A2 over 2]
  AREA --> DEG{area eq 0}
  DEG -->|yes| AVG[arithmetic average]
  DEG -->|no| CXY[cx cy equals acc over 6A]
  AVG --> RETA[return average]
  CXY --> RETB[return centroid]

  subgraph "Cases"
    CASES
    Z
    N
    MID
  end
  subgraph "Shoelace"
    NORM
    LOOP
    AREA
    DEG
  end
  subgraph "Return"
    AVG
    CXY
    RETA
    RETB
  end

  class IN class_io;
  class CASES,DEG class_decision;
  class NORM,LOOP,AREA,CXY class_compute;
  class Z,N,MID class_result;
  class RETA,RETB class_result;
```

# Sequence usage

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
sequenceDiagram
  participant Z as ZONE_MANAGER
  participant P as POLY
  Z->>P: reorderSlaveToMaster slave master
  P-->>Z: reordered vertices matching master order
  Z->>P: getCenterPoint vertices
  P-->>Z: center point
  Z->>P: getCentroidPoint vertices
  P-->>Z: polygon area centroid
```

# Implementation notes
- reorderSlaveToMaster uses rounded keys with default precision 3 to allow near-equality matches
  - Buckets store arrays and a read pointer to avoid costly front removals
  - Only vertices present in the master order are included in output
- getCenterPoint selects from rules and uses arithmetic centroid for 3 or more without area weighting
- getCentroidPoint computes the true area centroid with shoelace accumulators and a degenerate fallback

# Validation checklist
- reorderSlaveToMaster: [dev/POLY.lua](../../dev/POLY.lua:1705)
- getCenterPoint: [dev/POLY.lua](../../dev/POLY.lua:1779)
- getCentroidPoint: [dev/POLY.lua](../../dev/POLY.lua:1830)

# Related docs
- Convert and order: [docs/poly/convert_and_order.md](./convert_and_order.md)
- Bounds and divisions: [docs/poly/bounds_and_divisions.md](./bounds_and_divisions.md)

# Conventions
- Mermaid fenced blocks use GitHub Mermaid parser
- Subgraph labels use double quotes per [docs/_mermaid/README.md](../_mermaid/README.md)
- Labels inside brackets avoid double quotes and parentheses
- Links use relative paths for repository portability