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


util.add_superload('mod.class.interface.PartyLore', function(_M)
		local newLore = _M.newLore
		function _M:newLore(t)
			newLore(self, t)
			if t.start then
				self.starting_lores = self.starting_lores or {}
				table.insert(self.starting_lores, t.id)
				end
			end
		end)

util.add_superload('mod.class.Object', function(_M)
		local canUseObject = _M.canUseObject
		function _M:canUseObject()
			local transmo
			if self.__transmo and self.use_transmo then
				transmo = self.__transmo
				self.__transmo = nil
				end
			local ret = {canUseObject(self)}
			if transmo then self.__transmo = transmo end
			return unpack(ret)
			end
		end)

util.add_superload('mod.dialogs.UseItemDialog', function(_M)
		local generateList = _M.generateList
		function _M:generateList()
			generateList(self)

			if not self.dst_actor and self.object.__transmo and
				self.object.use_transmo and not self.no_use_allowed
			then
				if self.object:canUseObject() then
					table.insert(self.list, {name = 'Use', action = 'use'})
					end end
			end
		end)

util.add_superload('mod.class.Player', function(_M)
		local Lore = require 'mod.class.interface.PartyLore'

		local onBirth = _M.onBirth
		function _M:onBirth(birther)
			onBirth(self, birther)

			if Lore.starting_lores then
				local Object = require 'mod.class.Object'
				local base = Object.new {
					type = 'lore', subtype = 'lore', no_unique_lore = true,
					unided_name = 'scroll', identified = true,
					display = '?', color = colors.ANTIQUE_WHITE, image = 'object/scroll-lore.png',
					encumber = 0, __transmo = true, use_transmo = true,
					desc = [[Contains some lore.]],
					use_simple = {name = 'Read', use = function(self, who, inven, item)
							game.party:learnLore(self.lore_id)
							return {used = true, id = true,}
							end,},}
				for _, id in ipairs(Lore.starting_lores) do
					local o = game.zone:finishEntity(game.level, 'object', base)
					o.lore_id = id
					local lore = Lore:getLore(id, true)
					o.name = lore.name
					self:addObject(self:getInven(self.INVEN_INVEN), o)
					end end
			end
		end)
