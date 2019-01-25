local COMMON = require "libs.common"
local Observable = require "libs.observable_mixin"
local MultipleSubscription = require "libs.multiple_subscription"
local ECS = require "libs.ecs"

---@class World:Observable
local M = COMMON.class("World")
M:include(Observable)
local EVENTS = {
	RESOURCE_CHANGED = "RESOURCE_CHANGED" --{type = "energy"}
}

---@param self World
local function init_systems(self)
	--self.ecs_world
end

function M:initialize()
	self.EVENTS = EVENTS
	self.subscription = MultipleSubscription()
	self:set_observable_events(self.EVENTS)
	self.ecs_world = ECS.world()
	self.ecs_world.world = self
	self.resources = {
		energy = 100, --нужна для работы роботов и турелей. И для силового поля. Так-же для покупки и апгрейда
		ore = 100, --добывается роботами на астероидах
		steel = 0, --из руды на заводе получаем
		hp = 100, --здоровье базы.Если в 0 то мы проиграли. Возвращаемся на прошлый stage
	}
	--[[
	1)Реактор, производит энергию
	2)Плавильня, руду в металл
	3)Лаборатория(исследуем перки) и апгрейды зданий
	4)гипердвигатель(строим чтобы долететь до земли)
	--]]
	self.buildings = {}
end

function M:change_resource(type,v,max)
	local prev = self.resources[type]
	local new = COMMON.LUME.clamp(self.resources[type] + v,0,max or math.huge())
	self.resources[type] = new
	self:observable_notify(EVENTS.RESOURCE_CHANGED,{type= type, prev = prev, new = new, changes = new - prev})
end

function M:change_energy(v)
	self:change_resource("energy",v)
end

function M:change_ore(v)
	self:change_resource("ore",v)
end

function M:change_steel(v)
	self:change_resource("steel",v)
end


function M:update(dt, no_save)
	self.ecs_world:update(dt)
end


function M:save(file)

end

function M:dispose()
	self.ecs_world:clear()
end

function M:load(file)

end

return M()