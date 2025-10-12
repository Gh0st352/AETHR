# TYPES colors, markers, and grid

Anchors
- [AETHR._ColorRGBA:New()](../../dev/customTypes.lua:27)
- [AETHR._Marker:New()](../../dev/customTypes.lua:375)
- [AETHR._Grid:New()](../../dev/customTypes.lua:330)

Overview
- _ColorRGBA is an RGBA struct using 0..255 channels, defaulting to 0.
- _Marker encapsulates drawing primitives compatible with DCS map markup, including style and geometry fields.
- _Grid provides precomputed step and inverse step for fast cell indexing in spatial maps.

Mermaid flow overview
```mermaid
flowchart TD
  CALLER[Caller] --> C[_ColorRGBA New]
  CALLER --> M[_Marker New]
  CALLER --> G[_Grid New]

  C --> Cr[r default 0]
  C --> Cg[g default 0]
  C --> Cb[b default 0]
  C --> Ca[a default 0]

  M --> Mid[markID]
  M --> Mstr[label string]
  M --> Morigin[vec2Origin]
  M --> Mro[readOnly default true]
  M --> Mmsg[message]
  M --> Mshape[shapeId]
  M --> Mcoal[coalition]
  M --> Mlt[lineType]
  M --> Mlc[lineColor]
  M --> Mfc[fillColor]
  M --> Mverts[freeFormVec2Table]
  M --> Mrad[radius]

  G --> Gorg[minX minZ]
  G --> Gstep[dx dz]
  G --> Ginv[invDx invDz]
  G --> Gcorners[corners]
```

Marker structure and defaults
- Field defaults in constructor:
  - markID as provided
  - string and label default to empty
  - vec2Origin defaults to {} if not supplied
  - readOnly defaults to true when nil
  - shapeId and lineType default to 0
  - coalition defaults to -1
  - lineColor and fillColor default to { 0, 0, 0, 0 }
  - freeFormVec2Table defaults to {}
  - radius defaults to 0

Typical marker creation sequence
```mermaid
sequenceDiagram
  participant C as Caller
  participant T as _Marker
  C->>T: New(markID, label, origin, readOnly, message, shapeId, coalition, lineType, lineColor, fillColor, verts, radius)
  T-->>C: marker instance with style and geometry fields
```

Grid initialization sequence
```mermaid
sequenceDiagram
  participant C as Caller
  participant G as _Grid
  C->>G: New(corners, minX, maxZ, dx, dz)
  G-->>C: instance with invDx invDz cached and minZ stored from input maxZ
```

Source anchors
- [AETHR._ColorRGBA:New()](../../dev/customTypes.lua:27)
- [AETHR._Marker:New()](../../dev/customTypes.lua:375)
- [AETHR._Grid:New()](../../dev/customTypes.lua:330)
- Related types: [AETHR._vec2:New()](../../dev/customTypes.lua:522), [AETHR._ColorRGBA fields](../../dev/customTypes.lua:15)