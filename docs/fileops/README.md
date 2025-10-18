# AETHR FILEOPS diagrams and flows

# Primary anchors
- [AETHR.FILEOPS:joinPaths()](https://github.com/Gh0st352/AETHR/blob/main/dev/FILEOPS_.lua#L37)
- [AETHR.FILEOPS:ensureDirectory()](https://github.com/Gh0st352/AETHR/blob/main/dev/FILEOPS_.lua#L46)
- [AETHR.FILEOPS:ensureFile()](https://github.com/Gh0st352/AETHR/blob/main/dev/FILEOPS_.lua#L120)
- [AETHR.FILEOPS:saveData()](https://github.com/Gh0st352/AETHR/blob/main/dev/FILEOPS_.lua#L155)
- [AETHR.FILEOPS:loadData()](https://github.com/Gh0st352/AETHR/blob/main/dev/FILEOPS_.lua#L173)
- [AETHR.FILEOPS:fileExists()](https://github.com/Gh0st352/AETHR/blob/main/dev/FILEOPS_.lua#L189)
- [AETHR.FILEOPS:deepcopy()](https://github.com/Gh0st352/AETHR/blob/main/dev/FILEOPS_.lua#L206)
- [AETHR.FILEOPS:splitAndSaveData()](https://github.com/Gh0st352/AETHR/blob/main/dev/FILEOPS_.lua#L246)
- [AETHR.FILEOPS:loadandJoinData()](https://github.com/Gh0st352/AETHR/blob/main/dev/FILEOPS_.lua#L328)

# Documents and indices
- Master diagrams index: [docs/README.md](../README.md)
- AETHR overview: [docs/aethr/README.md](../aethr/README.md)

# Breakout documents
- Paths and ensure: [paths_and_ensure.md](./paths_and_ensure.md)
- Save and load: [save_and_load.md](./save_and_load.md)
- Chunking and tracker: [chunking.md](./chunking.md)
- Deep copy helper: [deepcopy.md](./deepcopy.md)

# Overview relationships

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart LR

  subgraph API["Core FILEOPS API"]
    JP[joinPaths]
    ED[ensureDirectory]
    EF[ensureFile]
    FE[fileExists]
    SD[saveData]
    LD[loadData]
    DC[deepcopy]
  end

  subgraph Chunking["Chunking and tracker"]
    SPT[splitAndSaveData tracker]
    LAD[loadandJoinData]
  end

  JP --> SD
  JP --> LD
  ED --> SD
  ED --> EF
  EF --> SD
  SD --> SPT
  SPT --> LAD
  LD --> LAD
  FE -.-> IO[IO read / write]
  DC -.-> LAD

  class JP,ED,EF,FE,SD,LD,DC,SPT,LAD class_step;
  class IO class_io;
```

# Save and load sequence

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
sequenceDiagram
  participant F as FILEOPS
  participant IO as IO

  F->>F: ensureDirectory
  F->>IO: store data to file
  IO-->>F: ok or error
  F->>IO: load data from file
  IO-->>F: table or nil
```

# Directory creation flow

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  subgraph Normalize["Normalize path"]
    P[path input] --> N[normalize separators]
  end
  N --> S[split path into parts]

  subgraph Iterate["Iterate and mkdir as needed"]
    S --> L[loop parts]
    subgraph PartLoop["Per-part mkdir loop"]
      L --> Q{existsDir check}
      Q -- "exists" --> C[continue]
      Q -- "missing" --> M[mkdir part]
      M --> E{error check}
      E -- "ok" --> C
      E -- "fail" --> X[stop and return false]
    end
  end

  C --> D[done return true]

  class Q,E class_decision;
  class N,S,L,M,C,Normalize,Iterate,PartLoop class_step;
  class D class_result;
```

# Chunked persistence flow

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart LR
  subgraph SortChunk["Sort and chunk"]
    S1[count records] --> S2[resolve chunk size]
    S2 --> S3[sort keys deterministic]
    S3 --> S4[fill chunk map]
  end

  subgraph PersistMeta["Persist and metadata"]
    S4 --> S5[flushChunk write part file]
    subgraph FlushAndTrack["Flush and track"]
      S5 --> S6[repeat until done]
      S6 --> S7[write tracker file]
    end
    S7 --> OUT[return metadata]
  end

  class S1,S2,S3,S4,S5,S6,S7 class_step;
  class OUT class_result;
```

# Chunked load sequence

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
sequenceDiagram
  participant F as FILEOPS

  F->>F: load tracker or dataset
  alt not tracker
    F-->>F: return master
  else tracker
    F->>F: build ordered parts
    loop for each part
      F->>F: load part
      F-->>F: merge into totalData
    end
    F-->>F: return merged
  end
```

# Source anchors
- [AETHR.FILEOPS:joinPaths()](https://github.com/Gh0st352/AETHR/blob/main/dev/FILEOPS_.lua#L37)
- [AETHR.FILEOPS:ensureDirectory()](https://github.com/Gh0st352/AETHR/blob/main/dev/FILEOPS_.lua#L46)
- [AETHR.FILEOPS:ensureFile()](https://github.com/Gh0st352/AETHR/blob/main/dev/FILEOPS_.lua#L120)
- [AETHR.FILEOPS:saveData()](https://github.com/Gh0st352/AETHR/blob/main/dev/FILEOPS_.lua#L155)
- [AETHR.FILEOPS:loadData()](https://github.com/Gh0st352/AETHR/blob/main/dev/FILEOPS_.lua#L173)
- [AETHR.FILEOPS:fileExists()](https://github.com/Gh0st352/AETHR/blob/main/dev/FILEOPS_.lua#L189)
- [AETHR.FILEOPS:deepcopy()](https://github.com/Gh0st352/AETHR/blob/main/dev/FILEOPS_.lua#L206)
- [AETHR.FILEOPS:splitAndSaveData()](https://github.com/Gh0st352/AETHR/blob/main/dev/FILEOPS_.lua#L246)
- [AETHR.FILEOPS:loadandJoinData()](https://github.com/Gh0st352/AETHR/blob/main/dev/FILEOPS_.lua#L328)

# Notes
- Diagrams reference a shared theme snippet for generation: [docs/_mermaid/theme.json](../_mermaid/theme.json)
- Sequence diagrams omit inline color; generation pipeline should inject styles from the shared theme.