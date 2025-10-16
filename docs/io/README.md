# AETHR IO diagrams and flows

Primary anchors
- [AETHR.IO.dump()](../../dev/IO.lua:35)
- [AETHR.IO.store()](../../dev/IO.lua:63)
- [AETHR.IO.storeNoFunc()](../../dev/IO.lua:134)
- [AETHR.IO.serializeNoFunc()](../../dev/IO.lua:199)
- [AETHR.IO.deSerialize()](../../dev/IO.lua:281)
- [AETHR.IO.load()](../../dev/IO.lua:310)

Related code anchors
- Writers dispatch: [write()](../../dev/IO.lua:337), [writeNoFunc()](../../dev/IO.lua:349), [writeSerialString()](../../dev/IO.lua:361)
- Writer tables: [writers](../../dev/IO.lua:422), [writersNoFunc](../../dev/IO.lua:488), [writersSerialString](../../dev/IO.lua:546)
- Helpers: [writeIndent()](../../dev/IO.lua:377), [writeIndentSerial()](../../dev/IO.lua:383), [refCount()](../../dev/IO.lua:401)
- FILEOPS usage: [AETHR.FILEOPS:saveData()](../../dev/FILEOPS_.lua:155), [AETHR.FILEOPS:loadData()](../../dev/FILEOPS_.lua:173)

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
  - [AETHR.IO.store()](../../dev/IO.lua:63), [AETHR.IO.storeNoFunc()](../../dev/IO.lua:134), [AETHR.IO.serializeNoFunc()](../../dev/IO.lua:199)
  - [AETHR.IO.deSerialize()](../../dev/IO.lua:281), [AETHR.IO.load()](../../dev/IO.lua:310)
- Writers and helpers
  - [write()](../../dev/IO.lua:337), [writeNoFunc()](../../dev/IO.lua:349), [writeSerialString()](../../dev/IO.lua:361)
  - [writers](../../dev/IO.lua:422), [writersNoFunc](../../dev/IO.lua:488), [writersSerialString](../../dev/IO.lua:546)
  - [writeIndent()](../../dev/IO.lua:377), [writeIndentSerial()](../../dev/IO.lua:383), [refCount()](../../dev/IO.lua:401)

# Cross-module anchors
- FILEOPS persist and retrieve: [AETHR.FILEOPS:saveData()](../../dev/FILEOPS_.lua:155), [AETHR.FILEOPS:loadData()](../../dev/FILEOPS_.lua:173)

# Notes
- Mermaid labels avoid double quotes and parentheses to satisfy renderer constraints.
- All diagrams use GitHub Mermaid fenced blocks.