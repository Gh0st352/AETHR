# POLY rays midpoints and slopes

Ray intersection against axis aligned bounds, segment midpoints, and line slopes.

Source anchors
- [AETHR.POLY:intersectRayToBounds()](../../dev/POLY.lua:1491)
- [AETHR.POLY:getMidpoint()](../../dev/POLY.lua:1171)
- [AETHR.POLY:calculateLineSlope()](../../dev/POLY.lua:1188)

Overview
- intersectRayToBounds computes the nearest positive intersection between a ray pt plus t dir and AABB bounds in XZ space using epsilon guards
- getMidpoint returns the average of segment endpoints
- calculateLineSlope returns dy over dx with vertical line handling returning math.huge

intersectRayToBounds flow

```mermaid
flowchart TD
  IN[pt dir bounds] --> CAND[empty candidate list]
  CAND --> XE{abs dir.x gt eps}
  XE -->|yes| XEDGES[for edges X min and max]
  XEDGES --> XT[t equals edgeX minus pt.x over dir.x]
  XT --> XY[y equals pt.y plus t dir.y]
  XY --> XR[in bounds Z min..max]
  XR --> ADDX[push candidate t edgeX y]
  XE -->|no| ZCHECK[skip X edges]
  CAND --> ZE{abs dir.y gt eps}
  ZE -->|yes| ZEDGES[for edges Z min and max]
  ZEDGES --> ZT[t equals edgeZ minus pt.y over dir.y]
  ZT --> ZX[x equals pt.x plus t dir.x]
  ZX --> ZR[in bounds X min..max]
  ZR --> ADDZ[push candidate t x edgeZ]
  ZE -->|no| DONE0[no Z edges]
  ADDX --> DONE1[collect]
  ADDZ --> DONE1
  DONE1 --> SORT[sort candidates by ascending t]
  SORT --> RET{any}
  RET -->|yes| OUT[return first candidate x y]
  RET -->|no| NONE[return nil]
```

Midpoint and slope flows

```mermaid
flowchart TD
  M1[line] --> M2[midpoint x equals x1 plus x2 over 2]
  M1 --> M3[midpoint y equals y1 plus y2 over 2]
  M2 --> MOUT[return midpoint]
  M3 --> MOUT
```

```mermaid
flowchart TD
  S1[line] --> DX[dx equals x2 minus x1]
  DX --> VERT{dx eq 0}
  VERT -->|yes| INF[return math.huge]
  VERT -->|no| DY[dy equals y2 minus y1]
  DY --> DIV[slope equals dy over dx]
  DIV --> SOUT[return slope]
```

Sequence usage

```mermaid
sequenceDiagram
  participant W as WORLD
  participant P as POLY
  W->>P: intersectRayToBounds pt dir bounds
  P-->>W: nearest intersection or nil
  W->>P: getMidpoint line
  P-->>W: midpoint
  W->>P: calculateLineSlope line
  P-->>W: slope or math.huge
```

Implementation notes
- intersectRayToBounds
  - Epsilon eps equals 1e minus 12 avoids near parallel division; only positive t considered
  - X edge tests ensure the resulting y lies within Z bounds range; Z edge tests mirror this
  - Chooses the lowest positive t among all valid candidates
- calculateLineSlope returns math.huge for vertical lines to preserve consistency with geometric helpers requiring a numeric sentinel
- getMidpoint is a simple arithmetic average and is used by utilities and visual features

Validation checklist
- intersectRayToBounds: [dev/POLY.lua](../../dev/POLY.lua:1491)
- getMidpoint: [dev/POLY.lua](../../dev/POLY.lua:1171)
- calculateLineSlope: [dev/POLY.lua](../../dev/POLY.lua:1188)

Related docs
- Distance and offset: [docs/poly/distance_projection_and_offset.md](./distance_projection_and_offset.md)
- Convert and order: [docs/poly/convert_and_order.md](./convert_and_order.md)

Conventions
- Mermaid fenced blocks use GitHub Mermaid parser
- Labels inside brackets avoid double quotes and parentheses
- Links use relative paths for repository portability