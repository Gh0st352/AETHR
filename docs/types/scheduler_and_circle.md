# TYPES scheduler and circle

Anchors
- [AETHR._task:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L483)
- [AETHR._circle:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L1471)
- [_dbCluster structure](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L1482)

Overview
- _task encapsulates scheduling metadata used by the BRAIN scheduler, including time windows, iteration caps, and repeat logic.
- _circle provides a minimal geometric helper with precomputed diameter, circumference, and area.
- _dbCluster is a data structure returned by clustering utilities, containing references to points, a center, and a radius.

# Task constructor defaults and timing
```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  subgraph TASK ["AETHR._task New"]
    T["AETHR._task New"]
    subgraph TIME ["Timing"]
      DLY[delay default 0]
      LR[lastRun 0]
      NR[nextRun now plus delay]
      ST[stopTime now plus stopAfterTime or nil]
    end
    subgraph LIMITS ["Limits and repeats"]
      STA[stopAfterTime default nil]
      SAI[stopAfterIterations passthrough]
      RI[repeatInterval default nil]
      ITR[iterations 0]
      REP[repeating computed flag]
    end
    subgraph EXEC ["Execution"]
      TF[taskFunction default nil]
      ARGS["functionArgs default []"]
    end
    subgraph FLAGS ["Flags and IDs"]
      RUN[running false]
      ACT[active true]
      SID[schedulerID default 0]
    end
    T --> STA
    T --> SAI
    T --> RI
    T --> DLY
    T --> TF
    T --> ARGS
    T --> ITR
    T --> LR
    T --> NR
    T --> ST
    T --> RUN
    T --> ACT
    T --> SID
    T --> REP
  end

  class T,STA,SAI,RI,DLY,TF,ARGS,ITR,LR,NR,ST,RUN,ACT,SID,REP,TASK,TIME,LIMITS,EXEC,FLAGS class_data;
```

# Scheduler interaction sequence
```mermaid
%% shared theme: docs/_mermaid/theme.json %%
sequenceDiagram
  participant C as Caller
  participant T as _task
  participant BR as BRAIN scheduler
  C->>T: New(stopAfterTime, stopAfterIterations, repeatInterval, delay, taskFunction, args, schedulerID)
  T-->>C: task instance with timing fields
  C->>BR: scheduleTask(T)
  loop scheduler tick
    BR->>T: if now >= T.nextRun then run
    T-->>BR: update iterations lastRun nextRun stopTime running
    alt limits reached
      BR-->>T: set active false
    end
  end
```

# Circle constructor fields
```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart LR
  subgraph CIRCLE ["_circle New"]
    C2[_circle New] --> Ctr[center vec2]
    C2 --> Rad[radius]
    C2 --> Dia[diameter 2r]
    C2 --> Circ[circumference 2 pi r]
    C2 --> Area[area pi r^2]
  end
  class C2,Ctr,Rad,Dia,Circ,Area,CIRCLE class_data;
```

# Cluster result structure
```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  subgraph CLUSTER ["_dbCluster"]
    CL[_dbCluster] --> PTS[Points references]
    CL --> CTR[Center vec2]
    CL --> RAD[Radius meters]
  end
  class CL,PTS,CTR,RAD,CLUSTER class_data;
```

# Source anchors
- Task: [AETHR._task:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L483)
- Circle: [AETHR._circle:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L1471)
- Cluster: [_dbCluster](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L1482)
- Related scheduler pages: [docs/brain/scheduler.md](../brain/scheduler.md)