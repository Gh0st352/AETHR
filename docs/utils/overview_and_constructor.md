# AETHR UTILS overview and constructor

Anchors
- [AETHR.UTILS:New()](../../dev/UTILS.lua:27)
- [AETHR.UTILS.DATA](../../dev/UTILS.lua:14)

Overview
- Constructor binds parent AETHR instance and initializes per instance cache.
- DATA holds shared structures such as _cache and _rateLog defaults.
- UTILS interacts with CONFIG, FILEOPS, POLY, AUTOSAVE, WORLD, ZONE_MANAGER.

Module relationships
```mermaid
flowchart LR
  A[AETHR] --> U[UTILS]
  U --> C[CONFIG]
  U --> FO[FILEOPS]
  U --> P[POLY]
  U --> AS[AUTOSAVE]
  U --> W[WORLD]
  U --> ZM[ZONE_MANAGER]
  U -.-> DATA[_cache and _rateLog]
```

Construction sequence
```mermaid
sequenceDiagram
  participant A as AETHR
  participant U as UTILS
  A->>U: New(parent)
  U-->>A: instance with _cache
```

Instance fields
- _cache table for per instance state including _rateLog used by [AETHR.UTILS:debugInfoRate()](../../dev/UTILS.lua:101)
- parent references via [AETHR.UTILS:New()](../../dev/UTILS.lua:27)
- defaults defined by [AETHR.UTILS.DATA](../../dev/UTILS.lua:14)

Source anchors
- [AETHR.UTILS:New()](../../dev/UTILS.lua:27)
- [AETHR.UTILS.DATA](../../dev/UTILS.lua:14)