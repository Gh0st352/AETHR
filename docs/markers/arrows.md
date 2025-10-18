# MARKERS arrows

Arrow drawing wrapper and core function. Documents [AETHR.MARKERS:markArrow()](https://github.com/Gh0st352/AETHR/blob/main/dev/MARKERS.lua#L139) and [AETHR.MARKERS:drawArrow()](https://github.com/Gh0st352/AETHR/blob/main/dev/MARKERS.lua#L176), including varargs normalization, color packing, and trigger calls.

# Primary anchors

- Wrapper arrow: [AETHR.MARKERS:markArrow()](https://github.com/Gh0st352/AETHR/blob/main/dev/MARKERS.lua#L139)
- Draw arrow core: [AETHR.MARKERS:drawArrow()](https://github.com/Gh0st352/AETHR/blob/main/dev/MARKERS.lua#L176)

# Overview flow

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart LR
  subgraph "Wrapper and Draw"
    MA[markArrow] --> DA[drawArrow]
    MA --> ST[optional store marker]
  end
  DA --> TA[trigger action markupToAll]
  class MA,ST class_step;
  class DA class_compute;
  class TA class_io;
```

# markArrow behavior

- Guards on _Marker table
- Defaults
  - coalition -1
  - fillColor and lineColor default black with alpha 0
  - lineType 0
  - markID 0
  - freeFormVec2Table used as two point list
- Calls [drawArrow](https://github.com/Gh0st352/AETHR/blob/main/dev/MARKERS.lua#L176) then optionally stores _Marker by markID

# Varargs normalization

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  subgraph "Varargs Normalization"
    VAR[varargs] --> ONE{single table arg}
    ONE -->|yes and not vec2| ASLIST[corners = varargs 1]
    ONE -->|no| ASVAR[corners = varargs]
    ASLIST --> OUT[corners]
    ASVAR --> OUT
  end
  class VAR,OUT class_io;
  class ONE class_decision;
  class ASLIST,ASVAR class_compute;
```

- Accepts either a single array like table of vec2 or two vec2 arguments
- Requires exactly 2 points; returns early otherwise

# Argument packing

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  subgraph "Argument Packing"
    PTS[corners 2 points] --> VEC3[push vec3 x z from vec2 x y]
    VEC3 --> COLORS[pack border then fill color]
    COLORS --> TYPE[lineType append]
    TYPE --> CALL[markupToAll]
  end
  class PTS,VEC3 class_data;
  class COLORS class_compute;
  class CALL class_io;
```

- Arrow uses MarkerTypes Arrow as shape identifier
  - shapeTypeID = [AETHR.ENUMS.MarkerTypes.Arrow](https://github.com/Gh0st352/AETHR/blob/main/dev/ENUMS.lua#L465)
- Note: Unlike polygon, arrow points are inserted in forward order (no reverse)

# Sequence

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
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

# Validation checklist

- Wrapper: [dev/MARKERS.lua](https://github.com/Gh0st352/AETHR/blob/main/dev/MARKERS.lua#L139)
- Draw core: [dev/MARKERS.lua](https://github.com/Gh0st352/AETHR/blob/main/dev/MARKERS.lua#L176)
- Packing and call: [dev/MARKERS.lua](https://github.com/Gh0st352/AETHR/blob/main/dev/MARKERS.lua#L213)

# Related breakouts

- Polygons and freeform: [polygons.md](./polygons.md)
- Circles and generic circle: [circles.md](./circles.md)
- Removal helpers: [removal.md](./removal.md)

# Conventions

- Mermaid fenced blocks with GitHub parser
- Labels avoid double quotes and parentheses inside bracket text
- All links use relative paths for portability