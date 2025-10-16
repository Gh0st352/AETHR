# FILEOPS deep copy helper

Cycle safe deep copy for arbitrary Lua tables, preserving nested structure and metatables.

# Primary anchor

- [AETHR.FILEOPS:deepcopy()](../../dev/FILEOPS_.lua:206)

# Overview

- Recursively copies tables and nested subtables
- Uses a visited map to break cycles and preserve graph structure
- Preserves metatables by deep copying the metatable and attaching it to the copy
- Non table values are returned as is primitive or reference

# Deep copy flow

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD

  %% Phases grouped with subgraphs
  subgraph TypeCheck["Type check"]
    S[input value] --> T{type is table}
    T -- "no" --> R[return value]
  end

  T -- "yes" --> TableBranch

  subgraph TableBranch["Table branch: copy and visit"]
    direction TB
    T --> V{visited exists}
    V -- "yes" --> RV[return visited copy]
    V -- "no" --> NC[new table copy]
    NC --> MAP["put obj->copy in visited"]
    MAP --> LOOP[for each k,v in pairs]
    LOOP --> DK[deepcopy key]
    DK --> DV[deepcopy value]
    DV --> SET["copy[nk] = nv"]
  end

  SET --> MT{has metatable}

  subgraph MetaBranch["Metatable handling"]
    direction TB
    MT -- "no" --> OUT[return copy]
    MT -- "yes" --> DMT[deepcopy metatable]
    DMT --> SMT["setmetatable(copy, mtcopy)"]
    SMT --> OUT
  end

  %% Assign classes; styling via shared theme (use underscore-style class names to match docs/_mermaid/theme.json)
  class T,V,MT class_decision;
  class DK,DV,SET,DMT,SMT,NC,MAP,LOOP class_compute;
  class S,R,RV,OUT class_data;
```

# Sequence illustration

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
sequenceDiagram
  participant C as deepcopy
  participant V as visited

  C->>C: check type
  alt non table
    C-->>C: return value
  else table
    C->>V: lookup obj
    alt found in visited
      V-->>C: existing copy
      C-->>C: return existing copy
    else not found
      C-->>C: create new copy
      C->>V: visited[obj] = copy
      loop iterate pairs
        C->>C: deepcopy key
        C->>C: deepcopy value
        C-->>C: set on copy
      end
      C->>C: deepcopy and set metatable if present
      C-->>C: return copy
    end
  end
```

# Usage notes

- Functions and userdata are copied by reference as values inside tables
- Keys are deep copied too which preserves structure if keys are tables
- Graphs with cycles or shared subtrees are preserved due to visited mapping

# Edge cases

- Sparse array tables retain their keys by iterating with pairs
- Metatable copy uses the same deepcopy routine so nested meta structures are handled
- If metatable enforces read only fields via __newindex, assignments during copy may trigger metamethods in user provided metas ensure your metas tolerate raw set via normal assignment

# Validation checklist

- Entry point: [dev/FILEOPS_.lua](../../dev/FILEOPS_.lua:206)

# Related breakouts

- Paths and ensure: [paths_and_ensure.md](./paths_and_ensure.md)
- Save and load: [save_and_load.md](./save_and_load.md)
- Chunking and tracker: [chunking.md](./chunking.md)