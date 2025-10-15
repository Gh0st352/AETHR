# AETHR AI data structures

Overview of classes and fields backing the DBSCAN logic in [dev/_AI.lua](../../dev/_AI.lua).

Key anchors
- [AETHR.AI](../../dev/_AI.lua:34)
- [AETHR.AI.DBSCANNER](../../dev/_AI.lua:90)
- [AETHR.AI.DATA.DBSCANNER](../../dev/_AI.lua:71)

Class diagram

```mermaid
%%{init: {"theme":"base", "themeVariables": {"primaryColor":"#f5f5f5"}}}%%
classDiagram
  %% Use safe identifiers (underscores) for class IDs. Legend below maps IDs to dotted names.
  %% Legend:
  %%   AETHR_AI -> "AETHR.AI"
  %%   AETHR_AI_DBSCANNER -> "AETHR.AI.DBSCANNER"
  %%   AETHR_AI_DATA_DBSCANNER -> "AETHR.AI.DATA.DBSCANNER"

  class AETHR_AI {
    +New parent : AETHR.AI
    +clusterPoints points area opts : _dbCluster list
    -_cache table
    -AETHR AETHR
  }

  class AETHR_AI_DBSCANNER {
    +New ai Points Area RadiusExtension params : DBSCANNER
    +generateDBSCANparams : DBSCANNER
    +Scan : DBSCANNER
    +_DBScan : DBSCANNER
    +region_count index target : number
    +region_query index : int list
    +expand_cluster pointIndex neighbors cluster_id : DBSCANNER
    +post_process_clusters : DBSCANNER
    -AI AETHR.AI
    -AETHR AETHR
    -UTILS AETHR.UTILS
    -Points list
    -numPoints int
    -Area number
    -_RadiusExtension number
    -_DBScanData map int int
    -Clusters list
    -_x number list
    -_y number list
    -_grid table
    -_cellSize number
    -epsilon number
    -epsilon2 number
    -min_samples int
    -f number
    -p number
    -min_samples_override number
  }

  class AETHR_AI_DATA_DBSCANNER {
    +params table
    +_DBScanData map int int
    +Clusters list
    +Points list
    +numPoints int
    +f number
    +p number
    +epsilon number
    +epsilon2 number
    +min_samples int
    +Area number
    +_RadiusExtension number
  }

  %% Relationships (use safe IDs)
  AETHR_AI ..> AETHR_AI_DBSCANNER : uses for clustering
  AETHR_AI_DBSCANNER ..> AETHR_UTILS : normalizePoint
  AETHR_AI_DBSCANNER ..> AETHR : default params from DATA

  %% Styling for readability
  classDef aiClass fill:#dae8fc,stroke:#6c8ebf,stroke-width:2px
  classDef scanner fill:#fff2cc,stroke:#d4b86f,stroke-width:2px
  classDef dataClass fill:#f5f5f5,stroke:#bfbfbf,stroke-width:2px

  class AETHR_AI aiClass
  class AETHR_AI_DBSCANNER scanner
  class AETHR_AI_DATA_DBSCANNER dataClass
```

Field sources
- DBSCANNER constructor and fields: [AETHR.AI.DBSCANNER:New()](../../dev/_AI.lua:123)
- DATA defaults: [AETHR.AI.DATA](../../dev/_AI.lua:70)
- Parameterization: [AETHR.AI.DBSCANNER:generateDBSCANparams()](../../dev/_AI.lua:186)

Method anchors
- Facade: [AETHR.AI:clusterPoints()](../../dev/_AI.lua:530)
- Scan: [AETHR.AI.DBSCANNER:Scan()](../../dev/_AI.lua:319)
- Core: [AETHR.AI.DBSCANNER:_DBScan()](../../dev/_AI.lua:333)
- Neighbors: [region_count](../../dev/_AI.lua:275), [region_query](../../dev/_AI.lua:370)
- Expansion: [expand_cluster](../../dev/_AI.lua:424)
- Post process: [post_process_clusters](../../dev/_AI.lua:466)

Notes
- Types in this diagram are descriptive and align with Lua usage in source.
- Diagrams use GitHub Mermaid fenced blocks.