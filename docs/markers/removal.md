# MARKERS removal

Remove one or multiple map marks by id. Documents [AETHR.MARKERS:removeMarksByID()](https://github.com/Gh0st352/AETHR/blob/main/dev/MARKERS.lua#L318) behavior for single numeric id and table of ids, with guard conditions.

Primary anchor

- Remove marks: [AETHR.MARKERS:removeMarksByID()](https://github.com/Gh0st352/AETHR/blob/main/dev/MARKERS.lua#L318)

# Overview

- Accepts either:
  - a single marker id number
  - a table of ids as keys or numeric list
- Guards:
  - If markID is nil, returns self
  - If markID is a table and empty, returns self
- Calls trigger.action.removeMark(id) for each id

# Flow

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  subgraph "Entry and guards"
    IN[markID] --> NIL{nil}
    NIL -->|yes| RET[return self]
    NIL -->|no| ISTBL{type is table}
  end
  subgraph "Table handling"
    ISTBL -->|yes| SUM{table has entries}
    SUM -->|no| RET
    SUM -->|yes| LOOP[for each id in table]
    LOOP --> RM[trigger action removeMark id]
  end
  ISTBL -->|no| ONE[remove single id]
  ONE --> RM2[trigger action removeMark markID]
  class IN,RM2 class_io;
  class NIL,ISTBL,SUM class_decision;
  class LOOP,RM class_compute;
  class RET,ONE class_step;
```

# Sequence

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
sequenceDiagram
  participant M as MARKERS
  participant T as trigger action
  alt markID is table with entries
    loop each id
      M->>T: removeMark(id)
    end
  else markID is single id
    M->>T: removeMark(markID)
  end
```

# Usage notes

- Works with both key sets and array lists
- No error is raised on missing ids; DCS handles silently

# Validation checklist

- Entry point: [dev/MARKERS.lua](https://github.com/Gh0st352/AETHR/blob/main/dev/MARKERS.lua#L318)
- Table guard and loop: [dev/MARKERS.lua](https://github.com/Gh0st352/AETHR/blob/main/dev/MARKERS.lua#L322)
- Single id path: [dev/MARKERS.lua](https://github.com/Gh0st352/AETHR/blob/main/dev/MARKERS.lua#L329)

# Related breakouts

- Polygons and freeform: [polygons.md](./polygons.md)
- Arrows: [arrows.md](./arrows.md)
- Circles and generic circle: [circles.md](./circles.md)

# Conventions

- Mermaid fenced blocks with GitHub parser
- Labels avoid double quotes and parentheses inside bracket text
- All links use relative paths for portability