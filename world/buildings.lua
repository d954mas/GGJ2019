local COMMON = require "libs.common"
local ECS = require "libs.ecs"
local SM = require "Jester.jester"
local M = {}

---@class Building
---@field e ECSEntity
local Building = COMMON.class("Building")

local STATES = {
	HIDE = 1, NOT_BUILD = 2, BUILD = 3
}

--Building.static = static

function Building:initialize()
	self.STATES = STATES
	self.state = STATES.HIDE
	self.e = {total_time = 10,time = 0,time_progress = 0}
	self.e.on_time = function(e,world) if self.state == STATES.BUILD then self:on_time(world) end end
	self.e.hp = 1
	self.cost = {}
	--self.state = self.static.states.HIDE
end

function Building:set_state(state)
	self.state = assert(state)
	self.e.time = 0
end

---@param world World
function Building:on_time(world)
	world:change_ore(5)
	self.e.hp = self.e.hp - 0.01
end

function Building:on_touch(slot)
	if self.state == STATES.NOT_BUILD then
		if #self.cost == 0 then
			--no cost upgrade
			self:set_state(STATES.BUILD)
		end
	elseif self.state == STATES.BUILD then
		SM.show("SlotModal",{slot = slot},{popup = true})
	end
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

---@class GeneratorBuilding:Building
local Generator = COMMON.class("Generator",Building)

function Generator:initialize()
	Building.initialize(self)
	self.e.total_time = 4
end

---@param world World
function Generator:on_time(world)
	world:change_energy(5)
	self.e.hp = self.e.hp - 0.01
end

M.generator = Generator
M.ore = Building
M.factory = Factory
M.lab = Lab


return M