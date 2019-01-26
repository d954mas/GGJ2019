local COMMON = require "libs.common"
--region tasks

--region Task class
---@class Task
local Task = COMMON.class("Task")
---@param world World
function Task:initialize(title, description,world)
    self.title = assert(title)
    self.description = description
    self.world = world
end

function Task:check()

end

function Task:get_description()
    return self.description
end

function Task:get_title()
    return self.title
end
--endregion

local EmptyTask = COMMON.class("Empty",Task)
---@param world World
function EmptyTask:initialize(world)
    self.title = ""
    self.description =""
    self.world = world
end

---@class Task1:Task
local Task1 = COMMON.class("Task1",Task)

function Task1:initialize(world)
    Task.initialize(self,world.locale.TASK_1_NAME,world.locale.TASK_1_DESCRIPTION,world)
end

function Task1:check()
    return false
end



---endregion

---@class Tasks
local Tasks = COMMON.class("Tasks")

function Tasks:initialize()
    ---@type Task[]
    self.tasks = {}
    self.current = 1
end

function Tasks:get_current()
    return self.tasks[self.current]
end

function Tasks:update()
    local ct = self:get_current()
    if ct and ct:check() then
        self.current = self.current + 1
    end

end

function Tasks:add_task(task)
    table.insert(self.tasks,assert(task))
end

function Tasks:skip_task()
    self.current = self.current + 1
end

function Tasks:go_to_task(idx)
    self.current = idx
end



local M = {}

function M.new_tasks(world)
    local tasks = Tasks()
    tasks:add_task(EmptyTask(world))
    tasks:add_task(Task1(world))
    return tasks
end


return M

