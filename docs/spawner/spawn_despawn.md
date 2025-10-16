# AETHR SPAWNER build, spawn, and despawn flows

Covered functions
- Build prototypes:
  - [AETHR.SPAWNER:buildSpawnGroups()](../../dev/SPAWNER.lua:684)
  - [AETHR.SPAWNER:buildGroundUnit()](../../dev/SPAWNER.lua:282)
  - [AETHR.SPAWNER:buildGroundGroup()](../../dev/SPAWNER.lua:321)
  - [AETHR.SPAWNER:assembleUnitsForGroup()](../../dev/SPAWNER.lua:358)
- World actions:
  - [AETHR.SPAWNER:spawnGroup()](../../dev/SPAWNER.lua:425)
  - [AETHR.SPAWNER:spawnDynamicSpawner()](../../dev/SPAWNER.lua:438)
  - [AETHR.SPAWNER:despawnGroup()](../../dev/SPAWNER.lua:457)
  - [AETHR.SPAWNER:updateDBGroupInfo()](../../dev/SPAWNER.lua:393)

Context
- Queues: [SPAWNER.DATA.spawnQueue](../../dev/SPAWNER.lua:82), [SPAWNER.DATA.despawnQueue](../../dev/SPAWNER.lua:84) are processed by WORLD.
- Safety delay: [SPAWNER.DATA.CONFIG.SPAWNER_WAIT_TIME](../../dev/SPAWNER.lua:95) defines delay before a newly added group is eligible for further processing, to prevent DCS instability.
- WORLD-side handlers: spawning and despawning execution happens in WORLD routines, external to this module.


# 1) Building prototypes from generated plans

### Input sources for build:
- Per-subzone plans created earlier: groupSettings.generatedGroupTypes, groupSettings.generatedGroupUnitTypes, groupSettings.generatedGroupCenterVec2s, groupSettings.generatedUnitVec2s from [AETHR.SPAWNER:generateSpawnerGroups()](../../dev/SPAWNER.lua:660).

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TB
  subgraph "Iterate & collect"
    direction TB
    B0[start buildSpawnGroups] --> B1[for each sub zone]
    B1 --> B2[init empty spawnGroups]
    B2 --> B3[for each groupSetting with numGroups greater than zero]
    B3 --> B4[for each group index]
    B4 --> U0[for each unit in generated list]
  end

  subgraph "Unit & group build"
    direction TB
    U0 --> U1[call buildGroundUnit with type vec2 and attributes]
    U1 --> U2[collect unit names]
    U2 --> G0[call assembleUnitsForGroup resolve unit prototypes]
    G0 --> G1[call buildGroundGroup with center route tasks flags]
    G1 --> G2[append group name to spawnGroups]
  end

  G2 --> NEXT[next group or setting]
  NEXT --> ASSIGN[assign spawnGroups to subZone]

  class B0 class_io;
  class B1,B2,B3,B4,U0,U1,U2,G0,G1,G2,NEXT,ASSIGN class_step;
```

- [AETHR.SPAWNER:buildGroundUnit()](../../dev/SPAWNER.lua:282) creates a unit prototype via AETHR._groundUnit and stores it in [SPAWNER.DATA.generatedUnits](../../dev/SPAWNER.lua:80).
- [AETHR.SPAWNER:buildGroundGroup()](../../dev/SPAWNER.lua:321) creates a group prototype via AETHR._groundGroup and stores it in [SPAWNER.DATA.generatedGroups](../../dev/SPAWNER.lua:76).
- No mission engine mutation occurs in the build phase; prototypes are prepared for later instantiation.


# 2) Spawning prepared groups

## Two entry points:
- Single group spawn: [AETHR.SPAWNER:spawnGroup()](../../dev/SPAWNER.lua:425)
- Batch spawn for a dynamic spawner: [AETHR.SPAWNER:spawnDynamicSpawner()](../../dev/SPAWNER.lua:438)

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  subgraph "Single group spawn"
    S0[start spawn] --> S1[get group prototype by name]
    S1 --> TS[set _engineAddTime via UTILS.getTime]
    TS --> CA[coalition.addGroup with country ID and Group.Category.GROUND]
    CA --> QP[push name to SPAWNER.DATA.spawnQueue]
  end
  QP --> OUT[WORLD will process spawn queue after wait time]
  class S0 class_io;
  class S1,TS,CA,QP class_step;
  class OUT class_result;
```

