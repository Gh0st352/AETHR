--- @class AETHR.BRAIN
--- @brief Manages AI behavior and decision-making processes.
---@diagnostic disable: undefined-global
--- @field AETHR AETHR Parent AETHR instance (injected by AETHR:New)
--- @field CONFIG AETHR.CONFIG Configuration table attached per-instance.
--- @field FILEOPS AETHR.FILEOPS File operations helper table attached per-instance.
--- @field POLY AETHR.POLY Geometry helper table attached per-instance.
--- @field WORLD AETHR.WORLD World learning submodule attached per-instance.
--- @field ZONE_MANAGER AETHR.ZONE_MANAGER Zone management submodule attached per-instance.
--- @field MARKERS AETHR.MARKERS
--- @field DATA table Container for zone management data.
--- @field DATA.MIZ_ZONES table<string, _MIZ_ZONE> Loaded mission trigger zones.
AETHR.BRAIN = {} ---@diagnostic disable-line

AETHR.BRAIN.DATA = {
    Schedulers = { -- Holds scheduled tasks and their states.
        -- [schedulerID] = { task = function, nextRun = time, interval = seconds, stopAfterTime = time, stopAfterIterations = count, iterations = count }
    },
    SchedulerIDCounter = 1, -- Incrementing counter to assign unique IDs to scheduled tasks.
    coroutines = {}, -- Holds active coroutines for asynchronous tasks.
    updateInterval = 10, -- Default update interval in seconds.
    mainScheduleLoopInterval = 0.1,

}
function AETHR.BRAIN:New(parent)
    local instance = {
        AETHR = parent,
        -- submodule-local caches/state can be initialized here
        _cache = {},
    }
    setmetatable(instance, { __index = self })
    return instance
end

--- Builds a watcher on a table to monitor changes to a specific key.
---
--- This function iterates through each key-value pair in a provided table and sets up a proxy table with a metatable to watch changes.
--- The proxy uses metatable magic to intercept changes to a specific key.
--- When a change to the specified key is detected, a watcher function is called with additional arguments if provided.
--- This is useful for monitoring changes to a table and triggering specific actions when those changes occur.
---
--- @param table_ table The table on which the watcher is to be set.
--- @param key_ any The key in the table to monitor for changes.
--- @param watcherFunction function The function to call when a change to the specified key is detected.
--- @param ... any Additional arguments to pass to the watcherFunction.
--- @usage AETHR.BRAIN:buildWatcher(myTable, "myKey", function(key, value) print("Key " .. key .. " changed to " .. value) end)
function AETHR.BRAIN:buildWatcher(table_, key_, watcherFunction, ...)
    local extraArgs = { ... } -- Capture extra arguments in a table

    for tableKey_, tableValue_ in pairs(table_) do
        local proxy = {
            __actualValue = tableValue_ -- Store actual value
        }

        setmetatable(proxy, {
            __index = function(t, k)
                return t.__actualValue[k] -- Access actual value
            end,

            __newindex = function(t, k, v)
                if k == key_ then
                    -- Call the watcher function with extra arguments
                    watcherFunction(tableKey_, v, unpack(extraArgs))
                end
                t.__actualValue[k] = v -- Modify actual value
            end
        })

        table_[tableKey_] = proxy -- Replace original value with the proxy
    end
end

---
---@param ... any[]|nil Variables to pass to function
---@param stopAfterTime number|nil Time in seconds after which the task should stop repeating. If nil, the task executes once.
---@param stopAfterIterations number|nil Number of times to repeat the task before stopping. If nil, the task executes once.
---@param repeatInterval number|nil Time in seconds between repeated executions of the task. If nil, the task executes once, otherwise it repeats indefinitely.
---@param delay number|nil Time in seconds to wait before executing the task.
---@param taskFunction function A function to be scheduled to run.
---@return _task scheduledTask An identifier for the scheduled task, which can be used to cancel it later if needed.
function AETHR.BRAIN:scheduleTask(taskFunction, delay, repeatInterval, stopAfterTime, stopAfterIterations, ...)
    local schedulerID = self.DATA.SchedulerIDCounter
    self.DATA.SchedulerIDCounter = self.DATA.SchedulerIDCounter + 1

    delay = delay or 0
    repeatInterval = repeatInterval or nil
    stopAfterTime = stopAfterTime or nil
    -- Leave stopAfterIterations nil by default (meaning: no iteration limit) unless explicitly provided.

    local args = { ... } -- Flatten varargs into a single table

    local scheduledTask = self.AETHR._task:New(
        stopAfterTime,
        stopAfterIterations,
        repeatInterval,
        delay,
        taskFunction,
        args, -- Pass flattened args table
        schedulerID
    )

    self.DATA.Schedulers[schedulerID] = scheduledTask
    -- Return the scheduler ID as a stable handle for cancellation/inspection
    return schedulerID
end

function AETHR.BRAIN:runScheduledTasks()
    local currentTime = self.AETHR.UTILS.getTime()
    for id, task in pairs(self.DATA.Schedulers) do
        if task and task.active and not task.running and currentTime >= task.nextRun then
            task.running = true
            task.lastRun = currentTime
            task.iterations = (task.iterations or 0) + 1

            -- Call the task function with protected call and flattened args
            local ok, err = pcall(task.taskFunction, unpack(task.functionArgs or {}))
            if not ok then
                    AETHR.UTILS:debugInfo("Scheduled task error (id " .. tostring(id) .. "): " .. tostring(err))
            end

            -- Update nextRun for repeating tasks. Use previous nextRun to avoid schedule drift.
            if task.repeating then
                if task.repeatInterval and task.repeatInterval > 0 then
                    task.nextRun = (task.nextRun or currentTime) + task.repeatInterval
                    -- If nextRun would be <= currentTime (e.g., long delay), push it forward
                    if task.nextRun <= currentTime then
                        task.nextRun = currentTime + task.repeatInterval
                    end
                else
                    task.nextRun = currentTime + (task.delay or 0)
                end
            else
                -- Non-repeating tasks become inactive after one run
                task.active = false
            end

            -- Check stopping conditions (only when explicit limits are provided)
            if (task.stopAfterTime and currentTime >= task.stopTime) or
               (task.stopAfterIterations and task.iterations >= task.stopAfterIterations) then
                task.active = false -- Deactivate the task if stopping conditions are met
            end

            task.running = false

            -- Remove inactive tasks to free memory
            if not task.active then
                self.DATA.Schedulers[id] = nil
            end
        end
    end
    return self
end
