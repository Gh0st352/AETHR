--- @class AETHR.BRAIN
--- @brief Manages AI behavior and decision-making processes.
---@diagnostic disable: undefined-global
--- @field AETHR AETHR Parent AETHR instance (injected by AETHR:New)
--- @field CONFIG AETHR.CONFIG Configuration table attached per-instance.
--- @field FILEOPS AETHR.FILEOPS File operations helper table attached per-instance.
--- @field POLY AETHR.POLY Geometry helper table attached per-instance.
--- @field MATH AETHR.MATH Math helper table attached per-instance.
--- @field AUTOSAVE AETHR.AUTOSAVE Autosave submodule attached per-instance.
--- @field ENUMS AETHR.ENUMS ENUMS submodule attached per-instance.
--- @field UTILS AETHR.UTILS Utility functions helper table attached per-instance.
--- @field WORLD AETHR.WORLD World learning submodule attached per-instance.
--- @field ZONE_MANAGER AETHR.ZONE_MANAGER Zone management submodule attached per-instance.
--- @field MARKERS AETHR.MARKERS Markers submodule attached per-instance.
--- @field DATA AETHR.BRAIN.Data Container for scheduling, coroutine, and timing data.
AETHR.BRAIN = {} ---@diagnostic disable-line

--- Scheduler and data types for AETHR.BRAIN
---@alias AETHR.SchedulerID integer

--- Represents a scheduled task managed by the BRAIN scheduler.
---@class AETHR.ScheduledTask
---@field active boolean|nil Whether the task is active.
---@field running boolean|nil True while the task is running.
---@field nextRun number|nil Next scheduled execution time (epoch seconds).
---@field lastRun number|nil Last execution time (epoch seconds).
---@field iterations integer|nil Number of times the task has executed.
---@field taskFunction fun(...: any) Function to execute.
---@field functionArgs any[]|nil Flattened argument list passed to taskFunction.
---@field repeatInterval number|nil Interval between executions when repeating.
---@field delay number|nil Initial delay before first execution.
---@field repeating boolean|nil Whether the task is configured to repeat.
---@field stopTime number|nil Absolute time after which the task should stop.
---@field stopAfterIterations integer|nil Max executions before stopping.

-----@alias AETHR.SchedulerMap table<AETHR.SchedulerID, AETHR.ScheduledTask>

--- Data container for the BRAIN module.
---@class AETHR.BRAIN.Data
---@field Schedulers _task[] Holds scheduled tasks and their states.
---@field SchedulerIDCounter integer Incrementing counter to assign unique IDs.
---@field coroutines table<integer, thread|fun(...: any)> Holds active coroutines or async tasks.
---@field updateInterval number Default update interval in seconds.
---@field BackgroundLoopInterval number Main scheduling loop tick interval in seconds.
---@type AETHR.BRAIN.Data
AETHR.BRAIN.DATA = {
    -- Map of scheduler IDs to scheduled task descriptors.
    Schedulers = {
        -- [schedulerID: AETHR.SchedulerID] = {
        --     taskFunction = function,               -- fun(...: any)
        --     functionArgs = { ... },                -- any[]
        --     active = true,                         -- boolean
        --     running = false,                       -- boolean
        --     nextRun = os.time(),                   -- number (epoch seconds)
        --     lastRun = os.time(),                   -- number (epoch seconds)
        --     repeatInterval = 10,                   -- number|nil
        --     delay = 0,                             -- number|nil
        --     stopTime = os.time() + 60,             -- number|nil
        --     stopAfterIterations = 3,               -- integer|nil
        --     iterations = 0,                        -- integer|nil
        --     repeating = true,                      -- boolean|nil
        -- }
    },
    SchedulerIDCounter = 1, -- Incrementing counter to assign unique IDs to scheduled tasks.
    coroutines = {}, -- Holds active coroutines for asynchronous tasks.
    updateInterval = 10, -- Default update interval in seconds.
    BackgroundLoopInterval = 0.1,

}
--- Creates a new AETHR.BRAIN submodule instance.
--- @function AETHR.BRAIN:New
--- @param parent AETHR Parent AETHR instance.
--- @return AETHR.BRAIN New instance inheriting AETHR.BRAIN methods.
function AETHR.BRAIN:New(parent)
    local instance = {
        AETHR = parent,
        -- submodule-local caches/state can be initialized here
        _cache = {},
    }
    setmetatable(instance, { __index = self })
    return instance ---@diagnostic disable-line
