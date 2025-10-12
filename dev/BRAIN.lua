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

--- Descriptor for a named background coroutine entry.
---@class AETHR.CoroutineDescriptor
---@field interval number Background loop ticks between runs.
---@field counter integer Internal counter incremented each background tick.
---@field thread thread|nil Coroutine thread handle.
---@field yieldThreshold integer|nil .
---@field yieldCounter integer|nil .
---@field desc string Description or name of the coroutine.

--- Data container for the BRAIN module.
---@class AETHR.BRAIN.Data
---@field Schedulers table<integer, any> Holds scheduled tasks and their states.
---@field SchedulerIDCounter integer Incrementing counter to assign unique IDs.
---@field coroutines table<string, AETHR.CoroutineDescriptor> Holds active coroutines or async tasks.
---@field BackgroundLoopInterval number Main scheduling loop tick interval in seconds.
---@type AETHR.BRAIN.Data
AETHR.BRAIN.DATA = {
    -- Map of scheduler IDs to scheduled task descriptors.
    Schedulers = {},
    SchedulerIDCounter = 1, -- Incrementing counter to assign unique IDs to scheduled tasks.
    coroutines = {
        -- phase is an offset (in loop ticks) used to stagger execution across the interval window.
        saveGroundUnits = {
            interval = 10, -- backgroundloop iterations between runs. To convert to seconds: interval * BackgroundLoopInterval
            phase = 9,
            counter = 0,
            thread = nil,
            yieldThreshold = 5,
            yieldCounter = 0,
            desc = "saveGroundUnits",
        },
        updateZoneOwnership = {
            interval = 10,
            phase = 2,
            counter = 0,
            thread = nil,
            yieldThreshold = 5,
            yieldCounter = 0,
            desc = "updateZoneOwnership",
        },
        updateAirfieldOwnership = {
            interval = 10,
            phase = 0,
            counter = 0,
            thread = nil,
            yieldThreshold = 5,
            yieldCounter = 0,
            desc = "updateAirfieldOwnership",
        },
        updateZoneColors = {
            interval = 10,
            phase = 4,
            counter = 0,
            thread = nil,
            yieldThreshold = 5,
            yieldCounter = 0,
            desc = "updateZoneColors",
        },
        updateZoneArrows = {
            interval = 10,
            phase = 6,
            counter = 0,
            thread = nil,
            yieldThreshold = 10,
            yieldCounter = 0,
            desc = "updateZoneArrows",
        },
        updateGroundUnitsDB = {
            interval = 30, -- make ground DB updates less frequent by default
            phase = 8,
            counter = 0,
            thread = nil,
            yieldThreshold = 10, -- yield more often
            yieldCounter = 0,
            desc = "updateGroundUnitsDB",
        },
        spawnGroundGroups = {
            interval = 10, -- make ground DB updates less frequent by default
            phase = 3,
            counter = 0,
            thread = nil,
            yieldThreshold = 3, -- yield more often
            yieldCounter = 0,
            desc = "spawnGroundGroups",
        },
        despawnGroundGroups = {
            interval = 10, -- make ground DB updates less frequent by default
            phase = 1,
            counter = 0,
            thread = nil,
            yieldThreshold = 3, -- yield more often
            yieldCounter = 0,
            desc = "despawnGroundGroups",
        },
        spawnerGenerationQueue = {
            interval = 10,
            phase = 12,
            counter = 0,
            thread = nil,
            yieldThreshold = 10,
            yieldCounter = 0,
            desc = "spawnerGenerationQueue",
        },
        processFSMQueue = {
            interval = 10,
            phase = 5,
            counter = 0,
            thread = nil,
            yieldThreshold = 10,
            yieldCounter = 0,
            desc = "processFSMQueue",
        },
    },
    BackgroundLoopInterval = 0.5, -- Main scheduling loop tick interval in seconds.
}
--updateInterval = 10,          -- Default update interval in seconds.


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

--- Runs a periodic coroutine routine based on its interval descriptor.
--- Increments the internal counter, runs when counter % interval == 0,
--- creates/resumes the coroutine safely, and cleans up when dead.
--- @function AETHR.BRAIN:doRoutine
--- @param cg AETHR.CoroutineDescriptor Coroutine descriptor (interval, counter, thread).
--- @param routineFn fun(...: any):nil Function to execute inside the coroutine.
--- @param ... any Additional arguments to pass to routineFn.
--- @return AETHR.BRAIN self Returns the BRAIN instance for chaining.
function AETHR.BRAIN:doRoutine(cg, routineFn, ...)
    if type(cg) ~= "table" then return self end
    local interval = tonumber(cg.interval) or 0
    local phase = tonumber(cg.phase) or 0
    cg.counter = (cg.counter or 0) + 1
    local args = { ... } -- Capture varargs for the coroutine

    -- Only run when the (counter + phase) aligns with the interval to spread work across ticks.
    if interval > 0 and ((cg.counter + phase) % interval) == 0 then
        -- conditional debug to reduce logging overhead when disabled
        local debugEnabled = (self.AETHR and self.AETHR.CONFIG and self.AETHR.CONFIG.MAIN and self.AETHR.CONFIG.MAIN.DEBUG)
        if debugEnabled and self.UTILS and type(self.UTILS.debugInfo) == "function" then
            self.UTILS:debugInfo("AETHR.BRAIN:doRoutine --> " .. (cg and cg.desc or ""))
        end

        cg.counter = 0

        -- Lazily (re)create the coroutine only when needed
        if (not cg.thread) or coroutine.status(cg.thread) == 'dead' then
            if debugEnabled and self.UTILS and type(self.UTILS.debugInfo) == "function" then
                self.UTILS:debugInfo("AETHR.BRAIN:doRoutine -- CREATED --> " .. (cg and cg.desc or ""))
            end
            local fn = routineFn or function() end
            cg.thread = coroutine.create(function() fn(unpack(args)) end) ---@diagnostic disable-line
        end

        -- Resume the coroutine (both newly created and previously suspended)
        local status = coroutine.status(cg.thread)
        if status == 'suspended' then
            if debugEnabled and self.UTILS and type(self.UTILS.debugInfo) == "function" then
                self.UTILS:debugInfo("AETHR.BRAIN:doRoutine -- RESUMED --> " .. (cg and cg.desc or ""))
            end
            local ok, err = coroutine.resume(cg.thread)
            if not ok then
                if self.UTILS and type(self.UTILS.debugInfo) == 'function' then
                    self.UTILS:debugInfo("doRoutine coroutine error: " .. tostring(err))
                end
                cg.thread = nil
            end
        end

        -- Clean up if it finished
        if cg.thread and coroutine.status(cg.thread) == 'dead' then
            if debugEnabled and self.UTILS and type(self.UTILS.debugInfo) == "function" then
                self.UTILS:debugInfo("AETHR.BRAIN:doRoutine -- DEAD --> " .. (cg and cg.desc or ""))
            end
            cg.thread = nil
        end
    end

    return self
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
function AETHR.BRAIN:runScheduledTasks(maxPerTick)
    -- Note: UTILS.getTime is a function (defined without colon), call via table field
    local currentTime = (self.AETHR and self.AETHR.UTILS and self.AETHR.UTILS.getTime) and self.AETHR.UTILS.getTime() or
        os.time()
    local executed = 0
    for id, task in pairs(self.DATA.Schedulers) do
        -- Cap tasks per tick if requested
        if maxPerTick and executed >= maxPerTick then break end

        if task and task.active and not task.running and (task.nextRun or 0) <= currentTime then
            executed = executed + 1
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
