# AETHR AI DBSCAN logic

Logic coverage for [AETHR.AI:clusterPoints()](../../dev/_AI.lua:530), [AETHR.AI.DBSCANNER:New()](../../dev/_AI.lua:123), [AETHR.AI.DBSCANNER:generateDBSCANparams()](../../dev/_AI.lua:186), [AETHR.AI.DBSCANNER:_prepare_points_and_index()](../../dev/_AI.lua:224), [AETHR.AI.DBSCANNER:Scan()](../../dev/_AI.lua:319), [AETHR.AI.DBSCANNER:_DBScan()](../../dev/_AI.lua:333), [AETHR.AI.DBSCANNER:region_count()](../../dev/_AI.lua:275), [AETHR.AI.DBSCANNER:region_query()](../../dev/_AI.lua:370), [AETHR.AI.DBSCANNER:expand_cluster()](../../dev/_AI.lua:424), [AETHR.AI.DBSCANNER:post_process_clusters()](../../dev/_AI.lua:466).

Notes:
- Node labels in Mermaid diagrams avoid double quotes and parentheses.
- Diagrams use GitHub Mermaid fenced blocks and follow project Mermaid Rules (subgraphs, styles, legends).

Overview

```mermaid
%%{init: {"theme":"base", "themeVariables": {"primaryColor":"#f5f5f5","edgeLabelBackground":"#ffffff"}}}%%
flowchart 
  %% Overview split into Construction, Preparation, Scan/Core, and PostProcessing
  subgraph CONSTR [Construction]
    CP[clusterPoints facade]
    NW[DBSCANNER New]
    CP --> NW
    NW --> GP[generate params]
  end
  style CONSTR fill:#ffe6cc,stroke:#d99a5a,stroke-width:2px

  subgraph PREP [Preparation]
    GP --> PR[prepare points and index]
  end
  style PREP fill:#fff2cc,stroke:#d4b86f,stroke-width:2px

  subgraph SCAN [Scan and Clustering]
    PR --> SC[Scan]
    SC --> DB[_DBScan core]
    DB -->|cnt < min_samples| NS[mark NOISE]
    DB -->|cnt >= min_samples| EX[expand cluster]
    EX --> DB
    SC --> PP[post process clusters]
    PP --> OUT[return Clusters]
  end
  style SCAN fill:#dae8fc,stroke:#6c8ebf,stroke-width:2px

  %% Styling for nodes
  classDef process fill:#f5f5f5,stroke:#bfbfbf,stroke-width:1px
  class CP,NW,GP,PR,SC,DB,NS,EX,PP,OUT process
```

Facade [AETHR.AI:clusterPoints()](../../dev/_AI.lua:530)

```mermaid
%%{init: {"theme":"base", "themeVariables": {"primaryColor":"#f5f5f5"}}}%%
flowchart LR
  subgraph FACADE [Facade]
    style FACADE fill:#f5f5f5,stroke:#bfbfbf,stroke-width:2px
    F0[start clusterPoints]
    F1[extract radiusExtension f p min_samples from opts]
    F2[call DBSCANNER New]
    F3[call Scan]
    F4[return scanner Clusters]
    F0 --> F1 --> F2 --> F3 --> F4
  end
  classDef facade fill:#e1d5e7,stroke:#a48fb1,stroke-width:1px
  class F0,F1,F2,F3,F4 facade
```

Constructor [AETHR.AI.DBSCANNER:New()](../../dev/_AI.lua:123)

```mermaid
%%{init: {"theme":"base"}}%%
flowchart TD
  subgraph NEW [Constructor - New]
    style NEW fill:#fff2cc,stroke:#d4b86f,stroke-width:2px
    N0[start New]
    N1[assign AI AETHR UTILS and dataset]
    N2[init arrays and fields]
    N3[load f and p defaults from DATA]
    N4[apply params overrides]
    N5[set min_samples_override default to 5 when p not explicit]
    N6[return generateDBSCANparams]
    N0 --> N1 --> N2 --> N3 --> N4 --> N5 --> N6
  end
  classDef ctor fill:#fff2cc,stroke:#d4b86f
  class N0,N1,N2,N3,N4,N5,N6 ctor
```

