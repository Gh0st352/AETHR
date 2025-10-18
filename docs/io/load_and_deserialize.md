# IO load and deSerialize

Loading and executing persisted Lua chunks from files or serialized strings. Covers [AETHR.IO.deSerialize()](https://github.com/Gh0st352/AETHR/blob/main/dev/IO.lua#L281) and [AETHR.IO.load()](https://github.com/Gh0st352/AETHR/blob/main/dev/IO.lua#L310), including error paths, file vs stream sources, and result semantics.

Primary anchors

- DeSerialize from string: [AETHR.IO.deSerialize()](https://github.com/Gh0st352/AETHR/blob/main/dev/IO.lua#L281)
- Load from path or stream: [AETHR.IO.load()](https://github.com/Gh0st352/AETHR/blob/main/dev/IO.lua#L310)

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

- [AETHR.IO.deSerialize()](https://github.com/Gh0st352/AETHR/blob/main/dev/IO.lua#L281)
  - Uses loadstring then executes the compiled chunk
  - Returns results of execution on success, or nil and error message on failure
- [AETHR.IO.load()](https://github.com/Gh0st352/AETHR/blob/main/dev/IO.lua#L310)
  - When given a string path uses loadfile; otherwise expects a stream supporting read '*a'
  - Returns results of execution on success, or nil and error message on failure

## Integration notes

- These functions pair with serialization output produced by [AETHR.IO.store()](https://github.com/Gh0st352/AETHR/blob/main/dev/IO.lua#L63), [AETHR.IO.storeNoFunc()](https://github.com/Gh0st352/AETHR/blob/main/dev/IO.lua#L134), and [AETHR.IO.serializeNoFunc()](https://github.com/Gh0st352/AETHR/blob/main/dev/IO.lua#L199)
- FILEOPS uses them under the hood in [AETHR.FILEOPS:saveData()](https://github.com/Gh0st352/AETHR/blob/main/dev/FILEOPS_.lua#L155) and [AETHR.FILEOPS:loadData()](https://github.com/Gh0st352/AETHR/blob/main/dev/FILEOPS_.lua#L173)

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
  - local data = [AETHR.IO.deSerialize()](https://github.com/Gh0st352/AETHR/blob/main/dev/IO.lua#L281)(serializedString)
- Load from disk
  - local data = [AETHR.IO.load()](https://github.com/Gh0st352/AETHR/blob/main/dev/IO.lua#L310)(path)

# Validation checklist

- deSerialize entry: [dev/IO.lua](https://github.com/Gh0st352/AETHR/blob/main/dev/IO.lua#L281)
- load entry: [dev/IO.lua](https://github.com/Gh0st352/AETHR/blob/main/dev/IO.lua#L310)
- FILEOPS callers: [dev/FILEOPS_.lua saveData](https://github.com/Gh0st352/AETHR/blob/main/dev/FILEOPS_.lua#L155), [dev/FILEOPS_.lua loadData](https://github.com/Gh0st352/AETHR/blob/main/dev/FILEOPS_.lua#L173)

# Related breakouts

- Store and multiref encoding: [store_and_variants.md](./store_and_variants.md)
- Writers and refcount internals: [writers_and_refcount.md](./writers_and_refcount.md)
- Serialize to string without functions: [serialize_nofunc.md](./serialize_nofunc.md)

# Conventions

- Mermaid fenced blocks with GitHub parser
- Labels avoid double quotes and parentheses inside bracket text
- All links use relative paths for portability