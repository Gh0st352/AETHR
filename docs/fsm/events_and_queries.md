# FSM events and queries

Guards and state queries used to decide if an event can fire and to inspect current state. Documents [AETHR.FSM:is()](../../dev/FSM.lua:401), [AETHR.FSM:can()](../../dev/FSM.lua:407), and [AETHR.FSM:cannot()](../../dev/FSM.lua:421), and shows how the event map is used.

# Primary anchors

- Is current state: [AETHR.FSM:is()](../../dev/FSM.lua:401)
- Guard and target: [AETHR.FSM:can()](../../dev/FSM.lua:407)
- Inverse guard: [AETHR.FSM:cannot()](../../dev/FSM.lua:421)
- Event map fill: [AETHR.FSM:add_to_map()](../../dev/FSM.lua:200)
- Transition builder context: [AETHR.FSM:create_transition()](../../dev/FSM.lua:104)

# Event map and guard logic

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  subgraph "Event map lookup"
    CUR[current state] --> LOOKUP["lookup map[current] or map*"]
    MAP[per event map from to] --> LOOKUP
    LOOKUP --> TO{to exists}
    TO -->|yes| CAN[can true return target]
    TO -->|no| CANT[can false return nil]
  end
  class CUR class_data;
  class MAP class_data;
  class LOOKUP class_compute;
  class TO class_decision;
  class CAN,CANT class_result;
```

- Each event has a map of from state to target state created during [AETHR.FSM:New()](../../dev/FSM.lua:366) via [add_to_map](../../dev/FSM.lua:200)
- Wildcard mapping * is supported and checked if an exact from is not found
- [can](../../dev/FSM.lua:407) returns two values: boolean can and the target to when can is true
- [cannot](../../dev/FSM.lua:421) simply negates can

# Usage inside transitions

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
sequenceDiagram
  participant T as create_transition
  participant F as fsm
  T->>F: can name
  alt cannot
    T-->>F: return false or recovery true
  else can
    T-->>F: proceed callbacks and state change
  end
```

# Query helpers

- [is](../../dev/FSM.lua:401) returns true when fsm.DATA.current equals the provided state string
- Useful for conditional logic outside transitions or to check completion

# Examples

- Defining events with multiple from states
  - [add_to_map](../../dev/FSM.lua:200) accepts a from string or an array of strings
- Wildcard
  - Provide from equal to * to allow the event to fire from any state not otherwise mapped

# Validation checklist

- Query helpers: [is](../../dev/FSM.lua:401), [can](../../dev/FSM.lua:407), [cannot](../../dev/FSM.lua:421)
- Map construction: [add_to_map](../../dev/FSM.lua:200)
- Transition use of guard: [create_transition](../../dev/FSM.lua:104)

# Related breakouts

- Transition lifecycle and async: [transition_lifecycle.md](./transition_lifecycle.md)
- Creation and callbacks: [creation_and_callbacks.md](./creation_and_callbacks.md)
- Manager and queue: [manager.md](./manager.md)
- Export and tooling: [export_and_tooling.md](./export_and_tooling.md)

# Conventions

- Mermaid fenced blocks with GitHub parser
- Labels avoid double quotes and parentheses inside bracket text
- All links use relative paths for portability