Parameterization [AETHR.AI.DBSCANNER:generateDBSCANparams()](../../dev/_AI.lua:186)

```mermaid
%%{init: {"theme":"base"}}%%
flowchart TD
  subgraph PARAM [Parameterization]
    style PARAM fill:#e1f5e7,stroke:#8fbf9a,stroke-width:2px
    G0[start generate params]
    G1[compute epsilon and epsilon2]
    G2[compute min_samples from override or p proportion]
    G3[optional debugInfo]
    G4[prepare points and index]
    G5[return self]
    G0 --> G1 --> G2 --> G3 --> G4 --> G5
  end
  classDef param fill:#e1f5e7,stroke:#8fbf9a
  class G0,G1,G2,G3,G4,G5 param
```

Pre normalize and index [AETHR.AI.DBSCANNER:_prepare_points_and_index()](../../dev/_AI.lua:224)

```mermaid
%%{init: {"theme":"base"}}%%
flowchart TB
  subgraph PREP2 [Pre-normalize & Index]
    style PREP2 fill:#fff2cc,stroke:#d4b86f,stroke-width:2px
    P0[start prepare]
    P1[guard n and eps]
    P2[clear grid and return]
    P3[normalize points to x y]
    P4[set cellSize to epsilon]
    P5[build uniform grid by cell indices]
    P6[return]
    P0 --> P1
    P1 -->|n <= 0 or eps <= 0| P2
    P1 -->|ok| P3 --> P4 --> P5 --> P6
  end
  classDef prep2 fill:#fff2cc,stroke:#d4b86f
  class P0,P1,P2,P3,P4,P5,P6 prep2
```

Scan wrapper [AETHR.AI.DBSCANNER:Scan()](../../dev/_AI.lua:319)

```mermaid
%%{init: {"theme":"base"}}%%
flowchart LR
  subgraph SCANWRAP [Scan wrapper]
    style SCANWRAP fill:#dae8fc,stroke:#6c8ebf,stroke-width:2px
    S0[start Scan] --> S1[call _DBScan]
    S1 --> S2[call post process clusters]
    S2 --> S3[return self]
  end
  classDef scanwrap fill:#dae8fc,stroke:#6c8ebf
  class S0,S1,S2,S3 scanwrap
```

Core clustering [AETHR.AI.DBSCANNER:_DBScan()](../../dev/_AI.lua:333)

```mermaid
%%{init: {"theme":"base"}}%%
flowchart TB
  %% Core loop and labeling
  subgraph CORE [Core _DBScan]
    style CORE fill:#d5e8d4,stroke:#6b9f73,stroke-width:2px
    D0[start _DBScan]
    D1[init labels and cluster counter]
    D2[for each point if unmarked]
    D3[count neighbors with early exit]
    D4[label NOISE]
    D5[increment cluster id]
    D6[neighbors via region_query]
    D7[expand_cluster]
    D0 --> D1 --> D2 --> D3
    D3 -->|cnt < min_samples| D4
    D3 -->|cnt >= min_samples| D5 --> D6 --> D7 --> D2
  end
  classDef core fill:#d5e8d4,stroke:#6b9f73
  class D0,D1,D2,D3,D4,D5,D6,D7 core
```

Neighbor count [AETHR.AI.DBSCANNER:region_count()](../../dev/_AI.lua:275)

```mermaid
%%{init: {"theme":"base"}}%%
flowchart LR
  subgraph RCOUNT [Neighbor count]
    style RCOUNT fill:#fff2cc,stroke:#d4b86f,stroke-width:2px
    RC0[start region_count]
    RC1[guard epsilon2 and cellSize]
    RC2[return 0]
    RC3[compute cell coords]
    RC4[scan neighbor buckets]
    RC5[distance check and increment]
    RC6[early return when count >= target]
    RC0 --> RC1
    RC1 -->|invalid| RC2
    RC1 -->|valid| RC3 --> RC4 --> RC5 --> RC1
    RC5 -->|count >= target| RC6
  end
  classDef rcount fill:#fff2cc,stroke:#d4b86f
  class RC0,RC1,RC2,RC3,RC4,RC5,RC6 rcount
```

