# AETHR SPAWNER zones and divisions

### Covered functions
- [AETHR.SPAWNER:generateSpawnerZones()](../../dev/SPAWNER.lua:2012)
- [AETHR.SPAWNER:weightZones()](../../dev/SPAWNER.lua:2148)
- [AETHR.SPAWNER:pairSpawnerWorldDivisions()](../../dev/SPAWNER.lua:723)
- [AETHR.SPAWNER:pairSpawnerActiveZones()](../../dev/SPAWNER.lua:760)
- [AETHR.SPAWNER:pairSpawnerZoneDivisions()](../../dev/SPAWNER.lua:803)
- [AETHR.SPAWNER:determineZoneDivObjects()](../../dev/SPAWNER.lua:857)

# 1. Zone generation and weighting
The spawner constructs a main zone and subzones, then assigns weights to each. Generation avoids restricted zones when provided to POLY utilities. See [dev/POLY.lua](../../dev/POLY.lua).

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  subgraph "Generate zones"
    direction TB
    Z0[generateSpawnerZones] --> Z1[reset subzones]
    Z1 --> Z2[create main zone object]
    Z2 --> Z3[compute sub zone minimum radius]
    Z3 --> Z4[call POLY generateSubCircles]
    Z4 --> Z5[instantiate spawner sub zone objects]
  end
  subgraph "Weighting"
    direction TB
    Z5 --> W0[weightZones]
    W0 --> W1[compute sub weights as area over main area]
    W1 --> W2[set main weight to one minus sum of subs]
  end
  class Z0 class_io;
  class Z1,Z2,Z3,Z4,Z5,W0,W1,W2 class_step;
```

# 2. Pairing to divisions
The spawner pairs against MIZ zones when available, otherwise world divisions. Results populate dynamicSpawner.worldDivisions and per zone worldDivisions.

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  subgraph "Mode select"
    direction TB
    P0[start pairing] --> P1{any MIZ zones}
    P1 -- "yes" --> A0[pairSpawnerActiveZones]
    P1 -- "no" --> W2x[pairSpawnerWorldDivisions]
  end
  subgraph "Assign"
    direction TB
    A0 --> W3[worldDivisions set from active MIZ zone divisions]
    W2x --> W3
    W3 --> ZD[pairSpawnerZoneDivisions]
    ZD --> ZDm[filter divisions for main zone]
    ZD --> ZDs[filter divisions for each sub zone]
  end
  ZDm --> OUT[zone worldDivisions assigned]
  ZDs --> OUT
  class P0 class_io;
  class P1 class_decision;
  class A0,W2x,W3,ZD,ZDm,ZDs class_step;
  class OUT class_result;
```

# 3. Object collection per sub zone
For each sub zone and its divisions, objects are collected into zoneDivSceneryObjects, zoneDivStaticObjects, and zoneDivBaseObjects using AABB prefilter and optional full include optimization. Config switches: [UseDivisionAABBReject](../../dev/SPAWNER.lua:96), [UseDivisionAABBFullInclude](../../dev/SPAWNER.lua:97). Cooperative yielding: [AETHR.SPAWNER:_maybeYield()](../../dev/SPAWNER.lua:255).

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TB
  subgraph "Iterate subzones & divisions"
    direction TB
    S0[start collect] --> L0[for each sub zone]
    L0 --> L1[for each division]
  end
  subgraph "AABB gate"
    direction TB
    L1 --> AABB0[AABB available and reject enabled]
    AABB0 -- "yes" --> REJ[circle vs AABB distance greater than radius squared]
    REJ -- "yes" --> SKIP[skip division]
    REJ -- "no" --> INC[full include enabled]
    AABB0 -- "no" --> INC
  end
  subgraph "Collect objects"
    direction TB
    INC -- "yes" --> ALL[append all objects from division lists]
    INC -- "no" --> PO[per object distance within radius squared]
    PO --> ADD[append passing objects into zone lists]
    ALL --> NEXT[next division]
    ADD --> NEXT
    SKIP --> NEXT
  end
  NEXT --> Y0[maybe yield]
  Y0 -- "yes" --> Y1[yield]
  Y0 -- "no" --> L1
  class S0 class_io;
  class L0,L1,AABB0,REJ,INC,ALL,PO,ADD,SKIP,NEXT,Y0,Y1 class_step;
  class REJ class_decision;
