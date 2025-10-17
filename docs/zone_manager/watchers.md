# Watchers: reacting to ownership changes

This document covers watchers that observe changes in airbase coalition and zone ownership, wiring them to WORLD callbacks via BRAIN utilities.

### Primary anchors:
- [AETHR.ZONE_MANAGER:initWatcher_AirbaseOwnership()](../../dev/ZONE_MANAGER.lua:1103)
- [AETHR.ZONE_MANAGER:initWatcher_ZoneOwnership()](../../dev/ZONE_MANAGER.lua:1113)

### Related modules:
- BRAIN watcher utilities: [AETHR.BRAIN:buildWatcher()](../../dev/BRAIN.lua:242)
- WORLD callbacks and reactions: [dev/WORLD.lua](../../dev/WORLD.lua)


# Airbase coalition ownership watcher

### Entry: [AETHR.ZONE_MANAGER:initWatcher_AirbaseOwnership()](../../dev/ZONE_MANAGER.lua:1103)

### Behavior:
- Iterates all MIZ zones
- For each zone, registers a watcher on the zone.Airbases collection for the field coalition
- The watcher triggers WORLD.airbaseOwnershipChanged with zone name and module context

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  A1[initWatcher_AirbaseOwnership] --> A2[for each zone in DATA MIZ_ZONES]
  subgraph "Registration"
    A2 --> A3[BRAIN buildWatcher target zone Airbases field coalition]
    A3 --> A4[callback WORLD airbaseOwnershipChanged with zone name and self]
  end
  A4 --> A5[return self]
  class A2,A4 class_step;
  class A3 class_compute;
  class A5 class_result;
```

### Notes:
- buildWatcher is used as the wiring mechanism in BRAIN
- WORLD is expected to handle updates such as recoloring or reassigning spawns after coalition change


# Zone ownership watcher

### Entry: [AETHR.ZONE_MANAGER:initWatcher_ZoneOwnership()](../../dev/ZONE_MANAGER.lua:1113)

### Behavior:
- Registers a watcher across the MIZ_ZONES table for field ownedBy
- The watcher triggers WORLD.zoneOwnershipChanged with module context

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  Z1[initWatcher_ZoneOwnership] --> Z2[BRAIN buildWatcher on MIZ_ZONES field ownedBy]
  Z2 --> Z3[callback WORLD zoneOwnershipChanged with self]
  Z3 --> Z4[return self]
  class Z2 class_compute;
  class Z3 class_step;
  class Z4 class_result;
```

### Typical downstream reactions in WORLD may include:
- Updating zone colors and arrow colors by coalition
- Showing outText notifications using CONFIG settings
- Triggering spawns or despawns when ownership flips


# Runtime sequence overview

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
sequenceDiagram
  participant ZM as ZONE_MANAGER
  participant BR as BRAIN
  participant WL as WORLD

  ZM->>BR: buildWatcher Airbases field coalition per zone
  BR-->>WL: on change call airbaseOwnershipChanged with zone name and ZM
  ZM->>BR: buildWatcher MIZ_ZONES field ownedBy
  BR-->>WL: on change call zoneOwnershipChanged with ZM
  WL-->>WL: update markers arrows text and spawns
```

### Configuration references:
- OutText display settings may be used by WORLD handlers
  - [AETHR.CONFIG.MAIN.outTextSettings](../../dev/CONFIG_.lua:336)


# Anchor index

- [AETHR.ZONE_MANAGER:initWatcher_AirbaseOwnership()](../../dev/ZONE_MANAGER.lua:1103)
- [AETHR.ZONE_MANAGER:initWatcher_ZoneOwnership()](../../dev/ZONE_MANAGER.lua:1113)
- [AETHR.BRAIN:buildWatcher()](../../dev/BRAIN.lua:242)
- [dev/WORLD.lua](../../dev/WORLD.lua)
- [dev/CONFIG_.lua](../../dev/CONFIG_.lua)