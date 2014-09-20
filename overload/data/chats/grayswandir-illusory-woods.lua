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


newChat {
	id = 'welcome',
	text = 'Please help me! I am afraid I lost myself in this place. I know there is a recall portal left around here by a friend, but I will not be able to continue the road alone. Would you help me?',
	answers = {
		{'Lead on; I will protect you.',
			action = function(npc, player)
				npc.ai_state.tactic_leash = 100
				game.party:addMember(npc, {
						control = 'order',
						type = 'escort',
						title = 'Escort',
						orders  = {escort_portal=true, escort_rest=true},})
				end,},
		{'Go away; I do not care for the weak.',
			action = function(npc, player)
				npc:disappear()
				npc:removed()
				player:hasQuest('illusory-woods').abandoned = true
				player:setQuestStatus('illusory-woods', engine.Quest.FAILED)
				end,
			},},}

return 'welcome'
