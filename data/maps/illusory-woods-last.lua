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
defineTile('P', 'PORTAL')
--defineTile('Y', 'FLOOR', nil, 'YEEK_WAYIST')

subGenerator{
	x = 0, y = 0, w = 50, h = 50,
	generator = 'engine.generator.map.Roomer',
	data = {
		nb_rooms = 10,
		--[[
		rooms = {'forest_clearing', {'lesser_vault', 12,},},
		rooms_config = {
			forest_clearing = {
				pit_chance = 13,
				filters = {
					{properties = {'rabbit'},},
					{type = 'spiderkin',},
					{type = 'animal', subtype = 'canine',},},},},
		lesser_vaults_list = {'honey_glade', 'plantlife', 'mold-path',},
		--]]
		['.'] = 'GRASS',
		['#'] = 'TREE',
		up = 'GRASS_UP4',
		door = 'GRASS',},
	define_up = true,}

endx = 41
endy = 46

checkConnectivity({26,44}, 'entrance', 'boss-area', 'boss-area')

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
[[                                                  ]],
[[                                                  ]],
[[                                                  ]],
[[                                                  ]],
[[                                                  ]],
[[                                                  ]],
[[                                                  ]],
[[                             	                    ]],
[[                                      #.#         ]],
[[                                    ###.###	      ]],
[[                                  ####...####     ]],
[[                                ###........#######]],
[[                              ###...............##]],
[[                              #..................#]],
[[                              ###......#P#.......#]],
[[                               ##.......#........#]],
[[                               ##...............##]],
[[                               ###################]],}
