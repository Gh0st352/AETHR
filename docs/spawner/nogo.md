# AETHR SPAWNER NOGO checks

Covered functions
- Surface and polygon checks
  - [AETHR.SPAWNER:checkIsInNOGO()](https://github.com/Gh0st352/AETHR/blob/main/dev/SPAWNER.lua#L2085)
  - [AETHR.SPAWNER:vec2AtNoGoSurface()](https://github.com/Gh0st352/AETHR/blob/main/dev/SPAWNER.lua#L2128)
  - [AETHR.POLY:pointInPolygon](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L66)
- Call sites during placement
  - Centers: NOGO check used in [AETHR.SPAWNER:generateVec2GroupCenters](https://github.com/Gh0st352/AETHR/blob/main/dev/SPAWNER.lua#L1227)
  - Units: NOGO check used in [AETHR.SPAWNER:generateVec2UnitPos](https://github.com/Gh0st352/AETHR/blob/main/dev/SPAWNER.lua#L1504)
- Configuration
  - NoGoSurfaces list: [SPAWNER.DATA.CONFIG.NoGoSurfaces](https://github.com/Gh0st352/AETHR/blob/main/dev/SPAWNER.lua#L108)
  - Polygon toggle: [SPAWNER.DATA.CONFIG.UseRestrictedZonePolys](https://github.com/Gh0st352/AETHR/blob/main/dev/SPAWNER.lua#L101)

# 1. NOGO decision flow

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TB
  subgraph "Entry"
    direction TB
    S[start checkIsInNOGO] --> S1[vec2AtNoGoSurface]
  end

  subgraph "Surface path"
    direction TB
    S1 --> C0{on NOGO surface}
    C0 -- "yes" --> RT1[return true]
    C0 -- "no" --> P0{UseRestrictedZonePolys enabled and restrictedZones is table}
  end

  subgraph "Polygon path"
    direction TB
    P0 -- "no" --> RT0[return false]
    P0 -- "yes" --> L0[for each zone in restrictedZones]
    L0 --> N1[normalize point and extract polygon vertices]
    N1 --> AABB[aabb prefilter minx maxx miny maxy]
    AABB --> C1{point inside aabb}
    C1 -- "no" --> NEXT[next zone]
    C1 -- "yes" --> PIP[POLY.pointInPolygon]
    PIP --> C2{inside polygon}
    C2 -- "yes" --> RT2[return true]
    C2 -- "no" --> NEXT
    NEXT --> L0
  end

  subgraph "Exit"
    direction TB
    RT2 --> END[is NOGO true]
    RT1 --> END
    RT0 --> END
  end

  class S class_io;
  class S1,N1,AABB,L0,NEXT class_step;
  class C0,C1,C2,P0 class_decision;
  class RT1,RT0,RT2,END class_result;
```

# 2. Surface classification path

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart LR
  subgraph "Surface test"
    direction LR
    V[vec2] --> Q[land.getSurfaceType]
    Q --> M[compare against CONFIG.NoGoSurfaces]
    M --> C{match found}
  end
  C -- "yes" --> T[true]
  C -- "no" --> F[false]
  class V,Q,M,T,F class_step;
  class C class_decision;
  class T,F class_result;
```

# 3. Integration in placement loops

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
sequenceDiagram
  participant Centers as generateVec2GroupCenters
  participant Units as generateVec2UnitPos
  participant Spawner as SPAWNER
  participant Poly as POLY
  Note over Centers,Units: After fast grid checks and strict building direct checks
  Centers->>Spawner: checkIsInNOGO(candidate, zones.restricted)
  Units->>Spawner: checkIsInNOGO(candidate, zones.restricted)
  alt UseRestrictedZonePolys disabled
    Spawner-->>Centers: result based on vec2AtNoGoSurface only
    Spawner-->>Units: result based on vec2AtNoGoSurface only
  else enabled
    Spawner->>Poly: pointInPolygon after aabb prefilter
    Poly-->>Spawner: inside or outside
    Spawner-->>Centers: reject when inside any restricted polygon
    Spawner-->>Units: reject when inside any restricted polygon
  end
```

# 4. Notes and guardrails

- Surface checks are always enforced via [AETHR.SPAWNER:vec2AtNoGoSurface](https://github.com/Gh0st352/AETHR/blob/main/dev/SPAWNER.lua#L2128) using DCS land.getSurfaceType and the configured [NoGoSurfaces](https://github.com/Gh0st352/AETHR/blob/main/dev/SPAWNER.lua#L108).
- Polygon checks are optional, controlled by [UseRestrictedZonePolys](https://github.com/Gh0st352/AETHR/blob/main/dev/SPAWNER.lua#L101). When enabled, an axis aligned bounding box prefilter is applied before [POLY.pointInPolygon](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L66).
- Placement loops call NOGO only after cheap spatial pruning and strict building checks. See call points in [generateVec2GroupCenters](https://github.com/Gh0st352/AETHR/blob/main/dev/SPAWNER.lua#L1227) and [generateVec2UnitPos](https://github.com/Gh0st352/AETHR/blob/main/dev/SPAWNER.lua#L1504).
- Performance tradeoff: polygon checks add cost proportional to number of polygons and their vertex counts, mitigated by the aabb prefilter.