# UTILS time and timestamps

Anchors
- [AETHR.UTILS.getTime()](https://github.com/Gh0st352/AETHR/blob/main/dev/UTILS.lua#L56)
- [AETHR.UTILS:debugInfoRate()](https://github.com/Gh0st352/AETHR/blob/main/dev/UTILS.lua#L101) time source selection

Overview
- getTime uses DCS engine timers to return elapsed mission time seconds: timer.getAbsTime minus timer.getTime0.
- debugInfoRate picks the best available clock: AETHR.UTILS.getTime, or instance getTime, or os.time, else 0.

# Time source flow
```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
subgraph "Source selection"
  START[request time] --> C1{AETHR.UTILS.getTime available?}
  C1 -- "yes" --> GT[AETHR.UTILS.getTime]
  C1 -- "no" --> C2{self.getTime available?}
  C2 -- "yes" --> SG[self.getTime]
  C2 -- "no" --> C3{os.time available?}
  C3 -- "yes" --> OS[os.time]
  C3 -- "no" --> FALLBACK[0]
  GT --> NOW[now number]
  SG --> NOW
  OS --> NOW
  FALLBACK --> NOW
end

class START class_io;
class C1,C2,C3 class_decision;
class GT,SG,OS class_compute;
class FALLBACK class_result;
class NOW class_data;
```

# Elapsed mission time
```mermaid
%% shared theme: docs/_mermaid/theme.json %%
sequenceDiagram
  participant T as timer
  participant U as UTILS
  U->>T: getAbsTime
  U->>T: getTime0
  U-->>U: return abs minus start
```

# Usage notes
- Prefer engine elapsed time for consistent sim relative timestamps used by rate limited logging.
- When running outside the sim, os.time fallback still provides reasonable debouncing.

# Source anchors
- [AETHR.UTILS.getTime()](https://github.com/Gh0st352/AETHR/blob/main/dev/UTILS.lua#L56)
- [AETHR.UTILS:debugInfoRate()](https://github.com/Gh0st352/AETHR/blob/main/dev/UTILS.lua#L101)

Last updated: 2025-10-16