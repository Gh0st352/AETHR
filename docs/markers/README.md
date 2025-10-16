# AETHR MARKERS diagrams and flows

Primary anchors
- [AETHR.MARKERS:markFreeform()](../../dev/MARKERS.lua:43)
- [AETHR.MARKERS:drawPolygon()](../../dev/MARKERS.lua:85)
- [AETHR.MARKERS:markArrow()](../../dev/MARKERS.lua:139)
- [AETHR.MARKERS:drawArrow()](../../dev/MARKERS.lua:176)
- [AETHR.MARKERS:markCircle()](../../dev/MARKERS.lua:229)
- [AETHR.MARKERS:drawCircle()](../../dev/MARKERS.lua:269)
- [AETHR.MARKERS:drawGenericCircle()](../../dev/MARKERS.lua:299)
- [AETHR.MARKERS:removeMarksByID()](../../dev/MARKERS.lua:318)

Related anchors
- ENUM constants: [AETHR.ENUMS.MarkerTypes](../../dev/ENUMS.lua:461), [AETHR.ENUMS.LineTypes](../../dev/ENUMS.lua:452)
- Update colors: [AETHR.UTILS:updateMarkupColors()](../../dev/UTILS.lua:188)

Documents and indices
- Master diagrams index: [docs/README.md](../README.md)
- ZONE_MANAGER: [docs/zone_manager/README.md](../zone_manager/README.md)
- WORLD: [docs/world/README.md](../world/README.md)

# Overview relationships

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart LR
  subgraph "Freeform Polygon"
    MF[markFreeform] --> DP[drawPolygon]
    DP -.-> TRIG[trigger.action.markupToAll]
  end
  subgraph "Arrow"
    MA[markArrow] --> DA[drawArrow]
    DA -.-> TRIG
  end
  subgraph "Circle"
    MC[markCircle] --> DC[drawCircle]
    GC[drawGenericCircle] --> MC
    DC -.-> CIRC[trigger.action.circleToAll]
  end
  subgraph "Removal"
    RM[removeMarksByID] -.-> DEL[trigger.action.removeMark]
  end
  class MF,MA,MC,RM class_step;
  class DP,DA,DC,GC class_compute;
  class TRIG,CIRC,DEL class_io;
```

# Freeform polygon flow

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  subgraph "Normalize and Pack"
    IN[_Marker with verts] --> NORM[normalize vertices]
    NORM --> ARGS[build arguments list]
    ARGS --> CALL[trigger.action.markupToAll]
  end
  CALL --> STORE[optional store marker]
  class IN class_data;
  class NORM,ARGS class_compute;
  class CALL class_io;
  class STORE class_step;
```

# Arrow flow

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  subgraph "Normalize and Pack"
    IN2[_Marker with 2 points] --> NORM2[normalize points]
    NORM2 --> ARGS2[build arguments list]
    ARGS2 --> CALL2[trigger.action.markupToAll]
  end
  CALL2 --> STORE2[optional store marker]
  class IN2 class_data;
  class NORM2,ARGS2 class_compute;
  class CALL2 class_io;
  class STORE2 class_step;
```

# Circle flow

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart LR
  subgraph "Pack Circle Args"
    IN3[_Marker vec2Origin radius] --> ARGS3[build arguments list]
    ARGS3 --> CALL3[trigger.action.circleToAll]
  end
  CALL3 --> STORE3[optional store marker]
  class IN3 class_data;
  class ARGS3 class_compute;
  class CALL3 class_io;
  class STORE3 class_step;
```

# Runtime sequence for drawing polygon

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
sequenceDiagram
  participant M as MARKERS
  participant U as UTILS
  participant E as ENUMS
  participant T as trigger.action
  M->>M: drawPolygon(coalition, fill, border, type, id, verts)
  M-->>E: MarkerTypes.Freeform, LineTypes
  M->>T: markupToAll(args...)
  opt recolor later
    M->>U: updateMarkupColors(markID, lineColor, fillColor)
  end
```

# Remove marks sequence

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
sequenceDiagram
  participant M as MARKERS
  participant T as trigger.action
  alt table of ids
    M->>T: removeMark(id) for each entry
  else single id
    M->>T: removeMark(id)
  end
```

# Key anchors
- Freeform: [AETHR.MARKERS:markFreeform()](../../dev/MARKERS.lua:43), [AETHR.MARKERS:drawPolygon()](../../dev/MARKERS.lua:85)
- Arrow: [AETHR.MARKERS:markArrow()](../../dev/MARKERS.lua:139), [AETHR.MARKERS:drawArrow()](../../dev/MARKERS.lua:176)
- Circle: [AETHR.MARKERS:markCircle()](../../dev/MARKERS.lua:229), [AETHR.MARKERS:drawCircle()](../../dev/MARKERS.lua:269), [AETHR.MARKERS:drawGenericCircle()](../../dev/MARKERS.lua:299)
- Removal: [AETHR.MARKERS:removeMarksByID()](../../dev/MARKERS.lua:318)

# Notes
- Mermaid labels avoid double quotes and parentheses.
- All diagrams use GitHub Mermaid fenced blocks.

## Breakout documents

- Polygons and freeform: [polygons.md](./polygons.md)
- Arrows: [arrows.md](./arrows.md)
- Circles and generic circle: [circles.md](./circles.md)
- Removal helpers: [removal.md](./removal.md)