local COMMON = require "libs.common"
local SM = require "Jester.jester"


local M = COMMON.class("Plot")

local Line = COMMON.class("Line")

---@class PlotLine
function Line:initialize()
	self.co = function() end
end

function Line:check()
	return false
end

function Line:wait(delay)
	local time = 0
	while time<delay do
		local dt = coroutine.yield()
		time = time + dt
	end
end

function Line:wait_text_modal(dt)
	while SM.MANAGER.stack:peek()._name == "TextModal" do
		coroutine.yield()
	end
end


---@class IntroLine:PlotLine
local IntroLine = COMMON.class("IntroLine",Line)

---@param world World
function IntroLine:initialize(world)
	self.co = function()
		while SM.MANAGER.co do coroutine.yield() end
		local l = world.locale
		local dialog = {
			{text = l.TASK_1_TEXT, name = l.NAME_AI},
			{text = l.TASK_1_TEXT_2,  name = l.NAME_AI, a1 = {text = l.TASK_1_TEXT_2_A_1}, a2= {text = l.TASK_1_TEXT_2_A_2} },
			{text = l.TASK_1_TEXT_3,  name = l.NAME_AI,a1 = {text = l.TASK_1_TEXT_3_A_1,page = 4}, a2 = {text = l.TASK_1_TEXT_3_A_2,page = 5}, a3= {text = l.TASK_1_TEXT_3_A_3,page = 6} },
			{text = l.TASK_1_TEXT_4,  name = l.NAME_AI, a1 = {text = l.TASK_1_TEXT_4_A_1,page = 5}, a2= {text = l.TASK_1_TEXT_4_A_2,page = 6} },
			{text = l.TASK_1_TEXT_5,  name = l.NAME_AI, a1 = {text = l.TASK_1_TEXT_5_A_1,page=4}, a2= {text = l.TASK_1_TEXT_5_A_2,page = 6} },
			{text = l.TASK_1_TEXT_6,  name = l.NAME_AI, a1 = {text = l.TASK_1_TEXT_6_A_1} }
		}

		SM.show("TextModal",{dialog = dialog},{popup = true})
		self:wait_text_modal()
		world.tasks:skip_task()
	end
end

function IntroLine:check()
	return true
end

---@param world World
function M:initialize(world)
    self.lines = {
		IntroLine(world),
		Line(world)
	}
	self.line_idx = 0
	self:next_line()
end

function M:next_line()
	self.line_idx = self.line_idx + 1
	self.line = self.lines[self.line_idx]
	print("CHANGE PLOT LINE:" .. self.line.class.name)
end



function M:update(dt)
	if self.co then
		local ok, res = coroutine.resume(self.co, dt)
		if not ok then
			COMMON.LOG.e(res, "Plot error")
		end
		if coroutine.status(self.co) == "dead" then
			self.co = nil
			self:next_line()
		end
	elseif self.line:check() then
		self.co = coroutine.create(self.line.co)
	end
end


return M