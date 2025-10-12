# MARKERS arrows

Arrow drawing wrapper and core function. Documents [AETHR.MARKERS:markArrow()](../../dev/MARKERS.lua:139) and [AETHR.MARKERS:drawArrow()](../../dev/MARKERS.lua:176), including varargs normalization, color packing, and trigger calls.

Primary anchors

- Wrapper arrow: [AETHR.MARKERS:markArrow()](../../dev/MARKERS.lua:139)
- Draw arrow core: [AETHR.MARKERS:drawArrow()](../../dev/MARKERS.lua:176)

Overview flow

```mermaid
flowchart LR
  MA[markArrow] --> DA[drawArrow]
  DA --> TA[trigger action markupToAll]
  MA --> ST[optional store marker]
```

markArrow behavior

- Guards on _Marker table
- Defaults
  - coalition -1
  - fillColor and lineColor default black with alpha 0
  - lineType 0
  - markID 0
  - freeFormVec2Table used as two point list
- Calls [drawArrow](../../dev/MARKERS.lua:176) then optionally stores _Marker by markID

Varargs normalization

```mermaid
flowchart TD
  VAR[varargs] --> ONE{single table arg}
  ONE -->|yes and not vec2| ASLIST[corners = varargs 1]
  ONE -->|no| ASVAR[corners = varargs]
  ASLIST --> OUT[corners]
  ASVAR --> OUT
```

- Accepts either a single array like table of vec2 or two vec2 arguments
- Requires exactly 2 points; returns early otherwise

Argument packing

```mermaid
flowchart TD
  PTS[corners 2 points] --> VEC3[push vec3 x z from vec2 x y]
  VEC3 --> COLORS[pack border then fill color]
  COLORS --> TYPE[lineType append]
  TYPE --> CALL[markupToAll]
```

- Arrow uses MarkerTypes Arrow as shape identifier
  - shapeTypeID = [AETHR.ENUMS.MarkerTypes.Arrow](../../dev/ENUMS.lua:465)
- Note: Unlike polygon, arrow points are inserted in forward order (no reverse)

Sequence

```mermaid
sequenceDiagram
  participant M as MARKERS
  participant E as ENUMS
  participant T as trigger action
  M->>M: markArrow _Marker storage
  M->>M: drawArrow coal fill border type id p1 p2
  M-->>E: MarkerTypes Arrow
  M->>T: markupToAll shape coal id p1 p2 border fill type true
  opt store marker
    M-->>M: storageLocation[markID] = _Marker
  end
```

Validation checklist

- Wrapper: [dev/MARKERS.lua](../../dev/MARKERS.lua:139)
- Draw core: [dev/MARKERS.lua](../../dev/MARKERS.lua:176)
- Packing and call: [dev/MARKERS.lua](../../dev/MARKERS.lua:213)

Related breakouts

- Polygons and freeform: [polygons.md](./polygons.md)
- Circles and generic circle: [circles.md](./circles.md)
- Removal helpers: [removal.md](./removal.md)

Conventions

- Mermaid fenced blocks with GitHub parser
- Labels avoid double quotes and parentheses inside bracket text
- All links use relative paths for portability