# AETHR BRAIN watchers

## Entry anchor
- [AETHR.BRAIN:buildWatcher()](https://github.com/Gh0st352/AETHR/blob/main/dev/BRAIN.lua#L242)

## Purpose
BRAIN provides a lightweight table proxy that intercepts writes to a specific key across a collection, invoking a watcher callback with optional extra arguments. This is used to react to ownership changes and other state transitions.

# Flow: buildWatcher

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart
  %% buildWatcher: create proxies and intercept writes
  subgraph BUILD ["buildWatcher flow"]
    W1[iterate pairs on target table]
    W2[create proxy per entry with __actualValue]
    W3[set metatable with __index passthrough]
    W4[__newindex intercept]
    W5{key equals watched key}
    W6[call watcherFunction with tableKey newValue extraArgs]
    W7[skip callback]
    W8[update actual value]
    W9[replace original entry with proxy]
    W1 --> W2 --> W3 --> W4 --> W5
    W5 -- "yes" --> W6 --> W8
    W5 -- "no" --> W7 --> W8
    W8 --> W9
  end

  class W1,W2,W3,W4,W5,W6,W7,W8,W9 class_step;
  class BUILD class_compute;
```

# Sequence: wiring watchers to WORLD

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
sequenceDiagram
  %% Background overlay removed (use theme seqBackdrop) to avoid inline colors
  participant ZM as ZONE_MANAGER
  participant BR as BRAIN
  participant WL as WORLD
  ZM->>BR: buildWatcher target table and key with handler
  BR-->>BR: proxy entries and intercept writes
  alt watched key changes
    BR-->>WL: invoke handler with provided context
  end
```

# Behavior notes mapped to code
- Proxy stores original value under __actualValue and forwards reads via __index [AETHR.BRAIN:buildWatcher()](https://github.com/Gh0st352/AETHR/blob/main/dev/BRAIN.lua#L250)
- __newindex checks for the watched field and invokes the callback before assigning [AETHR.BRAIN:buildWatcher()](https://github.com/Gh0st352/AETHR/blob/main/dev/BRAIN.lua#L255)
- Extra args are captured once and passed to each callback invocation [AETHR.BRAIN:buildWatcher()](https://github.com/Gh0st352/AETHR/blob/main/dev/BRAIN.lua#L243)

# Typical usage
- Airbase coalition change watcher in ZONE_MANAGER: [docs/zone_manager/watchers.md](docs/zone_manager/watchers.md)
- Zone ownership change watcher in ZONE_MANAGER: [docs/zone_manager/watchers.md](docs/zone_manager/watchers.md)

# Cross links
- Module index: [docs/brain/README.md](docs/brain/README.md)
- Scheduler: [docs/brain/scheduler.md](docs/brain/scheduler.md)
- Coroutines: [docs/brain/coroutines.md](docs/brain/coroutines.md)
- Data structures: [docs/brain/data_structures.md](docs/brain/data_structures.md)