# AETHR IO diagrams and flows

Primary anchors
- [AETHR.IO.dump()](https://github.com/Gh0st352/AETHR/blob/main/dev/IO.lua#L35)
- [AETHR.IO.store()](https://github.com/Gh0st352/AETHR/blob/main/dev/IO.lua#L63)
- [AETHR.IO.storeNoFunc()](https://github.com/Gh0st352/AETHR/blob/main/dev/IO.lua#L134)
- [AETHR.IO.serializeNoFunc()](https://github.com/Gh0st352/AETHR/blob/main/dev/IO.lua#L199)
- [AETHR.IO.deSerialize()](https://github.com/Gh0st352/AETHR/blob/main/dev/IO.lua#L281)
- [AETHR.IO.load()](https://github.com/Gh0st352/AETHR/blob/main/dev/IO.lua#L310)

Related code anchors
- Writers dispatch: [write()](https://github.com/Gh0st352/AETHR/blob/main/dev/IO.lua#L337), [writeNoFunc()](https://github.com/Gh0st352/AETHR/blob/main/dev/IO.lua#L349), [writeSerialString()](https://github.com/Gh0st352/AETHR/blob/main/dev/IO.lua#L361)
- Writer tables: [writers](https://github.com/Gh0st352/AETHR/blob/main/dev/IO.lua#L422), [writersNoFunc](https://github.com/Gh0st352/AETHR/blob/main/dev/IO.lua#L488), [writersSerialString](https://github.com/Gh0st352/AETHR/blob/main/dev/IO.lua#L546)
- Helpers: [writeIndent()](https://github.com/Gh0st352/AETHR/blob/main/dev/IO.lua#L377), [writeIndentSerial()](https://github.com/Gh0st352/AETHR/blob/main/dev/IO.lua#L383), [refCount()](https://github.com/Gh0st352/AETHR/blob/main/dev/IO.lua#L401)
- FILEOPS usage: [AETHR.FILEOPS:saveData()](https://github.com/Gh0st352/AETHR/blob/main/dev/FILEOPS_.lua#L155), [AETHR.FILEOPS:loadData()](https://github.com/Gh0st352/AETHR/blob/main/dev/FILEOPS_.lua#L173)

Documents and indices
- Master diagrams index: [docs/README.md](../README.md)
- FILEOPS: [docs/fileops/README.md](../fileops/README.md)
- AETHR overview: [docs/aethr/README.md](../aethr/README.md)

## Breakout documents

- Store and variants: [store_and_variants.md](./store_and_variants.md)
- Load and deSerialize: [load_and_deserialize.md](./load_and_deserialize.md)
- Writers and refCount internals: [writers_and_refcount.md](./writers_and_refcount.md)
- Serialize NoFunc: [serialize_nofunc.md](./serialize_nofunc.md)
- Dump helper: [dump.md](./dump.md)

# Overview relationships

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart LR
  subgraph "Serialization"
    D[dump] --> S[store]
    SNF[store NoFunc] --> S
    SNZ[serialize NoFunc] --> OUT[Serialized string]
    S --> FS[Filesystem write]
  end

  subgraph "Deserialization"
    L[load] --> EXEC[execute loaded chunk]
    DS[deSerialize] --> EXEC
  end

  WRT[writers dispatch] -.-> S
  RC[refCount] -.-> S

  class D,S,SNF,SNZ,FS,L,DS,WRT,RC class_io;
  class EXEC class_compute;
  class OUT class_result;
```

# Serialization pipeline

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart LR
  IN[Input values] --> RC[refCount multi refs]
  RC --> MRO[multiRefObjects preallocate]
  MRO --> FILL[fill multiRefObjects]
  FILL --> OBJ[define obj1 to objN]
  OBJ --> RET[return obj results]
  RET --> OUT[Write to file]

  class IN class_data;
  class RC class_tracker;
  class MRO,FILL,OBJ class_step;
  class RET class_result;
  class OUT class_io;
```

# Writers dispatch resolution

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  ITEM[Item to serialize] --> TYPE[type of item]
  subgraph "Type cases"
    TYPE --> CASE_NIL[nil]
    TYPE --> CASE_NUM[number]
    TYPE --> CASE_STR[string]
    TYPE --> CASE_BOOL[boolean]
    TYPE --> CASE_TBL[table]
    TYPE --> CASE_FUNC[function]
    TYPE --> CASE_THREAD[thread]
    TYPE --> CASE_USER[userdata]
  end
  CASE_TBL --> REFCHK[has multiRef index]
  REFCHK -->|yes| MR[multiRef reference]
  REFCHK -->|no| TBLW[table braces and fields]

  class ITEM,TYPE class_data;
  class CASE_NIL,CASE_NUM,CASE_STR,CASE_BOOL,CASE_TBL,CASE_FUNC,CASE_THREAD,CASE_USER class_step;
  class REFCHK class_decision;
  class MR class_tracker;
  class TBLW class_step;
```

# Store sequence

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
sequenceDiagram
  participant IO as IO
  participant File as File handle
  IO->>File: open write path
  IO->>IO: refCount over inputs
  IO->>File: write multiRefObjects header
  IO->>File: write multiRefObjects fill
  IO->>File: write obj1 to objN
  IO-->>File: write return obj list
  IO->>File: close handle
```

# NoFunc variants and string serialization

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart LR
  SNF[store NoFunc] --> WRITENF[writersNoFunc]
  SNZ[Serialize NoFunc] --> WSS[writersSerialString]
  WRITENF --> OUTF[file]
  WSS --> OUTS[string]

  class SNF,SNZ,WRITENF,WSS,OUTF,OUTS class_io;
  class OUTS class_result;
```

# Deserialization and load flows

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart LR
  subgraph "DeSerialize path"
    DS[deSerialize] --> LOADCHUNK[loadstring]
    LOADCHUNK --> EXEC[execute]
  end

  subgraph "Load path"
    L[load] --> SRC[src path or stream]
    SRC --> LOADFILE[loadfile or read all]
    LOADFILE --> EXEC
  end

  EXEC --> RESULT[result values]

  class DS,LOADCHUNK,L,SRC,LOADFILE class_io;
  class EXEC class_compute;
  class RESULT class_result;
```

# Error and guard behavior

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  OPEN[open file] -->|fail| ERR[e return]
  OPEN --> OK[proceed]
  LOADFILE[load file] -->|fail| ERR2[nil and error]
  LOADFILE --> OK2[execute chunk]

  class OPEN,LOADFILE class_io;
  class ERR,ERR2 class_result;
  class OK,OK2 class_step;
```

# Key anchors
- Entry points
  - [AETHR.IO.store()](https://github.com/Gh0st352/AETHR/blob/main/dev/IO.lua#L63), [AETHR.IO.storeNoFunc()](https://github.com/Gh0st352/AETHR/blob/main/dev/IO.lua#L134), [AETHR.IO.serializeNoFunc()](https://github.com/Gh0st352/AETHR/blob/main/dev/IO.lua#L199)
  - [AETHR.IO.deSerialize()](https://github.com/Gh0st352/AETHR/blob/main/dev/IO.lua#L281), [AETHR.IO.load()](https://github.com/Gh0st352/AETHR/blob/main/dev/IO.lua#L310)
- Writers and helpers
  - [write()](https://github.com/Gh0st352/AETHR/blob/main/dev/IO.lua#L337), [writeNoFunc()](https://github.com/Gh0st352/AETHR/blob/main/dev/IO.lua#L349), [writeSerialString()](https://github.com/Gh0st352/AETHR/blob/main/dev/IO.lua#L361)
  - [writers](https://github.com/Gh0st352/AETHR/blob/main/dev/IO.lua#L422), [writersNoFunc](https://github.com/Gh0st352/AETHR/blob/main/dev/IO.lua#L488), [writersSerialString](https://github.com/Gh0st352/AETHR/blob/main/dev/IO.lua#L546)
  - [writeIndent()](https://github.com/Gh0st352/AETHR/blob/main/dev/IO.lua#L377), [writeIndentSerial()](https://github.com/Gh0st352/AETHR/blob/main/dev/IO.lua#L383), [refCount()](https://github.com/Gh0st352/AETHR/blob/main/dev/IO.lua#L401)

# Cross-module anchors
- FILEOPS persist and retrieve: [AETHR.FILEOPS:saveData()](https://github.com/Gh0st352/AETHR/blob/main/dev/FILEOPS_.lua#L155), [AETHR.FILEOPS:loadData()](https://github.com/Gh0st352/AETHR/blob/main/dev/FILEOPS_.lua#L173)

# Notes
- Mermaid labels avoid double quotes and parentheses to satisfy renderer constraints.
- All diagrams use GitHub Mermaid fenced blocks.