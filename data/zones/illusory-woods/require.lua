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


-- Add Illusory Woods grid type to wilderness.
class:bindHook('Entity:loadList', function(self, data)
		if data.file == '/data/zones/wilderness/grids.lua' then
			self:loadList('/data-grayswandir-illusion/zones/illusory-woods/wilderness-grids.lua',
				data.no_default, data.res, data.mod, data.loaded)
			end
		end)

-- Place Illusory Woods on main map.
class:bindHook('MapGeneratorStatic:subgenRegister', function(self, data)
		if data.mapfile ~= 'wilderness/eyal' then return end

		table.insert(data.list, {
				x = 49, y = 31, w = 1, h = 1, overlay = true,
				generator = 'engine.generator.map.Static',
				data = {map = 'grayswandir_illusory_woods',},})
		end)
