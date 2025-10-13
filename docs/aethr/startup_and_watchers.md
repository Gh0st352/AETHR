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
%%{init: {"theme": "base", "themeVariables": {"primaryColor":"#e6f3ff","primaryBorderColor":"#0066cc","primaryTextColor":"#000","lineColor":"#495057","textColor":"#000","fontSize":"14px"}}}%%
flowchart LR
  S[Start] --> U[Update airbase ownership]
  U --> SCH[Schedule BackgroundProcesses]
  SCH --> W[Setup watchers]
  W --> RT[Return self]

  %% Styles
  classDef core fill:#e6f3ff,stroke:#0066cc,stroke-width:2px,color:#000
  classDef process fill:#cce5ff,stroke:#0066cc,color:#000

  %% Apply classes
  class S,RT core
  class U,SCH,W process
```

Sequence timeline

```mermaid
%%{init: {"theme":"base","themeVariables":{"actorBkg":"#e6f3ff","actorTextColor":"#000","lineColor":"#495057","signalColor":"#0066cc","signalTextColor":"#000","fontSize":"14px"}}}%%
sequenceDiagram
  participant A as AETHR
  participant W as WORLD
  participant T as Timer
  A->>W: updateAirbaseOwnership
  A->>T: schedule BackgroundProcesses at now plus interval
  A->>A: setupWatchers
  A-->>A: return self
```

Watchers registered

```mermaid
%%{init: {"theme": "base", "themeVariables": {"primaryColor":"#e6f3ff","primaryBorderColor":"#0066cc","primaryTextColor":"#000","lineColor":"#495057","textColor":"#000","fontSize":"14px"}}}%%
flowchart LR
  SW[setupWatchers] --> Z1[ZONE_MANAGER initWatcher AirbaseOwnership]
  SW --> Z2[ZONE_MANAGER initWatcher ZoneOwnership]

  %% Styles
  classDef core fill:#e6f3ff,stroke:#0066cc,stroke-width:2px,color:#000
  classDef process fill:#cce5ff,stroke:#0066cc,color:#000

  %% Apply classes
  class SW core
  class Z1,Z2 process
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