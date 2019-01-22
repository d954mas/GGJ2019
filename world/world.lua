local COMMON = require "libs.common"
local Observable = require "libs.observable_mixin"
local MultipleSubscription = require "libs.multiple_subscription"

---@class World:Observable
local M = COMMON.class("World")
M:include(Observable)
local EVENTS = {
}

function M:initialize()
	self.EVENTS = EVENTS
	self.subscription = MultipleSubscription()
	self:set_observable_events(self.EVENTS)
end

function M:update(dt, no_save)
end


function M:save(file)

end

function M:dispose()
end

function M:load(file)

end

return M()