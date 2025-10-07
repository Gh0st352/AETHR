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
--- @field DATA AETHR.SPAWNER.DATA Container for spawner-managed data.
---
--- Instance fields (runtime):
--- @field options AETHR.FSM.Options|nil Configuration options passed to :New()
--- @field current string|nil Current state.
--- @field asyncState string|nil Current async state (if any).
--- @field events table<string, { map: table<string, string> }>|nil Table of events and their from/to maps.
--- @field currentTransitioningEvent string|nil Name of the event currently being processed (if any).
--- @field NONE string Sentinel value for "no state" (AETHR.ENUMS.FSM.NONE).
--- @field ASYNC string Sentinel value for "async" (AETHR.ENUMS.FSM.ASYNC).
--- ADAPTED FROM:
--- https://github.com/kyleconroy/lua-state-machine/blob/master/statemachine.lua
---
--- AETHR.FSM LICENSE ONLY:
--- Copyright (c) 2012 Kyle Conroy
--- Permission is hereby granted, free of charge, to any person obtaining a copy
--- of this software and associated documentation files (the "Software"), to deal
--- in the Software without restriction, including without limitation the rights
--- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
--- copies of the Software, and to permit persons to whom the Software is
--- furnished to do so, subject to the following conditions:
---
--- The above copyright notice and this permission notice shall be included in all
--- copies or substantial portions of the Software.
---
--- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
--- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
--- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
--- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
--- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
--- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
--- SOFTWARE.
---
--- Type aliases for FSM options/events/callbacks (EmmyLua)
--- @class AETHR.FSM.Event
--- @field name string Event name
--- @field from string|string[] Source state(s); "*" wildcard allowed
--- @field to string Target state
---
--- @alias AETHR.FSM.Callback fun(self:AETHR.FSM, e:string, from:string, to:string, ...:any): any
---
--- @class AETHR.FSM.Options
--- @field initial string|nil Initial state (defaults to AETHR.ENUMS.FSM.NONE)
--- @field events AETHR.FSM.Event[] List of event descriptors
--- @field callbacks table&lt;string, AETHR.FSM.Callback&gt;|nil Lifecycle callbacks keyed as:
---  onbefore&lt;event&gt;, onafter&lt;event&gt;, onleave&lt;state&gt;, onenter&lt;state&gt;, on&lt;state&gt;, onstatechange
---
--- Ensure table literal below is typed as AETHR.FSM for editors
--- @type AETHR.FSM
AETHR.FSM = {
  options = nil,               -- Configuration options passed to :New()
  current = nil,               -- Current state.
  asyncState = nil,            -- Current async state (if any).
  events = nil,                -- Table of events and their from/to maps.
  currentTransitioningEvent = nil, -- Name of the event currently being processed (if any).
  __index = AETHR.FSM,
  NONE = AETHR.ENUMS.FSM.NONE,
  ASYNC = AETHR.ENUMS.FSM.ASYNC,
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
    -- Preserve original "stray-state recovery returns true" semantics.
    local recovering = false
    while true do
      if self.asyncState == self.NONE then
        local can, to = self:can(name)
        local from = self.current
        local params = { self, name, from, to, ... }

        if not can then
          self.currentTransitioningEvent = nil
          if recovering then return true end
          return false
        end

        self.currentTransitioningEvent = name

        local beforeReturn = self:call_handler(self[self.ENUMS.FSM.onBefore .. name], params)
        local leaveReturn  = self:call_handler(self[self.ENUMS.FSM.onLeave  .. from], params)

        if beforeReturn == false or leaveReturn == false then
          self.currentTransitioningEvent = nil
          if recovering then return true end
          return false
        end

        -- Advance to "waiting on leave" stage
        self.asyncState = name .. self.ENUMS.FSM.WaitingOnLeave
        if leaveReturn == self.ASYNC then
          -- Pause until caller re-invokes transition(name)
          return true
        end
        -- Immediately continue loop to process next stage

      elseif self.asyncState == name .. self.ENUMS.FSM.WaitingOnLeave then
        local _, to = self:can(name) -- recompute target safely
        local from = self.current
        self.current = to

        local params = { self, name, from, to, ... }
        local enterReturn = self:call_handler(self[self.ENUMS.FSM.onEnter .. to] or self[self.ENUMS.FSM.on .. to], params)

        -- Advance to "waiting on enter" stage
        self.asyncState = name .. self.ENUMS.FSM.WaitingOnEnter
        if enterReturn == self.ASYNC then
          -- Pause until caller re-invokes transition(name)
          return true
        end
        -- Immediately continue loop to finalize

      elseif self.asyncState == name .. self.ENUMS.FSM.WaitingOnEnter then
        local _, to = self:can(name)
        local from = self.current
        local params = { self, name, from, to, ... }

        self:call_handler(self[self.ENUMS.FSM.onAfter .. name] or self[self.ENUMS.FSM.on .. name], params)
        self:call_handler(self[self.ENUMS.FSM.onStateChange], params)

        self.asyncState = self.NONE
        self.currentTransitioningEvent = nil
        return true

      else
        -- Recovery: if asyncState resembles a partial transition marker, reset and restart.
        if type(self.asyncState) == "string"
          and (string.find(self.asyncState, self.ENUMS.FSM.WaitingOnLeave) or string.find(self.asyncState, self.ENUMS.FSM.WaitingOnEnter)) then
          self.asyncState = self.NONE
          recovering = true
          -- Loop will re-enter at NONE stage
        else
          self.currentTransitioningEvent = nil
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
--- @param options AETHR.FSM.Options
--- @return AETHR.FSM instance New FSM table with event functions bound
function AETHR.FSM:New(options)
  assert(options and options.events, "AETHR.FSM:New requires options.events")

  local fsm = {}
  setmetatable(fsm, { __index = self })

  fsm.options = options or {}
  fsm.current = (options and options.initial) or self.NONE
  fsm.asyncState = self.NONE
  fsm.events = {}

  for _, event in ipairs(options.events or {}) do
    local name = event.name
    fsm[name] = fsm[name] or self:create_transition(name)
    fsm.events[name] = fsm.events[name] or { map = {} }
    self:add_to_map(fsm.events[name].map, event)
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
  return self.current == state
end

--- Determine if event e can fire from current state and compute the target state.
--- @param e string Event name
--- @return boolean can, string|nil to
function AETHR.FSM:can(e)
  local event = self.events and self.events[e]
  if not event or not event.map then
    return false, nil
  end
  local to = event.map[self.current] or event.map["*"]
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
  for _, event in pairs(self.options.events) do
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
  if self.currentTransitioningEvent == event then
    return self[self.currentTransitioningEvent](self)
  end
end

--- Cancel an in-flight transition if it matches the provided event name.
--- Resets async state and clears the active transitioning event.
--- @param event string Event name to cancel
function AETHR.FSM:cancelTransition(event)
  if self.currentTransitioningEvent == event then
    self.asyncState = self.NONE
    self.currentTransitioningEvent = nil
  end
end
