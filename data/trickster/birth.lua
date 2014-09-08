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


getBirthDescriptor('class', 'Psionic').descriptor_choices.subclass.Trickster = 'allow'

newBirthDescriptor {
	type = 'subclass',
	name = 'Trickster',
	locked = function()
		return profile.mod.allow_build.grayswandir_trickster or config.settings.cheat
		end,
	locked_desc = 'Find the truth hidden behind the illusion, and master it for yourself.',
	desc = {
		'The sly Trickster uses their psionic prowess to manipulate other\'s perception of reality.',
		'Their most important stats are: Dexterity, Willpower, and Cunning',
		'#GOLD#Stat modifiers:',
		'#LIGHT_BLUE# * +0 Strength, +3 Dexterity, +0 Constitution',
		'#LIGHT_BLUE# * +0 Magic, +3 Willpower, +3 Cunning',
		'#GOLD#Life per level:#LIGHT_BLUE# +0',},
	power_source = {technique = true, psionic = true,},
	stats = {dex = 3, cun = 3, wil = 3,},
	talents_types = {
		-- Class
		['technique/dualweapon-attack'] = {true, 0.1},
		['technique/dualweapon-treaning'] = {true, 0.1},
		['cunning/lethality'] = {true, 0.3,},
		--['psionic/slumber'] = {true, 0.1,},
		['psionic/antiperception'] = {true, 0.3,},
		['psionic/trickery'] = {true, 0.3,},
		-- Locked Class
		['cunning/dirty'] = {false, 0.1,},
		['cunning/trapping'] = {false, 0.1},
		-- Generic
		['psionic/mentalism'] = {true, 0.2,},
		['psionic/illusion'] = {true, 0.3,},
		['technique/field-control'] = {true, 0.2},
		['technique/combat-training'] = {true, 0.2},
		['cunning/survival'] = {true, 0.2},
		-- Locked Generic
		['psionic/dreaming'] = {false, 0.2},},
	talents = {
		-- Class
		T_GRAYSWANDIR_ANTIPERCEPTION = 1,
		T_GRAYSWANDIR_CHAOS_FEED = 1,
		T_LETHALITY = 1,
		-- Generic
		T_KNIFE_MASTERY = 1,
		T_WEAPON_COMBAT = 1,},
	copy = {
		max_life = 100,
		resolvers.equipbirth {
			id = true,
			{name = 'iron dagger', autoreq = true, ego_chance = -1000,},
			{name = 'iron dagger', autoreq = true, ego_chance = -1000,},
			{name = 'rough leather armour', autoreq = true, ego_chance = -1000,},},},}
