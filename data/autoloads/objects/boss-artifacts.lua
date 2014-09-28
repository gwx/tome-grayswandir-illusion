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
	define_as = 'GRAYSWANDIR_DRAGONFLY_WING', unique = true,
	base = 'BASE_CLOAK',
	power_source = {nature = true, psionic = true,},
	unided_name = 'translucent fabric',
	name = 'Dragonfly Wings', image = 'object/artifact/grayswandir_dragonfly_wings.png',
	desc = [[This translucent shines and glitters as it moves. It seems to lighten your steps when you put it on.]],
	cost = 400, material_level = 3,
	rarity = 300, level_range = {18, 26,},
	wielder = {
		combat_def = 6, combat_ranged_def = 6,
		grayswandir_displacement = 25,
		combat_mindpower = 8,
		resists = {LIGHT = 15, MIND = 15,},
		on_melee_hit = {GRAYSWANDIR_ILLUSION = 35,},
		avoid_pressure_traps = 1,
		movement_speed = 0.15,},}
