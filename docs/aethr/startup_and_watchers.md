# AETHR startup and watchers

## Primary anchors
- [AETHR:Start()](https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L252)
- [WORLD updateAirbaseOwnership call site](https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L254)
- [timer.scheduleFunction for BackgroundProcesses](https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L255)
- [setupWatchers invocation](https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L257)
- [AETHR:setupWatchers()](https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L334)
- [initWatcher_AirbaseOwnership](https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L335)
- [initWatcher_ZoneOwnership](https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L336)

# Overview

[AETHR:Start()](https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L252) performs an immediate ownership update, schedules the recurring background loop, and registers event watchers via [AETHR:setupWatchers()](https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L334).

# Flowchart

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

  class S,RT class_result;
  class U,SCH,W class_step;
```

# Sequence timeline

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

# Watchers registered

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

  class SW class_result;
  class Z1,Z2 class_step;
```

# Notes
- The immediate ownership update at [call site](https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L254) ensures initial world state is consistent before the first background loop.
- Scheduling uses [timer.scheduleFunction](https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L255) to run [AETHR:BackgroundProcesses()](https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L267) on cadence managed by [AETHR.BRAIN.DATA.BackgroundLoopInterval](https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L255).
- For watcher details and event lifecycles see [ZONE_MANAGER Watchers](../zone_manager/watchers.md).

# Source anchors
- [AETHR:Start()](https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L252)
- [WORLD ownership update call](https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L254)
- [scheduleFunction](https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L255)
- [setupWatchers call](https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L257)
- [AETHR:setupWatchers()](https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L334)
- [initWatcher_AirbaseOwnership](https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L335)
- [initWatcher_ZoneOwnership](https://github.com/Gh0st352/AETHR/blob/main/dev/AETHR.lua#L336)