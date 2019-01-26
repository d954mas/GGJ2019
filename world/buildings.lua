local COMMON = require "libs.common"
local ECS = require "libs.ecs"
local M = {}

---@class Building
---@field e ECSEntity
local Building = COMMON.class("Building")

function Building:initialize()
	self.e = {total_time = 10,time = 0,time_progress = 0}
	self.e.on_time = function(e,world) self:on_time(world) end
end

---@param world World
function Building:on_time(world)
	world:change_ore(5)
end

---@class FactoryBuilding:Building
local Factory = COMMON.class("Factory",Building)
---@param world World
function Factory:on_time(world)
	if world.resources.ore > 10 then
		world:change_ore(-20)
		world:change_steel(5)
	else
		self.e.time = self.e.total_time
	end
end

---@class LabBuilding:Building
local Lab = COMMON.class("Lab",Building)

function Lab:initialize()
	Building.initialize(self)
	self.e.total_time = 1
end

---@param world World
function Lab:on_time(world)
	world:change_tech(6)
end


M.ore = Building
M.factory = Factory
M.lab = Lab


return M