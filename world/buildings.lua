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

local LEVELS = {
	[1] = 5,
	[2] = 8,
	[3] = 12,
	[4] = 16,
	[5] = 20,
	[6] = 25,
}

--Building.static = static
---@param world World
function Building:initialize(world)
	assert(world)
	self.STATES = STATES
	self.state = STATES.HIDE
	self.e = {total_time = 10,time = 0,time_progress = 0}
	self.e.on_time = function(e,world) if self.state == STATES.BUILD then self:on_time(world) end end
	self.e.hp = 1
	self.level = 0
	self.exp = 0
	self.cost = {}
	self.hp_lose_speed = 0.08
	self.levels = {
		[0] = {{type = "energy",n = 1},{type = "ore",n = 1}},
		[1] = {{type = "energy",n = 1},{type = "ore",n = -1}},
		[2] = {{type = "energy",n = 2},{type = "ore",n = -1}},
		[3] = {{type = "energy",n = 3},{type = "ore",n = -1}},
		[4] = {{type = "energy",n = 4},{type = "ore",n = -1}},
		[5] = {{type = "energy",n = 5},{type = "ore",n = -1}},
		[6] = {{type = "energy",n = 6},{type = "ore",n = -1}},
	}
	self.world = world
end

function Building:get_values()
	local level = self.level
	local data = self.levels[level]
	return data
end

function Building:add_exp(points)
	local exp = points
	self.exp = self.exp + exp
	while LEVELS[self.level+1] and  self.exp >= LEVELS[self.level+1] do
		self.level = self.level + 1
		self.exp = LEVELS[self.level+1] and self.exp - LEVELS[self.level+1] or 0
	end
end
function Building:add_hp(points)
	local hp = points/3 * 0.2
	self.e.hp = math.max(self.e.hp+hp,1)
end

function Building:get_next_exp()
	local level = LEVELS[self.level+1]
	if level then
		return level
	else return -1 end
end
function Building:add_time(points)
	self.e.time = self.e.time + points*1
end

function Building:set_state(state)
	self.state = assert(state)
	self.e.time = 0
end

function Building:get_description()
	local values = self:get_values()
	local str = ""
	self.ENERGY = "%d<img=gui:energy_icon/>"
	self.ORE = "%d<img=gui:ore_icon/>"
	self.STEEL = "%d<img=gui:steel_icon/>"
	self.TECH = "%d<img=gui:tech_icon/>"
	local map = {
		energy = self.world.locale.ENERGY,
		ore = self.world.locale.ORE,
		steel = self.world.locale.STEEL,
		tech = self.world.locale.TECH,
	}
	for _,v in ipairs(values) do
		str = str .. "  " .. string.format(map[v.type],v.n)
	end
	return str
end

function Building:update(dt)
	if self.state == STATES.BUILD then
		self.e.hp = math.max(0,self.e.hp - self.hp_lose_speed * dt)
	end
end

---@param world World
function Building:on_time(world)
	local values = self:get_values()
	local can_spend = true
	for _,v in ipairs(values) do
		local res, n = v.type, v.n
		if n<0 then
			if world.resources[res] < -n then can_spend = false end
		end
	end
	if not can_spend then
		self.e.time = self.e.total_time
		self.e.time_progress = 1
	else
		for _,v in ipairs(values) do
			local res, n = v.type, v.n
			world["change_" ..res](world,n)
		end
	end
	--self.e.hp = self.e.hp - 0.01
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



---@class LabBuilding:Building
local Lab = COMMON.class("Lab",Building)

function Lab:initialize(world)
	Building.initialize(self,world)
	self.e.total_time = 1
end


---@class GeneratorBuilding:Building
local Generator = COMMON.class("Generator",Building)

function Generator:initialize(world)
	Building.initialize(self,world)
	self.e.total_time = 4
	self.levels = {
		[0] = {{type = "energy",n = 5}},
		[1] = {{type = "energy",n = 8}},
		[2] = {{type = "energy",n = 12}},
		[3] = {{type = "energy",n = 15}},
		[4] = {{type = "energy",n = 20}},
		[5] = {{type = "energy",n = 25}},
		[6] = {{type = "energy",n = 30}},
	}
end

---@class OreBuilding:Building
local Ore = COMMON.class("Ore",Building)

function Ore:initialize(world)
	Building.initialize(self,world)
	self.e.total_time = 4
	self.levels = {
		[0] = {{type = "energy",n = -2},{type = "ore",n = 3}},
		[1] = {{type = "energy",n = -4},{type = "ore",n = 4}},
		[2] = {{type = "energy",n = -6},{type = "ore",n = 5}},
		[3] = {{type = "energy",n = -8},{type = "ore",n = 6}},
		[4] = {{type = "energy",n = -10},{type = "ore",n = 7}},
		[5] = {{type = "energy",n = -12},{type = "ore",n = 8}},
		[6] = {{type = "energy",n = -14},{type = "ore",n = 9}},
	}
end

---@class FactoryBuilding:Building
local Factory = COMMON.class("Factory",Building)


function Factory:initialize(world)
	Building.initialize(self,world)
	self.e.total_time = 15
	self.levels = {
		[0] = {{type = "energy",n = -20},{type = "ore",n = -30},{type = "steel",n = 1}},
		[1] = {{type = "energy",n = -20},{type = "ore",n = -30},{type = "steel",n = 2}},
		[2] = {{type = "energy",n = -25},{type = "ore",n = -40},{type = "steel",n = 3}},
		[3] = {{type = "energy",n = -25},{type = "ore",n = -40},{type = "steel",n = 4}},
		[4] = {{type = "energy",n = -30},{type = "ore",n = -40},{type = "steel",n = 5}},
		[5] = {{type = "energy",n = -30},{type = "ore",n = -40},{type = "steel",n = 6}},
		[6] = {{type = "energy",n = -30},{type = "ore",n = -50},{type = "steel",n = 7}},
	}
end

M.generator = Generator
M.ore = Ore
M.factory = Factory
M.lab = Lab


return M