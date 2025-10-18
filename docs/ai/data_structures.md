# AETHR AI data structures

Overview of classes and fields backing the DBSCAN logic in [dev/_AI.lua](../../dev/_AI.lua).

## Key anchors
- [AETHR.AI](https://github.com/Gh0st352/AETHR/blob/main/dev/_AI.lua#L34)
- [AETHR.AI.DBSCANNER](https://github.com/Gh0st352/AETHR/blob/main/dev/_AI.lua#L90)
- [AETHR.AI.DATA.DBSCANNER](https://github.com/Gh0st352/AETHR/blob/main/dev/_AI.lua#L71)

# Class diagram

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
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

  %% Styling note: styling is provided by docs/_mermaid/theme.json. Use class buckets only.
  class AETHR_AI class_io
  class AETHR_AI_DBSCANNER class_compute
  class AETHR_AI_DATA_DBSCANNER class_data
```

## Field sources
- DBSCANNER constructor and fields: [AETHR.AI.DBSCANNER:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/_AI.lua#L123)
- DATA defaults: [AETHR.AI.DATA](https://github.com/Gh0st352/AETHR/blob/main/dev/_AI.lua#L70)
- Parameterization: [AETHR.AI.DBSCANNER:generateDBSCANparams()](https://github.com/Gh0st352/AETHR/blob/main/dev/_AI.lua#L186)

## Method anchors
- Facade: [AETHR.AI:clusterPoints()](https://github.com/Gh0st352/AETHR/blob/main/dev/_AI.lua#L530)
- Scan: [AETHR.AI.DBSCANNER:Scan()](https://github.com/Gh0st352/AETHR/blob/main/dev/_AI.lua#L319)
- Core: [AETHR.AI.DBSCANNER:_DBScan()](https://github.com/Gh0st352/AETHR/blob/main/dev/_AI.lua#L333)
- Neighbors: [region_count](https://github.com/Gh0st352/AETHR/blob/main/dev/_AI.lua#L275), [region_query](https://github.com/Gh0st352/AETHR/blob/main/dev/_AI.lua#L370)
- Expansion: [expand_cluster](https://github.com/Gh0st352/AETHR/blob/main/dev/_AI.lua#L424)
- Post process: [post_process_clusters](https://github.com/Gh0st352/AETHR/blob/main/dev/_AI.lua#L466)

## Notes
- Types in this diagram are descriptive and align with Lua usage in source.
- Diagrams use GitHub Mermaid fenced blocks.