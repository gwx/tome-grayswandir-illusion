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

newEffect {
	name = 'GRAYSWANDIR_MENTAL_PRESSURE',
	desc = 'Mental Pressure',
	long_desc = function(self, eff)
		return ([[Target is having their thoughts suppressed, decreasing their mental save by %d and giving a %d%% confusion chance, and taking %d mind damage every turn.]])
			:format(eff.save, eff.confuse, eff.damage)
		end,
	type = 'mental',
	subtype = {confuse = true,},
	status = 'detrimental',
	parameters = {save = 5, confuse = 3, count = 1,},
	decrease = 0,
	activate = function(self, eff)
		local src = eff.src
		eff.src = nil

		eff[src] = {
			range = eff.range,
			confuse = eff.confuse * (1 - util.bound(self:attr 'confusion_immune' or 0, 0, 1)),
			damage = eff.damage,
			save = eff.save,}
		eff.range = nil
		eff.confuse = eff[src].confuse

		eff[src].confuse_id = self:addTemporaryValue('confused', eff[src].confuse)
		eff[src].save_id = self:addTemporaryValue('combat_mentalresist', -eff[src].save)

		eff.count = 1
		end,
	deactivate = function(self, eff)
		for src, sub_eff in pairs(eff) do
			if type(src) == 'table' then
				self:removeTemporaryValue('confused', sub_eff.confuse_id)
				self:removeTemporaryValue('combat_mentalresist', sub_eff.save_id)
				end
			end
		return true
		end,
	callbackOnDeath = function(self, eff)
		self:removeEffect('EFF_GRAYSWANDIR_MENTAL_PRESSURE', true, true)
		end,
	on_merge = function(self, old, new)
		new.confuse = new.confuse * (1 - util.bound(self:attr 'confusion_immune' or 0, 0, 1))
		new.confuse_id = self:addTemporaryValue('confused', new.confuse)
		new.save_id = self:addTemporaryValue('combat_mentalresist', -new.save)
		old[new.src] = new
		old.confuse = old.confuse + new.confuse
		old.save = old.save + new.save
		old.damage = old.damage + new.damage
		old.count = old.count + 1
		return old
		end,
	on_timeout = function(self, eff)
		for source, sub_eff in pairs(table.clone(eff) or {}) do
			if type(source) == 'table' then
				if source.dead or
					not source:isTalentActive 'T_GRAYSWANDIR_MENTAL_PRESSURE' or
					not source:hasLOS(self.x, self.y) or
					core.fov.distance(self.x, self.y, source.x, source.y) > sub_eff.range
				then
					if source:isTalentActive 'T_GRAYSWANDIR_MENTAL_PRESSURE' then
						source:forceUseTalent('T_GRAYSWANDIR_MENTAL_PRESSURE', {ignore_energy = true,})
						end
					self:removeTemporaryValue('confused', sub_eff.confuse_id)
					self:removeTemporaryValue('combat_mentalresist', sub_eff.save_id)
					eff.confuse = eff.confuse - sub_eff.confuse
					eff.save = eff.save - sub_eff.save
					eff.damage = eff.damage - sub_eff.damage
					eff.count = eff.count - 1
					eff[source] = nil
				else
					print 'XXX'
					table.print(source)
					DamageType:get('MIND').projector(source, self.x, self.y, 'MIND', sub_eff.damage)
					end end end
		if eff.count == 0 then
			self:removeEffect('EFF_GRAYSWANDIR_MENTAL_PRESSURE', nil, true)
			end
		end,}
