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


newEffect{
	name = 'GRAYSWANDIR_MENTAL_BLINDED', image = 'talents/grayswandir_darkness.png',
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

newEffect{
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
