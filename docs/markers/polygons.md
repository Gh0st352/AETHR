# MARKERS polygons and freeform

Freeform polygon drawing and its convenience wrapper. Documents [AETHR.MARKERS:markFreeform()](https://github.com/Gh0st352/AETHR/blob/main/dev/MARKERS.lua#L43) and [AETHR.MARKERS:drawPolygon()](https://github.com/Gh0st352/AETHR/blob/main/dev/MARKERS.lua#L85), including varargs normalization, vertex order, color packing, and trigger calls.

Primary anchors

- Wrapper freeform: [AETHR.MARKERS:markFreeform()](https://github.com/Gh0st352/AETHR/blob/main/dev/MARKERS.lua#L43)
- Draw polygon core: [AETHR.MARKERS:drawPolygon()](https://github.com/Gh0st352/AETHR/blob/main/dev/MARKERS.lua#L85)

# Overview flow

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart LR
  subgraph "Wrapper and Draw"
    MF[markFreeform] --> DP[drawPolygon]
    MF --> ST[optional store marker]
  end
  DP --> TA[trigger action markupToAll]
  class MF,ST class_step;
  class DP class_compute;
  class TA class_io;
```

# markFreeform behavior

- Guards on _Marker table
- Fields with defaults
  - coalition default -1
  - fillColor and lineColor defaults to black with alpha 0
  - lineType default 0
  - markID default 0
  - freeFormVec2Table passed as verts
- Calls [drawPolygon](https://github.com/Gh0st352/AETHR/blob/main/dev/MARKERS.lua#L85) then optionally stores _Marker by markID into storageLocation

# Varargs normalization

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  subgraph "Varargs Normalization"
    VARARGS[varargs] --> ONE{single table arg}
    ONE -->|yes and not vec2| USE[list is varargs 1]
    ONE -->|no| USE2[list is varargs]
    USE --> CORNERS[corners assigned]
    USE2 --> CORNERS
  end
  class VARARGS class_io;
  class ONE class_decision;
  class USE,USE2,CORNERS class_compute;
```

- Single array like table of vec2 is accepted
- Or multiple vec2 arguments are accepted

# Vertex order reversal

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart LR
  subgraph "Vertex Reversal"
    IN[corners array] --> REV[reverse iteration]
    REV --> V3[push vec3 x z from vec2 x y]
    V3 --> ARGS[build argument list]
  end
  class IN class_data;
  class REV class_compute;
  class V3,ARGS class_data;
```

- For polygons, vertices are pushed in reverse order to preserve original orientation from prior flows
- Each vec2 v yields vec3 { x v.x, y 0, z v.y }

# Color and type packing

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  subgraph "Color and Type Packing"
    FILL[fillColor r g b a] --> C1[pack array r g b a]
    BORDER[borderColor r g b a] --> C2[pack array r g b a]
    TYPE[lineType] --> ARGTYPE
    MT[MarkerTypes Freeform] --> SHAPE
  end
  class FILL,BORDER class_data;
  class C1,C2,ARGTYPE class_compute;
  class TYPE class_step;
  class MT,SHAPE class_io;
```

- Border color is inserted before fill color per API order used by draw functions
- Shape type id uses MarkerTypes Freeform

# Sequence

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
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

# Arguments layout for markupToAll

- shapeTypeID, coalition, markerID
- vec3 points in order
- border color array
- fill color array
- line type
- true

# Validation checklist

- Wrapper: [dev/MARKERS.lua](https://github.com/Gh0st352/AETHR/blob/main/dev/MARKERS.lua#L43)
- Draw core: [dev/MARKERS.lua](https://github.com/Gh0st352/AETHR/blob/main/dev/MARKERS.lua#L85)
- Reverse order push loop: [dev/MARKERS.lua](https://github.com/Gh0st352/AETHR/blob/main/dev/MARKERS.lua#L117)
- Color packing and final call: [dev/MARKERS.lua](https://github.com/Gh0st352/AETHR/blob/main/dev/MARKERS.lua#L122)

# Related breakouts

- Arrows wrapper and draw: [arrows.md](./arrows.md)
- Circles and generic circle: [circles.md](./circles.md)
- Removal helpers: [removal.md](./removal.md)

# Conventions

- Mermaid fenced blocks with GitHub parser
- Labels avoid double quotes and parentheses inside bracket text
- All links use relative paths for portability