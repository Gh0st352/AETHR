# AETHR AI DBSCAN logic

Logic coverage for [AETHR.AI:clusterPoints()](../../dev/_AI.lua:530), [AETHR.AI.DBSCANNER:New()](../../dev/_AI.lua:123), [AETHR.AI.DBSCANNER:generateDBSCANparams()](../../dev/_AI.lua:186), [AETHR.AI.DBSCANNER:_prepare_points_and_index()](../../dev/_AI.lua:224), [AETHR.AI.DBSCANNER:Scan()](../../dev/_AI.lua:319), [AETHR.AI.DBSCANNER:_DBScan()](../../dev/_AI.lua:333), [AETHR.AI.DBSCANNER:region_count()](../../dev/_AI.lua:275), [AETHR.AI.DBSCANNER:region_query()](../../dev/_AI.lua:370), [AETHR.AI.DBSCANNER:expand_cluster()](../../dev/_AI.lua:424), [AETHR.AI.DBSCANNER:post_process_clusters()](../../dev/_AI.lua:466).

Notes:
- Node labels in Mermaid diagrams avoid double quotes and parentheses.
- Diagrams use GitHub Mermaid fenced blocks.

Overview

```mermaid
flowchart TD
  CP[clusterPoints facade] --> NW[New DBSCANNER]
  NW --> GP[Generate params]
  GP --> PR[Prepare points and index]
  PR --> SC[Scan]
  SC --> DB[_DBScan core]
  DB -->|cnt < min_samples| NS[mark NOISE]
  DB -->|cnt >= min_samples| EX[expand cluster]
  EX --> DB
  SC --> PP[post process clusters]
  PP --> OUT[return Clusters]
```

Facade [AETHR.AI:clusterPoints()](../../dev/_AI.lua:530)

```mermaid
flowchart LR
  F0[start clusterPoints] --> F1[extract radiusExtension f p min_samples from opts]
  F1 --> F2[call DBSCANNER New]
  F2 --> F3[call Scan]
  F3 --> F4[return scanner Clusters]
```

Constructor [AETHR.AI.DBSCANNER:New()](../../dev/_AI.lua:123)

```mermaid
flowchart TD
  N0[start New] --> N1[assign AI AETHR UTILS and dataset]
  N1 --> N2[init arrays and fields]
  N2 --> N3[load f and p defaults from DATA]
  N3 --> N4[apply params overrides]
  N4 --> N5[set min_samples_override default to 5 when p not explicit]
  N5 --> N6[return generateDBSCANparams]
```

Parameterization [AETHR.AI.DBSCANNER:generateDBSCANparams()](../../dev/_AI.lua:186)

```mermaid
flowchart TD
  G0[start generate params] --> G1[compute epsilon and epsilon2]
  G1 --> G2[compute min_samples from override or p proportion]
  G2 --> G3[optional debugInfo]
  G3 --> G4[prepare points and index]
  G4 --> G5[return self]
```

Pre normalize and index [AETHR.AI.DBSCANNER:_prepare_points_and_index()](../../dev/_AI.lua:224)

```mermaid
flowchart TD
  P0[start prepare] --> P1[guard n and eps]
  P1 -->|n <= 0 or eps <= 0| P2[clear grid and return]
  P1 -->|ok| P3[normalize points to x y]
  P3 --> P4[set cellSize to epsilon]
  P4 --> P5[build uniform grid by cell indices]
  P5 --> P6[return]
```

Scan wrapper [AETHR.AI.DBSCANNER:Scan()](../../dev/_AI.lua:319)

```mermaid
flowchart LR
  S0[start Scan] --> S1[call _DBScan]
  S1 --> S2[call post process clusters]
  S2 --> S3[return self]
```

Core clustering [AETHR.AI.DBSCANNER:_DBScan()](../../dev/_AI.lua:333)

```mermaid
flowchart TD
  D0[start _DBScan] --> D1[init labels and cluster counter]
  D1 --> D2[for each point if unmarked]
  D2 --> D3[count neighbors with early exit]
  D3 -->|cnt < min_samples| D4[label NOISE]
  D3 -->|cnt >= min_samples| D5[increment cluster id]
  D5 --> D6[neighbors via region_query]
  D6 --> D7[expand_cluster]
  D7 --> D2
```

Neighbor count [AETHR.AI.DBSCANNER:region_count()](../../dev/_AI.lua:275)

```mermaid
flowchart LR
  RC0[start region_count] --> RC1[guard epsilon2 and cellSize]
  RC1 -->|invalid| RC2[return 0]
  RC1 -->|valid| RC3[compute cell coords]
  RC3 --> RC4[scan neighbor buckets]
  RC4 --> RC5[distance check and increment]
  RC5 -->|count >= target| RC6[early return]
  RC5 -->|else| RC4
```

Neighbor query [AETHR.AI.DBSCANNER:region_query()](../../dev/_AI.lua:370)

```mermaid
flowchart LR
  RQ0[start region_query] --> RQ1[guard epsilon2 and cellSize]
  RQ1 -->|invalid| RQ2[return empty]
  RQ1 -->|valid| RQ3[compute cell coords]
  RQ3 --> RQ4[collect bucket indices]
  RQ4 --> RQ5[distance check append neighbors]
  RQ5 --> RQ6[return neighbors]
```

Cluster expansion [AETHR.AI.DBSCANNER:expand_cluster()](../../dev/_AI.lua:424)

```mermaid
flowchart TD
  E0[start expand_cluster] --> E1[label seed and init i]
  E1 --> E2[while i <= neighbors length]
  E2 --> E3[label NOISE or UNMARKED as cluster]
  E3 --> E4[test core via region_count]
  E4 -->|core| E5[region_query and append eligible]
  E4 -->|not core| E6[continue]
  E5 --> E2
  E6 --> E2
  E2 --> E7[return self]
```

Post processing [AETHR.AI.DBSCANNER:post_process_clusters()](../../dev/_AI.lua:466)

```mermaid
flowchart TD
  PP0[start post process] --> PP1[group points by cluster id]
  PP1 --> PP2[compute centers via mean x y]
  PP2 --> PP3[compute radius via max distance plus extension]
  PP3 --> PP4[build output list]
  PP4 --> PP5[assign to self Clusters]
```

Sequence overview

```mermaid
sequenceDiagram
  participant AI as AETHR AI
  participant DB as DBSCANNER
  participant U as UTILS
  AI->>DB: New with points area params
  DB-->>DB: generate params and prepare index
  DB->>U: normalizePoint for each input
  AI->>DB: Scan
  DB-->>DB: _DBScan with region_count and region_query
  DB-->>DB: expand_cluster and post process
  DB-->>AI: Clusters
```

References

- Source: [dev/_AI.lua](../../dev/_AI.lua)
- Facade: [AETHR.AI:clusterPoints()](../../dev/_AI.lua:530)
- Core: [AETHR.AI.DBSCANNER:_DBScan()](../../dev/_AI.lua:333), [AETHR.AI.DBSCANNER:expand_cluster()](../../dev/_AI.lua:424)
- Utilities: [AETHR.AI.DBSCANNER:region_count()](../../dev/_AI.lua:275), [AETHR.AI.DBSCANNER:region_query()](../../dev/_AI.lua:370)