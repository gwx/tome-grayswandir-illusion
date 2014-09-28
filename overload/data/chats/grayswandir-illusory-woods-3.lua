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
	id = 'start',
	text = [[As he finally dies, you feel your senses sharpening.]],
	answers = {
		{'...',
			action = function(npc, player)
				game.party:reward('Select the party member to receive the sharpened senses:', function(player)
						player:attr('see_stealth', 25)
						player:attr('see_invisible', 25)
						game.logPlayer(player, 'Your experiences in this wood have sharpenend your senses. (+25 to see stealth and see invisibility.)')
						end)
				continue()
				end},},}

return 'start'
