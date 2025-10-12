# UTILS points and normalization

Anchors
- [AETHR.UTILS:getPointY()](../../dev/UTILS.lua:129)
- [AETHR.UTILS:normalizePoint()](../../dev/UTILS.lua:137)

Overview
- getPointY extracts the vertical component from a point like table, supporting y or z fields.
- normalizePoint converts any point like input into a normalized table { x, y } with defaults for missing components and does not mutate the input.

Point extraction and normalization
```mermaid
flowchart LR
  INP[point like x y or x z] --> GY[getPointY]
  GY --> OUTY[y or z]
  INP --> NP[normalizePoint]
  NP --> OUTXY[{ x y }]
```

Consumers and integration
```mermaid
sequenceDiagram
  participant C as Caller
  participant U as UTILS
  participant P as POLY
  participant W as WORLD
  C->>U: normalizePoint(pt)
  U-->>C: { x y }
  C->>P: use normalized points in polygon math
  C->>W: use normalized points in world conversions
```

Edge cases and defaults
- getPointY
  - Returns nil when pt is nil.
  - Returns pt.y if present; otherwise pt.z.
- normalizePoint
  - Returns { x 0, y 0 } when pt is nil.
  - x defaults to 0 when missing.
  - y uses pt.y when present, else falls back to pt.z, else 0.

Source anchors
- [AETHR.UTILS:getPointY()](../../dev/UTILS.lua:129)
- [AETHR.UTILS:normalizePoint()](../../dev/UTILS.lua:137)