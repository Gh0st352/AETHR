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
- Master diagrams index: [docs/README.md](docs/README.md)
- ZONE_MANAGER: [docs/zone_manager/README.md](../zone_manager/README.md)
- WORLD: [docs/world/README.md](../world/README.md)

Overview relationships

```mermaid
flowchart LR
  MF[markFreeform] --> DP[drawPolygon]
  MA[markArrow] --> DA[drawArrow]
  MC[markCircle] --> DC[drawCircle]
  GC[drawGenericCircle] --> DC
  DP -.-> TRIG[trigger.action.markupToAll]
  DA -.-> TRIG
  DC -.-> CIRC[trigger.action.circleToAll]
  RM[removeMarksByID] -.-> DEL[trigger.action.removeMark]
```

Freeform polygon flow

```mermaid
flowchart TD
  IN[_Marker with verts] --> NORM[normalize vertices]
  NORM --> ARGS[build arguments list]
  ARGS --> CALL[trigger.action.markupToAll]
  CALL --> STORE[optional store marker]
```

Arrow flow

```mermaid
flowchart TD
  IN2[_Marker with 2 points] --> NORM2[normalize points]
  NORM2 --> ARGS2[build arguments list]
  ARGS2 --> CALL2[trigger.action.markupToAll]
  CALL2 --> STORE2[optional store marker]
```

Circle flow

```mermaid
flowchart LR
  IN3[_Marker vec2Origin radius] --> ARGS3[build arguments list]
  ARGS3 --> CALL3[trigger.action.circleToAll]
  CALL3 --> STORE3[optional store marker]
```

Runtime sequence for drawing polygon

```mermaid
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

Remove marks sequence

```mermaid
sequenceDiagram
  participant M as MARKERS
  participant T as trigger.action
  alt table of ids
    M->>T: removeMark(id) for each entry
  else single id
    M->>T: removeMark(id)
  end
```

Key anchors
- Freeform: [AETHR.MARKERS:markFreeform()](../../dev/MARKERS.lua:43), [AETHR.MARKERS:drawPolygon()](../../dev/MARKERS.lua:85)
- Arrow: [AETHR.MARKERS:markArrow()](../../dev/MARKERS.lua:139), [AETHR.MARKERS:drawArrow()](../../dev/MARKERS.lua:176)
- Circle: [AETHR.MARKERS:markCircle()](../../dev/MARKERS.lua:229), [AETHR.MARKERS:drawCircle()](../../dev/MARKERS.lua:269), [AETHR.MARKERS:drawGenericCircle()](../../dev/MARKERS.lua:299)
- Removal: [AETHR.MARKERS:removeMarksByID()](../../dev/MARKERS.lua:318)

Notes
- Mermaid labels avoid double quotes and parentheses.
- All diagrams use GitHub Mermaid fenced blocks.