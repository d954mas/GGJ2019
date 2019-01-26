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

function IntroLine:initialize()
	self.co = function()
		while SM.MANAGER.co do coroutine.yield() end
		SM.show("TextModal",{title = "Crashed"},{popup = true})
		self:wait_text_modal()
	end
end

function IntroLine:check()
	return true
end

---@param world World
function M:initialize(world)
    self.lines = {
		IntroLine(),
		Line()
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