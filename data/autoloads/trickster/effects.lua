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


newEffect {
	name = 'GRAYSWANDIR_ILLUSION_BLINDED', image = 'talents/grayswandir_darkness.png',
	desc = 'Blinded by Illusion',
	long_desc = function(self, eff) return 'The target is blinded, unable to see anything.' end,
	type = 'mental',
	subtype = {blind = true, illusion = true,},
	status = 'detrimental',
	parameters = {},
	on_gain = function(self, err) return '#Target# loses sight!', '+Blind' end,
	on_lose = function(self, err) return '#Target# recovers sight.', '-Blind' end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue('blind', 1)
		if game.level then
			self:resetCanSeeCache()
			if self.player then for uid, e in pairs(game.level.entities) do if e.x then game.level.map:updateMap(e.x, e.y) end end game.level.map.changed = true end
				end
		end,
	deactivate = function(self, eff)
		self:removeTemporaryValue('blind', eff.tmpid)
		if game.level then
			self:resetCanSeeCache()
			if self.player then for uid, e in pairs(game.level.entities) do if e.x then game.level.map:updateMap(e.x, e.y) end end game.level.map.changed = true end
				end
		end,}

newEffect {
	name = 'GRAYSWANDIR_ILLUSION_DAZED', image = 'talents/grayswandir_sensory_overload.png',
	desc = 'Dazed by Illusion',
	long_desc = function(self, eff) return 'The target is dazed, rendering it unable to move, halving all damage done, defense, saves, accuracy, spell, mind and physical power. Any damage will remove the daze.' end,
	type = 'mental',
	subtype = {stun = true, illusion = true,},
	status = 'detrimental',
	parameters = {},
	on_gain = function(self, eff) return '#Target# is dazed!', '+Dazed' end,
	on_lose = function(self, eff) return '#Target# is not dazed anymore.', '-Dazed' end,
	callbackOnHit = function(self, eff) self:removeEffect 'EFF_GRAYSWANDIR_ILLUSION_DAZED' end,
	activate = function(self, eff)
		self:autoTemporaryValues(eff, {
				dazed = 1,
				never_move = 1,})
		end,
	deactivate = function(self, eff) end,}

newEffect {
	name = 'GRAYSWANDIR_DELUSION_SHACKLES', image = 'talents/grayswandir_delusion_shackles.png',
	desc = 'Delusion: Shackles',
	long_desc = function(self, eff)
		return ('The target is bound with illusory shackles visible only to themselves, reducing movement, combat, and spell speeds by %d%%.')
			:format(eff.speed_loss * 100)
		end,
	type = 'mental',
	subtype = {slow = true, illusion = true,},
	status = 'detrimental',
	parameters = {speed_loss = 0.1,},
	on_gain = function(self, eff) return '#Target# is delusional!', '+Shackles' end,
	on_lose = function(self, eff) return '#Target# is not delusional anymore.', '-Shackles' end,
	activate = function(self, eff)
		self:autoTemporaryValues(eff, {
				combat_physspeed = -eff.speed_loss,
				combat_spellspeed = -eff.speed_loss,
				movement_speed = -eff.speed_loss,})
		end,
	deactivate = function(self, eff) end,}

newEffect {
	name = 'GRAYSWANDIR_DELUSION_HOUNDED', image = 'talents/grayswandir_delusion_hounded.png',
	desc = 'Delusion: Hounded',
	long_desc = function(self, eff)
		return ('The target is harrassed by invisible assailants, reducing Dexterity and Cunning by %d, and are %d%% more likely to be hit by physical criticals.')
			:format(eff.stat_loss, eff.crit_chance)
		end,
	type = 'mental',
	subtype = {illusion = true,},
	status = 'detrimental',
	parameters = {stat_loss = 10, crit_chance = 10,},
	on_gain = function(self, eff) return '#Target# is delusional!', '+Hounded' end,
	on_lose = function(self, eff) return '#Target# is not delusional anymore.', '-Hounded' end,
	activate = function(self, eff)
		local Stats = require 'engine.interface.ActorStats'
		self:autoTemporaryValues(eff, {
				inc_stats = {
					[Stats.STAT_DEX] = -eff.stat_loss,
					[Stats.STAT_CUN] = -eff.stat_loss,},
				combat_crit_vulnerable = eff.crit_chance,})
		end,
	deactivate = function(self, eff) end,}

newEffect {
	name = 'GRAYSWANDIR_CHAOS_CASCADE', image = 'talents/grayswandir_chaos_cascade.png',
	desc = 'Chaos Cascade',
	long_desc = function(self, eff)
		return ('The target is strengthened by the chaos it\'s caused, gaining %d mindpower.')
			:format(eff.mindpower * eff.stacks)
		end,
	type = 'mental',
	charges = function(self, eff) return eff.stacks end,
	subtype = {psi = true,},
	status = 'beneficial',
	parameters = {stacks = 1, max_stacks = 4, mindpower = 10,},
	activate = function(self, eff)
		self:autoTemporaryValues(eff, {
				combat_mindpower = eff.mindpower * eff.stacks,})
		end,
	deactivate = function(self, eff) return true end,
	on_merge = function(self, old, new)
		self:autoTemporaryValuesRemove(old)
		old.mindpower = math.max(old.mindpower, new.mindpower)
		old.max_stacks = math.max(old.max_stacks, new.max_stacks)
		old.stacks = math.min(old.max_stacks, old.stacks + new.stacks)
		old.dur = math.max(old.dur, new.dur)
		self:autoTemporaryValues(old, {
				combat_mindpower = old.mindpower * old.stacks,})
		return old
		end,}

newEffect {
	name = 'GRAYSWANDIR_PANDEMONIUM', image = 'talents/grayswandir_pandemonium.png',
	desc = 'Pandemonium',
	long_desc = function(self, eff)
		return ('The target is strengthened by the chaos it\'s caused, gaining %d mind damage on its melee and rangedattacks.')
			:format(self:damDesc('MIND', eff.project))
		end,
	type = 'mental',
	subtype = {psi = true,},
	status = 'beneficial',
	parameters = {project = 10,},
	activate = function(self, eff)
		self:autoTemporaryValues(eff, {
				melee_project = {MIND = eff.project,},
				ranged_project = {MIND = eff.project,},})
		end,
	deactivate = function(self, eff) return true end,}

newEffect {
	name = 'GRAYSWANDIR_CHAOS_CHANNEL', image = 'talents/grayswandir_chaos_channel.png',
	desc = 'Chaos Channel',
	long_desc = function(self, eff)
		return ('The target\'s mind has been shocked by raw psychic energy, reducing its mind save by %d.')
			:format(-eff.temps.combat_mentalresist)
		end,
	type = 'mental',
	subtype = {psi = true,},
	status = 'detrimental',
	parameters = {},
	activate = function(self, eff) self:autoTemporaryValues(eff) end,
	deactivate = function(self, eff) return true end,}