```

### Notes
- Division object sources come from WORLD databases for scenery, static, and base objects.
- Full include treats a division as entirely inside when all AABB corners lie inside the sub zone circle.
- Distance checks use squared distances to avoid square roots.

# Flowchart: Zones and divisions pipeline

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart LR
  subgraph "Pairing"
    direction LR
    START[dynamicSpawner] --> CHOOSE{MIZ zones available}
    CHOOSE -- "yes" --> PA[pairSpawnerActiveZones]
    CHOOSE -- "no" --> PW[pairSpawnerWorldDivisions]
  end
  subgraph "Objects"
    direction LR
    PA --> PZ[pairSpawnerZoneDivisions]
    PW --> PZ
    PZ --> OBJ[determineZoneDivObjects]
    OBJ --> OUT[subZones have worldDivisions and per-division objects]
  end
  class START class_io;
  class CHOOSE class_decision;
  class PA,PW,PZ,OBJ,OUT class_step;
```

Source anchors
- [AETHR.SPAWNER:pairSpawnerActiveZones()](../../dev/SPAWNER.lua:760)
- [AETHR.SPAWNER:pairSpawnerWorldDivisions()](../../dev/SPAWNER.lua:723)
- [AETHR.SPAWNER:pairSpawnerZoneDivisions()](../../dev/SPAWNER.lua:803)
- [AETHR.SPAWNER:determineZoneDivObjects()](../../dev/SPAWNER.lua:857)
- [AETHR.POLY:circleOverlapPoly()](../../dev/POLY.lua:115)

## Sequence: Pair and collect divisions and objects

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
sequenceDiagram
  participant SP as SPAWNER
  participant DZ as dynamicSpawner
  participant SUB as subZones[*]
  participant WD as WORLD.DATA
  participant POLY as POLY

  Note over SP,DZ: Decide pairing mode
  SP->>SP: pairSpawnerActiveZones or pairSpawnerWorldDivisions
  alt MIZ zones present
    SP->>DZ: pairSpawnerActiveZones()
    SP->>WD: use ZONE_MANAGER.DATA.MIZ_ZONES activeDivisions
    DZ-->>SP: spawnerActiveDivisions
  else
    SP->>DZ: pairSpawnerWorldDivisions()
    SP->>WD: iterate WORLD.DATA.worldDivisions
    loop for each division
      SP->>POLY: circleOverlapPoly(maxRadius, center, div.corners)
    end
    DZ-->>SP: spawnerActiveDivisions
  end

  Note over SP,SUB: Pair per-subzone divisions
  SP->>SUB: pairSpawnerZoneDivisions()
  loop for each subZone
    SP->>POLY: circleOverlapPoly(actualRadius, center, div.corners)
    SUB-->>SP: subZone.worldDivisions populated
  end

  Note over SP,SUB: Collect per-division objects
  SP->>SUB: determineZoneDivObjects()
  loop for each subZone and its worldDivisions
    SP->>WD: read divisionSceneryObjects/static/base
    SP->>POLY: distance tests and AABB fast paths
    SUB-->>SP: zoneDivSceneryObjects/static/base populated
  end
```

# Source anchors
- [AETHR.SPAWNER:pairSpawnerActiveZones()](../../dev/SPAWNER.lua:760)
- [AETHR.SPAWNER:pairSpawnerWorldDivisions()](../../dev/SPAWNER.lua:723)
- [AETHR.SPAWNER:pairSpawnerZoneDivisions()](../../dev/SPAWNER.lua:803)
- [AETHR.SPAWNER:determineZoneDivObjects()](../../dev/SPAWNER.lua:857)
- [AETHR.POLY:circleOverlapPoly()](../../dev/POLY.lua:115)