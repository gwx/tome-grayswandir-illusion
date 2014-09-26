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


return {
	name = 'Illusory Woods',
	level_range = {18, 26},
	level_scheme = 'player',
	max_level = 4,
	decay = {300, 800},
	actor_adjust_level = function(zone, level, e)
		return zone.base_level + e:getRankLevelAdjust() + level.level + rng.range(-2, 1)
		end,
	width = 50, height = 50,
	all_lited = true,
	day_night = true,
	no_autoexplore = true,
	persistent = 'zone',
	color_shown = {0.7, 0.9, 0.9, 1.0,},
	color_obscure = {0.6*0.7, 0.6*0.9, 0.6*0.9, 0.6*1.0,},
	ambient_music = {'Woods of Eremae.ogg',},
	min_material_level = function() return game.state:isAdvanced() and 4 or 2 end,
	max_material_level = function() return game.state:isAdvanced() and 5 or 3 end,
	nicer_tiler_overlay = 'DungeonWallsGrass',
	generator =  {
		map = {
			class = 'engine.generator.map.Roomer',
			nb_rooms = 11,
			edge_entrances = {4, 6,},
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
			up = 'GRASS_UP4',
			down = 'GRASS_DOWN6',
			door = 'GRASS',},
		actor = {
			class = 'mod.class.generator.actor.Random',
			nb_npc = {40, 55,},
			--[[guardian = 'HUGE_DULL_CRYSTAL',]]},
		object = {
			class = 'engine.generator.object.Random',
			nb_object = {6, 9},},
		trap = {
			class = 'engine.generator.trap.Random',
			nb_trap = {0, 0},},},
	levels = {
		[1] = {
			generator = {
				map = {
					up = 'GRASS_UP_WILDERNESS',},},},
		[4] = {
			generator = {
				map = {
					class = 'engine.generator.map.Static',
					map = 'grayswandir-illusion+illusory-woods-last',},},},
		},
	post_process = function(level)
		game:placeRandomLoreObject('NOTE'..level.level)

		game.state:makeWeather(
			level, 6, {
				max_nb = 3, chance = 1, dir = 110,
				speed = {0.1, 0.6,}, alpha = {0.3, 0.5,},
				particle_name = 'weather/dark_cloud_%02d',})

		game.state:makeAmbientSounds(
			level, {
				wind = {chance = 120, volume_mod = 1.9, pitch = 2, random_pos = {rad = 10,},
					files = {
						'ambient/forest/wind1', 'ambient/forest/wind2',
						'ambient/forest/wind3', 'ambient/forest/wind4',},},
				bird = {chance = 60, volume_mod = 0.75,
					files = {
						'ambient/forest/bird1', 'ambient/forest/bird2',
						'ambient/forest/bird3', 'ambient/forest/bird4',
						'ambient/forest/bird5', 'ambient/forest/bird6',
						'ambient/forest/bird7'},},
				creature = {chance = 2500, volume_mod = 0.6, pitch = 0.5, random_pos = {rad = 10,},
					files = {
						'creatures/bears/bear_growl_2', 'creatures/bears/bear_growl_3',
						'creatures/bears/bear_moan_2',},},})
		end,
	foreground = function(level, x, y, nb_keyframes)
		if not config.settings.tome.weather_effects or not level.foreground_particle then return end
		level.foreground_particle.ps:toScreen(x, y, true, 1)
		end,
	onPlayerEnter = function()
		if game.level.level ~= 4 then return end
		game.player:grantQuest('grayswandir-illusion+illusory-woods')
		end,}
