--- @class AETHR.FSM
--- @brief Lightweight finite-state machine for AETHR modules; supports async transitions via returning AETHR.FSM.ASYNC from callbacks.
---@diagnostic disable: undefined-global
--- Submodule wiring (set by AETHR:New):
--- @field AETHR AETHR Parent AETHR instance (injected by AETHR:New).
--- @field CONFIG AETHR.CONFIG Configuration table attached per-instance.
--- @field FILEOPS AETHR.FILEOPS File operations helper table attached per-instance.
--- @field POLY AETHR.POLY Geometry helper table attached per-instance.
--- @field UTILS AETHR.UTILS Utility helper table attached per-instance.
--- @field BRAIN AETHR.BRAIN Brain submodule attached per-instance.
--- @field MATH AETHR.MATH Math helper table attached per-instance.
--- @field SPAWNER AETHR.SPAWNER Spawner submodule attached per-instance.
--- @field IO AETHR.IO Input/Output helper table attached per-instance.
--- @field AUTOSAVE AETHR.AUTOSAVE Autosave submodule attached per-instance.
--- @field ENUMS AETHR.ENUMS ENUMS submodule attached per-instance.
--- @field WORLD AETHR.WORLD World learning submodule attached per-instance.
--- @field ZONE_MANAGER AETHR.ZONE_MANAGER Zone management submodule attached per-instance.
--- @field MARKERS AETHR.MARKERS Marker utilities submodule attached per-instance.
--- @field DATA AETHR.FSM.DATA FSM instance data container.
AETHR.FSM = {}

AETHR.FSM.NONE = (AETHR and AETHR.ENUMS and AETHR.ENUMS.FSM and AETHR.ENUMS.FSM.NONE) or "none"
AETHR.FSM.ASYNC = (AETHR and AETHR.ENUMS and AETHR.ENUMS.FSM and AETHR.ENUMS.FSM.ASYNC) or "async"

--- Type aliases for FSM options/events/callbacks (EmmyLua)
--- @class AETHR.FSM.Event
--- @field name string Event name
--- @field from string|string[] Source state(s); "*" wildcard allowed
--- @field to string Target state
---
--- @alias AETHR.FSM.Callback fun(self:AETHR.FSM, e:string, from:string, to:string, ...:any): any
---

--- @class AETHR.FSM.DATA
--- @field options AETHR.FSM.DATA.Options|nil Configuration options passed to :New()
--- @field current string|nil Current state.
--- @field asyncState string|nil Current async state (if any).
--- @field events table<string, { map: table<string, string> }>|nil Table of events and their from/to maps.
--- @field currentTransitioningEvent string|nil Name of the event currently being processed (if any).
--- @field NONE string Sentinel value for "no state" (AETHR.ENUMS.FSM.NONE).
--- @field ASYNC string Sentinel value for "async" (AETHR.ENUMS.FSM.ASYNC).
--- @field _FSM_DATA table Internal data for FSM manager (queue, active set, stats).

--- @class AETHR.FSM.DATA.Options
--- @field initial string|nil Initial state (defaults to AETHR.ENUMS.FSM.NONE)
--- @field events AETHR.FSM.Event[] List of event descriptors
--- @field callbacks table&lt;string, AETHR.FSM.Callback&gt;|nil Lifecycle callbacks keyed as:
---  onbefore&lt;event&gt;, onafter&lt;event&gt;, onleave&lt;state&gt;, onenter&lt;state&gt;, on&lt;state&gt;, onstatechange
---
--- @class AETHR.FSM.DATA._FSM_DATA
--- @field queue AETHR.FSM.ManagerItem[] FIFO of {fsm, event, args}
--- @field active table<AETHR.FSM, boolean> Set of FSMs currently awaiting ASYNC completion
--- @field stats table
--- 
--- @class AETHR.FSM.DATA._FSM_DATA.stats
--- @field enqueued number Count of enqueued events
--- @field processed number Count of processed events
--- @field resumed number Count of resumed async events
--- @field finished number Count of finished events
--- @field errors number Count of errors during event processing

