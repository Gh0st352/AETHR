# MATH randomization

Nominal value generation, random decimal, and nudge helpers used by SPAWNER and other systems.

Source anchors
- [AETHR.MATH:generateNominal()](../../dev/MATH_.lua:181)
- [AETHR.MATH:randomDecimalBetween()](../../dev/MATH_.lua:215)
- [AETHR.MATH:generateNudge()](../../dev/MATH_.lua:233)

# Overview

- generateNominal returns a value around a nominal with a controllable nudge factor and min max bounds
- randomDecimalBetween returns a uniform random decimal in a..b inclusive of ends in expectation
- generateNudge returns a randomized factor around NudgeFactor with bounds derived from its square

# generateNominal flow

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  subgraph "Inputs and quick returns"
    IN[Nominal Min Max NudgeFactor]
    NF1{NudgeFactor equals 1}
    NF0{NudgeFactor equals 0}
  end
  IN --> NF1
  NF1 -->|yes| RETN[return Nominal]
  NF1 -->|no| NF0
  NF0 -->|yes| COIN[math random lt 0.5]
  COIN -->|true| RETMIN[return Min]
  COIN -->|false| RETMAX[return Max]
  NF0 -->|no| RANGE[compute nudged range]
  subgraph "Range calculation"
    MIN[nudgedMin max of Nominal minus NudgeFactor times half span and Min]
    MAX[nudgedMax min of Nominal plus NudgeFactor times half span and Max]
  end
  RANGE --> MIN
  RANGE --> MAX
  MIN --> CALL[randomDecimalBetween]
  MAX --> CALL
  CALL --> RET[return value]
  class IN class_io;
  class NF1,NF0,COIN class_decision;
  class RANGE,MIN,MAX,CALL class_compute;
  class RET,RETN,RETMIN,RETMAX class_result;
```

# randomDecimalBetween flow

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  subgraph "Endpoints"
    IN[a b]
    ORD{a greater b}
  end
  IN --> ORD
  ORD -->|yes| SWAP[swap a and b]
  ORD -->|no| KEEP[keep a b]
  SWAP --> LERP[a plus b minus a times math random]
  KEEP --> LERP
  LERP --> OUT[return number]
  class IN class_io;
  class ORD,SWAP,KEEP class_decision;
  class LERP class_compute;
  class OUT class_result;
```

# generateNudge flow

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  IN[NudgeFactor] --> EDGE{equals 1 or 0}
  EDGE -->|yes| RET[return NudgeFactor]
  EDGE -->|no| BOUNDS[compute bounds]
  subgraph "Bounds"
    LB[lowerBound max of NudgeFactor minus square and 0.01]
    UB[upperBound min of NudgeFactor plus square and 0.99]
  end
  BOUNDS --> LB
  BOUNDS --> UB
  LB --> CALL[randomDecimalBetween lower upper]
  UB --> CALL
  CALL --> OUT[return value]
  class IN class_io;
  class EDGE class_decision;
  class BOUNDS,LB,UB,CALL class_compute;
  class RET,OUT class_result;
```

# Sequence usage in SPAWNER

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
sequenceDiagram
  participant S as SPAWNER
  participant M as MATH
  S->>M: generateNominal nominal min max factor
  M-->>S: value around nominal
  S->>M: generateNudge factor
  M-->>S: bounded random factor
  S->>M: randomDecimalBetween a b
  M-->>S: uniform random value
```

# Implementation notes

- generateNominal
  - For factor 1 returns the nominal value deterministically
  - For factor 0 returns either bound using a coin flip
  - Otherwise computes a half span around nominal scaled by factor and constrained to Min Max
  - Uses [AETHR.MATH:randomDecimalBetween()](../../dev/MATH_.lua:215) to sample the range
- randomDecimalBetween
  - Ensures proper ordering by swapping endpoints when a greater than b
  - Returns a plus b minus a times math random which is uniform in the interval
- generateNudge
  - Uses a square term to widen bounds for mid range factors and narrow near edges
  - Clamps to 0.01 and 0.99 to avoid degenerate extremes

# Validation checklist

- generateNominal: [dev/MATH_.lua](../../dev/MATH_.lua:181)
- randomDecimalBetween: [dev/MATH_.lua](../../dev/MATH_.lua:215)
- generateNudge: [dev/MATH_.lua](../../dev/MATH_.lua:233)

# Related docs

- SPAWNER pipeline and types: [docs/spawner/pipeline.md](../spawner/pipeline.md), [docs/spawner/types_and_counts.md](../spawner/types_and_counts.md)

# Conventions

- Mermaid fenced blocks use GitHub Mermaid parser
- Labels inside brackets avoid double quotes and parentheses
- Links use relative paths for repository portability