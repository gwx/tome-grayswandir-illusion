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
	type = 'psionic/mind-games',
	name = 'Mind Games',
	description = 'Befuddle and Bewilder!',
	allow_random = true,}

local make_require = function(tier)
	return {
		stat = {cun = function(level) return 2 + tier * 8 + level * 2 end,},
		level = function(level) return -5 + tier * 4 + level end,}
	end

newTalent {
	name = 'Sensory Overload', short_name = 'GRAYSWANDIR_SENSORY_OVERLOAD',
	type = {'psionic/mind-games', 1,},
	points = 5,
	require = make_require(1),
	requires_target = true,
	psi = 4,
	cooldown = 6,
	tactical = {ATTACK = {MIND = 1,}, DISABLE = {daze = 3,},},
	range = function(self, t) return self:scale {low = 4, high = 6, t, after = 'floor',} end,
	radius = function(self, t) return self:scale {low = 0, high = 3, t, after = 'floor',} end,
	damage = function(self, t) return self:scale {low = 0, high = 45, t, 'mind', after = 'damage',} end,
	duration = 2,
	target = function(self, t)
		return {type = 'ball', friendlyfire = false, nowarning = true,
			radius = self:mindCrit(get(t.radius, self, t)),
			range = get(t.range, self, t),}
		end,
	action = function(self, t)
		local _
		local tg = get(t.target, self, t)
		local x, y = self:getTarget(tg)
		if not x or not y then return end
		if tg.range > 0 then
			_, x, y = self:canProject(tg, x, y)
		else
			x, y = self.x, self.y
			end

		local damage = get(t.damage, self, t)
		local duration = get(t.duration, self, t)
		local apply = self:combatMindpower()
		self:project(tg, x, y, function(x, y, tg, self)
				local actor = game.level.map(x, y, Map.ACTOR)
				if not actor then return end
				DamageType:get('GRAYSWANDIR_ILLUSION').projector(self, x, y, 'GRAYSWANDIR_ILLUSION', damage)
				if actor:canBe 'stun' then
					actor:setEffect('EFF_GRAYSWANDIR_ILLUSION_DAZED', duration, {
							src = self,
							apply_power = apply,})
					end
				end)

		game.level.map:particleEmitter(x, y, tg.radius, 'psionic_pulse', {radius = tg.radius})
		game:playSoundNear({x = x, y = y,}, 'talents/warp')

		return true
		end,
	info = function(self, t)
		return ([[Send a burst of sensations designed to disorient your opponents. All opponents struck take %d #SLATE#[*, mind]#LAST# #FFFF44#illusion#LAST# damage and are #ORANGE#dazed#LAST# #SLATE#[mind vs. mind, stun]#LAST# for %d turns. Range %d #SLATE#[*]#LAST#, Radius %d #SLATE#[*, mind crit]#LAST#.]])
			:format(
				self:damDesc('MIND', get(t.damage, self, t)),
				get(t.duration, self, t),
				get(t.range, self, t),
				get(t.radius, self, t))
		end,}

newTalent {
	name = 'Delusion: Shackles', short_name = 'GRAYSWANDIR_DELUSION_SHACKLES',
	type = {'psionic/mind-games', 2,},
	points = 5,
	require = make_require(2),
	requires_target = true,
	psi = 6,
	cooldown = 16,
	tactical = {DISABLE = 3,},
	range = function(self, t) return self:scale {low = 4, high = 6, t, after = 'floor',} end,
	radius = function(self, t) return self:scale {low = 0, high = 3, t, after = 'floor',} end,
	duration = function(self, t) return self:scale {low = 6, high = 10, t, after = 'floor',} end,
	speed_loss = function(self, t) return self:scale {low = 0.18, high = 0.36, limit = 0.54, t,} end,
	target = function(self, t)
		return {type = 'ball', friendlyfire = false, nowarning = true,
			radius = self:mindCrit(get(t.radius, self, t)),
			range = get(t.range, self, t),}
		end,
	action = function(self, t)
		local _
		local tg = get(t.target, self, t)
		local x, y = self:getTarget(tg)
		if not x or not y then return end
		if tg.range > 0 then
			_, x, y = self:canProject(tg, x, y)
		else
			x, y = self.x, self.y
			end

		local duration = get(t.duration, self, t)
		local apply = self:combatMindpower()
		local speed_loss = get(t.speed_loss, self, t)
		self:project(tg, x, y, function(x, y, tg, self)
				local actor = game.level.map(x, y, Map.ACTOR)
				if not actor then return end
				actor:setEffect('EFF_GRAYSWANDIR_DELUSION_SHACKLES', duration, {
						src = self,
						apply_power = apply,
						speed_loss = speed_loss,})
				end)

		game.level.map:particleEmitter(x, y, tg.radius, 'psionic_pulse', {radius = tg.radius})
		game:playSoundNear({x = x, y = y,}, 'talents/warp')

		return true
		end,
	info = function(self, t)
		return ([[Bind your foes with shackles visible only to themselves. All opponents struck #SLATE#[mind vs. mind]#LAST# are bound for %d #SLATE#[*]#LAST# turns, losing %d%% #SLATE#[*]#LAST# movement, combat, and spell speeds. Range %d #SLATE#[*]#LAST#, Radius %d #SLATE#[*, mind crit]#LAST#.]])
			:format(
				get(t.duration, self, t),
				get(t.speed_loss, self, t) * 100,
				get(t.range, self, t),
				get(t.radius, self, t))
		end,}

newTalent {
	name = 'Delusion: Hounded', short_name = 'GRAYSWANDIR_DELUSION_HOUNDED',
	type = {'psionic/mind-games', 3,},
	points = 5,
	require = make_require(3),
	requires_target = true,
	psi = 8,
	cooldown = 22,
	tactical = {DISABLE = 3,},
	range = function(self, t) return self:scale {low = 4, high = 6, t, after = 'floor',} end,
	radius = function(self, t) return self:scale {low = 0, high = 3, t, after = 'floor',} end,
	duration = function(self, t) return self:scale {low = 6, high = 12, t, after = 'floor',} end,
	stat_loss = function(self, t) return self:scale {low = 15, high = 60, t, 'cun', after = 'floor',} end,
	crit_chance = function(self, t) return self:scale {low = 0, high = 30, t,} end,
	target = function(self, t)
		return {type = 'ball', friendlyfire = false, nowarning = true,
			radius = self:mindCrit(get(t.radius, self, t)),
			range = get(t.range, self, t),}
		end,
	action = function(self, t)
		local _
		local tg = get(t.target, self, t)
		local x, y = self:getTarget(tg)
		if not x or not y then return end
		if tg.range > 0 then
			_, x, y = self:canProject(tg, x, y)
		else
			x, y = self.x, self.y
			end

		local duration = get(t.duration, self, t)
		local apply = self:combatMindpower()
		local speed_loss = get(t.speed_loss, self, t)
		local crit_chance = get(t.crit_chance, self, t)
		self:project(tg, x, y, function(x, y, tg, self)
				local actor = game.level.map(x, y, Map.ACTOR)
				if not actor then return end
				actor:setEffect('EFF_GRAYSWANDIR_DELUSION_HOUNDED', duration, {
						src = self,
						apply_power = apply,
						stat_loss = stat_loss,
						crit_chance = crit_chance,})
				end)

		game.level.map:particleEmitter(x, y, tg.radius, 'psionic_pulse', {radius = tg.radius})
		game:playSoundNear({x = x, y = y,}, 'talents/warp')

		return true
		end,
	info = function(self, t)
		return ([[Harrass your targets with invisible assailants that constantly loom out of the corner of their eye. All opponents struck #SLATE#[mind vs. mind]#LAST# are hounded for %d #SLATE#[*]#LAST# turns, losing %d #SLATE#[*, cun]#LAST# Dexterity and Cunning, and have an increased %d%% #SLATE#[*]#LAST# chance to be struck by physical criticals. Range %d #SLATE#[*]#LAST#, Radius %d #SLATE#[*, mind crit]#LAST#.]])
			:format(
				get(t.duration, self, t),
				get(t.stat_loss, self, t),
				get(t.crit_chance, self, t),
				get(t.range, self, t),
				get(t.radius, self, t))
		end,}

newTalent {
	name = 'Figments', short_name = 'GRAYSWANDIR_FIGMENTS',
	type = {'psionic/mind-games', 4,},
	points = 5,
	require = make_require(4),
	psi = 15,
	cooldown = 18,
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
	count = 3,
	duration = 7,
	damage = function(self, t) return self:scale {low = 10, high = 70, 'u.mind', after = 'damage',} end,
	confuse = function(self, t) return self:scale {low = 15, high = 35, t,} end,
	psi_conversion = function(self, t) return self:scale {low = 30, high = 20, limit = 10, t,} end,
	confuse_dur = 3,
	action = function(self, t)
		local tg = get(t.target, self, t)
		local x, y
		if tg.range > 0 then
			x, y = self:getTarget(tg)
		else
			x, y = self.x, self.y end
		if not x or not y then return end

		local NPC = require 'mod.class.NPC'
		local damage = get(t.damage, self, t)
		local count = get(t.count, self, t)
		local confuse = get(t.confuse, self, t)
		local confuse_dur = get(t.confuse_dur, self, t)
		local duration = get(t.duration, self, t)
		local power = self:combatMindpower()
		local psi_conversion = get(t.psi_conversion, self, t)

		local summoned
		for i = 1, count do
			local sx, sy = util.findFreeGrid(x, y, tg.radius, true, {[Map.ACTOR] = true,})
			if not sx or not sy then break end

			local figment = NPC.new {
				name = 'Figment',
				type = 'illusion', subtype = 'canine',
				image = 'npc/canine_fox.png', shader = 'shadow_simulacrum',
				shader_args = {color = {0.8, 0.8, 0.8,}, base = 0.8, time_factor = 4000,},
				display = 'C', color = colors.WHITE,
				faction = self.faction,
				summoner = self, summoner_gain_exp = true, summon_time = duration,
				autolevel = 'none', level_range = {1, 1,}, exp_worth = 0,
				ai = 'summoned', ai_real = 'dumb_talented_simple',
				ai_state = {tactic_leash = 100,},
				special = {
					damage = damage,
					confuse = confuse,
					confuse_dur = confuse_dur,
					psi_conversion = psi_conversion * -0.01,
					power = power,},
				attackTarget = function(self, target)
					self:project({}, target.x, target.y, 'GRAYSWANDIR_ILLUSION', self.special.damage)
					if target:canBe 'confuse' then
						target:setEffect('EFF_CONFUSED', self.special.confuse_dur, {
								src = self,
								power = self.special.confuse,
								apply_power = self.special.power,})
						end
					return true
					end,
				takeHit = function(self, value, src, death_note)
					if not self.summoner or not self.summoner.incPsi then return false, value end
					self.summoner:incPsi(self.special.psi_conversion * value)
					return false, value
					end,
				x = sx, y = sy,
				max_life = 1, life_rating = 0,
				levitation = 1,
				no_breath = 1,
				poison_immune = 1,
				cut_immune = 1,
				disease_immune = 1,
				stun_immune = 1,
				blind_immune = 1,
				knockback_immune = 1,
				confusion_immune = 1,
				resists = table.clone(self.resists, true),
				inc_damage = table.clone(self.inc_damage, true),}
			figment:resolve() figment:resolve(nil, true)
			game.level:addEntity(figment)
			game.zone:addEntity(game.level, figment, 'actor', sx, sy)
			game.level.map:particleEmitter(sx, sy, 1, 'summon')
			game:playSoundNear(figment, 'talents/warp')

			summoned = true
			end

		return summoned
		end,
	info = function(self, t)
		return ([[Create up to %d #SLATE#[*]#LAST# figments randomly within range %d #SLATE#[*]#LAST# radius %d for %d turns. They will harrass your oponents, dealing %d #SLATE#[mind]#LAST# #FFFF44#illusion#LAST# damage, and will try to #YELLOW#confuse#LAST# #SLATE#[mind vs. mind, confuse]#LAST# them with %d%% #SLATE#[*]#LAST# power for %d turns. Instead of them taking damage, you will lose %d%% #SLATE#[*]#LAST# as much psi.]])
			:format(get(t.count, self, t),
				get(t.range, self, t),
				get(t.radius, self, t),
				get(t.duration, self, t),
				self:damDesc('MIND', get(t.damage, self, t)),
				get(t.confuse, self, t),
				get(t.confuse_dur, self, t),
				get(t.psi_conversion, self, t))
		end,}
