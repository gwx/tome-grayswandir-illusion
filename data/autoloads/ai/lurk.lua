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


newAI('lurk-tactical', function(self)
		local targeted = self:runAI(self.ai_state.ai_target or "target_simple")

		-- Can we see the target?
		local see_target = false
		local ax, ay = self:aiSeeTargetPos(self.ai_target.actor)
		if self.ai_target.actor and self:hasLOS(ax, ay) then
			see_target = true
			end

		if see_target then return self:runAI 'tactical' end

		if not self:isTalentActive 'T_GRAYSWANDIR_LURK' then
			return self:useTalent 'T_GRAYSWANDIR_LURK'
			end
		end)
