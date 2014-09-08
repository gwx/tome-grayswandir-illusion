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


util.add_superload('mod.class.Actor', function(_M)
		local mimic_attributes = {
			'block_sight', 'block_sense',}

		--- Set the entity which this actor will mimic.
		-- @param entity the entity to mimic
		function _M:setMimic(entity)
			self.mimic_entity = entity

			if entity.__CLASSNAME == 'mod.class.NPC' then
				self.mimic_mode = 'actor'
			elseif entity.__CLASSNAME == 'mod.class.Grid' then
				self.mimic_mode = 'terrain'
			else
				self.mimic_mode = 'other'
				end
			end

		--- Start mimicking
		function _M:enableMimic()
			if not self.mimic_entity then
				print 'MIMIC: Cannot begin mimicking: no mimic entity.'
				return
				end

			if self.mimic_enabled then return end

			self.mimic_enabled = true

			self.replace_display = self.mimic_entity
			if self.mimic_entity.tooltip then
				self.tooltip_entity = self.mimic_entity
				self.tooltip_default_pos = true
				end
			self.mimic_base_attributes = {}
			for _, attr in pairs(mimic_attributes) do
				self.mimic_base_attributes[attr] = rawget(self, attr)
				self[attr] = self.mimic_entity[attr]
				end


			-- Update Map
			self:removeAllMOs()
			game.level.map:updateMap(self.x, self.y)
			end

		--- Stop mimicking
		function _M:disableMimic()
			if not self.mimic_enabled then return end

			self.mimic_enabled = false

			self.replace_display = nil
			if self.mimic_entity.tooltip then
				self.tooltip_entity = nil
				self.tooltip_default_pos = nil
				end
			for _, attr in pairs(mimic_attributes) do
				self[attr] = self.mimic_base_attributes[attr]
				end

			-- Update Map
			self:removeAllMOs()
			game.level.map:updateMap(self.x, self.y)
			end

		--- Turn mimic on/off.
		function _M:setMimicState(state)
			if state then
				self:enableMimic()
			else
				self:disableMimic()
				end
			end

		local tooltip = _M.tooltip
		function _M:tooltip(x, y, seen_by)
			if self.tooltip_default_pos then
				x = x or self.x
				y = y or self.y
				end
			if self.tooltip_entity then
				return self.tooltip_entity:tooltip(x, y, seen_by)
			else
				return tooltip(self, x, y, seen_by)
				end
			end

		local bigTacticalFrame = _M.bigTacticalFrame
		function _M:bigTacticalFrame(x, y, w, h, zoom, on_map, tlx, tly)
			if self.mimic_enabled and self.mimic_mode ~= 'actor' then return end
			bigTacticalFrame(self, x, y, w, h, zoom, on_map, tlx, tly)
			end

		local smallTacticalFrame = _M.smallTacticalFrame
		function _M:smallTacticalFrame(x, y, w, h, zoom, on_map, tlx, tly)
			if self.mimic_enabled and self.mimic_mode ~= 'actor' then return end
			smallTacticalFrame(self, x, y, w, h, zoom, on_map, tlx, tly)
			end

		local setupMinimapInfo = _M.setupMinimapInfo
		function _M:setupMinimapInfo(mo, map)
			if self.mimic_enabled then
				return self.mimic_entity:setupMinimapInfo(self.mimic_entity._mo, map)
				end
			return setupMinimapInfo(self, mo, map) end

		local canSee = _M.canSee
		function _M:canSee(actor, def, def_pct)
			local res, chance = canSee(self, actor, def, def_pct)
			if res and (self.resting or self.running or self:attr '__no_see_mimic') and
				actor.mimic_enabled and actor.mimic_mode ~= 'actor'
			then
				res = false
				end
			return res, chance
			end

		local runCheck = _M.runCheck
		function _M:runCheck(ignore_memory)
			self:attr('__no_see_mimic', 1)
			local ret = {runCheck(self, ignore_memory)}
			self:attr('__no_see_mimic', -1)
			return unpack(ret)
			end

		local reactionToward = _M.reactionToward
		function _M:reactionToward(target, no_reflection)
			if self:attr '__no_see_mimic' and target.mimic_enabled and target.mimic_mode ~= 'actor' then
				return 0
			else
				return reactionToward(self, target, no_reflection)
				end
			end
		end)

util.add_superload('mod.class.NPC', function(_M)
		local tooltip = _M.tooltip
		function _M:tooltip(x, y, seen_by)
			if self.tooltip_default_pos then
				x = x or self.x
				y = y or self.y
				end
			if self.tooltip_entity then
				return self.tooltip_entity:tooltip(x, y, seen_by)
			else
				return tooltip(self, x, y, seen_by)
				end
			end
		end)

util.add_superload('mod.dialogs._M', function(_M)
		local Map = require 'engine.Map'

		local generateList = _M.generateList
		_M.generateList = function(self)
			generateList(self)
			local a = game.level.map(self.tmx, self.tmy, Map.ACTOR)
			if table.get(a, 'mimic_enabled') then
				if 'actor' == a.mimic_mode then
					-- If we're mimicking another actor, replace ourselves with it.
					for _, item in pairs(self.list) do
						if item.actor then item.actor = a.mimic_entity end
						end
				else
					-- If we're not mimicking an actor, remove all actor items.
					for i = #self.list, 1, -1 do
						if self.list[i].actor then table.remove(self.list, i) end
						end
					end
				end
			end
		end)

util.add_superload('engine.Target', function(_M)
		-- Disable seeing mimics while scanning for targets.
		local scan = _M.scan
		function _M:scan(dir, radius, sx, sy, filter, kind)
			game.player:attr('__no_see_mimic', 1)
			local ret = {scan(self, dir, radius, sx, sy, filter, kind)}
			game.player:attr('__no_see_mimic', -1)
			return unpack(ret)
			end
		end)

util.add_superload('mod.class.Tooltip', function(_M)
		local Map = require 'engine.Map'
		-- I'm being lazy, just overwriting the whole thing.

		--- Gets the tooltips at the given map coord
		function _M:getTooltipAtMap(tmx, tmy, mx, my)
			if self.locked then return nil end
			local tt = {}
			local seen = game.level.map.seens(tmx, tmy)
			local remember = game.level.map.remembers(tmx, tmy)

			local check = function(check_type)
				local to_add = game.level.map:checkEntity(tmx, tmy, check_type, "tooltip", game.level.map.actor_player)
				if to_add then
					if type(to_add) == "string" then to_add = to_add:toTString() end
					if to_add.is_tstring then
						tt[#tt+1] = to_add
					else
						table.append(tt, to_add)
						end
					end
				return to_add
				end

			local actor = game.level.map(tmx, tmy, Map.ACTOR)

			if seen or remember and not core.key.modState("ctrl") then
				check(Map.TRAP)
				if seen then check(Map.ACTOR) end
				check(Map.OBJECT)
				if seen then check(Map.PROJECTILE) end
				if not (table.get(actor, 'mimic_enabled') and actor.mimic_mode == 'terrain') then
					check(Map.TERRAIN)
					end
				end

			if #tt > 0 then
				return tt
				end
			return nil
			end
		end)

-- Marson's UI Mod
util.add_superload('engine.ActorsSeenDisplayMin', function(_M)
		-- Prevent seeing mimics while making the seen actor list.
		local display = _M.display
		function _M:display()
			game.player:attr('__no_see_mimic', 1)
			local seen = display(self, hostile_only)
			game.player:attr('__no_see_mimic', -1)
			return seen
			end
		end)
