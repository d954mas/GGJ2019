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
    return self:check() and "<img=gui:task_check_on/>" or "<img=gui:task_check_off/>" ..  self.description
end

function Task:get_title()
    return self.title
end
--endregion

---@class ComplexTask:Task
local ComplexTask = COMMON.class("ComplexTask",Task)

function ComplexTask:initialize(world,title)
    Task.initialize(self,title,"",world)
    self.tasks = {}
end

function ComplexTask:add_task(task)
    table.insert(self.tasks,task)
end

function ComplexTask:check()
    local checked = true
    for _,task in ipairs(self.tasks) do
        checked = checked and task:check()
    end
    return false
end

function ComplexTask:get_description()
    local description = ""
    for _,task in ipairs(self.tasks) do
        description = description .. task:get_description() .. "\n\n"
    end
    return description
end

function Task:get_title()
    return self.title
end


local EmptyTask = COMMON.class("Empty",Task)
---@param world World
function EmptyTask:initialize(world)
    self.title = ""
    self.description =""
    self.world = world
end

function EmptyTask:get_description(world)
    return ""
end

local CallbackTask = COMMON.class("CallbackTask",Task)
---@param world World
function CallbackTask:initialize(title,text,world,cb)
    Task.initialize(self,title,text,world,cb)
    self.cb = assert(cb)
end

function ComplexTask:check()
    return self.cb()
end

---@class Task1:ComplexTask
local Task1 = COMMON.class("Task1",ComplexTask)

function Task1:initialize(world)
    ComplexTask.initialize(self,world.locale.TASK_1_NAME,world)
    self:add_task(CallbackTask("",world.locale.TASK_1_DESCRIPTION_1,world,function() return false end))
    self:add_task(CallbackTask("",world.locale.TASK_1_DESCRIPTION_2,world,function() return false end))
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
      --  self.current = self.current + 1
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

