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


defineTile('.', 'GRASS')
defineTile('#', 'TREE')
defineTile('<', 'GRASS_UP4')
defineTile('T', 'GRASS', nil, {random_filter = {properties = {'wall_mimic',},},})
defineTile('E', 'GRASS', nil, nil, nil, nil, {type = 'quest', subtype = 'escort',})
defineTile('P', 'PORTAL', nil, nil, nil, nil, {type = 'quest', subtype = 'portal',})

subGenerator {
	x = 0, y = 0, w = 50, h = 40,
	generator = 'engine.generator.map.Roomer',
	overlay = true,
	data = {
		nb_rooms = 10,
		rooms = {'forest_clearing', {'lesser_vault', 12,},},
		rooms_config = {
			forest_clearing = {
				pit_chance = 13,
				filters = {
					{properties = {'rabbit'},},
					{type = 'spiderkin',},
					{type = 'animal', subtype = 'canine',},},},},
		lesser_vaults_list = {'honey_glade', 'plantlife', 'mold-path',},
		['.'] = 'GRASS',
		['#'] = 'TREE',
		door = 'GRASS',
		force_tunnels = {
			{'random', {3, 39}, id=-500},
			{'random', {39, 39}, id=-501},},},
	define_up = false,}

startx = 0
starty = 43
endx = 39
endy = 45

--checkConnectivity({40,45}, 'entrance', 'boss-area', 'boss-area')

return {
[[                                                  ]],
[[                                                  ]],
[[                                                  ]],
[[                                                  ]],
[[                                                  ]],
[[                                                  ]],
[[                                                  ]],
[[                                                  ]],
[[                                                  ]],
[[                                                  ]],
[[                                                  ]],
[[                                                  ]],
[[                                                  ]],
[[                                                  ]],
[[                                                  ]],
[[                                                  ]],
[[                                                  ]],
[[                                                  ]],
[[                                                  ]],
[[                                                  ]],
[[                                                  ]],
[[                                                  ]],
[[                                                  ]],
[[                                                  ]],
[[                                                  ]],
[[                                                  ]],
[[                                                  ]],
[[                                                  ]],
[[                                                  ]],
[[                                                  ]],
[[                                                  ]],
[[                                                  ]],
[[                                                  ]],
[[                                                  ]],
[[                                                  ]],
[[                                                  ]],
[[                                                  ]],
[[                                                  ]],
[[                                                  ]],
[[                             	                    ]],
[[###T###################################.##########]],
[[#..#############################..T####.##########]],
[[...#############################....####.#########]],
[[<#.############################.......###..###T###]],
[[E###############################...##.........####]],
[[###############################....P#.........####]],
[[################################....#............#]],
[[################################............T#####]],
[[###############################...T###......######]],
[[##################################################]],}
