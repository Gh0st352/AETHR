# AETHR startup and watchers

Primary anchors
- [AETHR:Start()](../../dev/AETHR.lua:252)
- [WORLD updateAirbaseOwnership call site](../../dev/AETHR.lua:254)
- [timer.scheduleFunction for BackgroundProcesses](../../dev/AETHR.lua:255)
- [setupWatchers invocation](../../dev/AETHR.lua:257)
- [AETHR:setupWatchers()](../../dev/AETHR.lua:334)
- [initWatcher_AirbaseOwnership](../../dev/AETHR.lua:335)
- [initWatcher_ZoneOwnership](../../dev/AETHR.lua:336)

Overview
[AETHR:Start()](../../dev/AETHR.lua:252) performs an immediate ownership update, schedules the recurring background loop, and registers event watchers via [AETHR:setupWatchers()](../../dev/AETHR.lua:334).

Flowchart

```mermaid
%%{init: {"theme":"base","themeVariables":{"primaryColor":"#e6f3ff","primaryBorderColor":"#0066cc","lineColor":"#495057","textColor":"#e9ecef","fontSize":"14px"}}}%%
flowchart
  %% Groupings
  subgraph BOOT ["Startup"]
    S["Start"]
    U["Update airbase ownership"]
  end

  subgraph SCHED ["Scheduling"]
    SCH["Schedule BackgroundProcesses"]
  end

  subgraph WATCH ["Watchers"]
    W["Setup watchers"]
  end

  RT["Return self"]

  %% Flow
  S --> U
  U --> SCH
  SCH --> W
  W --> RT

  %% Styles
  classDef core fill:#e6f3ff,stroke:#0066cc,stroke-width:2px,color:#000
  classDef process fill:#cce5ff,stroke:#0066cc,color:#000

  %% Apply classes
  class S,RT core
  class U,SCH,W process

  %% Subgraph styles
  style BOOT fill:#f9f9f9,stroke:#ccc,stroke-width:2px
  style SCHED fill:#fff0e6,stroke:#ff9900,stroke-width:2px
  style WATCH fill:#f8f9fa,stroke:#495057,stroke-width:2px
```

Sequence timeline

```mermaid
%%{init: {"theme":"base","themeVariables":{"actorBkg":"#e6f3ff","actorTextColor":"#000000ff","lineColor":"#495057","signalColor":"#0066cc","signalTextColor":"#000000ff","textColor":"#000000ff","fontSize":"14px"}}}%%
sequenceDiagram
  participant A as "AETHR"
  participant W as "WORLD"
  participant T as "Timer"

  rect rgba(255,255,255,0.75)
    A->>W: updateAirbaseOwnership
    A->>T: schedule BackgroundProcesses at now plus interval
    A->>A: setupWatchers
    A-->>A: return self
  end
```

Watchers registered

```mermaid
%%{init: {"theme":"base","themeVariables":{"primaryColor":"#e6f3ff","primaryBorderColor":"#0066cc","lineColor":"#495057","textColor":"#000000ff","fontSize":"14px"}}}%%
flowchart TB
  %% Group
  subgraph WATCHERS ["Watchers"]
    SW["setupWatchers"]
    subgraph ZM_WATCHERS ["ZONE_MANAGER watchers"]
      Z1["initWatcher AirbaseOwnership"]
      Z2["initWatcher ZoneOwnership"]
    end
  end

  SW --> Z1
  SW --> Z2

  %% Styles
  classDef core fill:#e6f3ff,stroke:#0066cc,stroke-width:2px,color:#000
  classDef process fill:#cce5ff,stroke:#0066cc,color:#000

  %% Apply classes
  class SW core
  class Z1,Z2 process

  %% Subgraph style
  style WATCHERS fill:#f9f9f9,stroke:#ccc,stroke-width:2px
  style ZM_WATCHERS fill:#e9ecef,stroke:#6c757d,stroke-width:2px
```

Notes
- The immediate ownership update at [call site](../../dev/AETHR.lua:254) ensures initial world state is consistent before the first background loop.
- Scheduling uses [timer.scheduleFunction](../../dev/AETHR.lua:255) to run [AETHR:BackgroundProcesses()](../../dev/AETHR.lua:267) on cadence managed by [AETHR.BRAIN.DATA.BackgroundLoopInterval](../../dev/AETHR.lua:255).
- For watcher details and event lifecycles see [ZONE_MANAGER Watchers](../zone_manager/watchers.md).

Source anchors
- [AETHR:Start()](../../dev/AETHR.lua:252)
- [WORLD ownership update call](../../dev/AETHR.lua:254)
- [scheduleFunction](../../dev/AETHR.lua:255)
- [setupWatchers call](../../dev/AETHR.lua:257)
- [AETHR:setupWatchers()](../../dev/AETHR.lua:334)
- [initWatcher_AirbaseOwnership](../../dev/AETHR.lua:335)
- [initWatcher_ZoneOwnership](../../dev/AETHR.lua:336)