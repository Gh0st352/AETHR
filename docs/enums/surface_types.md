# ENUMS surface types and NOGO flows

Surface type enumeration and how SPAWNER enforces NOGO surfaces and optional restricted polygons during placement.

# Primary sources

- Surface types class doc: [AETHR.ENUMS.SurfaceType](https://github.com/Gh0st352/AETHR/blob/main/dev/ENUMS.lua#L50)
- Surface types mapping: [AETHR.ENUMS.SurfaceType = { ... }](https://github.com/Gh0st352/AETHR/blob/main/dev/ENUMS.lua#L365)
- SPAWNER config defaults referencing surface types: [AETHR.SPAWNER.DATA.CONFIG.NoGoSurfaces](https://github.com/Gh0st352/AETHR/blob/main/dev/SPAWNER.lua#L108)
- NOGO checks:
  - Polygon plus surfaces: [AETHR.SPAWNER:checkIsInNOGO()](https://github.com/Gh0st352/AETHR/blob/main/dev/SPAWNER.lua#L2085)
  - Surface-only: [AETHR.SPAWNER:vec2AtNoGoSurface()](https://github.com/Gh0st352/AETHR/blob/main/dev/SPAWNER.lua#L2128)

# Overview relationships

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart LR

subgraph "ENUMS" ["ENUMS"]
  EN[ENUMS]
  ST[SurfaceType]
end

subgraph "SPAWNER.DATA.CONFIG" ["SPAWNER.DATA.CONFIG"]
  NGS[NoGoSurfaces]
end

subgraph "SPAWNER" ["SPAWNER"]
  NG1[checkIsInNOGO]
  NG2[vec2AtNoGoSurface]
end

EN --> ST
ST -.-> NGS
NGS -.-> NG1
NGS -.-> NG2

class EN,ST class_data;
class NGS class_compute;
class NG1,NG2 class_step;
```

# Placement NOGO flow

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
sequenceDiagram
  participant SP as SPAWNER
  participant EN as ENUMS

  note over SP: During center/unit placement
  SP->>EN: SurfaceType.WATER | RUNWAY | SHALLOW_WATER from CONFIG
  SP->>SP: vec2AtNoGoSurface(vec2)
  alt not NOGO and UseRestrictedZonePolys true
    SP->>SP: point-in-polygon against restricted zones with AABB prefilter
  end
  SP-->>SP: accept or reject candidate
```

# Configuration knobs

- SPAWNER.DATA.CONFIG.NoGoSurfaces defaults: [RUNWAY, WATER, SHALLOW_WATER] at [dev/SPAWNER.lua](https://github.com/Gh0st352/AETHR/blob/main/dev/SPAWNER.lua#L108)
- SPAWNER.DATA.CONFIG.UseRestrictedZonePolys enables polygon checks in [checkIsInNOGO](https://github.com/Gh0st352/AETHR/blob/main/dev/SPAWNER.lua#L2085)

# Where checks apply

- Group center placement: [AETHR.SPAWNER:generateVec2GroupCenters()](https://github.com/Gh0st352/AETHR/blob/main/dev/SPAWNER.lua#L1067)
  - Invokes [checkIsInNOGO](https://github.com/Gh0st352/AETHR/blob/main/dev/SPAWNER.lua#L2085) after cheap grid rejections
- Unit position placement: [AETHR.SPAWNER:generateVec2UnitPos()](https://github.com/Gh0st352/AETHR/blob/main/dev/SPAWNER.lua#L1299)
  - Invokes [checkIsInNOGO](https://github.com/Gh0st352/AETHR/blob/main/dev/SPAWNER.lua#L2085) after proximity checks

# Surface-only quick check

- [AETHR.SPAWNER:vec2AtNoGoSurface()](https://github.com/Gh0st352/AETHR/blob/main/dev/SPAWNER.lua#L2128) queries land.getSurfaceType and compares against CONFIG NoGoSurfaces

# Validation checklist

- SurfaceType mapping is set at [dev/ENUMS.lua](https://github.com/Gh0st352/AETHR/blob/main/dev/ENUMS.lua#L365)
- NoGoSurfaces default defined at [dev/SPAWNER.lua](https://github.com/Gh0st352/AETHR/blob/main/dev/SPAWNER.lua#L108)
- NOGO functions present at [checkIsInNOGO](https://github.com/Gh0st352/AETHR/blob/main/dev/SPAWNER.lua#L2085) and [vec2AtNoGoSurface](https://github.com/Gh0st352/AETHR/blob/main/dev/SPAWNER.lua#L2128)
- Placement generators call NOGO logic at [dev/SPAWNER.lua](https://github.com/Gh0st352/AETHR/blob/main/dev/SPAWNER.lua#L1227) and [dev/SPAWNER.lua](https://github.com/Gh0st352/AETHR/blob/main/dev/SPAWNER.lua#L1505)

# Related breakouts

- Categories: [categories.md](./categories.md)
- Spawn types and priority: [spawn_types.md](./spawn_types.md)
- Lines and markers: [lines_and_markers.md](./lines_and_markers.md)
- Coalition and text strings: [coalition_and_text.md](./coalition_and_text.md)

# Conventions

- GitHub Mermaid fenced blocks
- Labels avoid double quotes and parentheses inside bracket labels
- Relative links use stable line anchors to source