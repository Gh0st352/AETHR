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
%% shared theme: docs/_mermaid/theme.json %%
flowchart LR
  subgraph BOOT [Startup]
    S[Start]
    U[Update airbase ownership]
  end

  subgraph SCHED [Scheduling]
    SCH[Schedule BackgroundProcesses]
  end

  subgraph WATCH [Watchers]
    W[Setup watchers]
  end

  RT[Return self]

  S --> U --> SCH --> W --> RT

  class S,RT class-result
  class U,SCH,W class-step
```

Sequence timeline

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
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
%% shared theme: docs/_mermaid/theme.json %%
flowchart TB
  subgraph WATCHERS [Watchers]
    SW[setupWatchers]
    subgraph ZM_WATCHERS [ZONE_MANAGER watchers]
      Z1[initWatcher AirbaseOwnership]
      Z2[initWatcher ZoneOwnership]
    end
  end

  SW --> Z1
  SW --> Z2

  class SW class-result
  class Z1,Z2 class-step
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