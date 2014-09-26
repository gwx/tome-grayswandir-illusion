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
	type = 'psionic/illusion',
	name = 'Illusion',
	description = 'Mess with other people\'s heads!.',
	generic = true,
	allow_random = true,}

local make_require = function(tier)
	return {
		stat = {wil = function(level) return 2 + tier * 8 + level * 2 end,},
		level = function(level) return -5 + tier * 4 + level end,}
	end

newTalent {
	name = 'Darkness', short_name = 'GRAYSWANDIR_DARKNESS',
	type = {'psionic/illusion', 1,},
	points = 5,
	require = make_require(1),
	range = 3,
	psi = 3,
	requires_target = true,
	cooldown = 14,
	no_energy = true,
	tactical = {DISABLE = 2,},
	radius = function(self, t)
		return self:scale {low = 0, high = 3, t, after = 'floor',}
		end,
	target = function(self, t)
		local radius = math.floor(get(t.radius, self, t))
		return {type = 'ball', friendlyfire = false, nowarning = true,
			radius = radius, nolock = radius > 0,
			range = get(t.range, self, t),}
		end,
	duration = function(self, t)
		return self:scale {low = 2, high = 5, t, after = 'floor',}
		end,
	action = function(self, t)
		local _
		local tg = get(t.target, self, t)
		local x, y = self:getTarget(tg)
		if not x or not y then return end
		_, x, y = self:canProject(tg, x, y)

		local duration = get(t.duration, self, t)
		local apply = self:combatMindpower()
		self:project(tg, x, y, function(x, y, tg, self)
				local actor = game.level.map(x, y, Map.ACTOR)
				if not actor then return end
				if actor:canBe 'blind' then
					actor:setEffect('EFF_GRAYSWANDIR_ILLUSION_BLINDED', duration, {
							src = self,
							apply_power = apply,})
					end
				end)

		game.level.map:particleEmitter(x, y, tg.radius, 'generic_ball', {
				radius = tg.radius + 0.5, size = {3, 8,},
				rm = 0, rM = 50, gm = 0, gM = 50, bm = 0, bM = 50, am = 50, aM = 200,})
		game:playSoundNear({x = x, y = y,}, 'talents/spell_generic')

		return true
		end,
	info = function(self, t)
		return ([[The simplest illusion - convince people that they've gone blind #SLATE#[mind vs. mind, blind]#LAST#. Range %d, radius %d #SLATE#[*]#LAST#, lasts for %d #SLATE#[*]#LAST# turns.]])
			:format(get(t.range, self, t),
				get(t.radius, self, t),
				get(t.duration, self, t))
		end,}

newTalent {
	name = 'Illusory Walls', short_name = 'GRAYSWANDIR_ILLUSORY_WALLS',
	type = {'psionic/illusion', 2,},
	points = 5,
	require = make_require(2),
	range = 3,
	psi_per = function(self, t)
		return 0.04 * (100 + 2 * self:combatFatigue()) end,
	requires_target = true,
	no_npc_use = true,
	cooldown = 22,
	count = function(self, t)
		return self:scale {low = 2, high = 5, t, after = 'floor',}
		end,
	target = function(self, t)
		return {type = 'hit', nolock = true, nowarning = true, range = get(t.range, self, t),}
		end,
	duration = function(self, t)
		return self:scale {low = 5, high = 10, t, after = 'floor',}
		end,
	action = function(self, t)
		local Trap = require 'mod.class.Trap'
		local duration = get(t.duration, self, t)
		local power = self:combatMindpower()

		local count = get(t.count, self, t)
		local psi_per = get(t.psi_per, self, t)
		count = math.min(count, math.floor(self:getPsi() / psi_per))
		if count == 0 then return end
		for i = 1, count do
			local _, x, y
			local valid
			while not valid do
				local tg = get(t.target, self, t)
				x, y = self:getTarget(tg)
				if not x or not y then return i > 1 end
				_, x, y = self:canProject(tg, x, y)

				if game.level.map(x, y, Map.TRAP) then
					game.logPlayer(self, 'Invalid Selection.')
				else
					self:incPsi(-psi_per)
					valid = true
					end
				end

			local wall = Trap.new {
				name = ('Illusory Wall (%d mindpower)'):format(power),
				unided_name = 'shimmering wall',
				type = 'mental', id_by_type = true,
				image = 'npc/illusory-wall.png',
				display = '#', color = colors.YELLOW,
				faction = self.faction,
				summoner = self,
				temporary = duration,
				power = power,
				x = x, y = y,
				canAct = false,
				energy = {value = 0,},
				disarm = function() end,
				act = function(self)
					self:useEnergy()
					self.temporary = self.temporary - 1
					if self.temporary <= 0 then
						if game.level.map(self.x, self.y, engine.Map.TRAP) == self then
							game.level.map:remove(self.x, self.y, engine.Map.TRAP)
							end
						game.level:removeEntity(self)
						end
					end,
				block_move = function(self, x, y, e, act, couldpass)
					if e and e.reactionToward and e:reactionToward(self.summoner) < 0
						and e.combatMentalResist
					then
						return self:checkHit(self.power, e:combatMentalResist())
						end
					end,
				triggered = function() end,
				trigger = function() end,}
			wall:identify(true)
			wall:resolve() wall:resolve(nil, true)
			wall:setKnown(self, true)
			game.level:addEntity(wall)
			game.zone:addEntity(game.level, wall, 'trap', x, y)
			game.level.map:particleEmitter(x, y, 1, 'summon')
			end
		return true
		end,
	info = function(self, t)
		return ([[Place up to %d #SLATE#[*]#LAST# illusory walls within %d spaces, lasting for %d #SLATE#[*]#LAST# turns. Hostile creatures will need to make a mind save to move into those spaces. Each wall will cost #7FFFD4#%.1f psi#LAST#.]])
			:format(get(t.count, self, t),
				get(t.range, self, t),
				get(t.duration, self, t),
				get(t.psi_per, self, t))
		end,}

newTalent {
	name = 'Illusory Army', short_name = 'GRAYSWANDIR_ILLUSORY_ARMY',
	type = {'psionic/illusion', 3,},
	points = 5,
	require = make_require(3),
	range = 3,
	psi_per = function(self, t)
		return 0.05 * (100 + 2 * self:combatFatigue()) end,
	requires_target = true,
	cooldown = 30,
	tactical = {ATTACK = {MIND = 2,},},
	count = function(self, t)
		return self:scale {low = 2, high = 6, t, after = 'floor',}
		end,
	target = function(self, t)
		return {type = 'hit', nolock = true, nowarning = true, range = get(t.range, self, t),}
		end,
	duration = function(self, t)
		return self:scale {low = 6, high = 12, t, after = 'floor',}
		end,
	damage = function(self, t)
		return self:scale {low = 10, high = 80, t, 'mind', after = 'damage',}
		end,
	radius = 1,
	action = function(self, t)
		local NPC = require 'mod.class.NPC'
		local damage = get(t.damage, self, t)
		local duration = get(t.duration, self, t)
		local radius = get(t.radius, self, t)
		local power = self:combatMindpower()

		local count = get(t.count, self, t)
		local psi_per = get(t.psi_per, self, t)
		count = math.min(count, math.floor(self:getPsi() / psi_per))
		if count == 0 then return end
		for i = 1, count do
			local _, x, y
			local valid
			while not valid do
				local tg = get(t.target, self, t)
				x, y = self:getTarget(tg)
				if not x or not y then return i > 1 end
				_, _, _, x, y = self:canProject(tg, x, y)

				local actor = game.level.map(x, y, Map.ACTOR)
				local terrain = game.level.map(x, y, Map.TERRAIN)
				if actor and (
					actor == self or
						(actor.name == 'Illusory Decoy' and actor.summoner == self) or
						not self.player)
				then
					local _, _, grids = util.findFreeGrid(x, y, 5, true, {[Map.ACTOR] = true,})
					for i = 1, #grids do
						x, y = grids[i][1], grids[i][2]
						_, x, y = self:canProject(tg, x, y)
						local terrain = game.level.map(x, y, Map.TERRAIN)
						if not terrain.does_block_move and x == grids[i][1] and y == grids[i][2] then
							break end end end

				actor = game.level.map(x, y, Map.ACTOR)
				if actor or terrain.does_block_move then
					game.logPlayer(self, 'Invalid Selection.')
					if not self.player then return i > 1 end
				else
					self:incPsi(-psi_per)
					valid = true
					end
				end

			local illusion = NPC.new {
				name = 'Illusory Decoy',
				type = 'illusion', subtype = 'ghost',
				color = colors.YELLOW,
				image = 'npc/lure.png', shader = 'shadow_simulacrum',
				shader_args = {color = {0.8, 0.8, 0.8,}, base = 0.8, time_factor = 4000,},
				display = self.display, color = colors.YELLOW,
				faction = self.faction,
				summoner = self, summoner_gain_exp = true, summon_time = duration,
				autolevel = 'none', level_range = {1, 1,}, exp_worth = 0,
				ai = 'summoned', ai_real = 'dumb_talented',
				attackTarget = function() end,
				never_move = 1,
				power = power,
				x = x, y = y,
				max_life = 1, life_rating = 0,
				radius = radius,
				damage_mindpower = power,
				damage = damage,
				levitation = 1,
				no_breath = 1,
				poison_immune = 1,
				cut_immune = 1,
				disease_immune = 1,
				stun_immune = 1,
				blind_immune = 1,
				knockback_immune = 1,
				confusion_immune = 1,
				inc_damage = table.clone(self.inc_damage),
				on_die = function(self)
					if not self.summon_time or self.summon_time <= 0 then return end
					local tg = {type = 'ball', range = 0, friendlyfire = false, radius = self.radius,}
					game.level.map:particleEmitter(self.x, self.y, tg.radius, 'generic_blast', {
							radius = tg.radius,
							rm = 130, rM = 230,
							gm = 10, gM = 110,
							bm = 70, bM = 170,
							am = 150, aM = 255,})
					game:playSoundNear(self, 'talents/echo')
					self:project(tg, self.x, self.y, 'GRAYSWANDIR_ILLUSION', {
							dam = self.damage,
							power = 'damage_mindpower',})
					end,}
			illusion:resolve() illusion:resolve(nil, true)
			game.level:addEntity(illusion)
			game.zone:addEntity(game.level, illusion, 'actor', x, y)
			game.level.map:particleEmitter(x, y, 1, 'summon')
			end
		return true
		end,
	info = function(self, t)
		return ([[Place up to %d #SLATE#[*]#LAST# decoys within %d spaces, lasting for %d #SLATE#[*]#LAST# turns. Upon dying, they will explode, dealing %d #FFFF44#illusion#LAST# damage in radius %d. Each decoy will cost #7FFFD4#%.1f psi#LAST#.
You may target an already placed decoy to place another nearby.]])
			:format(get(t.count, self, t),
				get(t.range, self, t),
				get(t.duration, self, t),
				self:damDesc('MIND', get(t.damage, self, t)),
				get(t.radius, self, t),
				get(t.psi_per, self, t))
		end,}

newTalent {
	name = 'Mirror Image', short_name = 'GRAYSWANDIR_MIRROR_IMAGE',
	type = {'psionic/illusion', 4,},
	points = 5,
	require = make_require(4),
	mode = 'sustained',
	sustain_psi = 30,
	cooldown = 24,
	no_energy = true,
	tactical = {BUFF = 3,},
	chance = function(self, t) return self:scale {low = 10, high = 30, t} end,
	radius = function(self, t) return self:scale {low = 2, high = 4, t, after = 'floor',} end,
	target = function(self, t) return {type = 'ball', range = 0, radius = get(t.radius, self, t),} end,
	activate = function(self, t) return true end,
	deactivate = function(self, t) return true end,
	callbackOnPositionSeen = function(self, t, src, pos)
		if not rng.percent(get(t.chance, self, t)) then return end
		local summons = {}
		self:project(get(t.target, self, t), self.x, self.y, function(x, y)
				local actor = game.level.map(x, y, Map.ACTOR)
				if actor and actor.summoner == self then table.insert(summons, actor) end
				end)
		if #summons == 0 then return end
		local summon = get(summons)
		local distance = core.fov.distance(self.x, self.y, pos.x, pos.y)
		if core.fov.distance(self.x, self.y, summon.x, summon.y) < distance then return end
		pos.x = summon.x
		pos.y = summon.y
		end,
	info = function(self, t)
		return ([[Your nearby summons now look like you to your enemies' eyes. Whenever an enemy targets you they have a %d%% #SLATE#[*]#LAST# chance to instead target one of your summons within radius %d #SLATE#[*]#LAST#. This will never move their target closer to you than it already is #SLATE#(eg. if you're also stealthed)#LAST#]])
			:format(get(t.chance, self, t), get(t.radius, self, t))
		end,}
