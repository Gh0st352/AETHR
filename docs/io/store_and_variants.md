# IO store variants and multiref encoding

Persist multiple Lua values to disk with reference deduplication. Covers [AETHR.IO.store()](https://github.com/Gh0st352/AETHR/blob/main/dev/IO.lua#L63) and [AETHR.IO.storeNoFunc()](https://github.com/Gh0st352/AETHR/blob/main/dev/IO.lua#L134), the multiref table construction, and the writer dispatch helpers.

Primary anchors

- Store: [AETHR.IO.store()](https://github.com/Gh0st352/AETHR/blob/main/dev/IO.lua#L63)
- Store no function: [AETHR.IO.storeNoFunc()](https://github.com/Gh0st352/AETHR/blob/main/dev/IO.lua#L134)
- Reference counter: [refCount](https://github.com/Gh0st352/AETHR/blob/main/dev/IO.lua#L401)
- Writer dispatch: [write](https://github.com/Gh0st352/AETHR/blob/main/dev/IO.lua#L337), [writeNoFunc](https://github.com/Gh0st352/AETHR/blob/main/dev/IO.lua#L349), [writeIndent](https://github.com/Gh0st352/AETHR/blob/main/dev/IO.lua#L377)
- Writers: [writers](https://github.com/Gh0st352/AETHR/blob/main/dev/IO.lua#L422), [writersNoFunc](https://github.com/Gh0st352/AETHR/blob/main/dev/IO.lua#L488)

# High level flow

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart LR
  subgraph "High level store flow"
    IN[values ...] --> CNT[count refs with refCount]
    CNT --> MREF[assign ids in objRefNames]
    MREF --> HDR[write header and multiRefObjects]
    HDR --> FILL[fill multiref tables]
    FILL --> REST[emit remaining objects local objN = ...]
    REST --> RET[return list of objects]
    RET --> DONE[close file]
  end

  class IN class_data;
  class CNT class_tracker;
  class MREF,HDR,FILL,REST class_step;
  class RET class_result;
  class DONE class_io;
```

# Multiref construction logic

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  subgraph "Multiref construction"
    V[each input value] --> RC[refCount traverse]
    RC --> MAP[objRefCount]
    MAP --> SEL{count > 1}
    SEL -->|yes| IDX[assign id in objRefNames]
    SEL -->|no| NEXT[next]
    IDX --> NEXT
    NEXT --> OUT[multiRefObjects header]
  end

  class V class_data;
  class RC class_tracker;
  class MAP class_step;
  class SEL class_decision;
  class IDX,NEXT class_step;
  class OUT class_io;
```

- [refCount](https://github.com/Gh0st352/AETHR/blob/main/dev/IO.lua#L401) traverses tables recursively and counts references
- Tables with count greater than 1 receive an index in objRefNames and an empty table slot in multiRefObjects

# Writer selection

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart LR
  subgraph "Writer selection"
    IT[item by type] --> DISP[writers type]
    DISP --> EMIT[file write]
    NOTE[no func variant] --> NDISP[writersNoFunc type]
  end

  class IT class_data;
  class DISP class_step;
  class EMIT class_io;
  class NOTE,NDISP class_step;
```

- [write](https://github.com/Gh0st352/AETHR/blob/main/dev/IO.lua#L337) selects from [writers](https://github.com/Gh0st352/AETHR/blob/main/dev/IO.lua#L422) by Lua type
- [writeNoFunc](https://github.com/Gh0st352/AETHR/blob/main/dev/IO.lua#L349) selects from [writersNoFunc](https://github.com/Gh0st352/AETHR/blob/main/dev/IO.lua#L488) that replaces function values with placeholders
- Functions with upvalues or non Lua are emitted as nil markers in writers

# Store sequence

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
sequenceDiagram
  participant U as caller
  participant IO as IO.store
  U->>IO: store path values...
  IO->>IO: open file w
  IO->>IO: count refs and build objRefNames
  IO->>IO: write multiRefObjects header
  IO->>IO: fill multiRefObjects tables
  IO->>IO: write local objN blocks
  IO-->>U: return or error on open
```

# StoreNoFunc differences

- Uses [writeNoFunc](https://github.com/Gh0st352/AETHR/blob/main/dev/IO.lua#L349) to avoid serializing functions
- Places explicit INTENDEDSKIP markers in the serialized output via [writersNoFunc function handler](https://github.com/Gh0st352/AETHR/blob/main/dev/IO.lua#L528)

# Edge cases and errors

- File open failure yields error via return error(e) inside [store](https://github.com/Gh0st352/AETHR/blob/main/dev/IO.lua#L63) and [storeNoFunc](https://github.com/Gh0st352/AETHR/blob/main/dev/IO.lua#L134)
- Circular references are handled by multiref encoding and refCount traversal

# Validation checklist

- Store: [dev/IO.lua](https://github.com/Gh0st352/AETHR/blob/main/dev/IO.lua#L63)
- StoreNoFunc: [dev/IO.lua](https://github.com/Gh0st352/AETHR/blob/main/dev/IO.lua#L134)
- Reference counter: [dev/IO.lua](https://github.com/Gh0st352/AETHR/blob/main/dev/IO.lua#L401)
- Writers: [dev/IO.lua](https://github.com/Gh0st352/AETHR/blob/main/dev/IO.lua#L422), [dev/IO.lua](https://github.com/Gh0st352/AETHR/blob/main/dev/IO.lua#L488)

# Related breakouts

- Load and deSerialize: [load_and_deserialize.md](./load_and_deserialize.md)
- Writers and refcount: [writers_and_refcount.md](./writers_and_refcount.md)
- Serialize to string: see [load_and_deserialize.md](./load_and_deserialize.md) for deSerialize pairing