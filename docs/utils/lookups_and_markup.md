# UTILS lookups and markup

Anchors
- [AETHR.UTILS.safe_lookup()](../../dev/UTILS.lua:170)
- [AETHR.UTILS:updateMarkupColors()](../../dev/UTILS.lua:188)

Overview
- safe_lookup resolves dotted global paths like A.B.C against _G with guards, returning a fallback if any step fails.
- updateMarkupColors wraps DCS trigger.action color functions for line and fill and returns self for chaining.

Dotted path resolution
```mermaid
flowchart TD
  IN[path fallback] --> CUR[start at _G]
  CUR --> STEP[read next part]
  STEP --> TYPE[is table]
  TYPE -->|no| OUT[fallback]
  TYPE -->|yes| ADV[advance cur to cur part]
  ADV --> NIL[cur is nil]
  NIL -->|yes| OUT
  NIL -->|no| STEP
  STEP -->|end| VAL[return value]
```

Markup color update sequence
```mermaid
sequenceDiagram
  participant U as UTILS
  participant TA as trigger.action
  U->>TA: setMarkupColor(markupID lineColor)
  U->>TA: setMarkupColorFill(markupID fillColor)
  U-->>U: return self
```

Usage notes
- safe_lookup is read only and never throws; it stops early on non table intermediates or nil members.
- updateMarkupColors expects AETHR.CONFIG compatible color tables and assumes trigger.action bindings are available.

Source anchors
- [AETHR.UTILS.safe_lookup()](../../dev/UTILS.lua:170)
- [AETHR.UTILS:updateMarkupColors()](../../dev/UTILS.lua:188)