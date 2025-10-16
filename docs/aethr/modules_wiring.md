# AETHR modules wiring and auto registration

## Primary anchors
- [AETHR.MODULES](../../dev/AETHR.lua:40)
- [Build modulesList](../../dev/AETHR.lua:148)
- [Phase 1 construct submodules](../../dev/AETHR.lua:155)
- [pcall mod New and fallback](../../dev/AETHR.lua:160)
- [Phase 2 wire backrefs](../../dev/AETHR.lua:172)
- [Ensure sub AETHR ref](../../dev/AETHR.lua:178)
- [Inject sibling refs](../../dev/AETHR.lua:181)

# Overview
AETHR uses a simple registry [AETHR.MODULES](../../dev/AETHR.lua:40) to determine which prototype tables to attach to each instance. Modules are constructed in two phases to avoid ordering constraints and to ensure sibling access within submodules.

# Flow of module wiring

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart LR
  subgraph REG [Registry]
    M[AETHR MODULES list]
    L[Build modules list copy]
  end

  subgraph CON [Construction]
    P1GRP["Phase 1 (construct)"]
    P1[Phase 1 construct submodules]
  end

  subgraph WIR [Wiring]
    P2GRP["Phase 2 (wire)"]
    P2[Phase 2 inject backrefs and siblings]
    D[Instance modules wired]
  end

  M --> L --> P1GRP --> P1 --> P2GRP --> P2 --> D
  
  class M,D class_result;
  class L,P1,P2 class_step;
```

# Phase 1 construction
- Iterate list from [modulesList](../../dev/AETHR.lua:148)
- If prototype field is a table and instance slot is empty, try `:New(instance)` via protected call
- On success with table result, assign returned submodule
- On failure or non table return, assign the prototype table directly

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
sequenceDiagram
  participant A as AETHR
  participant Mod as Module prototype

  loop each name in modules list
    A->>Mod: try construct via New
    alt returns table
      A-->>A: set instance submodule to returned table
    else no New or failure
      A-->>A: set instance submodule to prototype table
    end
  end
```

# Phase 2 backrefs and sibling injection
- Ensure each submodule has `AETHR` pointer to parent
- For each submodule, shallow inject references to all other submodules for direct calls

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
sequenceDiagram
  participant A as AETHR
  participant S as Submodule

  loop each submodule
    A-->>S: ensure AETHR reference
    loop each sibling
      A-->>S: inject sibling reference
    end
  end
```

# Edge cases and notes
- If a module table does not expose `New`, the prototype table is used as the instance submodule
- If `New` throws or returns non table, fallback assigns the prototype table to keep system operable
- The two pass strategy avoids initialization order coupling between sibling modules

## Related pages
- [AETHR instance creation](./instance_creation.md)
- [AETHR overview](./README.md)

## Source anchors
- [modules list build](../../dev/AETHR.lua:148)
- [Phase 1 loop](../../dev/AETHR.lua:155)
- [pcall to New](../../dev/AETHR.lua:160)
- [Phase 2 loop](../../dev/AETHR.lua:172)
- [assign AETHR ref](../../dev/AETHR.lua:178)
- [inject sibling refs](../../dev/AETHR.lua:181)