# AETHR BRAIN scheduler

Entry anchors
- [AETHR.BRAIN:scheduleTask()](dev/BRAIN.lua:277)
- [AETHR.BRAIN:runScheduledTasks()](dev/BRAIN.lua:306)

Purpose
The scheduler manages delayed and repeating work using a drift resistant next run calculation and safe execution with pcall.

Flow: scheduleTask

```mermaid
flowchart TD
  ST1[call scheduleTask] --> ST2[get next SchedulerID]
  ST2 --> ST3[normalize delay and repeat interval]
  ST3 --> ST4[flatten varargs into args table]
  ST4 --> ST5[create ScheduledTask via AETHR _task New]
  ST5 --> ST6[store in DATA Schedulers by id]
  ST6 --> ST7[return SchedulerID]
```

Flow: runScheduledTasks

```mermaid
flowchart TD
  RS0[call runScheduledTasks] --> RS1[read current time]
  RS1 --> RS2[for each id and task in Schedulers]
  RS2 --> RS3[stop when executed hits maxPerTick if set]
  RS3 --> RS4{task active not running and due}
  RS4 -->|no| RS2
  RS4 -->|yes| RS5[mark running and update lastRun and iterations]
  RS5 --> RS6[pcall taskFunction with args]
  RS6 --> RS7{task repeating}
  RS7 -->|yes| RS8[advance nextRun by repeatInterval]
  RS7 -->|no| RS9[deactivate task]
  RS8 --> RS10{nextRun behind now}
  RS10 -->|yes| RS11[push to now plus interval]
  RS10 -->|no| RS12[keep computed nextRun]
  RS9 --> RS13[mark not active]
  RS11 --> RS14[apply stopping conditions]
  RS12 --> RS14[apply stopping conditions]
  RS14 --> RS15[clear running flag]
  RS15 --> RS16{task inactive}
  RS16 -->|yes| RS17[remove from Schedulers]
  RS16 -->|no| RS2
```

Sequence: typical scheduling usage

```mermaid
sequenceDiagram
  participant WL as WORLD
  participant BR as BRAIN
  WL->>BR: scheduleTask for world updates
  loop main tick
    BR->>BR: runScheduledTasks with optional cap
    BR-->>WL: execute due tasks
  end
```

Notes and guarantees
- No drift on repeating tasks by computing nextRun from previous nextRun when possible [AETHR.BRAIN:runScheduledTasks()](dev/BRAIN.lua:331)
- Overdue protection pushes nextRun forward when behind [AETHR.BRAIN:runScheduledTasks()](dev/BRAIN.lua:336)
- Safe execution via pcall and debug logging where available [AETHR.BRAIN:runScheduledTasks()](dev/BRAIN.lua:322)
- Removal of inactive tasks frees memory [AETHR.BRAIN:runScheduledTasks()](dev/BRAIN.lua:356)
- Identifier handle allows external cancel or inspection [AETHR.BRAIN:scheduleTask()](dev/BRAIN.lua:300)

Cross links
- Data structures: [docs/brain/data_structures.md](docs/brain/data_structures.md)
- Module index: [docs/brain/README.md](docs/brain/README.md)