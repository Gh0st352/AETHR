# UTILS time and timestamps

Anchors
- [AETHR.UTILS.getTime()](../../dev/UTILS.lua:56)
- [AETHR.UTILS:debugInfoRate()](../../dev/UTILS.lua:101) time source selection

Overview
- getTime uses DCS engine timers to return elapsed mission time seconds: timer.getAbsTime minus timer.getTime0.
- debugInfoRate picks the best available clock: AETHR.UTILS.getTime, or instance getTime, or os.time, else 0.

Time source flow
```mermaid
flowchart TD
  TRY1[Use AETHR.UTILS.getTime] --> OK1[if function available]
  TRY1 -->|no| TRY2[Use self.getTime]
  TRY2 -->|no| TRY3[Use os.time]
  TRY3 -->|no| FALLBACK[0]
  OK1 --> NOW[now number]
  TRY2 --> NOW
  TRY3 --> NOW
```

Elapsed mission time
```mermaid
sequenceDiagram
  participant T as timer
  participant U as UTILS
  U->>T: getAbsTime
  U->>T: getTime0
  U-->>U: return abs minus start
```

Usage notes
- Prefer engine elapsed time for consistent sim relative timestamps used by rate limited logging.
- When running outside the sim, os.time fallback still provides reasonable debouncing.

Source anchors
- [AETHR.UTILS.getTime()](../../dev/UTILS.lua:56)
- [AETHR.UTILS:debugInfoRate()](../../dev/UTILS.lua:101)