## Batch spawn across a dynamic spawner:

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  subgraph "Batch spawn"
    DS0[start spawnDynamicSpawner] --> DS1[for each sub zone]
    DS1 --> DS2[for each group in subZone.spawnGroups]
    DS2 --> DS3[lookup prototype from generatedGroups]
    DS3 --> DS4[set _engineAddTime and call coalition.addGroup]
    DS4 --> DS5[push name to spawnQueue]
  end
  class DS0 class_io;
  class DS1,DS2,DS3,DS4,DS5 class_step;
```

Notes
- Country selection: explicit countryID overrides the prototype’s countryID when provided to [AETHR.SPAWNER:spawnGroup()](../../dev/SPAWNER.lua:425) and [AETHR.SPAWNER:spawnDynamicSpawner()](../../dev/SPAWNER.lua:438).
- After adding to the mission engine, WORLD respects [SPAWNER_WAIT_TIME](../../dev/SPAWNER.lua:95) before further actions.
- The queue enables WORLD to throttle operations within [operationLimit](../../dev/SPAWNER.lua:98) per cycle.


# 3) Despawning live groups

Before enqueueing despawn, the module snapshots the group’s latest unit positions and recomputes group center.

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  subgraph "Despawn"
    D0[start despawnGroup] --> D1[updateDBGroupInfo]
    D1 --> D2[push name to SPAWNER.DATA.despawnQueue]
  end
  D2 --> OUT[WORLD processes despawn queue]
  class D0 class_io;
  class D1,D2 class_step;
  class OUT class_result;
```

## Details of [AETHR.SPAWNER:updateDBGroupInfo()](../../dev/SPAWNER.lua:393)

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
sequenceDiagram
  participant SPAWNER
  participant DCSG as Group
  participant POLY
  SPAWNER->>DCSG: getByName
  DCSG-->>SPAWNER: groupObj
  SPAWNER->>DCSG: getUnits
  DCSG-->>SPAWNER: unitsObj
  loop for each unit
    SPAWNER-->>SPAWNER: read unit:getPoint and unit:getLife
    SPAWNER-->>SPAWNER: record alive unit positions
    SPAWNER-->>SPAWNER: persist unit x and y into generatedGroups DB
  end
  SPAWNER->>POLY: getCenterPoint with alive unit positions
  POLY-->>SPAWNER: center vec2
  SPAWNER-->>SPAWNER: write DB.x and DB.y with center
```

Actions performed within updateDBGroupInfo:
- Read unit positions from DCS and write last-known ground X Z into the DB as x y for the group prototype.
- Recompute and store the group center using [AETHR.POLY:getCenterPoint](../../dev/POLY.lua).
- Ensures WORLD has accurate final positions for post-despawn analytics or re-spawn logic.


# 4) Activation utilities

- [AETHR.SPAWNER:activateGroup()](../../dev/SPAWNER.lua:375) calls Group.activate on a named group.
- [AETHR.SPAWNER:deactivateGroup()](../../dev/SPAWNER.lua:383) calls trigger.action.deactivateGroup on a named group.

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart LR
  subgraph "Activation"
    direction LR
    A[activateGroup] --> GA[Group.activate]
  end
  subgraph "Deactivation"
    direction LR
    D[deactivateGroup] --> TG[trigger.action.deactivateGroup]
  end
  class A,D class_io;
  class GA,TG class_step;
```

# 5) End-to-end lifecycle overview

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart LR
  subgraph "Plan & Build"
    direction LR
    PLAN[generateSpawnerGroups and buildSpawnGroups] --> PROTO[prototypes in generatedGroups and generatedUnits]
  end
  subgraph "Spawn & Live"
    direction LR
    PROTO --> SPAWN[spawnGroup or spawnDynamicSpawner]
    SPAWN --> Q[enqueue spawnQueue]
    Q --> WORLD[WORLD handles spawn timing and limits]
    WORLD --> LIVE[live group in world]
  end
  subgraph "Despawn"
    direction LR
    LIVE --> DESP[despawnGroup]
    DESP --> SNAP[updateDBGroupInfo]
    SNAP --> DQ[enqueue despawnQueue]
    DQ --> W2[WORLD performs despawn]
  end
  class PLAN class_io;
  class PROTO,SPAWN,Q,WORLD,LIVE,DESP,SNAP,DQ,W2 class_step;
```

# Operational guardrails
- Avoid immediate post-add mutations until after [SPAWNER_WAIT_TIME](../../dev/SPAWNER.lua:95) elapses to prevent engine instability.
- Respect [operationLimit](../../dev/SPAWNER.lua:98) to bound per-cycle spawn and despawn work.
- Always snapshot before despawn to keep DB consistent for analytics and potential future reuse.