end

--- Builds a watcher on a table to monitor changes to a specific key.
---
--- This function iterates through each key-value pair in a provided table and sets up a proxy table with a metatable to watch changes.
--- The proxy uses metatable magic to intercept changes to a specific key.
--- When a change to the specified key is detected, a watcher function is called with additional arguments if provided.
--- This is useful for monitoring changes to a table and triggering specific actions when those changes occur.
--- @function AETHR.BRAIN:buildWatcher
--- @generic TKey, TValue
--- @param table_ table<TKey, TValue> The table on which the watcher is to be set.
--- @param key_ any The key in the table to monitor for changes.
--- @param watcherFunction fun(changedKey: TKey, newValue: any, ...: any) The function to call when a change to the specified key is detected.
--- @param ... any Additional arguments to pass to the watcherFunction.
--- @return nil
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
                    watcherFunction(tableKey_, v, unpack(extraArgs)) ---@diagnostic disable-line
                end
                t.__actualValue[k] = v -- Modify actual value
            end
        })

        table_[tableKey_] = proxy -- Replace original value with the proxy
    end
end

--- Schedules a task for later execution, optionally repeating.
--- @function AETHR.BRAIN:scheduleTask
--- @param taskFunction fun(...: any) A function to be scheduled to run.
--- @param delay number|nil Time in seconds to wait before executing the task.
--- @param repeatInterval number|nil Time in seconds between repeated executions of the task. If nil, the task executes once, otherwise it repeats indefinitely.
--- @param stopAfterTime number|nil Time in seconds after which the task should stop repeating. If nil, the task executes once.
--- @param stopAfterIterations integer|nil Number of times to repeat the task before stopping. If nil, the task executes once.
--- @param ... any Variables to pass to the task function.
--- @return AETHR.SchedulerID schedulerID Identifier for the scheduled task (numeric handle).
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

--- Execute scheduled tasks that are due. Iterates through schedulers and runs active tasks whose nextRun <= current time.
--- @function AETHR.BRAIN:runScheduledTasks
----- @return AETHR.BRAIN self Returns the BRAIN instance for chaining.
function AETHR.BRAIN:runScheduledTasks()
self.UTILS:debugInfo("AETHR.BRAIN:runScheduledTasks-------------")
    -- Note: UTILS.getTime is a function (defined without colon), call via table field
    local currentTime = (self.AETHR and self.AETHR.UTILS and self.AETHR.UTILS.getTime) and self.AETHR.UTILS.getTime() or os.time()
    for id, task in pairs(self.DATA.Schedulers) do
        if task and task.active and not task.running and (task.nextRun or 0) <= currentTime then
            task.running = true
            task.lastRun = currentTime
            task.iterations = (task.iterations or 0) + 1

            -- Call the task function with protected call and flattened args
            local ok, err = pcall(task.taskFunction, unpack(task.functionArgs or {})) ---@diagnostic disable-line
            if not ok then
                if self.AETHR and self.AETHR.UTILS and type(self.AETHR.UTILS.debugInfo) == "function" then
                    pcall(function()
                        self.AETHR.UTILS:debugInfo("Scheduled task error (id " .. tostring(id) .. "): " .. tostring(err))
                    end)
                end
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
            if (task.stopTime and currentTime >= task.stopTime) or
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

