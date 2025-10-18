# AETHR UTILS diagrams and flows

Primary anchors
- [AETHR.UTILS:isDebug()](https://github.com/Gh0st352/AETHR/blob/main/dev/UTILS.lua#L70)
- [AETHR.UTILS:debugInfo()](https://github.com/Gh0st352/AETHR/blob/main/dev/UTILS.lua#L79)
- [AETHR.UTILS:debugInfoRate()](https://github.com/Gh0st352/AETHR/blob/main/dev/UTILS.lua#L101)
- [AETHR.UTILS.getTime()](https://github.com/Gh0st352/AETHR/blob/main/dev/UTILS.lua#L56)
- [AETHR.UTILS:getPointY()](https://github.com/Gh0st352/AETHR/blob/main/dev/UTILS.lua#L129)
- [AETHR.UTILS:normalizePoint()](https://github.com/Gh0st352/AETHR/blob/main/dev/UTILS.lua#L137)
- [AETHR.UTILS:hasValue()](https://github.com/Gh0st352/AETHR/blob/main/dev/UTILS.lua#L147)
- [AETHR.UTILS:table_hasValue()](https://github.com/Gh0st352/AETHR/blob/main/dev/UTILS.lua#L162)
- [AETHR.UTILS.safe_lookup()](https://github.com/Gh0st352/AETHR/blob/main/dev/UTILS.lua#L170)
- [AETHR.UTILS:updateMarkupColors()](https://github.com/Gh0st352/AETHR/blob/main/dev/UTILS.lua#L188)
- [AETHR.UTILS:pickRandomKeyFromTable()](https://github.com/Gh0st352/AETHR/blob/main/dev/UTILS.lua#L201)
- [AETHR.UTILS:Shuffle()](https://github.com/Gh0st352/AETHR/blob/main/dev/UTILS.lua#L218)
- [AETHR.UTILS:withSeed()](https://github.com/Gh0st352/AETHR/blob/main/dev/UTILS.lua#L243)

Documents and indices
- Master diagrams index: [docs/README.md](../README.md)
- AETHR overview: [docs/aethr/README.md](../aethr/README.md)
- MARKERS: [docs/markers/README.md](../markers/README.md)

# Overview relationships

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart LR

subgraph "Debugging"
  D[isDebug] --> DI[debugInfo]
  D --> DIR[debugInfoRate]
  GT[getTime] -.-> DIR
end

subgraph "Geometry"
  NP[normalizePoint] --> PIP[POLY helpers]
end

subgraph "Lookups/Markup"
  SLook[safe_lookup] --> GV[global access]
  UMC[updateMarkupColors] --> TRIG[trigger.action color calls]
end

subgraph "Randomization"
  RNG[withSeed] --> DET[deterministic block]
  Shuffle --> RandOps
  pickRandomKeyFromTable --> RandOps
end

class D class_decision;
class GT class_data;
class DI,DIR,NP,RNG,Shuffle,pickRandomKeyFromTable class_compute;
class PIP,GV,TRIG,DET,RandOps class_result;
```

# Debug gating and rate limiting

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
subgraph "Debug gate"
  IN[message, data] --> CHECK{isDebug?}
  CHECK -- "false" --> RETURN1[return]
  CHECK -- "true" --> EMIT[env.info or BASE.E]
  EMIT --> DONE1[done]
end

class IN class_io;
class CHECK class_decision;
class EMIT class_compute;
class RETURN1,DONE1 class_result;
```

# Rate-limited debug logger

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
subgraph "Rate-limit check"
  K[key, interval] --> NOW[getTime or os.time]
  NOW --> LAST[read last emission from cache]
  LAST --> GAP{now - last >= interval?}
  GAP -- "no" --> RETURN2[return]
  GAP -- "yes" --> UPDATE[update cache timestamp]
  UPDATE --> LOG["debugInfo(key, data)"]
end

class K class_io;
class NOW,LAST class_data;
class GAP class_decision;
class UPDATE,LOG class_compute;
class RETURN2 class_result;
```

# Deterministic RNG scope

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
sequenceDiagram
  participant U as UTILS
  participant FN as Callback
  U->>U: math.randomseed(seed)
  U-->>U: warmup draws
  U->>FN: pcall(fn)
  alt reseedAfter
    U-->>U: scramble RNG with mixed seed and warmup
  end
  U-->>U: return fn results or rethrow
```

# Point normalization and helpers

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart LR
subgraph "Normalization"
  GY[getPointY] --> NP[normalizePoint]
  NP --> P2["table { x, y }"]
  P2 --> CONSUMERS[POLY and WORLD]
end

class GY,NP class_compute;
class P2 class_data;
class CONSUMERS class_result;
```

# Safe lookup guard

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
subgraph "Traversal"
  PATH[dotted path string] --> CUR[start at _G]
  CUR --> STEP[next part]
  STEP --> EXISTS{"cur[part] exists?"}
  EXISTS -- "no" --> FALLBACK[return fallback]
  EXISTS -- "yes" --> CUR
  STEP -- "end" --> OUT[return value]
end

class PATH class_io;
class CUR class_data;
class STEP class_step;
class EXISTS class_decision;
class FALLBACK,OUT class_result;
```

# Update markup colors

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
sequenceDiagram
  participant U as UTILS
  participant T as trigger.action
  U->>T: setMarkupColor(markupID, lineColor)
  U->>T: setMarkupColorFill(markupID, fillColor)
```

# Randomization helpers

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart LR
subgraph SHUFFLE_SG ["Shuffle"]
  SHUFFLE_FN[Shuffle] --> OUT1["shuffled shallow copy"]
end
subgraph "Select random key"
  pickRandomKeyFromTable --> SHUF[Shuffle keys] --> PICK[random index]
end

class SHUFFLE_FN,pickRandomKeyFromTable class_compute;
class SHUF class_step;
class OUT1,PICK class_result;
```

# Key anchors
- Debug: [isDebug](https://github.com/Gh0st352/AETHR/blob/main/dev/UTILS.lua#L70), [debugInfo](https://github.com/Gh0st352/AETHR/blob/main/dev/UTILS.lua#L79), [debugInfoRate](https://github.com/Gh0st352/AETHR/blob/main/dev/UTILS.lua#L101)
- Time: [getTime](https://github.com/Gh0st352/AETHR/blob/main/dev/UTILS.lua#L56)
- Geometry helpers: [getPointY](https://github.com/Gh0st352/AETHR/blob/main/dev/UTILS.lua#L129), [normalizePoint](https://github.com/Gh0st352/AETHR/blob/main/dev/UTILS.lua#L137)
- Lookups and colors: [safe_lookup](https://github.com/Gh0st352/AETHR/blob/main/dev/UTILS.lua#L170), [updateMarkupColors](https://github.com/Gh0st352/AETHR/blob/main/dev/UTILS.lua#L188)
- RNG and collections: [withSeed](https://github.com/Gh0st352/AETHR/blob/main/dev/UTILS.lua#L243), [Shuffle](https://github.com/Gh0st352/AETHR/blob/main/dev/UTILS.lua#L218), [pickRandomKeyFromTable](https://github.com/Gh0st352/AETHR/blob/main/dev/UTILS.lua#L201)

Notes
- Mermaid labels avoid double quotes and parentheses.
- All diagrams use GitHub Mermaid fenced blocks.

## Breakout documents

- Overview and constructor: [docs/utils/overview_and_constructor.md](overview_and_constructor.md)
- Debug and logging: [docs/utils/debug_and_logging.md](debug_and_logging.md)
- Time and timestamps: [docs/utils/time_and_timestamps.md](time_and_timestamps.md)
- Points and normalization: [docs/utils/points_and_normalization.md](points_and_normalization.md)
- Lookups and markup: [docs/utils/lookups_and_markup.md](lookups_and_markup.md)
- Randomization and RNG: [docs/utils/randomization_and_rng.md](randomization_and_rng.md)
- Collections and membership: [docs/utils/collections_and_membership.md](collections_and_membership.md)

Last updated: 2025-10-16