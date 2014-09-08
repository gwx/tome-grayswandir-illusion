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


newEntity {
	define_as = 'GRAYSWANDIR_ILLUSORY_WOODS',
	base = 'ZONE_PLAINS',
	name = 'Path into an Ominous Wood',
	color = colors.GREEN,
	add_displays = {
		class.new {image = 'terrain/road_upwards_01.png', z = 8, display_h = 2, display_y = -1,},},
	change_zone = 'grayswandir-illusion+illusory-woods',}
