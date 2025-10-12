# TYPES scheduler and circle

Anchors
- [AETHR._task:New()](../../dev/customTypes.lua:483)
- [AETHR._circle:New()](../../dev/customTypes.lua:1471)
- [_dbCluster structure](../../dev/customTypes.lua:1482)

Overview
- _task encapsulates scheduling metadata used by the BRAIN scheduler, including time windows, iteration caps, and repeat logic.
- _circle provides a minimal geometric helper with precomputed diameter, circumference, and area.
- _dbCluster is a data structure returned by clustering utilities, containing references to points, a center, and a radius.

Task constructor defaults and timing
```mermaid
flowchart TD
  T[AETHR._task New] --> STA[stopAfterTime default nil]
  T --> SAI[stopAfterIterations passthrough]
  T --> RI[repeatInterval default nil]
  T --> DLY[delay default 0]
  T --> TF[taskFunction default nil]
  T --> ARGS[functionArgs default []]
  T --> ITR[iterations 0]
  T --> LR[lastRun 0]
  T --> NR[nextRun now plus delay]
  T --> ST[stopTime now plus stopAfterTime or nil]
  T --> RUN[running false]
  T --> ACT[active true]
  T --> SID[schedulerID default 0]
  T --> REP[repeating computed flag]
```

Scheduler interaction sequence
```mermaid
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

Circle constructor fields
```mermaid
flowchart LR
  C2[_circle New] --> Ctr[center vec2]
  C2 --> Rad[radius]
  C2 --> Dia[diameter radius times 2]
  C2 --> Circ[circumference 2 pi r]
  C2 --> Area[area pi r^2]
```

Cluster result structure
```mermaid
flowchart TD
  CL[_dbCluster] --> PTS[Points references]
  CL --> CTR[Center vec2]
  CL --> RAD[Radius meters]
```

Source anchors
- Task: [AETHR._task:New()](../../dev/customTypes.lua:483)
- Circle: [AETHR._circle:New()](../../dev/customTypes.lua:1471)
- Cluster: [_dbCluster](../../dev/customTypes.lua:1482)
- Related scheduler pages: [docs/brain/scheduler.md](../brain/scheduler.md)