AETHR.FSM.DATA = {
    options = nil,               -- Configuration options passed to :New()
    current = nil,               -- Current state.
    asyncState = nil,            -- Current async state (if any).
    events = nil,                -- Table of events and their from/to maps.
    currentTransitioningEvent = nil, -- Name of the event currently being processed (if any).
    NONE = (AETHR and AETHR.ENUMS and AETHR.ENUMS.FSM and AETHR.ENUMS.FSM.NONE) or "none",
    ASYNC = (AETHR and AETHR.ENUMS and AETHR.ENUMS.FSM and AETHR.ENUMS.FSM.ASYNC) or "async",
    _FSM_DATA = {
      queue = {},             -- FIFO of {fsm, event, args}
      active = {},            -- set of FSMs currently awaiting ASYNC completion
      stats = {
        enqueued = 0,
        processed = 0,
        resumed = 0,
        finished = 0,
        errors = 0,
      },
    },
}


--- Invoke a lifecycle callback if provided.
--- @param handler AETHR.FSM.Callback|any Function to call; ignored if not a function
--- @param params any[] Packed arguments: { self, eventName, from, to, ... }
--- @return any|nil Return value from handler or nil when not a function
function AETHR.FSM:call_handler(handler, params)
  if type(handler) == "function" then
    return handler(unpack(params))
  end
end

--- Build and return an event transition function bound to a specific event name.
--- Lifecycle order:
---   onBefore<event> -> onLeave<from> -> onEnter<to>/on<to> -> onAfter<event>/on<event> -> onStateChange
--- Async:
---   If onLeave/onEnter returns self.ASYNC, this returns true immediately and must be re-invoked
---   with the same event name to continue the transition.
--- @param name string Event name
--- @return fun(self:AETHR.FSM, ...:any): boolean Transition function:
---   - true when transition completes or is awaiting async callback
---   - false when transition is not allowed or canceled
function AETHR.FSM:create_transition(name)
  local function transition(self, ...)
    -- Iterative implementation (no recursion) to progress transition through stages.
    -- Cache frequently-used lookups to minimize table indexing inside the loop.
    local FSM = (self.ENUMS and self.ENUMS.FSM) or AETHR.ENUMS.FSM
    local state = self.DATA or self
    local ASYNC = (state and state.ASYNC) or self.ASYNC or (AETHR and AETHR.FSM and AETHR.FSM.ASYNC) or "async"
    local NONE  = (state and state.NONE)  or self.NONE  or (AETHR and AETHR.FSM and AETHR.FSM.NONE)  or "none"
    local waitingLeave = name .. FSM.WaitingOnLeave
    local waitingEnter = name .. FSM.WaitingOnEnter

    -- Preserve original "stray-state recovery returns true" semantics.
    local recovering = false
    while true do
      if state.asyncState == NONE then
        local can, to = self:can(name)
        local from = state.current
        local params = { self, name, from, to, ... }

        if not can then
          state.currentTransitioningEvent = nil
          if recovering then return true end
          return false
        end

        state.currentTransitioningEvent = name

        local beforeReturn = self:call_handler(self[FSM.onBefore .. name], params)
        local leaveReturn  = self:call_handler(self[FSM.onLeave  .. from], params)

        if beforeReturn == false or leaveReturn == false then
          state.currentTransitioningEvent = nil
          if recovering then return true end
          return false
        end

        -- Advance to "waiting on leave" stage
        state.asyncState = waitingLeave
        if leaveReturn == ASYNC then
          -- Pause until caller re-invokes transition(name)
          return true
        end
        -- Immediately continue loop to process next stage

      elseif state.asyncState == waitingLeave then
        local _, to = self:can(name) -- recompute target safely
        local from = state.current
        state.current = to

        local params = { self, name, from, to, ... }
        local enterReturn = self:call_handler(self[FSM.onEnter .. to] or self[FSM.on .. to], params)

        -- Advance to "waiting on enter" stage
        state.asyncState = waitingEnter
        if enterReturn == ASYNC then
          -- Pause until caller re-invokes transition(name)
          return true
        end
        -- Immediately continue loop to finalize

      elseif state.asyncState == waitingEnter then
        local _, to = self:can(name)
        local from = state.current
        local params = { self, name, from, to, ... }

        self:call_handler(self[FSM.onAfter .. name] or self[FSM.on .. name], params)
        self:call_handler(self[FSM.onStateChange], params)

        state.asyncState = NONE
        state.currentTransitioningEvent = nil
        return true

      else
        -- Recovery: if asyncState resembles a partial transition marker, reset and restart.
        if type(state.asyncState) == "string"
          and (string.find(state.asyncState, FSM.WaitingOnLeave, 1, true)
               or string.find(state.asyncState, FSM.WaitingOnEnter, 1, true)) then
          state.asyncState = NONE
          recovering = true
          -- Loop will re-enter at NONE stage
        else
          state.currentTransitioningEvent = nil
          if recovering then return true end
          return false
        end
      end
    end
  end

  return transition
