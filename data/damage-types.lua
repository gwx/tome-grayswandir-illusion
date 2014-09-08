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

-- Mind damage, but a save completely negates.
newDamageType {
  type = 'GRAYSWANDIR_ILLUSION',
  name = 'illusion',
  text_color = '#FFFF44#',
  projector = function(src, x, y, type, params)
		local target = game.level.map(x, y, Map.ACTOR)
    if not target then return 0 end

    if 'table' ~= _G.type(params) then params = {dam = params} end
		local dam = params.dam or 10
		local power = params.power or 'combatMindpower'
		power = get(src[power], src)
		local save = params.save or 'combatMentalResist'
		save = get(target[save], target)

		if not target:checkHit(power, save, 0, 95, 15) then
			game.logSeen(target, '%s disbelieves the #FFFF44#illusion#LAST# damage!', target.name:capitalize())
			return 0 end

		return DamageType.defaultProjector(src, x, y, type, dam)
		end,}
