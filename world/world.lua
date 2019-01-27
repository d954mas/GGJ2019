local COMMON = require "libs.common"
local Observable = require "libs.observable_mixin"
local MultipleSubscription = require "libs.multiple_subscription"
local ECS = require "libs.ecs"
local SYSTEMS = require "world.systems"
local BUILDINGS = require "world.buildings"
local SM = require "Jester.jester"
local TASKS = require "world.tasks"
local PLOT = require "world.plot"
local LOCALE = require "world.locale"

---@class World:Observable
local M = COMMON.class("World")
M:include(Observable)
local EVENTS = {
	RESOURCE_CHANGED = "RESOURCE_CHANGED" --{type = "energy"}
}


function M:initialize()
	self.EVENTS = EVENTS
	self.subscription = MultipleSubscription()
	self:set_observable_events(self.EVENTS)
	self.ecs_world = ECS.world()
	self.ecs_world.world = self
	self.time_scale = 1
	self.resources = {
		energy = 0, --нужна для работы роботов и турелей. И для силового поля. Так-же для покупки и апгрейда
		ore = 0, --добывается роботами на астероидах
		steel = 0, --из руды на заводе получаем
		hp = 100, --здоровье базы.Если в 0 то мы проиграли. Возвращаемся на прошлый stage
		tech = 0, --очки для прокачки
	}
	--[[
	1)Реактор, производит энергию
	2)Плавильня, руду в металл
	3)Лаборатория(исследуем перки) и апгрейды зданий
	4)гипердвигатель(строим чтобы долететь до земли)
	--]]
	---@type Building[]
	self.buildings = {BUILDINGS.generator(self),BUILDINGS.ore(self), BUILDINGS.factory(self), BUILDINGS.lab(self),BUILDINGS.ore(self)}
	for _,b in ipairs(self.buildings) do
		self.ecs_world:addEntity(b.e)
	end
	SYSTEMS.init_systems(self.ecs_world)
	self.plot = PLOT(self)
	self.locale = LOCALE()
	self.tasks = TASKS.new_tasks(self)

end


function M:change_resource(type,v,max)
	local prev = self.resources[type]
	local new = COMMON.LUME.clamp(self.resources[type] + v,0,max or math.huge)
	self.resources[type] = new
	self:observable_notify(EVENTS.RESOURCE_CHANGED,{type= type, prev = prev, new = new, changes = new - prev})
	return new - prev
end

function M:change_energy(v)
	return self:change_resource("energy",v)
end

function M:change_ore(v)
	return self:change_resource("ore",v)
end

function M:change_steel(v)
	return self:change_resource("steel",v)
end

function M:change_tech(v)
	return self:change_resource("tech",v)
end


function M:update(dt, no_save)
	self.ecs_world:update(dt*self.time_scale)
	self.plot:update(dt)
	for _,b in ipairs(self.buildings) do
		b:update(dt)
	end
end


function M:save(file)

end

function M:dispose()
	self.ecs_world:clear()
end

function M:load(file)

end



--region GAME

function M:click_slot(slot)
	COMMON.GLOBAL.slot = slot
	self.buildings[slot]:on_touch(slot)

end

return M()