# UTILS randomization and RNG

Anchors
- [AETHR.UTILS:withSeed()](../../dev/UTILS.lua:243)
- [AETHR.UTILS:Shuffle()](../../dev/UTILS.lua:218)
- [AETHR.UTILS:pickRandomKeyFromTable()](../../dev/UTILS.lua:201)

Overview
- withSeed executes a callback under a deterministic RNG seed with optional warmup and reseedAfter scramble.
- Shuffle returns a shuffled shallow copy using Fisher Yates.
- pickRandomKeyFromTable builds a key list, shuffles it, then selects a random index.

# Deterministic RNG scope and reseed
```mermaid
%% shared theme: docs/_mermaid/theme.json %%
sequenceDiagram
  participant U as UTILS
  participant FN as Callback
  U->>U: guard inputs and coerce non negative seed
  U->>U: math.randomseed(seed)
  alt warmup n times
    U-->>U: perform math.random draws
  end
  U->>FN: pcall(fn)
  alt reseedAfter true or nil
    U-->>U: compute mixed entropy nonce time mem clk
    U-->>U: math.randomseed(mix)
    U-->>U: stir with a few draws
  end
  alt pcall failed
    U-->>U: error rethrow
  else ok
    U-->>U: return results
  end
```

# Shuffle algorithm
```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
subgraph "Fisher–Yates"
  IN[list t] --> COPY[copy to s]
  COPY --> LOOP[i from len down to 2]
  LOOP --> PICK[pick j in 1..i]
  PICK --> SWAP[swap s i j]
  SWAP --> LOOP
  LOOP --> OUT[return s]
end

class IN class_io;
class COPY,SWAP class_compute;
class LOOP class_step;
class PICK class_compute;
class OUT class_result;
```

# Pick random key from table
```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart LR
subgraph "Select random key"
  T[t map] --> KEYS[collect keys into array]
  KEYS --> SHUF["Shuffle(keys)"]
  SHUF --> IDX[pick random index in 1..#keys]
  IDX --> KEY[out key]
end

class T class_io;
class KEYS,IDX class_compute;
class SHUF class_step;
class KEY class_result;
```

# Usage notes
- withSeed does not restore previous RNG state due to Lua 5.1 limitations; reseedAfter scrambles with mixed entropy for best effort safety.
- Shuffle preserves input order in a copied array then shuffles; the input t is not mutated.
- pickRandomKeyFromTable is O(n) to collect keys plus shuffle; for very large maps consider alternative streaming sampling.

# Source anchors
- [AETHR.UTILS:withSeed()](../../dev/UTILS.lua:243)
- [AETHR.UTILS:Shuffle()](../../dev/UTILS.lua:218)
- [AETHR.UTILS:pickRandomKeyFromTable()](../../dev/UTILS.lua:201)

Last updated: 2025-10-16