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

-- Add autolevel loadDefinition.
util.add_superload('engine.Autolevel', function(_M)
		function _M:loadDefinition(file, env)
			local f, err = util.loadfilemods(file, setmetatable(env or {
						registerScheme = function(t) self:registerScheme(t) end,
						load = function(f) self:loadDefinition(f, getfenv(2)) end
						}, {__index=_G}))
			if not f and err then error(err) end
			f()
			end
		end)

--- Recursively load a directory according to file names.
function util.load_dir(dir, mode)
		for _, file in ipairs(fs.list(dir)) do
			local full = dir .. file
			if fs.isdir(full) then
				local do_load = true
				full = full .. '/'
				if mode then -- nop
				elseif file == 'ai' then
					-- AI is weird and takes a whole directory.
					do_load = false
					require('engine.interface.ActorAI'):loadDefinition(full)
				elseif file == 'achievements' then
					-- Achievements is weird and takes a whole directory.
					do_load = false
					require('engine.interface.WorldAchievements'):loadDefinition(full)
				elseif file == 'birth' then mode = 'birth'
				elseif file == 'talents' then mode = 'talent'
				elseif file == 'effects' then mode = 'effect'
				elseif file == 'lore' then mode = 'lore'
				elseif file == 'damage-types' or file == 'damage_types' then mode = 'damage-type'
				elseif file == 'autolevels' or file == 'autolevel_schemes' then mode = 'damage-type'
					end
				if do_load then util.load_dir(full, mode) end
			else
				if mode == 'birth' or (not mode and file == 'birth.lua') then
					require('engine.Birther'):loadDefinition(full)
				elseif mode == 'talent' or (not mode and file == 'talents.lua') then
					require('engine.interface.ActorTalents'):loadDefinition(full)
				elseif mode == 'effect' or (not mode and file == 'effects.lua') then
					require('engine.interface.ActorTemporaryEffects'):loadDefinition(full)
				elseif mode == 'lore' or (not mode and file == 'lore.lua') then
					require('mod.class.interface.PartyLore'):loadDefinition(full)
				elseif mode == 'damage-type' or
					(not mode and (file == 'damage-types.lua' or file == 'damage_types.lua'))
				then
					require('engine.DamageType'):loadDefinition(full)
				elseif mode == 'autolevels' or
					(not mode and (file == 'autolevels.lua' or file == 'autolevel_schemes.lua'))
				then
					require('engine.Autolevel'):loadDefinition(full)
					end
				end
			end end

--- Autoload the /data/autoloads directory.
class:bindHook('ToME:load', function(self, data)
		util.load_dir('/data-'..addon..'/autoloads/')
		end)
