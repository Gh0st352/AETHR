--- @class AETHR.FSM Finite State Machine module.
--- @brief Lightweight finite-state machine for AETHR modules; supports async transitions via returning AETHR.FSM.ASYNC from callbacks.
---@diagnostic disable: undefined-global
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
AETHR.FSM = {}
AETHR.FSM.__index = AETHR.FSM

AETHR.FSM.NONE = "none"
AETHR.FSM.ASYNC = "async"

-- Invoke a lifecycle callback if provided.
function AETHR.FSM:call_handler(handler, params)
  if type(handler) == "function" then
    return handler(unpack(params))
  end
end

-- Build and return an event transition function bound to event name.
function AETHR.FSM:create_transition(name)
  local function transition(self, ...)
    if self.asyncState == self.NONE then
      local can, to = self:can(name)
      local from = self.current
      local params = { self, name, from, to, ... }

      if not can then
        self.currentTransitioningEvent = nil
        return false
      end

      self.currentTransitioningEvent = name

      local beforeReturn = self:call_handler(self["onbefore" .. name], params)
      local leaveReturn  = self:call_handler(self["onleave"  .. from], params)

      if beforeReturn == false or leaveReturn == false then
        self.currentTransitioningEvent = nil
        return false
      end

      self.asyncState = name .. "WaitingOnLeave"
      if leaveReturn ~= self.ASYNC then
        return transition(self, ...)
      end
      return true

    elseif self.asyncState == name .. "WaitingOnLeave" then
      local _, to = self:can(name) -- recompute target safely
      local from = self.current
      self.current = to

      local params = { self, name, from, to, ... }
      local enterReturn = self:call_handler(self["onenter" .. to] or self["on" .. to], params)

      self.asyncState = name .. "WaitingOnEnter"
      if enterReturn ~= self.ASYNC then
        return transition(self, ...)
      end
      return true

    elseif self.asyncState == name .. "WaitingOnEnter" then
      local _, to = self:can(name)
      local from = self.current
      local params = { self, name, from, to, ... }

      self:call_handler(self["onafter" .. name] or self["on" .. name], params)
      self:call_handler(self["onstatechange"], params)

      self.asyncState = self.NONE
      self.currentTransitioningEvent = nil
      return true
    else
      if type(self.asyncState) == "string"
        and (string.find(self.asyncState, "WaitingOnLeave") or string.find(self.asyncState, "WaitingOnEnter")) then
        self.asyncState = self.NONE
        transition(self, ...)
        return true
      end
    end

    self.currentTransitioningEvent = nil
    return false
  end

  return transition
end

-- Map event.from to event.to across strings or arrays.
function AETHR.FSM:add_to_map(map, event)
  if type(event.from) == "string" then
    map[event.from] = event.to
  else
    for _, from in ipairs(event.from) do
      map[from] = event.to
    end
  end
end

-- Construct a new FSM instance from options.
-- options = {
--   initial = "state",
--   events = { {name="go", from="a", to="b"}, {name="back", from={"b","c"}, to="a"} },
--   callbacks = { onbeforego = function(self, e, from, to, ...) end, onenterb = function(self, e, from, to, ...) end }
-- }
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

function AETHR.FSM:is(state)
  return self.current == state
end

function AETHR.FSM:can(e)
  local event = self.events and self.events[e]
  if not event or not event.map then
    return false, nil
  end
  local to = event.map[self.current] or event.map["*"]
  return to ~= nil, to
end

function AETHR.FSM:cannot(e)
  local can, _ = self:can(e)
  return not can
end

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

function AETHR.FSM:transition(event)
  if self.currentTransitioningEvent == event then
    return self[self.currentTransitioningEvent](self)
  end
end

function AETHR.FSM:cancelTransition(event)
  if self.currentTransitioningEvent == event then
    self.asyncState = self.NONE
    self.currentTransitioningEvent = nil
  end
end