end

--- Map event.from to event.to across strings or arrays.
--- @param map table<string, string> Mutable map of from -> to states
--- @param event AETHR.FSM.Event Event descriptor
function AETHR.FSM:add_to_map(map, event)
  if type(event.from) == "string" then
    map[event.from] = event.to
  else
    for _, from in ipairs(event.from) do
      map[from] = event.to
    end
  end
end

--- Construct a new FSM instance from options.
--- Example:
---   options = {
---     initial = "state",
---     events = { {name="go", from="a", to="b"}, {name="back", from={"b","c"}, to="a"} },
---     callbacks = { onbeforego = function(self, e, from, to, ...) end, onenterb = function(self, e, from, to, ...) end }
---   }
--- 
--- 4 callbacks are available if your state machine has methods using the following naming conventions:
---
---     onbeforeevent - fired before the event
---     onleavestate - fired when leaving the old state
---     onenterstate - fired when entering the new state
---     onafterevent - fired after the event
---
--- You can affect the event in 3 ways:
---
---     return false from an onbeforeevent handler to cancel the event.
---     return false from an onleavestate handler to cancel the event.
---     return ASYNC from an onleavestate or onenterstate handler to perform an asynchronous state transition (see next section)
---
--- For convenience, the 2 most useful callbacks can be shortened:
---
---     onevent - convenience shorthand for onafterevent
---     onstate - convenience shorthand for onenterstate
---
--- In addition, a generic onstatechange() callback can be used to call a single function for all state changes:
---
--- All callbacks will be passed the same arguments:
---
---     self
---     event name
---     from state
---     to state
---     (followed by any arguments you passed into the original event method)
---
--- Callbacks can be specified when the state machine is first created:
---
--- local machine = require('statemachine')
---
--- local fsm = machine.create({
---   initial = 'green',
---   events = {
---     { name = 'warn',  from = 'green',  to = 'yellow' },
---     { name = 'panic', from = 'yellow', to = 'red'    },
---     { name = 'calm',  from = 'red',    to = 'yellow' },
---     { name = 'clear', from = 'yellow', to = 'green'  }
---   },
---   callbacks = {
---     onpanic =  function(self, event, from, to, msg) print('panic! ' .. msg)    end,
---     onclear =  function(self, event, from, to, msg) print('thanks to ' .. msg) end,
---     ongreen =  function(self, event, from, to)      print('green light')       end,
---     onyellow = function(self, event, from, to)      print('yellow light')      end,
---     onred =    function(self, event, from, to)      print('red light')         end,
---   }
--- })
---
--- fsm:warn()
--- fsm:panic('killer bees')
--- fsm:calm()
--- fsm:clear('sedatives in the honey pots')
--- ...
---
--- Additionally, they can be added and removed from the state machine at any time:
---
--- fsm.ongreen       = nil
--- fsm.onyellow      = nil
--- fsm.onred         = nil
--- fsm.onstatechange = function(self, event, from, to) print(to) end
---
--- or
---
--- function fsm:onstatechange(event, from, to) print(to) end
---
--- Asynchronous State Transitions
---
--- Sometimes, you need to execute some asynchronous code during a state transition and ensure the new state is not entered until your code has completed.
---
--- A good example of this is when you transition out of a menu state, perhaps you want to gradually fade the menu away, or slide it off the screen and don't want to transition to your game state until after that animation has been performed.
---
--- You can now return ASYNC from your onleavestate and/or onenterstate handlers and the state machine will be 'put on hold' until you are ready to trigger the transition using the new transition(eventName) method.
---
--- If another event is triggered during a state machine transition, the event will be triggered relative to the state the machine was transitioning to or from. Any calls to transition with the cancelled async event name will be invalidated.
---
--- During a state change, asyncState will transition from NONE to [event]WaitingOnLeave to [event]WaitingOnEnter, looping back to NONE. If the state machine is put on hold, asyncState will pause depending on which handler you returned ASYNC from.
---
--- Example of asynchronous transitions:
---
--- local machine = require('statemachine')
--- local manager = require('SceneManager')
---
--- local fsm = machine.create({
---
---   initial = 'menu',
---
---   events = {
---     { name = 'play', from = 'menu', to = 'game' },
---     { name = 'quit', from = 'game', to = 'menu' }
---   },
---
---   callbacks = {
---
---     onentermenu = function() manager.switch('menu') end,
---     onentergame = function() manager.switch('game') end,
---
---     onleavemenu = function(fsm, name, from, to)
---       manager.fade('fast', function()
---         fsm:transition(name)
---       end)
---       return fsm.ASYNC --- tell machine to defer next state until we call transition (in fadeOut callback above)
---     end,
---
---     onleavegame = function(fsm, name, from, to)
---       manager.slide('slow', function()
---         fsm:transition(name)
---       end)
---       return fsm.ASYNC --- tell machine to defer next state until we call transition (in slideDown callback above)
---     end,
---   }
--- })
---
--- If you decide to cancel the async event, you can call fsm.cancelTransition(eventName)
--- Initialization Options
---
--- How the state machine should initialize can depend on your application requirements, so the library provides a number of simple options.
---
--- By default, if you dont specify any initial state, the state machine will be in the 'none' state and you would need to provide an event to take it out of this state:
---
--- local machine = require('statemachine')
---
--- local fsm = machine.create({
---   events = {
---     { name = 'startup', from = 'none',  to = 'green' },
---     { name = 'panic',   from = 'green', to = 'red'   },
---     { name = 'calm',    from = 'red',   to = 'green' },
--- }})
---
--- print(fsm.current) --- "none"
--- fsm:startup()
--- print(fsm.current) --- "green"
---
--- If you specify the name of your initial event (as in all the earlier examples), then an implicit startup event will be created for you and fired when the state machine is constructed.
---
--- local machine = require('statemachine')
---
--- local fsm = machine.create({
---   inital = 'green',
---   events = {
---     { name = 'panic',   from = 'green', to = 'red'   },
---     { name = 'calm',    from = 'red',   to = 'green' },
--- }})
--- print(fsm.current) --- "green"
---
---
---
--- @param options AETHR.FSM.DATA.Options
--- @return AETHR.FSM instance New FSM table with event functions bound
function AETHR.FSM:New(options)
  assert(options and options.events, "AETHR.FSM:New requires options.events")

  local fsm = {}
  setmetatable(fsm, { __index = self })

  fsm.DATA = fsm.DATA or {}
  fsm.DATA.options = options or {}
  fsm.DATA.NONE = self.NONE or ((AETHR and AETHR.FSM and AETHR.FSM.NONE) or "none")
  fsm.DATA.ASYNC = self.ASYNC or ((AETHR and AETHR.FSM and AETHR.FSM.ASYNC) or "async")
  fsm.DATA.current = (options and options.initial) or fsm.DATA.NONE
  fsm.DATA.asyncState = fsm.DATA.NONE
  fsm.DATA.events = {}
  fsm.DATA.currentTransitioningEvent = nil

  fsm.ASYNC = fsm.DATA.ASYNC
  fsm.NONE  = fsm.DATA.NONE
  for _, event in ipairs(options.events or {}) do
    local name = event.name
    fsm[name] = fsm[name] or self:create_transition(name)
    fsm.DATA.events[name] = fsm.DATA.events[name] or { map = {} }
    self:add_to_map(fsm.DATA.events[name].map, event)
  end

  for name, callback in pairs(options.callbacks or {}) do
    fsm[name] = callback
  end

  return fsm