Neighbor query [AETHR.AI.DBSCANNER:region_query()](../../dev/_AI.lua:370)

```mermaid
%%{init: {"theme":"base"}}%%
flowchart LR
  subgraph RQUERY [Neighbor query]
    style RQUERY fill:#fff2cc,stroke:#d4b86f,stroke-width:2px
    RQ0[start region_query]
    RQ1[guard epsilon2 and cellSize]
    RQ2[return empty]
    RQ3[compute cell coords]
    RQ4[collect bucket indices]
    RQ5[distance check append neighbors]
    RQ6[return neighbors]
    RQ0 --> RQ1
    RQ1 -->|invalid| RQ2
    RQ1 -->|valid| RQ3 --> RQ4 --> RQ5 --> RQ6
  end
  classDef rquery fill:#fff2cc,stroke:#d4b86f
  class RQ0,RQ1,RQ2,RQ3,RQ4,RQ5,RQ6 rquery
```

Cluster expansion [AETHR.AI.DBSCANNER:expand_cluster()](../../dev/_AI.lua:424)

```mermaid
%%{init: {"theme":"base"}}%%
flowchart TB
  subgraph EXPAND [Expand cluster]
    style EXPAND fill:#f5f5f5,stroke:#bfbfbf,stroke-width:2px
    E0[start expand_cluster]
    E1[label seed and init i]
    E2[while i <= neighbors length]
    E3[label NOISE or UNMARKED as cluster]
    E4[test core via region_count]
    E5[region_query and append eligible]
    E6[continue]
    E7[return self]
    E0 --> E1 --> E2
    E2 --> E3 --> E4
    E4 -->|core| E5 --> E2
    E4 -->|not core| E6 --> E2
    E2 --> E7
  end
  classDef expand fill:#f5f5f5,stroke:#bfbfbf
  class E0,E1,E2,E3,E4,E5,E6,E7 expand
```

Post processing [AETHR.AI.DBSCANNER:post_process_clusters()](../../dev/_AI.lua:466)

```mermaid
%%{init: {"theme":"base"}}%%
flowchart TB
  subgraph POST [Post processing]
    style POST fill:#ffe6cc,stroke:#d99a5a,stroke-width:2px
    PP0[start post process]
    PP1[group points by cluster id]
    PP2[compute centers via mean x y]
    PP3[compute radius via max distance plus extension]
    PP4[build output list]
    PP5[assign to self Clusters]
    PP0 --> PP1 --> PP2 --> PP3 --> PP4 --> PP5
  end
  classDef post fill:#ffe6cc,stroke:#d99a5a
  class PP0,PP1,PP2,PP3,PP4,PP5 post
```

Sequence overview

```mermaid
%%{init: {"theme":"base", "themeVariables": {"primaryColor":"#f5f5f5"}}}%%
sequenceDiagram
  %% Add a faint background rect for readability on dark docs background
  rect rgba(255,255,255,0.75)
    participant AI as AETHR AI
    participant DB as DBSCANNER
    participant U as UTILS
    AI->>DB: New with points area params
    DB-->>DB: generateDBSCANparams and prepare index
    DB->>U: normalizePoint per input
    AI->>DB: Scan
    DB-->>DB: _DBScan with region_count and region_query
    DB-->>DB: expand_cluster and post process clusters
    DB-->>AI: Clusters
  end
```

References

- Source: [dev/_AI.lua](../../dev/_AI.lua)
- Facade: [AETHR.AI:clusterPoints()](../../dev/_AI.lua:530)
- Core: [AETHR.AI.DBSCANNER:_DBScan()](../../dev/_AI.lua:333), [AETHR.AI.DBSCANNER:expand_cluster()](../../dev/_AI.lua:424)
- Utilities: [AETHR.AI.DBSCANNER:region_count()](../../dev/_AI.lua:275), [AETHR.AI.DBSCANNER:region_query()](../../dev/_AI.lua:370)