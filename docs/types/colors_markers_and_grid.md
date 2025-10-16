# TYPES colors, markers, and grid

Anchors
- [AETHR._ColorRGBA:New()](../../dev/customTypes.lua:27)
- [AETHR._Marker:New()](../../dev/customTypes.lua:375)
- [AETHR._Grid:New()](../../dev/customTypes.lua:330)

Overview
- _ColorRGBA is an RGBA struct using 0..255 channels, defaulting to 0.
- _Marker encapsulates drawing primitives compatible with DCS map markup, including style and geometry fields.
- _Grid provides precomputed step and inverse step for fast cell indexing in spatial maps.

# Mermaid flow overview
```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  CALLER[Caller]

  subgraph COLOR ["_ColorRGBA fields"]
    C[_ColorRGBA New]
    Cr[r default 0]
    Cg[g default 0]
    Cb[b default 0]
    Ca[a default 0]
    C --> Cr
    C --> Cg
    C --> Cb
    C --> Ca
  end

  subgraph MARKER ["_Marker fields"]
    M[_Marker New]
    Mid[markID]
    Mstr[label string]
    Morigin[vec2Origin]
    Mro[readOnly default true]
    Mmsg[message]
    Mshape[shapeId]
    Mcoal[coalition]
    Mlt[lineType]
    Mlc[lineColor]
    Mfc[fillColor]
    Mverts[freeFormVec2Table]
    Mrad[radius]
    M --> Mid
    M --> Mstr
    M --> Morigin
    M --> Mro
    M --> Mmsg
    M --> Mshape
    M --> Mcoal
    M --> Mlt
    M --> Mlc
    M --> Mfc
    M --> Mverts
    M --> Mrad
  end

  subgraph GRID ["_Grid fields"]
    G[_Grid New]
    Gorg[minX minZ]
    Gstep[dx dz]
    Ginv[invDx invDz]
    Gcorners[corners]
    G --> Gorg
    G --> Gstep
    G --> Ginv
    G --> Gcorners
  end

  CALLER --> C
  CALLER --> M
  CALLER --> G

  class C,Cr,Cg,Cb,Ca,M,Mid,Mstr,Morigin,Mro,Mmsg,Mshape,Mcoal,Mlt,Mlc,Mfc,Mverts,Mrad,G,Gorg,Gstep,Ginv,Gcorners,COLOR,MARKER,GRID,CALLER class_data;
```

# Marker structure and defaults
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

## Typical marker creation sequence
```mermaid
%% shared theme: docs/_mermaid/theme.json %%
sequenceDiagram
  participant C as Caller
  participant T as _Marker
  C->>T: New(markID, label, origin, readOnly, message, shapeId, coalition, lineType, lineColor, fillColor, verts, radius)
  T-->>C: marker instance with style and geometry fields
```

## Grid initialization sequence
```mermaid
%% shared theme: docs/_mermaid/theme.json %%
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