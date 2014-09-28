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


local Chat = require 'engine.Chat'
local Map = require 'engine.Map'
local NameGenerator = require 'engine.NameGenerator'
local NPC = require 'mod.class.NPC'

local name_rules = {
	phonemesVocals = 'a, e, i, o, u, y',
	syllablesStart = 'Ad, Aer, Ar, Bel, Bet, Beth, Ce\'N, Cyr, Eilin, El, Em, Emel, G, Gl, Glor, Is, Isl, Iv, Lay, Lis, May, Ner, Pol, Por, Sal, Sil, Vel, Vor, X, Xan, Xer, Yv, Zub',
	syllablesMiddle = 'bre, da, dhe, ga, lda, le, lra, mi, ra, ri, ria, re, se, ya',
	syllablesEnd = 'ba, beth, da, kira, laith, lle, ma, mina, mira, na, nn, nne, nor, ra, rin, ssra, ta, th, tha, thra, tira, tta, vea, vena, we, wen, wyn',
	rules = '$s$v$35m$10m$e',}

id = 'illusory-woods'

kind = {}

name = ''
desc = function(self, who)
	local Quest = require 'engine.Quest'
	local desc = {}

	if not self:isStatus(Quest.DONE, 'escort') then
		table.insert(desc, ('Escort %s to the recall portal.'):format(self.escort_name_full))
	else
		table.insert(desc, ('You successfully escorted %s to the recall portal.'):format(self.escort_name_full))

		table.insert(desc, '')
		if not self:isStatus(Quest.DONE) then
			table.insert(desc, 'Treachery! The Hidden One has lured you into a trap. Defend yourself!')
		else
			table.insert(desc, 'You defeated The Hidden One!')
			end
		end

	return table.concat(desc, '\n')
	end

on_grant = function(self, who)
	local escort_spot = game.level:pickSpot {type = 'quest', subtype = 'escort',}
	local portal_spot = game.level:pickSpot {type = 'quest', subtype = 'portal',}

	-- Get rid of anything on escort spot.
	local blocking_actor = game.level.map(escort_spot.x, escort_spot.y, Map.ACTOR)
	if blocking_actor then
		local newx, newy = util.findFreeGrid(escort_spot.x, escort_spot.y, 20, true, {[Map.ACTOR] = true,})
		if newx and newy then
			blocking_actor:move(newx, newy, true)
		else
			blocking_actor:teleportRandom(newx, newy, 200)
			end
		end

	self.escort_name = NameGenerator.new(name_rules):generate():capitalize()
	self.escort_name_full = ('%s, lost trickster'):format(self.escort_name)

	local escort = NPC.new {
		name = self.escort_name_full,
		type = 'humanoid', subtype = 'halfling', image = 'player/halfling_female.png',
		display = '@', color = colors.YELLOW,
		desc = [[She looks tired and wounded.]],
		autolevel = 'trickster',
		ai = 'escort_quest', ai_state = {talent_in = 1,},
		stats = {str = 7, dex = 13, con = 11, wil = 16, cun = 18,},
		body = {INVEN = 10, MAINHAND = 1, OFFHAND = 1, BODY = 1,},
		resolvers.equip {
			{type = 'weapon', subtype = 'dagger', autoreq = true,},
			{type = 'weapon', subtype = 'dagger', autoreq = true,},},
		resolvers.talents {
			T_GRAYSWANDIR_ANTIPERCEPTION = 3,
			T_GRAYSWANDIR_SENSORY_OVERLOAD = 2,
			T_GRAYSWANDIR_CHAOS_FEED = 1,},
		resolvers.inscription('INFUSION:_REGENERATION', {
				cooldown = 20, dur = 10, heal = 100,}),
		lite = 4,
		rank = 3,
		exp_worth = 1,
		antimagic_ok = true,
		max_life = 100, life_regen = 0.1,
		life_rating = 12,
		combat_armor = 10, combat_def = 15,
		level_range = {game.player.level, game.player.level,},
		faction = who.faction,
		summoner = who,
		is_escort = true,
		no_inventory_access = true,
		remove_from_party_on_death = true,
		on_die = function(self, who)
			end,
		escort_target = portal_spot,}
	escort:resolve() escort:resolve(nil, true)
	game.zone:addEntity(game.level, escort, 'actor', escort_spot.x, escort_spot.y)

	self.level_name = game.level.level..' of '..game.zone.name
	self.name = 'Escort: Trickster (level '..self.level_name..')'

	local portal = game.level.map(portal_spot.x, portal_spot.y, Map.TERRAIN)
	portal.on_move = function(self, x, y, who)
		local Quest = require 'engine.Quest'
		if not who.is_escort then return end
		if not game.player:hasLOS(who.x, who.y) then return end
		game.player:setQuestStatus('illusory-woods', Quest.DONE, 'escort')
		self.on_move = nil
		end

	self.escort = escort
	self.portal = portal

	Chat.new('grayswandir-illusory-woods', escort, game.player):invoke()
	end

on_status_change = function(self, who, status, sub)
	local Quest = require 'engine.Quest'
	if (sub == 'escort' and status == Quest.DONE) then
		local continue = function()
			local x, y = self.escort.x, self.escort.y
			self.escort:disappear()
			self.escort:removed()
			game.party:removeMember(self.escort, true)

			self.boss = game.zone:makeEntityByName(game.level, 'actor', 'GRAYSWANDIR_HIDDEN_ONE')
			game.zone:addEntity(game.level, self.boss, 'actor', x, y)

			for i = 1, 4 do
				local npc = game.zone:makeEntityByName(game.level, 'actor', 'GRAYSWANDIR_SHADOW_WOLF')
				local x, y = util.findFreeGrid(self.boss.x, self.boss.y, 5, true, {[Map.ACTOR] = true,})
				if x and y then
					game.zone:addEntity(game.level, npc, 'actor', x, y)
					game.level.map:particleEmitter(x, y, 1, 'summon')
					end
				end
			end

		Chat.new('grayswandir-illusory-woods-2', self.escort, game.player, {
				name = self.escort_name,
				continue = continue,})
			:invoke()

	elseif not sub and status == Quest.DONE then
		local continue = function()
			world:gainAchievement('GRAYSWANDIR_TRICKSTER', game.player)
			end

		Chat.new('grayswandir-illusory-woods-3', self.escort, game.player, {
				name = self.escort_name,
				continue = continue,})
			:invoke()
		end

	end