end

--- Check if the current state matches the provided state.
--- @param state string
--- @return boolean
function AETHR.FSM:is(state)
  return (self.DATA and self.DATA.current) == state
end

--- Determine if event e can fire from current state and compute the target state.
--- @param e string Event name
--- @return boolean can, string|nil to
function AETHR.FSM:can(e)
  local events = self.DATA and self.DATA.events
  local event = events and events[e]
  if not event or not event.map then
    return false, nil
  end
  local to = event.map[(self.DATA and self.DATA.current) or nil] or event.map["*"]
  return to ~= nil, to
end

--- Inverse of can(); true when event e cannot fire from current state.
--- @param e string Event name
--- @return boolean
function AETHR.FSM:cannot(e)
  local can, _ = self:can(e)
  return not can
end

--- Export FSM topology to a Graphviz DOT file for visualization.
--- @param filename string Path to the destination .dot file
function AETHR.FSM:todot(filename)
  local dotfile = io.open(filename, "w")
  assert(dotfile ~= nil)
  dotfile:write("digraph {\n")
  local function transition(event, from, to)
    dotfile:write(string.format("%s -> %s [label=%s];\n", from, to, event))
  end
  local opts = self.DATA and self.DATA.options
  for _, event in pairs((opts and opts.events) or {}) do
    if type(event.from) == "table" then
      for _, from in ipairs(event.from) do
        transition(event.name, from, event.to)
      end
    else
      transition(event.name, event.from, event.to)
    end
  end
  dotfile:write("}\n")
  dotfile:close()
