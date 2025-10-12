# UTILS debug and logging

Anchors
- [AETHR.UTILS:isDebug()](../../dev/UTILS.lua:70)
- [AETHR.UTILS:debugInfo()](../../dev/UTILS.lua:79)
- [AETHR.UTILS:debugInfoRate()](../../dev/UTILS.lua:101)

Overview
- isDebug checks CONFIG.MAIN.DEBUG_ENABLED with minimal overhead.
- debugInfo emits to env.info when available and optionally to BASE.E for structured data.
- debugInfoRate uses an in instance cache to rate limit log emission by key using engine time when available.

Debug gating overview
```mermaid
flowchart TD
  INP[input message data] --> GATE[isDebug flag]
  GATE -->|false| RETURN[return]
  GATE -->|true| EMIT[emit via env.info or BASE.E]
  EMIT --> DONE[done]
```

Rate limited logging flow
```mermaid
flowchart TD
  K[key interval data] --> NOW[now time]
  NOW --> LAST[last timestamp from cache]
  LAST --> GAP[now minus last greater equal interval]
  GAP -->|no| EXIT[return]
  GAP -->|yes| SET[update cache timestamp]
  SET --> CALL[call debugInfo with key and data]
```

Time source selection for rate limiting
```mermaid
sequenceDiagram
  participant U as UTILS
  participant T as timer
  participant OS as os
  U->>U: select preferred time source
  alt AETHR.UTILS.getTime available
    U-->>U: use engine elapsed time
  else self.getTime available
    U-->>U: use instance getTime
  else os.time available
    U-->>U: use os time
  else none
    U-->>U: fallback to 0
  end
```

Integration and usage notes
- Avoid heavy string formatting on hot paths unless isDebug returns true.
- debugInfoRate keys should be stable identifiers for the emission point.
- Structured data logging to BASE.E is attempted only when provided and available.

Source anchors
- [AETHR.UTILS:isDebug()](../../dev/UTILS.lua:70)
- [AETHR.UTILS:debugInfo()](../../dev/UTILS.lua:79)
- [AETHR.UTILS:debugInfoRate()](../../dev/UTILS.lua:101)