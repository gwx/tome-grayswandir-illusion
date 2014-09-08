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


local addon = __loading_addon
local class = require 'engine.class'

class:bindHook('ToME:load', function(self, data)
		local load_data = function(loader, name)
			require(loader):loadDefinition('/data-grayswandir-illusion/'..name)
			end

		load_data('engine.interface.ActorAI', 'ai')
		load_data('engine.interface.ActorTalents', 'talents.lua')
		load_data('engine.interface.ActorTemporaryEffects', 'effects.lua')
		load_data('engine.DamageType', 'damage-types.lua')

		util.load_dir('/data-'..addon..'/trickster/')
		end)
