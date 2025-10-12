# FSM transition lifecycle and async semantics

Detailed walkthrough of event firing, lifecycle callbacks, and async progression logic implemented by [AETHR.FSM:create_transition()](../../dev/FSM.lua:104). Includes resume and cancel semantics via [AETHR.FSM:transition()](../../dev/FSM.lua:451) and [AETHR.FSM:cancelTransition()](../../dev/FSM.lua:461).

Primary anchors

- Transition builder: [AETHR.FSM:create_transition()](../../dev/FSM.lua:104)
- Resume progression: [AETHR.FSM:transition()](../../dev/FSM.lua:451)
- Cancel in flight: [AETHR.FSM:cancelTransition()](../../dev/FSM.lua:461)
- Call wrapper for lifecycle hooks: [AETHR.FSM:call_handler()](../../dev/FSM.lua:88)
- State query and guards: [AETHR.FSM:can()](../../dev/FSM.lua:407)
- Async sentinels: [AETHR.FSM.ASYNC](../../dev/FSM.lua:23), [AETHR.FSM.NONE](../../dev/FSM.lua:22)

Lifecycle order and branching

```mermaid
flowchart LR
  EV[fire event name] --> CAN{can fire}
  CAN -->|no| REJ[reject return false]
  CAN -->|yes| OB[onBefore event]
  OB --> OL[onLeave from]
  OL --> AL{returns ASYNC}
  AL -->|yes| WL[asyncState set to event WaitingOnLeavereturn true]
  AL -->|no| EN[onEnter to]
  WL --> EN
  EN --> AE{returns ASYNC}
  AE -->|yes| WE[asyncState set to event WaitingOnEnterreturn true]
  AE -->|no| OA[onAfter event]
  WE --> OA
  OA --> SC[onStateChange]
  SC --> DONE[done return true]
```

- When can returns false the transition is rejected. If the code is performing a stray state recovery, it will return true, otherwise false. See recovery notes below.
- The event name drives async marker labels constructed as name plus suffix values from ENUMS FSM fields.

Sequence for async resume

```mermaid
sequenceDiagram
  participant C as caller
  participant F as FSM
  Note over F: transition function installed by create_transition
  C->>F: fsm:eventName args
  alt onLeave returns ASYNC
    F-->>C: return true paused at WaitingOnLeave
    C->>F: fsm:transition eventName
    F-->>C: continue enter stage or pause again
  else onEnter returns ASYNC
    F-->>C: return true paused at WaitingOnEnter
    C->>F: fsm:transition eventName
    F-->>C: finalize after and statechange
  end
```

Key implementation notes

- Waiting markers
  - [AETHR.FSM:create_transition()](../../dev/FSM.lua:104) constructs
    - waitingLeave = name .. FSM.WaitingOnLeave
    - waitingEnter = name .. FSM.WaitingOnEnter
  - These suffix constants are defined in [AETHR.ENUMS.FSM](../../dev/ENUMS.lua) and are concatenated to the event name.
- Async and none sentinels
  - [AETHR.FSM.ASYNC](../../dev/FSM.lua:23) and [AETHR.FSM.NONE](../../dev/FSM.lua:22) fall back to string defaults when ENUMS is unavailable.
- Callback invocation
  - All lifecycle callbacks are invoked through [AETHR.FSM:call_handler()](../../dev/FSM.lua:88) which safely no-ops for non functions.
  - Order inside the NONE stage: onBefore<event> then onLeave<from> then possibly pause.
  - In waitingLeave stage, current is switched to target state and onEnter<to> or on<to> is invoked.
  - In waitingEnter stage, onAfter<event> or on<event> followed by onStateChange are invoked.
- Guards and target resolution
  - [AETHR.FSM:can()](../../dev/FSM.lua:407) returns can, to using current state and the per event from map.
- Return semantics
  - Returning false from onBefore or onLeave cancels transition and returns false.
  - Returning ASYNC from onLeave or onEnter pauses and returns true. Caller must later call [AETHR.FSM:transition()](../../dev/FSM.lua:451) with the same event.
  - Completed transitions return true.

Stray state recovery

```mermaid
flowchart TD
  S[asyncState unexpected] --> CK{contains WaitingOnLeave or WaitingOnEnter}
  CK -->|yes| RST[reset asyncState to NONE]
  RST --> LOOP[re enter NONE stage]
  CK -->|no| FAIL[clear currentTransitioningEvent and return false]
```

- If asyncState contains a partial transition marker string but does not match expected stage, the code resets it to NONE and continues once in recovery mode.
- When recovering, attempts that would otherwise return false will return true to avoid breaking calling sequences.

Cancellation

- [AETHR.FSM:cancelTransition()](../../dev/FSM.lua:461)
  - If the active event matches the provided name, clears asyncState to NONE and currentTransitioningEvent to nil.
  - Subsequent calls to [AETHR.FSM:transition()](../../dev/FSM.lua:451) for that event will be ignored until a new event is fired.

Validation checklist

- Builder and core: [create_transition](../../dev/FSM.lua:104)
- Resume and cancel: [transition](../../dev/FSM.lua:451), [cancelTransition](../../dev/FSM.lua:461)
- Handler wrapper: [call_handler](../../dev/FSM.lua:88)
- Sentinel constants: [FSM.NONE](../../dev/FSM.lua:22), [FSM.ASYNC](../../dev/FSM.lua:23)
- Guard and target: [can](../../dev/FSM.lua:407)

Related breakouts

- Creation and callbacks: [creation_and_callbacks.md](./creation_and_callbacks.md)
- Events and queries: [events_and_queries.md](./events_and_queries.md)
- Manager and queue: [manager.md](./manager.md)
- Export and tooling: [export_and_tooling.md](./export_and_tooling.md)

Conventions

- Mermaid fenced blocks with GitHub parser
- Labels avoid double quotes and parentheses inside bracket text
- All links use relative paths for portability