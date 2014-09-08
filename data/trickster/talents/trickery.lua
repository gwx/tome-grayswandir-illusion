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
	psi_gen = function(self, t)
		return self:scale {low = 3, high = 16, t, after = 'floor',}
		end,
	callbackOnInflictTemporaryEffect = function(self, t, eff_id, e, p)
		if self.turn_procs.chaos_feed then return end
		if p.dur == 0 then return end
		if e.status ~= 'detrimental' or e.type ~= 'mental' then return end
		local gain = get(t.psi_gen, self, t)
		game.logSeen(self, '%s gains %d psi from Chaos Feed.', self.name:capitalize(), gain)
		self:incPsi(gain)
		self.turn_procs.chaos_feed = true

		if self:knowTalent 'T_GRAYSWANDIR_CHAOS_CASCADE' then
			self:callTalent('T_GRAYSWANDIR_CHAOS_CASCADE', 'onFeed')
			end
		end,
	info = function(self, t)
		local mult = get(t.psi_stealth_mult, self, t)
		local add = get(t.psi_stealth_add, self, t)
		return ([[Feed on the chaos you cause. Every turn you inflict a mental debuff, you gain %d #SLATE#[*]#LAST# #7FFFD4#psi#LAST#.]])
			:format(get(t.psi_gen, self, t))
		end,}

newTalent {
	name = 'Chaos Cascade', short_name = 'GRAYSWANDIR_CHAOS_CASCADE',
	type = {'psionic/trickery', 2,},
	points = 5,
	require = make_require(2),
	mode = 'passive',
	mindpower = function(self, t) return self:scale {low = 5, high = 30, t, 'cun',} end,
	max_stacks = 4,
	duration = function(self, t) return self:scale {low = 2, high = 3, t, after = 'floor',} end,
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
