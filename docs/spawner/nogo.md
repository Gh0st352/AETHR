# AETHR SPAWNER NOGO checks

Covered functions
- Surface and polygon checks
  - [AETHR.SPAWNER:checkIsInNOGO()](../../dev/SPAWNER.lua:2085)
  - [AETHR.SPAWNER:vec2AtNoGoSurface()](../../dev/SPAWNER.lua:2128)
  - [AETHR.POLY:pointInPolygon](../../dev/POLY.lua:66)
- Call sites during placement
  - Centers: NOGO check used in [AETHR.SPAWNER:generateVec2GroupCenters](../../dev/SPAWNER.lua:1227)
  - Units: NOGO check used in [AETHR.SPAWNER:generateVec2UnitPos](../../dev/SPAWNER.lua:1504)
- Configuration
  - NoGoSurfaces list: [SPAWNER.DATA.CONFIG.NoGoSurfaces](../../dev/SPAWNER.lua:108)
  - Polygon toggle: [SPAWNER.DATA.CONFIG.UseRestrictedZonePolys](../../dev/SPAWNER.lua:101)

1. NOGO decision flow

```mermaid
flowchart TB
  S[start checkIsInNOGO] --> S1[vec2AtNoGoSurface]
  S1 --> C0{on NOGO surface}
  C0 -- yes --> RT1[return true]
  C0 -- no --> P0{UseRestrictedZonePolys enabled and restrictedZones is table}
  P0 -- no --> RT0[return false]
  P0 -- yes --> L0[for each zone in restrictedZones]
  L0 --> N1[normalize point and extract polygon vertices]
  N1 --> AABB[aabb prefilter minx maxx miny maxy]
  AABB --> C1{point inside aabb}
  C1 -- no --> NEXT[next zone]
  C1 -- yes --> PIP[POLY.pointInPolygon]
  PIP --> C2{inside polygon}
  C2 -- yes --> RT2[return true]
  C2 -- no --> NEXT
  NEXT --> L0
  RT2 --> END[is NOGO true]
  RT1 --> END
  RT0 --> END
```

2. Surface classification path

```mermaid
flowchart LR
  V[vec2] --> Q[land.getSurfaceType]
  Q --> M[compare against CONFIG.NoGoSurfaces]
  M --> C{match found}
  C -- yes --> T[true]
  C -- no --> F[false]
```

3. Integration in placement loops

```mermaid
sequenceDiagram
  participant Centers as generateVec2GroupCenters
  participant Units as generateVec2UnitPos
  participant Spawner as SPAWNER
  participant Poly as POLY
  note over Centers,Units: After fast grid checks and strict building direct checks
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

4. Notes and guardrails

- Surface checks are always enforced via [AETHR.SPAWNER:vec2AtNoGoSurface](../../dev/SPAWNER.lua:2128) using DCS land.getSurfaceType and the configured [NoGoSurfaces](../../dev/SPAWNER.lua:108).
- Polygon checks are optional, controlled by [UseRestrictedZonePolys](../../dev/SPAWNER.lua:101). When enabled, an axis aligned bounding box prefilter is applied before [POLY.pointInPolygon](../../dev/POLY.lua:66).
- Placement loops call NOGO only after cheap spatial pruning and strict building checks. See call points in [generateVec2GroupCenters](../../dev/SPAWNER.lua:1227) and [generateVec2UnitPos](../../dev/SPAWNER.lua:1504).
- Performance tradeoff: polygon checks add cost proportional to number of polygons and their vertex counts, mitigated by the aabb prefilter.