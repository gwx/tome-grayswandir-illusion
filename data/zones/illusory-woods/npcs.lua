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


load('/data/general/npcs/bear.lua', rarity(2, 7))
load('/data/general/npcs/vermin.lua', rarity(4, 7))
load('/data/general/npcs/canine.lua', rarity(2, 7))
load('/data/general/npcs/snake.lua', rarity(2, 7))
load('/data/general/npcs/spider.lua', rarity(0, 3))
load('/data/general/npcs/swarm.lua', rarity(2, 7))
load('/data/general/npcs/plant.lua', rarity(1, 7))
load('/data/general/npcs/ant.lua', rarity(5, 7))
load('/data/general/npcs/all.lua', rarity(4, 250))

local rm = resolvers.mbonus
local ravg = resolvers.rngavg
local rt = resolvers.talents
local rlev = resolvers.levelup
local rtalents = resolvers.talents

local Quest = require 'engine.Quest'

newEntity{
	base = 'BASE_NPC_OOZE',
	name = 'invisible ooze', color = colors.WHITE,
	image = 'npc/vermin_oozes_brittle_clear_ooze.png',
	blood_color = colors.WHITE,
	desc = 'You can barely tell it\'s there.',
	level_range = {1, nil,}, exp_worth = 1,
	rarity = 3,
	rank = 2,
	max_life = ravg(50, 60), life_rating = 7,
	stats = {wil = 15, cun = 15,},
	stealth = rm(40, 10),
	combat = {
		dam = rm(30, 10),
		atk = 15,
		apr = 5,},
	clone_on_hit = {min_dam_pct = 3, chance = 45,},}

newEntity{
	base = 'BASE_NPC_MOLD',
	name = 'psionic mold', color = colors.ORANGE,
	desc = 'A strange sickly orange growth on the forest floor. You can feel it pressing on your mind.',
	level_range = {1, nil,}, exp_worth = 1,
	rarity = 3,
	max_life = ravg(10, 18),
	combat = {dam = 5, atk = 10, apr = 10,},
	lite = 1,
	ai_state = {talent_in = 1,},
	autolevel = 'wildcaster',
	make_escort = {
		{name = 'psionic mold', number = 1, no_subescort = true,},},
	rtalents {
		T_SLIME_ROOTS = {base = 1, every = 3, max = 5,},
		T_GRAYSWANDIR_MENTAL_PRESSURE = {base = 1, every = 5, max = 7,},},}

newEntity{
	base = 'BASE_NPC_PLANT',
	name = 'hidden treant', color = colors.GREEN,
	image = 'npc/immovable_plants_treant.png',
	desc = 'A very strong near-sentient tree. Your gaze seems to want to slide off of it.',
	sound_moam = 'creatures/treants/treeant_2',
	sound_die = {'creatures/treants/treeant_death_%d', 1, 2,},
	sound_random = {'creatures/treants/treeant_%d', 1, 3,},
	ai = 'lurk-tactical',
	ai_state = {talent_in = 2,},
	resolvers.nice_tile {
		image = 'invis.png',
		add_mos = {{image = 'npc/immovable_plants_treant.png', display_h = 2, display_y = -1,},},},
	level_range = {1, nil,}, exp_worth = 1,
	rarity = 1, wall_mimic = true,
	max_life = ravg(100, 130),
	life_rating = 15,
	combat = {
		dam = rlev(ravg(8, 13), 1, 1.2),
		atk = 15, apr = 5,
		sound = 'actions/melee_thud',},
	never_move = 0,
	psi_stealth_mult = 0.5,
	psi_stealth_add = rm(30, 10),
	psi_stealth_mimic = 1,
	stats = {wil = 24,},
	autolevel = 'warriorwill',
	resolvers.generic(
		function(self)
			local mimic = game.zone:makeEntityByName(game.level, 'grid', 'TREE'..rng.range(1, 30))
			mimic.add_displays[1].z = 12
			mimic.block_sense = true
			self:setMimic(mimic)
			end),
	rtalents {
		T_GRAB = {base = 1, every = 6, max = 6,},
		T_GRAYSWANDIR_LURK = {base = 1, every = 5, max = 8,},
		T_GRAYSWANDIR_LURKING_STRIKE = {base = 1, every = 7, max = 9,},},
	make_escort = {
		{name = 'hidden treant', number = 2, no_subescort = true,},},
	rank = 2,
	size_category = 5,}

