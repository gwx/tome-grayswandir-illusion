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
	text = ([[#VIOLET#%s shimmers, and then rapidly changes form before your eyes.#LAST#
You fool! Your imbecile! I know your true aim - I will kill you first!]]):format(name),
	answers = {
		{'...',
			action = function(npc, player)
				continue()
				end},},}

return 'start'
