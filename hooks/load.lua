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


__loading_addon = 'grayswandir-illusion'

----------------------------------------------------------------
-- Libs System

if not lib then
	lib = {}
	lib.loaded = {}
	lib.require = function(name, min_version)
		min_version = min_version or -math.huge
		local libs_dir = '/data-'..__loading_addon..'/libs/'
		local libs = fs.list(libs_dir)
		local matcher = '^'..name:gsub('%-', '%%-')..'%-([%d%.]+)%.lua$'
		for _, libname in pairs(libs) do
			local version = tonumber(({libname:find(matcher)})[3])
			if version and
				version > (lib.loaded[name] or -math.huge) and
				version >= min_version
			then
				lib.loaded[name] = version
				dofile(libs_dir..libname)
				return true end end
		assert(lib.loaded[name],
			('Addon <%s> could not find needed lib <%s>.'):format(__loading_addon, name))
		assert(lib.loaded[name] >= min_version,
			('Addon <%s> needs lib <%s> of at least version %s.'):format(__loading_addon, name, min_version))
		end
	lib.require_all = function()
		local libs_dir = '/data-'..__loading_addon..'/libs/'
		local libs = fs.list(libs_dir)
		local matcher = '^(.+)%-([%d%.]+)%.lua$'
		for _, libname in pairs(libs) do
			local _, _, name, version = libname:find(matcher)
			version = tonumber(version)
			if version and version > (lib.loaded[name] or -math.huge) then
				dofile(libs_dir..libname)
				lib.loaded[name] = version
				end end end end

----------------------------------------------------------------
-- Additional Superloads System

if not __additional_superloads then
	__additional_superloads = {}

	--- Adds a superload for a class.
	-- @param class the class name to superload
	-- @param fun the superloading function - takes the class as an argument
	util.add_superload = function(class, fun)
		local class_superloads = table.get(_G, '__additional_superloads', class)
		if not class_superloads then
			class_superloads = {}
			table.set(_G, '__additional_superloads', class, class_superloads)
			end
		table.insert(class_superloads, fun)
		end

	-- XXX UNTESTED
	--[[
	local loadfilemods = util.loadfilemods
	function util.loadfilemods(file, env)
		local base = loadfilemods(file, env)
		for _, f in pairs(_G.__additional_superloads[file] or {}) do
			f(base)
			end
		return base
		end
	--]]

	local te4_loader = package.loaders[3]
	package.loaders[3] = function(name)
		local base = te4_loader(name)
		if base then
			for _, f in pairs(_G.__additional_superloads[name] or {}) do
				local prev = base
				base = function(name)
					prev(name)
					print("FROM ", name, "loading special!")
					local _M = package.loaded[name]
					f(_M)
					return _M
					end
				end
			return base
			end
		end
	end

----------------------------------------------------------------

lib.require_all()

for _, file in ipairs(fs.list '/hooks/grayswandir-illusion/') do
	if file ~= 'load.lua' then
		dofile('/hooks/grayswandir-illusion/'..file)
		end
	end

-- Additional Hooks
dofile 'data-grayswandir-illusion/zones/illusory-woods/require.lua'

----------------------------------------------------------------

__loading_addon = nil
