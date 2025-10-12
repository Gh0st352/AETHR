# AETHR FILEOPS diagrams and flows

Primary anchors
- [AETHR.FILEOPS:joinPaths()](../../dev/FILEOPS_.lua:37)
- [AETHR.FILEOPS:ensureDirectory()](../../dev/FILEOPS_.lua:46)
- [AETHR.FILEOPS:ensureFile()](../../dev/FILEOPS_.lua:120)
- [AETHR.FILEOPS:saveData()](../../dev/FILEOPS_.lua:155)
- [AETHR.FILEOPS:loadData()](../../dev/FILEOPS_.lua:173)
- [AETHR.FILEOPS:fileExists()](../../dev/FILEOPS_.lua:189)
- [AETHR.FILEOPS:deepcopy()](../../dev/FILEOPS_.lua:206)
- [AETHR.FILEOPS:splitAndSaveData()](../../dev/FILEOPS_.lua:246)
- [AETHR.FILEOPS:loadandJoinData()](../../dev/FILEOPS_.lua:328)

Documents and indices
- Master diagrams index: [docs/README.md](../README.md)
- AETHR overview: [docs/aethr/README.md](../aethr/README.md)

Breakout documents
- Paths and ensure: [paths_and_ensure.md](./paths_and_ensure.md)
- Save and load: [save_and_load.md](./save_and_load.md)
- Chunking and tracker: [chunking.md](./chunking.md)
- Deep copy helper: [deepcopy.md](./deepcopy.md)

Overview relationships

```mermaid
flowchart LR
  JP[joinPaths] --> SD[saveData]
  JP --> LD[loadData]
  ED[ensureDirectory] --> SD
  ED --> EF[ensureFile]
  EF --> SD
  SD --> SPT[splitAndSaveData tracker]
  SPT --> LAD[loadandJoinData]
  LD --> LAD
  FE[fileExists] -.-> IO[IO read write]
  DC[deepcopy] -.-> LAD
```

Save and load sequence

```mermaid
sequenceDiagram
  participant F as FILEOPS
  participant IO as IO
  F->>F: ensureDirectory
  F->>IO: store data to file
  IO-->>F: ok or error
  F->>IO: load data from file
  IO-->>F: table or nil
```

Directory creation flow

```mermaid
flowchart TD
  P[path input] --> N[normalize separators]
  N --> S[split path into parts]
  S --> L[loop parts]
  L --> Q[existsDir check]
  Q -->|exists| C[continue]
  Q -->|missing| M[mkdir part]
  M --> E[error check]
  E -->|ok| C
  E -->|fail| X[stop and return false]
  C --> D[done return true]
```

Chunked persistence flow

```mermaid
flowchart LR
  S1[count records] --> S2[resolve chunk size]
  S2 --> S3[sort keys deterministic]
  S3 --> S4[fill chunk map]
  S4 --> S5[flushChunk write part file]
  S5 --> S6[repeat until done]
  S6 --> S7[write tracker file]
  S7 --> OUT[return metadata]
```

Chunked load sequence

```mermaid
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

Source anchors
- [AETHR.FILEOPS:joinPaths()](../../dev/FILEOPS_.lua:37)
- [AETHR.FILEOPS:ensureDirectory()](../../dev/FILEOPS_.lua:46)
- [AETHR.FILEOPS:ensureFile()](../../dev/FILEOPS_.lua:120)
- [AETHR.FILEOPS:saveData()](../../dev/FILEOPS_.lua:155)
- [AETHR.FILEOPS:loadData()](../../dev/FILEOPS_.lua:173)
- [AETHR.FILEOPS:fileExists()](../../dev/FILEOPS_.lua:189)
- [AETHR.FILEOPS:deepcopy()](../../dev/FILEOPS_.lua:206)
- [AETHR.FILEOPS:splitAndSaveData()](../../dev/FILEOPS_.lua:246)
- [AETHR.FILEOPS:loadandJoinData()](../../dev/FILEOPS_.lua:328)

Notes
- Mermaid labels avoid double quotes and parentheses.
- All diagrams use GitHub Mermaid fenced blocks.