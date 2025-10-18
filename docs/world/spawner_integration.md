# WORLD ↔ SPAWNER integration

### Primary WORLD anchors
- Generation dispatch: [AETHR.WORLD:spawnerGenerationQueue()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L801)
- Activation: [AETHR.WORLD:spawnGroundGroups()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L538)
- Deactivation: [AETHR.WORLD:despawnGroundGroups()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L590)

### Related SPAWNER anchors
- Enqueue job: [AETHR.SPAWNER:enqueueGenerateDynamicSpawner()](https://github.com/Gh0st352/AETHR/blob/main/dev/SPAWNER.lua#L520)
- Main generation: [AETHR.SPAWNER:generateDynamicSpawner()](https://github.com/Gh0st352/AETHR/blob/main/dev/SPAWNER.lua#L563)
- Placement, building, and counts: see SPAWNER index [../spawner/README.md](../spawner/README.md)

### Coroutine controls
- WORLD uses BRAIN coroutine configs:
  - spawn generation queue: `self.SPAWNER.DATA._genState` and `self.SPAWNER:_maybeYield(...)`
  - spawn/despawn loops: `self.BRAIN.DATA.coroutines.spawnGroundGroups` / `despawnGroundGroups`

# spawnerGenerationQueue

Processes one queued generation job per invocation, marking job status and timestamps. Heavy work yields deep inside SPAWNER via `_maybeYield`.

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  SGQ[[spawnerGenerationQueue]] --> STATE[ensure genState and read jobs and queue]
  STATE --> RUN{already running job}
  RUN -- "yes" --> RET0([return self])
  RUN -- "no" --> NEXTID[pop next job id from queue]
  NEXTID -- "none" --> RET0
  NEXTID -- "found" --> JOBJ[resolve job by id]
  subgraph "Job execution"
    JOBJ --> MARK[set currentJobId status running and startedAt]
    MARK --> CALL[SPAWNER generateDynamicSpawner]
    CALL --> OPT{autoSpawn}
    OPT -- "yes" --> SPAWN[SPAWNER spawnDynamicSpawner]
    OPT -- "no" --> SKIP
    SPAWN --> DONE[complete]
    SKIP --> DONE
    DONE --> FIN[set completedAt, mark done, clear currentJobId]
    FIN --> YIELD[SPAWNER maybeYield]
  end
  YIELD --> RET([return self])

  class RUN,OPT class_decision;
  class RET,RET0 class_result;
  class SGQ,STATE,NEXTID,JOBJ,MARK,CALL,SPAWN,SKIP,DONE,FIN,YIELD class_step;
```

### Anchors
- Entry: [AETHR.WORLD:spawnerGenerationQueue()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L801)
- SPAWNER calls: [AETHR.SPAWNER:generateDynamicSpawner()](https://github.com/Gh0st352/AETHR/blob/main/dev/SPAWNER.lua#L563)

# spawnGroundGroups

Activates groups by name when their engine add time has aged past the configured wait window.

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  SGG[[spawnGroundGroups]] --> Q[queue from spawner data spawnQueue]
  Q --> LOOP[for i descending from queue length to one]
  subgraph "Activation scan"
    LOOP --> NAME[get name entry]
    NAME --> WAIT{curTime - addTime < waitTime}
    WAIT -- "true" --> SKIP[debug skip and continue]
    WAIT -- "false" --> ACT[get group by name then activate via pcall]
    ACT --> RES{activated}
    RES -- "yes" --> REM[remove from queue]
    RES -- "no" --> DBG[debug activate fail]
    REM --> YLD{yield threshold}
    DBG --> YLD
    YLD -- "hit" --> CY[debug yield]
    YLD -- "not hit" --> NEXT[next]
    CY --> NEXT
  end
  NEXT --> END([return self])

  class WAIT,RES,YLD class_decision;
  class END class_result;
  class SGG,Q,LOOP,NAME,ACT,REM,DBG,CY,NEXT,SKIP class_step;
```

### Anchors
- [AETHR.WORLD:spawnGroundGroups()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L538)

# despawnGroundGroups

Deactivates groups by name using trigger.action.deactivateGroup and removes successful entries from the queue.

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  DSG[[despawnGroundGroups]] --> QD[queue from spawner data despawnQueue]
  QD --> LOOP[for i descending from queue length to one]
  subgraph "Deactivation scan"
    LOOP --> NAME[get name entry]
    NAME --> TRY[pcall get group by name and deactivate]
    TRY --> RES{deactivated}
    RES -- "yes" --> REM[remove from queue]
    RES -- "no" --> DBG[debug deactivate fail]
    REM --> YLD{yield threshold}
    DBG --> YLD
    YLD -- "hit" --> CY[debug yield]
    YLD -- "not hit" --> NEXT[next]
    CY --> NEXT
  end
  NEXT --> END([return self])

  class RES,YLD class_decision;
  class END class_result;
  class DSG,QD,LOOP,NAME,TRY,REM,DBG,CY,NEXT class_step;
```

### Anchors
- [AETHR.WORLD:despawnGroundGroups()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L590)

# Sequence overview

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
sequenceDiagram
  participant Z as ZONE_MANAGER
  participant W as WORLD
  participant S as SPAWNER
  participant B as BRAIN
  Z->>S: enqueueGenerateDynamicSpawner(...)  (queue job)
  S-->>W: job available in SPAWNER.DATA.GenerationQueue
  loop scheduled tick
    W->>W: spawnerGenerationQueue
    W->>S: generateDynamicSpawner(...)
    alt autoSpawn
      W->>S: spawnDynamicSpawner(...)
    end
  end
  S-->>W: SPAWNER.DATA.spawnQueue filled with group names
  loop scheduled tick
    W->>W: spawnGroundGroups (activate)
    W->>W: despawnGroundGroups (deactivate)
  end
```

### Notes
- Activation defers until `UTILS:getTime() - group._engineAddTime >= SPAWNER.DATA.CONFIG.SPAWNER_WAIT_TIME`.
- All engine calls guarded by pcall to avoid hard faults when objects are missing.
- Yielding behavior controlled by `BRAIN.DATA.coroutines.spawnGroundGroups` and `.despawnGroundGroups`.

# Anchor index

- WORLD
  - Generation: [AETHR.WORLD:spawnerGenerationQueue()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L801)
  - Activation: [AETHR.WORLD:spawnGroundGroups()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L538)
  - Deactivation: [AETHR.WORLD:despawnGroundGroups()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L590)
- SPAWNER
  - Enqueue: [AETHR.SPAWNER:enqueueGenerateDynamicSpawner()](https://github.com/Gh0st352/AETHR/blob/main/dev/SPAWNER.lua#L520)
  - Generate: [AETHR.SPAWNER:generateDynamicSpawner()](https://github.com/Gh0st352/AETHR/blob/main/dev/SPAWNER.lua#L563)
- Related
  - SPAWNER pipeline: [../spawner/pipeline.md](../spawner/pipeline.md)