end

--- Progress an in-flight async transition for the given event, if it is active.
--- @param event string Event name currently transitioning
--- @return boolean|nil True/false result from transition progression, or nil if no active transition
function AETHR.FSM:transition(event)
  local st = self.DATA
  if st and st.currentTransitioningEvent == event then
    return self[st.currentTransitioningEvent](self)
  end
end

--- Cancel an in-flight transition if it matches the provided event name.
--- Resets async state and clears the active transitioning event.
--- @param event string Event name to cancel
function AETHR.FSM:cancelTransition(event)
  local st = self.DATA
  if st and st.currentTransitioningEvent == event then
    st.asyncState = st.NONE or self.NONE
    st.currentTransitioningEvent = nil
  end
end


--- FSM manager: queued/active processing (background coroutine support)
--- @class AETHR.FSM.ManagerItem
--- @field fsm table
--- @field event string|nil
--- @field args any[]

--- Ensure per-instance FSM data container
--- @return table data
function AETHR.FSM:_ensureData(parent)
  self.DATA = self.DATA or {}
  self.DATA._FSM_DATA = self.DATA._FSM_DATA or {
    queue = {},             -- FIFO of {fsm, event, args}
    active = {},            -- set of FSMs currently awaiting ASYNC completion
    stats = {
      enqueued = 0,
      processed = 0,
      resumed = 0,
      finished = 0,
      errors = 0,
    }
  }
  return self.DATA._FSM_DATA
