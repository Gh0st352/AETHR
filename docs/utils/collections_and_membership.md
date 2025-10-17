# UTILS collections and membership

Anchors
- [AETHR.UTILS.sumTable()](../../dev/UTILS.lua:42)
- [AETHR.UTILS:hasValue()](../../dev/UTILS.lua:147)
- [AETHR.UTILS:table_hasValue()](../../dev/UTILS.lua:162)

Overview
- sumTable counts keys in a table using pairs iteration; useful for sparse maps.
- hasValue performs a linear search for a value using pairs; returns true on first match.
- table_hasValue is a backward compatible alias that forwards to hasValue.

# Counting and membership flows
```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
subgraph "sumTable"
  TBL[input table] --> SUM[sumTable]
  SUM --> LOOP[pairs iteration]
  LOOP --> CNT[increment counter]
  CNT --> LOOP
  LOOP --> OUT[count]
end

subgraph "hasValue"
  TBL2[input table] --> HV[hasValue]
  HV --> ITER[pairs iteration]
  ITER --> EQ{value equals target?}
  EQ -- "yes" --> TRUE[return true]
  EQ -- "no" --> ITER
  ITER -- "end" --> FALSE[return false]
end

class TBL,TBL2 class_io;
class SUM,HV class_compute;
class LOOP,ITER class_step;
class CNT class_compute;
class OUT,TRUE,FALSE class_result;
```

# Alias mapping
```mermaid
%% shared theme: docs/_mermaid/theme.json %%
sequenceDiagram
  participant U as UTILS
  U->>U: table_hasValue(tbl, val)
  U-->>U: return hasValue(tbl, val)
```

# Usage notes
- sumTable counts non nil keys; order is unspecified due to pairs traversal.
- hasValue compares via Lua equality; for deep comparisons consider a custom predicate.
- table_hasValue exists for legacy callers and should not be extended differently from hasValue.

# Source anchors
- [AETHR.UTILS.sumTable()](../../dev/UTILS.lua:42)
- [AETHR.UTILS:hasValue()](../../dev/UTILS.lua:147)
- [AETHR.UTILS:table_hasValue()](../../dev/UTILS.lua:162)

Last updated: 2025-10-16