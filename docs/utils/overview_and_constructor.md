# AETHR UTILS overview and constructor

Anchors
- [AETHR.UTILS:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/UTILS.lua#L27)
- [AETHR.UTILS.DATA](https://github.com/Gh0st352/AETHR/blob/main/dev/UTILS.lua#L14)

Overview
- Constructor binds parent AETHR instance and initializes per instance cache.
- DATA holds shared structures such as _cache and _rateLog defaults.
- UTILS interacts with CONFIG, FILEOPS, POLY, AUTOSAVE, WORLD, ZONE_MANAGER.

# Module relationships
```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart LR

subgraph "Modules"
  A[AETHR] --> U[UTILS]
end

subgraph "UTILS dependencies"
  C[CONFIG]
  FO[FILEOPS]
  P[POLY]
  AS[AUTOSAVE]
  W[WORLD]
  ZM[ZONE_MANAGER]
end

U --> C
U --> FO
U --> P
U --> AS
U --> W
U --> ZM

subgraph "Shared data"
  DATA[_cache and _rateLog]
end

U -.-> DATA

class A class_data;
class U class_compute;
class C,FO,P,AS,W,ZM class_data;
class DATA class_data;
```

# Construction sequence
```mermaid
%% shared theme: docs/_mermaid/theme.json %%
sequenceDiagram
  participant A as AETHR
  participant U as UTILS
  A->>U: New(parent)
  U-->>A: instance with _cache
```

Instance fields
- _cache table for per instance state including _rateLog used by [AETHR.UTILS:debugInfoRate()](https://github.com/Gh0st352/AETHR/blob/main/dev/UTILS.lua#L101)
- parent references via [AETHR.UTILS:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/UTILS.lua#L27)
- defaults defined by [AETHR.UTILS.DATA](https://github.com/Gh0st352/AETHR/blob/main/dev/UTILS.lua#L14)

Source anchors
- [AETHR.UTILS:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/UTILS.lua#L27)
- [AETHR.UTILS.DATA](https://github.com/Gh0st352/AETHR/blob/main/dev/UTILS.lua#L14)

Last updated: 2025-10-16