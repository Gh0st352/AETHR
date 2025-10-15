# ENUMS surface types and NOGO flows

Surface type enumeration and how SPAWNER enforces NOGO surfaces and optional restricted polygons during placement.

Primary sources

- Surface types class doc: [AETHR.ENUMS.SurfaceType](../../dev/ENUMS.lua:50)
- Surface types mapping: [AETHR.ENUMS.SurfaceType = { ... }](../../dev/ENUMS.lua:365)
- SPAWNER config defaults referencing surface types: [AETHR.SPAWNER.DATA.CONFIG.NoGoSurfaces](../../dev/SPAWNER.lua:108)
- NOGO checks:
  - Polygon plus surfaces: [AETHR.SPAWNER:checkIsInNOGO()](../../dev/SPAWNER.lua:2085)
  - Surface-only: [AETHR.SPAWNER:vec2AtNoGoSurface()](../../dev/SPAWNER.lua:2128)

Overview relationships

```mermaid
%%{init: {"theme":"base", "themeVariables":{"primaryColor":"#0f172a","primaryTextColor":"#ffffff","lineColor":"#94a3b8","fontSize":"12px"}}}%%
flowchart LR

%% Classes
classDef enums fill:#dae8fc,stroke:#6c8ebf,stroke-width:2px;
classDef config fill:#fff2cc,stroke:#d6b656,stroke-width:2px;
classDef spawner fill:#ffe6cc,stroke:#d79b00,stroke-width:2px;

%% ENUMS
subgraph sgEnums [ENUMS]
  EN[ENUMS]
  ST[SurfaceType]
end

%% CONFIG
subgraph sgCfg [SPAWNER.DATA.CONFIG]
  NGS[NoGoSurfaces]
end

%% SPAWNER
subgraph sgSp [SPAWNER]
  NG1[checkIsInNOGO]
  NG2[vec2AtNoGoSurface]
end

%% Edges
EN --> ST
ST -.-> NGS
NGS -.-> NG1
NGS -.-> NG2

%% Class applications
class EN,ST enums
class NGS config
class NG1,NG2 spawner

%% Styles
style sgEnums fill:#eef4ff,stroke:#6c8ebf,stroke-width:2px
style sgCfg fill:#fff9e6,stroke:#d6b656,stroke-width:2px
style sgSp fill:#fff1db,stroke:#d79b00,stroke-width:2px
```

Placement NOGO flow

```mermaid
%%{init: {"theme":"base"}}%%
sequenceDiagram
  participant SP as SPAWNER
  participant EN as ENUMS

  rect rgba(255, 255, 255, 0.75)
    Note over SP: During center/unit placement
    SP->>EN: SurfaceType.WATER|RUNWAY|SHALLOW_WATER from CONFIG
    SP->>SP: vec2AtNoGoSurface(vec2)
    alt not NOGO and UseRestrictedZonePolys true
      SP->>SP: point-in-polygon against restricted zones with AABB prefilter
    end
    SP-->>SP: accept or reject candidate
  end
```

Configuration knobs

- SPAWNER.DATA.CONFIG.NoGoSurfaces defaults: [RUNWAY, WATER, SHALLOW_WATER] at [dev/SPAWNER.lua](../../dev/SPAWNER.lua:108)
- SPAWNER.DATA.CONFIG.UseRestrictedZonePolys enables polygon checks in [checkIsInNOGO](../../dev/SPAWNER.lua:2085)

Where checks apply

- Group center placement: [AETHR.SPAWNER:generateVec2GroupCenters()](../../dev/SPAWNER.lua:1067)
  - Invokes [checkIsInNOGO](../../dev/SPAWNER.lua:2085) after cheap grid rejections
- Unit position placement: [AETHR.SPAWNER:generateVec2UnitPos()](../../dev/SPAWNER.lua:1299)
  - Invokes [checkIsInNOGO](../../dev/SPAWNER.lua:2085) after proximity checks

Surface-only quick check

- [AETHR.SPAWNER:vec2AtNoGoSurface()](../../dev/SPAWNER.lua:2128) queries land.getSurfaceType and compares against CONFIG NoGoSurfaces

Validation checklist

- SurfaceType mapping is set at [dev/ENUMS.lua](../../dev/ENUMS.lua:365)
- NoGoSurfaces default defined at [dev/SPAWNER.lua](../../dev/SPAWNER.lua:108)
- NOGO functions present at [checkIsInNOGO](../../dev/SPAWNER.lua:2085) and [vec2AtNoGoSurface](../../dev/SPAWNER.lua:2128)
- Placement generators call NOGO logic at [dev/SPAWNER.lua](../../dev/SPAWNER.lua:1227) and [dev/SPAWNER.lua](../../dev/SPAWNER.lua:1505)

Related breakouts

- Categories: [categories.md](./categories.md)
- Spawn types and priority: [spawn_types.md](./spawn_types.md)
- Lines and markers: [lines_and_markers.md](./lines_and_markers.md)
- Coalition and text strings: [coalition_and_text.md](./coalition_and_text.md)

Conventions

- GitHub Mermaid fenced blocks
- Labels avoid double quotes and parentheses inside bracket labels
- Relative links use stable line anchors to source