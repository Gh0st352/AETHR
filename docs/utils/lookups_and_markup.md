# UTILS lookups and markup

Anchors
- [AETHR.UTILS.safe_lookup()](https://github.com/Gh0st352/AETHR/blob/main/dev/UTILS.lua#L170)
- [AETHR.UTILS:updateMarkupColors()](https://github.com/Gh0st352/AETHR/blob/main/dev/UTILS.lua#L188)

Overview
- safe_lookup resolves dotted global paths like A.B.C against _G with guards, returning a fallback if any step fails.
- updateMarkupColors wraps DCS trigger.action color functions for line and fill and returns self for chaining.

# Dotted path resolution
```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD

subgraph "Traversal"
  IN[path, fallback] --> CUR[start at _G]
  CUR --> STEP[next part]
  STEP --> OK{cur is table?}
  OK -- "no" --> OUT[fallback]
  OK -- "yes" --> ADV[advance cur to cur.part]
  ADV --> NIL{cur is nil?}
  NIL -- "yes" --> OUT
  NIL -- "no" --> STEP
  STEP -- "end" --> VAL[return value]
end

class IN class_io;
class CUR class_data;
class STEP class_step;
class OK,NIL class_decision;
class ADV class_compute;
class OUT,VAL class_result;
```

# Markup color update sequence
```mermaid
%% shared theme: docs/_mermaid/theme.json %%
sequenceDiagram
  participant U as UTILS
  participant TA as trigger.action
  U->>TA: setMarkupColor(markupID, lineColor)
  U->>TA: setMarkupColorFill(markupID, fillColor)
  U-->>U: return self
```

# Usage notes
- safe_lookup is read only and never throws; it stops early on non table intermediates or nil members.
- updateMarkupColors expects AETHR.CONFIG compatible color tables and assumes trigger.action bindings are available.

# Source anchors
- [AETHR.UTILS.safe_lookup()](https://github.com/Gh0st352/AETHR/blob/main/dev/UTILS.lua#L170)
- [AETHR.UTILS:updateMarkupColors()](https://github.com/Gh0st352/AETHR/blob/main/dev/UTILS.lua#L188)

Last updated: 2025-10-16