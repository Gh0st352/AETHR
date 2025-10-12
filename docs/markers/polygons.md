# MARKERS polygons and freeform

Freeform polygon drawing and its convenience wrapper. Documents [AETHR.MARKERS:markFreeform()](../../dev/MARKERS.lua:43) and [AETHR.MARKERS:drawPolygon()](../../dev/MARKERS.lua:85), including varargs normalization, vertex order, color packing, and trigger calls.

Primary anchors

- Wrapper freeform: [AETHR.MARKERS:markFreeform()](../../dev/MARKERS.lua:43)
- Draw polygon core: [AETHR.MARKERS:drawPolygon()](../../dev/MARKERS.lua:85)

Overview flow

```mermaid
flowchart LR
  MF[markFreeform] --> DP[drawPolygon]
  DP --> TA[trigger action markupToAll]
  MF --> ST[optional store marker]
```

markFreeform behavior

- Guards on _Marker table
- Fields with defaults
  - coalition default -1
  - fillColor and lineColor defaults to black with alpha 0
  - lineType default 0
  - markID default 0
  - freeFormVec2Table passed as verts
- Calls [drawPolygon](../../dev/MARKERS.lua:85) then optionally stores _Marker by markID into storageLocation

Varargs normalization

```mermaid
flowchart TD
  VARARGS[varargs] --> ONE{single table arg}
  ONE -->|yes and not vec2| USE[list is varargs 1]
  ONE -->|no| USE2[list is varargs]
  USE --> CORNERS[corners assigned]
  USE2 --> CORNERS
```

- Single array like table of vec2 is accepted
- Or multiple vec2 arguments are accepted

Vertex order reversal

```mermaid
flowchart LR
  IN[corners array] --> REV[reverse iteration]
  REV --> V3[push vec3 x z from vec2 x y]
  V3 --> ARGS[build argument list]
```

- For polygons, vertices are pushed in reverse order to preserve original orientation from prior flows
- Each vec2 v yields vec3 { x v.x, y 0, z v.y }

Color and type packing

```mermaid
flowchart TD
  FILL[fillColor r g b a] --> C1[pack array r g b a]
  BORDER[borderColor r g b a] --> C2[pack array r g b a]
  TYPE[lineType] --> ARGTYPE
  MT[MarkerTypes Freeform] --> SHAPE
```

- Border color is inserted before fill color per API order used by draw functions
- Shape type id uses MarkerTypes Freeform

Sequence

```mermaid
sequenceDiagram
  participant M as MARKERS
  participant E as ENUMS
  participant T as trigger action
  M->>M: markFreeform _Marker storage
  M->>M: drawPolygon coal fill border type id verts
  M-->>E: MarkerTypes Freeform
  M->>T: markupToAll shape coal id vecs border fill type true
  opt store marker
    M-->>M: storageLocation[markID] = _Marker
  end
```

Arguments layout for markupToAll

- shapeTypeID, coalition, markerID
- vec3 points in order
- border color array
- fill color array
- line type
- true

Validation checklist

- Wrapper: [dev/MARKERS.lua](../../dev/MARKERS.lua:43)
- Draw core: [dev/MARKERS.lua](../../dev/MARKERS.lua:85)
- Reverse order push loop: [dev/MARKERS.lua](../../dev/MARKERS.lua:117)
- Color packing and final call: [dev/MARKERS.lua](../../dev/MARKERS.lua:122)

Related breakouts

- Arrows wrapper and draw: [arrows.md](./arrows.md)
- Circles and generic circle: [circles.md](./circles.md)
- Removal helpers: [removal.md](./removal.md)

Conventions

- Mermaid fenced blocks with GitHub parser
- Labels avoid double quotes and parentheses inside bracket text
- All links use relative paths for portability