end

--- Enqueue an FSM event to be processed by the background coroutine.
--- If the FSM is already in an async transition, this will attempt to resume it first.
--- @param parent AETHR Parent AETHR instance
--- @param fsm table FSM instance returned from AETHR.FSM:New
--- @param event string Event name to fire (fsm[event](fsm, ...))
--- @param ... any Arguments forwarded to the event function
--- @return AETHR.FSM self
function AETHR.FSM:enqueue(parent, fsm, event, ...)
  if not parent or not fsm or not event then return self end
  local data = self:_ensureData(parent)
  table.insert(data.queue, { fsm = fsm, event = event, args = { ... } })
  data.stats.enqueued = (data.stats.enqueued or 0) + 1
  return self
end

--- Process queued and active FSMs. Intended to be called by BRAIN coroutine.
--- It will:
--- 1) Drain up to N queued items (N = yieldThreshold of processFSMQueue or 10)
--- 2) Advance up to N active async FSMs via fsm:transition(fsm.currentTransitioningEvent)
--- @param parent AETHR
--- @return AETHR.FSM self
function AETHR.FSM:processQueue(parent)
  if not parent then return self end
  local data = self:_ensureData(parent)

  -- Derive batch limit from coroutine descriptor if present
  local cg = parent.BRAIN and parent.BRAIN.DATA and parent.BRAIN.DATA.coroutines
            and parent.BRAIN.DATA.coroutines.processFSMQueue or nil
  local maxBatch = (cg and cg.yieldThreshold) or 10

  local NONE = self.NONE or (AETHR and AETHR.ENUMS and AETHR.ENUMS.FSM and AETHR.ENUMS.FSM.NONE) or "none"

  -- 1) Process queued items
  local processed = 0
  while processed < maxBatch and #data.queue > 0 do
    local item = table.remove(data.queue, 1)
    local fsm = item and item.fsm
    local event = item and item.event
    local args = (item and item.args) or {}

    if fsm then
      local ok = true
      local _err = nil
      ok, _err = pcall(function()
        local st = fsm.DATA
        if st and st.currentTransitioningEvent and st.asyncState and st.asyncState ~= NONE then
          -- Resume any in-flight async transition first
          fsm:transition(st.currentTransitioningEvent)
        else
          local fn = fsm[event]
          if type(fn) == "function" then fn(fsm, unpack(args)) end
        end
      end)

      data.stats.processed = (data.stats.processed or 0) + 1
      processed = processed + 1
      if not ok then
        data.stats.errors = (data.stats.errors or 0) + 1
      end

      local st2 = fsm and fsm.DATA or nil
      if st2 and st2.asyncState and st2.asyncState ~= NONE then
        data.active[fsm] = true
        data.stats.resumed = (data.stats.resumed or 0) + 1
      end
    end
  end

  -- 2) Progress active async FSMs
  local progressed = 0
  local finished = {}
  for fsm, _ in pairs(data.active) do
    if progressed >= maxBatch then break end
    local ok = true
    ok = pcall(function()
      local st = fsm and fsm.DATA or nil
      if st and st.currentTransitioningEvent then
        fsm:transition(st.currentTransitioningEvent)
      end
    end)
    if not ok then data.stats.errors = (data.stats.errors or 0) + 1 end
    progressed = progressed + 1

    local st3 = fsm and fsm.DATA or nil
    if not (st3 and st3.asyncState and st3.asyncState ~= NONE) then
      table.insert(finished, fsm)
      data.stats.finished = (data.stats.finished or 0) + 1
    end
  end
  for _, f in ipairs(finished) do data.active[f] = nil end

  return self
end

--- Convenience alias for enqueue
--- @param parent AETHR
--- @param fsm table
--- @param event string
--- @param ... any
function AETHR.FSM:queueEvent(parent, fsm, event, ...)
  return self:enqueue(parent, fsm, event, ...)
end
