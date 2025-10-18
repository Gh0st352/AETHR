# AETHR CONFIG outText settings

Display timings and view-clearing behavior for ownership change messages.

## Source anchors

- Types and schema
  - [AETHR.CONFIG.OutTextSection](https://github.com/Gh0st352/AETHR/blob/main/dev/CONFIG_.lua#L130)
  - [AETHR.CONFIG.OutTextSettings](https://github.com/Gh0st352/AETHR/blob/main/dev/CONFIG_.lua#L134)
- Defaults block
  - outTextSettings defaults: [dev/CONFIG_.lua](https://github.com/Gh0st352/AETHR/blob/main/dev/CONFIG_.lua#L336)
- Runtime consumers
  - [AETHR.WORLD.airbaseOwnershipChanged()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L970)
  - [AETHR.WORLD.zoneOwnershipChanged()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L1006)

# Overview

The outText settings define how long messages appear and whether prior messages are cleared when airbase or zone ownership changes. WORLD emits outText in those change handlers using the configured durations and clearView flags.

# Structure

- OutTextSection
  - displayTime number
  - clearView boolean
- OutTextSettings
  - airbaseOwnershipChange OutTextSection
  - zoneOwnershipChange OutTextSection

# Defaults

```text
airbaseOwnershipChange:
  displayTime = 10
  clearView   = false
zoneOwnershipChange:
  displayTime = 10
  clearView   = false
```

# Ownership change flow

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
sequenceDiagram
  participant W as WORLD
  participant T as DCS trigger.action
  W->>W: detect ownership change
  alt airbase change
    W->>T: outText message (airbase), duration = CONFIG.MAIN.outTextSettings.airbaseOwnershipChange.displayTime
  else zone change
    W->>T: outText message (zone), duration = CONFIG.MAIN.outTextSettings.zoneOwnershipChange.displayTime
  end
```

- Airbase flow in [AETHR.WORLD.airbaseOwnershipChanged()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L970)
  - Emits capture or contested text using enums and [trigger.action.outText](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L994)
- Zone flow in [AETHR.WORLD.zoneOwnershipChanged()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L1006)
  - Emits capture or contested text at [dev/WORLD.lua](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L1035)

# Message composition

- Uses enum text strings to build user-facing messages
- Duration and clearing behavior sourced directly from CONFIG.MAIN.outTextSettings

# Related breakouts

- Main schema: [main_schema.md](./main_schema.md)
- Init and persistence: [init_and_persistence.md](./init_and_persistence.md)

# Validation checklist

- OutTextSection defined at [dev/CONFIG_.lua](https://github.com/Gh0st352/AETHR/blob/main/dev/CONFIG_.lua#L130)
- OutTextSettings defined at [dev/CONFIG_.lua](https://github.com/Gh0st352/AETHR/blob/main/dev/CONFIG_.lua#L134)
- Defaults present at [dev/CONFIG_.lua](https://github.com/Gh0st352/AETHR/blob/main/dev/CONFIG_.lua#L336)
- Airbase handler at [AETHR.WORLD.airbaseOwnershipChanged()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L970)
- Zone handler at [AETHR.WORLD.zoneOwnershipChanged()](https://github.com/Gh0st352/AETHR/blob/main/dev/WORLD.lua#L1006)

# Conventions

- Mermaid fenced blocks with GitHub parser
- Labels avoid double quotes and parentheses inside bracket labels
- Relative links with line anchors to source