-- Gray's Illusions, for Tales of Maj'Eyal.
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.


local get = util.getval

newTalentType {
	type = 'psionic/antiperception',
	name = 'Antiperception',
	description = 'Use your psionic powers to hide in plain sight.',
	allow_random = true,}

local make_require = function(tier)
	return {
		stat = {wil = function(level) return 2 + tier * 8 + level * 2 end,},
		level = function(level) return -5 + tier * 4 + level end,}
	end

newTalent {
	name = 'Antiperception', short_name = 'GRAYSWANDIR_ANTIPERCEPTION',
	type = {'psionic/antiperception', 1,},
	points = 5,
	require = make_require(1),
	mode = 'sustained',
	sustain_psi = 50,
	cooldown = 20,
	no_energy = true,
	tactical = {BUFF = 3,},
	no_break_stealth = true,
	psi_stealth_mult = function(self, t)
		return self:scale {low = 0.2, high = 0.5, limit = 0.7, t,}
		end,
	psi_stealth_add = function(self, t)
		return self:scale {low = 0, high = 20, t,}
		end,
	activate = function(self, t)
		local p = {}
		self:autoTemporaryValues(p, {
				psi_stealth_mult = get(t.psi_stealth_mult, self, t),
				psi_stealth_add = get(t.psi_stealth_add, self, t),})
		self:resetCanSeeCacheOf()
		return p
		end,
	deactivate = function(self, t, p)
		self:resetCanSeeCacheOf()
		return true end,
	info = function(self, t)
		local mult = get(t.psi_stealth_mult, self, t)
		local add = get(t.psi_stealth_add, self, t)
		return ([[Gives you antiperception power equal to %d%% #SLATE#[*]#LAST# of your unscaled mindpower plus an additional #SLATE#[*]#LAST# %d.
Your current scaled antiperception power is: %d.
Damaging targets will temporarily give them a 'memory' bonus, improving their ability to see through your antiperception.]])
			:format(mult * 100, add, self:psiStealthPower() or 0)
		end,}

newTalent {
	name = 'Amnesia Pulse', short_name = 'GRAYSWANDIR_AMNESIA_PULSE',
	type = {'psionic/antiperception', 2,},
	points = 5,
	require = make_require(2),
	psi = 20,
	cooldown = 24,
	tactical = {DEBUFF = 1,},
	radius = 3,
	range = function(self, t)
		return math.max(0, self:scale {low = -5, high = 3, after = 'floor', t})
		end,
	target = function(self, t)
		return {type = 'ball', nowarning = true,
			radius = get(t.radius, self, t),
			range = get(t.range, self, t),}
		end,
	memory_mult = function(self, t)
		return self:scale {low = 0.4, high = 0.1, limit = 0.0, t,}
		end,
	action = function(self, t)
		local tg = get(t.target, self, t)
		local x, y
		if tg.range > 0 then
			 x, y = self:getTarget(tg)
		else
			x, y = self.x, self.y end
		if not x or not y then return end

		local mult = get(t.memory_mult, self, t)
		self:project(tg, x, y, function(x, y, tg, self)
				local actor = game.level.map(x, y, Map.ACTOR)
				if not actor then return end
				if actor.psiStealthAlterMemory then
					actor:psiStealthAlterMemory('all', 0, mult)
					end
				end)

		game.level.map:particleEmitter(x, y, 1, 'amnesia_pulse', {})
		game:playSoundNear({x = x, y = y,}, 'talents/warp')

		return true
		end,
	info = function(self, t)
		return ([[Send out an amnesiac pulse with range %d #SLATE#[*]#LAST# and radius %d, causing everything hit (even yourself) to have their memory bonus be reduced to %d%% #SLATE#[*]#LAST# of its current value.]])
			:format(get(t.range, self, t),
				get(t.radius, self, t),
				get(t.memory_mult, self, t) * 100)
		end,}