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


-- X grayswandir_displacement makes targets see you in a different
-- spot, up to X% of their distance from your true position away.

lib.require 'pick-circle-point'

superload('mod.class.NPC', function(_M)
		local aiSeeTargetPos = _M.aiSeeTargetPos
		function _M:aiSeeTargetPos(target)
			local x, y = aiSeeTargetPos(self, target)
			if not target then return x, y end
			local displacement = target:attr 'grayswandir_displacement'
			if displacement then
				displacement = displacement * core.fov.distance(self.x, self.y, target.x, target.y) * 0.01
				x, y = util.pick_circle_point(x, y, displacement)
				end
			return x, y
			end
		end)

hook('Object:descWielder', function(self, data)
		local displacement = data.w.grayswandir_displacement
		if displacement then
			data.desc:add('Displacement: ', {'color', 'LIGHT_GREEN',},
				('+%d%%'):format(displacement), {'color', 'LAST',})
			end
		end)
