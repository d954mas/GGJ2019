local COMMON = require "libs.common"
--region tasks

--region Task class
---@class Task
local Task = COMMON.class("Task")

function Task:initialize(title, description)
    self.title = assert(title)
    self.description = description and "<img=gui:task_check/>" .. description
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

local Task1 = COMMON.class("Task1",Task)

function Task1:initialize()
    Task.initialize(self,"Crashed","Need build engine")
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
end

function Tasks:get_current()
    return self.tasks[1]
end

function Tasks:update()
    local ct = self:get_current()
    if ct and ct:check() then
        table.remove(self.tasks,1)
    end

end

function Tasks:add_task(task)
    table.insert(self.tasks,assert(task))
end



local M = {}

function M.new_tasks()
    local tasks = Tasks()
    tasks:add_task(Task1())
    return tasks
end

return M

