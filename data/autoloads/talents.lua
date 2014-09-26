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


local Particles = require 'engine.Particles'
local get = util.getval

newTalent {
	name = 'Lurk', short_name = 'GRAYSWANDIR_LURK',
	type = {'psionic/other', 1},
	points = 5,
	cooldown = 18,
	no_energy = true,
	mode = 'sustained',
	--no_npc_use = true,
	psi_stealth_mult = 0.7,
	psi_stealth_add = function(self, t) return self:combatTalentScale(t, 10, 50) end,
	activate = function(self, t)
		local eff = {}
		self:talentTemporaryValue(eff, 'psi_stealth_mult', get(t.psi_stealth_mult, self, t))
		self:talentTemporaryValue(eff, 'psi_stealth_add', get(t.psi_stealth_add, self, t))
		self:talentTemporaryValue(eff, 'never_move', 1)
		return eff
		end,
	deactivate = function(self, t, p)
		if not self.player then game.logSeen(self, 'You glimpse something moving!') end
		return true
		end,
	callbackOnTakeDamage = function(self, t, src, x, y, type, dam, tmp, no_martyr)
		local lurk = self:isTalentActive(t.id)
		if lurk then self:forceUseTalent(t.id, {ignore_energy = true,}) end
		end,
	info = function(self, t)
		return ([[You cannot move but gain %d psionic stealth power, and an additional %.1f psionic stealth multiplier after that.
This will be deactivated if you take damage.]])
			:format(get(t.psi_stealth_add, self, t),
				get(t.psi_stealth_mult, self, t))
		end,}

newTalent {
	name = 'Lurking Strike', short_name = 'GRAYSWANDIR_LURKING_STRIKE',
	type = {'psionic/other', 1},
	points = 5,
	cooldown = 12,
	requires_target = true,
	range = 1,
	no_energy = 'fake',
	target = function(self, t) return {type = 'hit', range = get(t.range, self, t),} end,
	tactical = {ATTACK = 2,},
	on_pre_use = function(self, t, silent)
		if not self:isTalentActive 'T_GRAYSWANDIR_LURK' then
			if not silent then
				game.logPlayer(self, 'You must be lurking to use this talent.')
				end
			return false
			end
		return true
		end,
	weapon_mult = function(self, t) return self:combatTalentScale(t, 1, 1.8) end,
	awaken_radius = 10,
	action = function(self, t)
		local tg = get(t.target, self, t)
		local x, y, actor = self:getTarget(tg)
		if not x or not y or not actor then return end
		if core.fov.distance(self.x, self.y, x, y) > tg.range then return end

		self:attackTarget(actor, nil, get(t.weapon_mult, self, t))

		tg = {type = 'ball', range = 0, radius = get(t.awaken_radius, self, t),}
		local projector = function(x, y)
			local target = game.level.map(x, y, Map.ACTOR)
			if not target then return end
			if self:reactionToward(target) >= 0 and target:isTalentActive('T_GRAYSWANDIR_LURK') then
				target:forceUseTalent('T_GRAYSWANDIR_LURK', {ignore_energy = true,})
				end
			end
		self:project(tg, self.x, self.y, projector)

		return true
		end,
	info = function(self, t)
		return ([[Perform a powerful strike on the target for %d%% weapon damage.
May only be performed while lurking.
This will also knock all friendly actors in radius 10 out of lurking.]])
			:format(get(t.weapon_mult, self, t) * 100)
		end,}

newTalent {
	name = 'Mental Pressure', short_name = 'GRAYSWANDIR_MENTAL_PRESSURE',
	type = {'psionic/other', 1},
	points = 5,
	cooldown = 8,
	sustain_psi = 10,
	mode = 'sustained',
	save = function(self, t)
		return self:combatTalentScale(t, 10, 80) * (100 + self:combatMindpower()) * 0.005
		end,
	confuse = function(self, t) return self:combatTalentScale(t, 3, 7) end,
	damage = function(self, t) return self:combatTalentMindDamage(t, 10, 40) end,
	range = function(self, t) return math.floor(self:combatTalentScale(t, 6, 12)) end,
	target = function(self, t) return {type = 'hit', range = get(t.range, self, t),} end,
	activate = function(self, t)
		local tg = get(t.target, self, t)
		local x, y, actor = self:getTarget(tg)
		if not actor then return end
		if core.fov.distance(self.x, self.y, actor.x, actor.y) > tg.range then return end
		if not self:hasLOS(x, y) then return end

		actor:setEffect('EFF_GRAYSWANDIR_MENTAL_PRESSURE', 1, {
				src = self,
				range = tg.range,
				save = get(t.save, self, t),
				confuse = get(t.confuse, self, t),
				damage = get(t.damage, self, t),})

		self:callTalent('T_GRAYSWANDIR_MENTAL_PRESSURE', 'callbackOnActBase')

		return {target = actor,}
		end,
	deactivate = function(self, t, p)
		if p.particles then
			game.level.map:removeParticleEmitter(p.particles)
			end
		return true
		end,
	on_die = function(self, p)
		if p.particles then
			game.level.map:removeParticleEmitter(p.particles)
			end end,
	callbackOnActBase = function(self, t)
		local p = self:isTalentActive(t.id)
		if not p then return end
		local effect = p.target:hasEffect 'EFF_GRAYSWANDIR_MENTAL_PRESSURE'
		if not effect or not effect[self] then
			self:forceUseTalent(t.id, {ignore_energy = true,})
			return end

		-- update particles position
		if not p.particles or
			p.particles.x ~= self.x or p.particles.y ~= self.y or
			p.particles.tx ~= p.target.x or p.particles.ty ~= p.target.y
		then
			if p.particles then
				game.level.map:removeParticleEmitter(p.particles)
				end
			-- add updated particle emitter
			local dx, dy = p.target.x - self.x, p.target.y - self.y
			p.particles = Particles.new('mental_pressure', math.max(math.abs(dx), math.abs(dy)), { tx=dx, ty=dy })
			p.particles.x = self.x
			p.particles.y = self.y
			p.particles.tx = p.target.x
			p.particles.ty = p.target.y
			game.level.map:addParticleEmitter(p.particles)
			end
		end,
	info = function(self, t)
		return ([[Exert mental pressure on the target, decreasing their mental save by %d and giving a %d%% confuse chance, and deal %d mind damage per turn.]])
			:format(get(t.save, self, t),
				get(t.confuse, self, t),
				self:damDesc('MIND', get(t.damage, self, t)))
		end,}

newTalent {
	name = 'Hop', short_name = 'GRAYSWANDIR_HOP',
	type = {'technique/other', 1},
	points = 5,
	random_ego = 'attack',
	message = '@Source@ does a cute little hop!',
	cooldown = function(self, t) return math.max(6, 13 - math.floor(self:getTalentLevel(t))) end,
	range = function(self, t) return math.floor(self:combatTalentScale(t, 3, 7)) end,
	tactical = {CLOSEIN = 3,},
	requires_target = true,
	action = function(self, t)
		local tg = {type='hit', pass_terrain = true, range = get(t.range, self, t),}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return end
		if core.fov.distance(self.x, self.y, x, y) > tg.range then return end

		local start = rng.range(0, 8)
		for i = start, start + 8 do
			local x = target.x + (i % 3) - 1
			local y = target.y + math.floor((i % 9) / 3) - 1
			if game.level.map:isBound(x, y)
					and self:canMove(x, y)
					and not game.level.map.attrs(x, y, 'no_teleport') then
				self:move(x, y, true)
				return true end end end,
	info = function(self, t)
		return [[Hop to a random space adjacent to target.]] end, }
