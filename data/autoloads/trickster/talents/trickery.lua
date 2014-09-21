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
	type = 'psionic/trickery',
	name = 'Trickery',
	description = 'Gain power from fooling your opponents.',
	allow_random = true,}

local make_require = function(tier)
	return {
		stat = {cun = function(level) return 2 + tier * 8 + level * 2 end,},
		level = function(level) return -5 + tier * 4 + level end,}
	end

newTalent {
	name = 'Chaos Feed', short_name = 'GRAYSWANDIR_CHAOS_FEED',
	type = {'psionic/trickery', 1,},
	points = 5,
	require = make_require(1),
	mode = 'passive',
	gain = function(self, t)
		return self:scale {low = 3, high = 15, t, after = 'floor',}
		end,
	callbackOnInflictTemporaryEffect = function(self, t, eff_id, e, p)
		if self.turn_procs.chaos_feed then return end
		if p.dur == 0 then return end
		if e.status ~= 'detrimental' or e.type ~= 'mental' then return end
		local gain = get(t.gain, self, t)
		local psi_gain = gain * util.bound((self.healing_factor or 1), 0, 2.5)
		game.logSeen(self, '%s gains %d #LIGHT_RED#life#LAST# and #7FFFD4#psi#LAST# from Chaos Feed.',
			self.name:capitalize(), psi_gain)
		self:heal(gain)
		self:incPsi(psi_gain)
		self.turn_procs.chaos_feed = true

		if self:knowTalent 'T_GRAYSWANDIR_CHAOS_CASCADE' then
			self:callTalent('T_GRAYSWANDIR_CHAOS_CASCADE', 'onFeed')
			end
		end,
	info = function(self, t)
		return ([[Feed on the chaos you cause. Every turn you inflict a mental debuff, you gain %d #SLATE#[*, healmod]#LAST# #LIGHT_RED#life#LAST# and #7FFFD4#psi#LAST#.]])
			:format(get(t.gain, self, t) * util.bound((self.healing_factor or 1), 0, 2.5))
		end,}

newTalent {
	name = 'Chaos Cascade', short_name = 'GRAYSWANDIR_CHAOS_CASCADE',
	type = {'psionic/trickery', 2,},
	points = 5,
	require = make_require(2),
	mode = 'passive',
	mindpower = function(self, t) return self:scale {low = 5, high = 25, t, 'cun', synergy = 0.9,} end,
	max_stacks = 4,
	duration = function(self, t) return self:scale {low = 2, high = 4, t, after = 'floor',} end,
	onFeed = function(self, t)
		self:setEffect('EFF_GRAYSWANDIR_CHAOS_CASCADE', get(t.duration, self, t), {
				stacks = 1,
				max_stacks = get(t.max_stacks, self, t),
				mindpower = get(t.mindpower, self, t),})
		end,
	info = function(self, t)
		local mult = get(t.psi_stealth_mult, self, t)
		local add = get(t.psi_stealth_add, self, t)
		return ([[Whenever Chaos Feed triggers, you will get a %d #SLATE#[*, cun]#LAST# bonus to mindpower. This will last for %d #SLATE#[*]#LAST# turns and can stack up to %d times.]])
			:format(get(t.mindpower, self, t),
				get(t.duration, self, t),
				get(t.max_stacks, self, t))
		end,}

newTalent {
	name = 'Pandemonium', short_name = 'GRAYSWANDIR_PANDEMONIUM',
	type = {'psionic/trickery', 3,},
	points = 5,
	require = make_require(3),
	cooldown = 28,
	no_energy = true,
	psi = 12,
	tactical = {BUFF = 3,},
	project = function(self, t) return self:scale {low = 3, high = 18, t, 'cun', after = 'damage',} end,
	duration = function(self, t) return self:scale {low = 3, high = 7, t, after = 'floor',} end,
	on_pre_use = function(self, t, silent)
		if self:hasEffect 'EFF_GRAYSWANDIR_CHAOS_CASCADE' then return true end
		if not silent then
			game.logPlayer(self, 'You need an active Chaos Cascade to use this.')
			end
		return false end,
	action = function(self, t)
		local cascade = self:hasEffect 'EFF_GRAYSWANDIR_CHAOS_CASCADE'
		if not cascade then return end
		self:setEffect('EFF_GRAYSWANDIR_PANDEMONIUM', get(t.duration, self, t), {
				project = cascade.stacks * get(t.project, self, t)})
		return true end,
	info = function(self, t)
		local mult = get(t.psi_stealth_mult, self, t)
		local add = get(t.psi_stealth_add, self, t)
		return ([[Focus your chaotic energy into your weapons. For %d #SLATE#[*]#LAST# turns you will deal an extra %d #SLATE#[*, cun]#LAST# #YELLOW#mind#LAST# damage on melee and ranged attacks for every stack of Chaos Cascade you have when using this ability.]])
			:format(get(t.duration, self, t),
				self:damDesc('MIND', get(t.project, self, t)))
		end,}

newTalent {
	name = 'Chaos Channel', short_name = 'GRAYSWANDIR_CHAOS_CHANNEL',
	type = {'psionic/trickery', 4,},
	points = 5,
	require = make_require(4),
	cooldown = 34,
	psi = 22,
	tactical = {ATTACK = 3, DISABLE = 3,},
	range = 1,
	target = function(self, t) return {type = 'hit', range = get(t.range, self, t),} end,
	damage_mult = function(self, t) return self:scale {low = 0.3, high = 0.7, t,} end,
	duration = function(self, t) return self:scale {low = 5, high = 8, t, after = 'floor',} end,
	mindsave = function(self, t) return self:scale {low = 10, high = 70, t, 'cun', synergy = 0.9,} end,
	action = function(self, t)
		local tg = get(t.target, self, t)
		local x, y, actor = self:getTarget(tg)
		if not x or not y or not actor then return end
		if core.fov.distance(self.x, self.y, x, y) > tg.range then return end

		if self:attackTarget(actor, nil, get(t.damage_mult, self, t)) then
			actor:setEffect('EFF_GRAYSWANDIR_CHAOS_CHANNEL', get(t.duration, self, t), {temps = {
						combat_mentalresist = -get(t.mindsave, self, t),},})
			end

		return true end,
	info = function(self, t)
		return ([[Do a melee attack for %d%% #SLATE#[*]#LAST# damage. If it hits, you channel raw psychic energy into them, reducing their mind save by %d #SLATE#[*, cun]#LAST# for %d #SLATE#[*]#LAST# turns.]])
			:format(get(t.damage_mult, self, t) * 100,
				get(t.mindsave, self, t),
				get(t.duration, self, t))
		end,}
