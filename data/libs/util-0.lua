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


--- Sets t's index.
function table.set_index(t, index)
	local meta = getmetatable(t)
	if not meta then
		meta = {}
		setmetatable(t, meta) end
	meta.__index = index
	end


-- Load data file
function util.load_dir(dir, mode)
		for _, file in ipairs(fs.list(dir)) do
			local full = dir .. file
			if fs.isdir(full) then
				full = full .. '/'
				if file == 'birth' then mode = 'birth'
				elseif file == 'talents' then mode = 'talent'
				elseif file == 'effects' then mode = 'effect'
					end
				util.load_dir(full, mode)
			else
				if mode == 'birth' or (not mode and file == 'birth.lua') then
					require('engine.Birther'):loadDefinition(full)
				elseif mode == 'talent' or (not mode and file == 'talents.lua') then
					require('engine.interface.ActorTalents'):loadDefinition(full)
				elseif mode == 'effect' or (not mode and file == 'effects.lua') then
					require('engine.interface.ActorTemporaryEffects'):loadDefinition(full)
					end
				end
			end end
