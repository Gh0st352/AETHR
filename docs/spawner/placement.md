# AETHR SPAWNER placement logic

Covered functions
- Centers: [AETHR.SPAWNER:generateVec2GroupCenters()](dev/SPAWNER.lua:1067)
- Units: [AETHR.SPAWNER:generateVec2UnitPos()](dev/SPAWNER.lua:1301)
- Shared helpers
  - Extract XY: [AETHR.SPAWNER:_extractXY()](dev/SPAWNER.lua:157)
  - Grid index: [AETHR.SPAWNER:_toCell()](dev/SPAWNER.lua:171), [AETHR.SPAWNER:_cellKey()](dev/SPAWNER.lua:178)
  - Grid ops: [AETHR.SPAWNER:_gridInsert()](dev/SPAWNER.lua:183), [AETHR.SPAWNER:_gridQuery()](dev/SPAWNER.lua:195)
  - Strict building reject: [AETHR.SPAWNER:_directCellStructureReject()](dev/SPAWNER.lua:233)
  - Yielding: [AETHR.SPAWNER:_maybeYield()](dev/SPAWNER.lua:255)
  - NoGo checks: [AETHR.SPAWNER:checkIsInNOGO()](dev/SPAWNER.lua:2085)
- Config references
  - BUILD_PAD and EXTRA_ATTEMPTS_BUILDING: [SPAWNER.DATA.CONFIG](dev/SPAWNER.lua:92)
  - operationLimit and separationSettings: [SPAWNER.DATA.CONFIG](dev/SPAWNER.lua:98)


1. Group center placement flow

```mermaid
flowchart TB
  A0[start centers for each sub zone] --> A1[derive cell size from min of minGroups and minBuildings across group settings]
  A1 --> A2[build structuresGrid from base static scenery objects]
  A2 --> A3[build groupsGrid from nearby units and WORLD DB]
  A3 --> A4[init centersGrid empty]
  A4 --> A5[for each groupSetting in sub zone]
  A5 --> A6[init counters and thresholds from separation settings]
  A6 --> L0[loop i from one to numGroups]
  L0 --> C0[glassBreak equals zero accepted false]
  C0 --> C1[pick random point in sub zone circle]
  C1 --> C2[compute relax factor up to thirty percent based on glassBreak and operationLimit]
  C2 --> Q0{centersGrid within relaxed minGroups}
  Q0 -- true --> R[reject]
  Q0 -- false --> Q1{groupsGrid within relaxed minGroups}
  Q1 -- true --> R
  Q1 -- false --> Q2{structuresGrid within relaxed minBuildings}
  Q2 -- true --> R
  Q2 -- false --> B0{strict building direct reject with BUILD_PAD}
  B0 -- true --> R
  B0 -- false --> N0{checkIsInNOGO when enabled}
  N0 -- true --> R
  N0 -- false --> ACC[provisionally accept]
  R --> F0{glassBreak at or beyond operationLimit}
  F0 -- no --> INC[glassBreak plus one and maybeYield]
  F0 -- yes --> FB{building reject direct was false}
  FB -- yes --> ACC
  FB -- no --> BEX{glassBreak below limit plus extra attempts building}
  BEX -- yes --> X[force reject and retry]
  BEX -- no --> X
  ACC --> SB[recheck strict building direct reject]
  SB -- true --> X
  SB -- false --> OK[accept center and insert into centersGrid]
  X --> INC
  OK --> NEXT[next group or setting]
  INC --> C1
```

2. Unit position placement flow

```mermaid
flowchart TB
  U0[start units for each sub zone] --> U1[derive cell size from min of minGroups minBuildings minUnits]
  U1 --> U2[build structuresGrid from base static scenery]
  U2 --> U3[also build baseGrid staticGrid sceneryGrid for strict direct checks]
  U3 --> U4[build groupsGrid from nearby units and WORLD DB]
  U4 --> U5[init centersGrid empty for placed units]
  U5 --> U6[for each groupSetting in sub zone]
  U6 --> U7[for each group i from one to numGroups]
  U7 --> U8[for each unit j in generatedGroupUnitTypes for group i]
  U8 --> P0[glassBreak equals zero accepted false]
  P0 --> P1[pick random point within maxGroups radius around group center or sub zone center]
  P1 --> P2[compute relax factor up to thirty percent for minUnits and minBuildings]
  P2 --> Q0{centersGrid within relaxed minUnits}
  Q0 -- true --> R[reject]
  Q0 -- false --> Q1{groupsGrid within relaxed minUnits}
  Q1 -- true --> R
  Q1 -- false --> Q2{structuresGrid within relaxed minBuildings}
  Q2 -- true --> R
  Q2 -- false --> DB{strict direct reject against baseGrid}
  DB -- true --> R
  DB -- false --> DS{strict direct reject against staticGrid}
  DS -- true --> R
  DS -- false --> DC{strict direct reject against sceneryGrid}
  DC -- true --> R
  DC -- false --> N0{checkIsInNOGO when enabled}
  N0 -- true --> R
  N0 -- false --> ACC[provisionally accept]
  R --> F0{glassBreak at or beyond operationLimit}
  F0 -- no --> INC[glassBreak plus one and maybeYield]
  F0 -- yes --> FB{was building direct reject false}
  FB -- yes --> ACC
  FB -- no --> BEX{glassBreak below limit plus extra attempts building}
  BEX -- yes --> X[force reject and retry]
  BEX -- no --> X
  ACC --> SB[recheck strict building direct reject on all three grids]
  SB -- true --> X
  SB -- false --> OK[accept unit pos and insert into centersGrid]
  X --> INC
  OK --> NX[next unit or group]
  INC --> P1
```

3. Grid hashing mechanics

```mermaid
flowchart LR
  G0[input candidates and objects] --> G1[toCell floor by cell size]
  G1 --> G2[cellKey concatenate indices]
  G2 --> G3[gridInsert push record with x y and optional r radius]
  G3 --> G4[gridQuery scan neighbor range cells only]
  G4 --> G5[distance squared compare against threshold squared]
```

4. Notes and invariants

- Strict building separation is never relaxed during final accept checks. Center and unit placement both enforce direct per object checks via [AETHR.SPAWNER:_directCellStructureReject()](dev/SPAWNER.lua:233) with extra padding BUILD_PAD.
- Relaxation affects only group to group and unit to unit and structures fast prune thresholds, capped at thirty percent as operation budget depletes. See computation inside [AETHR.SPAWNER:generateVec2GroupCenters()](dev/SPAWNER.lua:1179) and [AETHR.SPAWNER:generateVec2UnitPos()](dev/SPAWNER.lua:1443).
- NoGo surfaces are always enforced through [AETHR.SPAWNER:vec2AtNoGoSurface()](dev/SPAWNER.lua:2128). Polygonal restricted zones are enforced only when enabled through [AETHR.SPAWNER:checkIsInNOGO()](dev/SPAWNER.lua:2085).
- Candidate selection uses uniform random sampling inside circles using POLY utilities: centers from sub zone circle [AETHR.POLY:getRandomVec2inCircle](dev/POLY.lua:0) and units from a radius around the group center, value maxGroups from separation settings.
- Cooperative yielding is done periodically based on operationLimit to avoid blocking frames via [AETHR.SPAWNER:_maybeYield()](dev/SPAWNER.lua:255).
- Grids reduce neighbor queries by scanning only a bounded number of cells around the candidate derived from neighbor ranges computed from thresholds and cell size.