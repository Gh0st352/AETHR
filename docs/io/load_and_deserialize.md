# IO load and deSerialize

Loading and executing persisted Lua chunks from files or serialized strings. Covers [AETHR.IO.deSerialize()](../../dev/IO.lua:281) and [AETHR.IO.load()](../../dev/IO.lua:310), including error paths, file vs stream sources, and result semantics.

Primary anchors

- DeSerialize from string: [AETHR.IO.deSerialize()](../../dev/IO.lua:281)
- Load from path or stream: [AETHR.IO.load()](../../dev/IO.lua:310)

# Overview flows

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart LR
  subgraph "DeSerialize path"
    SZ[serialized string] --> DS[deSerialize]
    DS --> LSTR[loadstring]
    LSTR --> EXEC[execute chunk]
    EXEC --> OUT[result values]
  end

  subgraph "Load path"
    PATH[file path or stream] --> LD[load]
    LD --> SEL{type is string}
    SEL -->|string| LOADFILE[loadfile]
    SEL -->|stream| READALL[read all]
    LOADFILE --> EXEC2[execute chunk]
    READALL --> EXEC2
    EXEC2 --> OUT2[result values or nil error]
  end

  class SZ,DS,LSTR,PATH,LD class_io;
  class SEL class_decision;
  class EXEC,EXEC2 class_compute;
  class OUT,OUT2 class_result;
```

# DeSerialize sequence

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
sequenceDiagram
  participant U as caller
  participant IO as IO.deSerialize
  U->>IO: deSerialize(serialString)
  IO->>IO: loadstring(serialString)
  alt load ok
    IO->>IO: execute chunk
    IO-->>U: return results
  else load error
    IO-->>U: return nil and error
  end
```

# Load sequence file or stream

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
sequenceDiagram
  participant U as caller
  participant IO as IO.load
  U->>IO: load(pathOrStream)
  alt path is string
    IO->>IO: loadfile(path)
  else file like object
    IO->>IO: path:read *a
  end
  alt load ok
    IO->>IO: execute chunk
    IO-->>U: return results
  else load error
    IO-->>U: return nil and error
  end
```

# Behavior and errors

- [AETHR.IO.deSerialize()](../../dev/IO.lua:281)
  - Uses loadstring then executes the compiled chunk
  - Returns results of execution on success, or nil and error message on failure
- [AETHR.IO.load()](../../dev/IO.lua:310)
  - When given a string path uses loadfile; otherwise expects a stream supporting read '*a'
  - Returns results of execution on success, or nil and error message on failure

## Integration notes

- These functions pair with serialization output produced by [AETHR.IO.store()](../../dev/IO.lua:63), [AETHR.IO.storeNoFunc()](../../dev/IO.lua:134), and [AETHR.IO.serializeNoFunc()](../../dev/IO.lua:199)
- FILEOPS uses them under the hood in [AETHR.FILEOPS:saveData()](../../dev/FILEOPS_.lua:155) and [AETHR.FILEOPS:loadData()](../../dev/FILEOPS_.lua:173)

# Guard and result patterns

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  LS[loadstring or loadfile] --> OK{success}
  OK -->|yes| EXEC[execute]
  OK -->|no| ERR[nil and error]
  EXEC --> RES[return values]
  class LS,EXEC class_io;
  class OK class_decision;
  class ERR,RES class_result;
```

# Usage examples

- DeSerialize a string chunk
  - local data = [AETHR.IO.deSerialize()](../../dev/IO.lua:281)(serializedString)
- Load from disk
  - local data = [AETHR.IO.load()](../../dev/IO.lua:310)(path)

# Validation checklist

- deSerialize entry: [dev/IO.lua](../../dev/IO.lua:281)
- load entry: [dev/IO.lua](../../dev/IO.lua:310)
- FILEOPS callers: [dev/FILEOPS_.lua saveData](../../dev/FILEOPS_.lua:155), [dev/FILEOPS_.lua loadData](../../dev/FILEOPS_.lua:173)

# Related breakouts

- Store and multiref encoding: [store_and_variants.md](./store_and_variants.md)
- Writers and refcount internals: [writers_and_refcount.md](./writers_and_refcount.md)
- Serialize to string without functions: [serialize_nofunc.md](./serialize_nofunc.md)

# Conventions

- Mermaid fenced blocks with GitHub parser
- Labels avoid double quotes and parentheses inside bracket text
- All links use relative paths for portability