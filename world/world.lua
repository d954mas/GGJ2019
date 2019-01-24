local COMMON = require "libs.common"
local Observable = require "libs.observable_mixin"
local MultipleSubscription = require "libs.multiple_subscription"
local ECS = require "libs.ecs"

---@class World:Observable
local M = COMMON.class("World")
M:include(Observable)
local EVENTS = {
}

---@param self World
local function init_systems(self)
	self.ecs_world
end

function M:initialize()
	self.EVENTS = EVENTS
	self.subscription = MultipleSubscription()
	self:set_observable_events(self.EVENTS)
	self.ecs_world = ECS.world()
end

function M

function M:update(dt, no_save)
end


function M:save(file)

end

function M:dispose()
	self.ecs_world:clear()
end

function M:load(file)

end

return M()