newEntity {
	define_as = 'GRAYSWANDIR_SHADOW_WOLF', base = 'BASE_NPC_CANINE',
	name = 'shadow wolf', color = colors.DARK_GREY,
	resolvers.nice_tile {
		image = 'invis.png', add_mos = {
			{image = 'npc/animal_canine_shadow_wolf.png', display_h = 2, display_y = -1,},},},
	desc = [[Unless you focus on it this wolf looks just like shifting shadows.]],
	level_range = {1, nil,}, exp_worth = 1,
	rarity = 7,
	autolevel = 'warriorwill',
	max_life = ravg(60,70), life_rating = 12,
	combat_armor = 1, combat_def = 3,
	psi_stealth_mult = 0.7,
	psi_stealth_add = rm(30, 10),
	stats = {wil = 16,},
	combat = {
		dam = rlev(5, 1, 0.7),
		atk = 0,
		apr = 3,},
	resolvers.talents {
		T_BLINDSIDE = {base = 1, every = 7, max = 8,},
		T_DOMINATE = {base = 1, every = 12,},
		T_MIND_SEAR = {base = 1, every = 7, max = 6,},},}

newEntity {
	base = 'BASE_NPC_RODENT',
	name = 'cute little rabbit', color = colors.WHITE,
	image = 'npc/vermin_rodent_cute_little_bunny.png',
	desc = [[A cute little bunny. You feel great just looking at it.]],
	rabbit = true,
	level_range = {10, nil,}, exp_worth = 1,
	global_speed_base = 1.2,
	rarity = 8,
	autolevel = 'wyrmic',
	stats = {wil = 30, dex = 30,},
	max_life = resolvers.rngavg(50,70),
	combat_critical_power = rm(100, 50),
	combat_mindpower = rm(50, 30),
	combat = {
		dam = rm(30, 15), atk = rm(10, 20), apr = rm(30, 20), damtype = 'GRAYSWANDIR_SNUGGLES',},
	resolvers.talents {
		T_EVASION = {base = 2, every = 3, max = 5,},
		T_GRAYSWANDIR_HOP = {base = 2, every = 5, max = 7,},},}

newEntity {
	define_as = 'GRAYSWANDIR_HIDDEN_ONE',
	unique = true,
	name = 'The Hidden One',
	faction = 'enemies',
	type = 'humanoid', subtype = 'human',
	color = colors.YELLOW, display = 'p', image = 'npc/humanoid_human_shady_cornac_man.png',
	desc = [[This human seems to shimmer in and out of focus. The only consistent feature you can make out is his malevolent grin..]],
	level_range = {20, nil}, exp_worth = 2,
	max_life = 400, life_rating = 15, fixed_rating = true,
	max_psi = 200,
	rank = 4,
	size_category = 3,
	move_others = true,

	stats = {str = 12, dex = 25, con = 10, cun = 30, wil = 20, mag = 7,},
	body = {INVEN = 10, MAINHAND = 1, OFFHAND = 1, BODY = 1,},

	instakill_immune = 1,
	stun_immune = 0.3,
	blind_immune = 0.4,
	combat_mentalresist = 50,
	combat_mindpower = 30,

	resolvers.equip {
		{type='weapon', subtype='knife', force_drop = true, tome_drops = 'boss', autoreq = true,},
		{type='weapon', subtype='knife', force_drop = true, tome_drops = 'boss', autoreq = true,},},
	resolvers.drops {chance = 100, nb = 4, {tome_drops = 'boss',},},

	resolvers.talents {
		T_KNIFE_MASTERY = {base = 4, every = 8, max = 6,},
		T_WEAPON_COMBAT = {base = 2, every = 4, max = 5,},
		T_FLURRY = {base = 1, every = 8, max = 3,},
		T_GRAYSWANDIR_ANTIPERCEPTION = {base = 4, every = 8, max = 6,},
		T_GRAYSWANDIR_SENSORY_OVERLOAD = {base = 2, every = 6, max = 4,},
		T_GRAYSWANDIR_DARKNESS = {base = 3, every = 6, max = 4,},
		T_GRAYSWANDIR_DELUSION_SHACKLES = {base = 2, every = 5, max = 4,},
		T_GRAYSWANDIR_DELUSION_HOUNDED = {base = 2, every = 5, max = 4,},
		T_GRAYSWANDIR_CHAOS_FEED = {base = 4, every = 5, max = 7,},
		T_GRAYSWANDIR_CHAOS_CASCADE = {base = 2, every = 5, max = 5,},
		T_GRAYSWANDIR_PANDEMONIUM = {base = 2, every = 8, max = 5,},},

	autolevel = 'trickster',
	ai = 'tactical', ai_state = {talent_in = 1, ai_move = 'move_astar',},
	ai_tactic = resolvers.tactic 'melee',
	resolvers.inscriptions(2, {}),

	on_die = function(self, who)
		local Quest = require 'engine.Quest'
		game.player:setQuestStatus('illusory-woods', Quest.DONE)
		end,}
