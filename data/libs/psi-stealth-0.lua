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


lib.require 'unscale'

util.add_superload('mod.class.Actor', function(_M)
		function _M:psiStealthPower(target)
			if not self:attr 'psi_stealth_add' and not self:attr 'psi_stealth_mult' then return end
			local power = self:unscaleCombatStats(self:combatMindpower())
			local mult, add = self.psi_stealth_mult or 0, self.psi_stealth_add or 0
			power = self:rescaleCombatStats((power * mult) + add)
			local dec = table.get(target, 'psi_stealth_damage', self)
			if dec then power = power * (1 - dec) end
			return power
			end

		function _M:psiStealthMimic()
			return self.psi_stealth_mimic
			end

		local canSeeNoCache = _M.canSeeNoCache
		function _M:canSeeNoCache(actor, def, def_pct)
			local see, chance = canSeeNoCache(self, actor, def, def_pct)
			if not see then return see, chance end
			if actor == self then return see, chance end

			local psi_stealth = actor.psiStealthPower and actor:psiStealthPower(self)
			if psi_stealth and not (actor.reactionToward and actor:reactionToward(self) > 0) then
				local hit, psi_chance = self:checkHit(self:combatMentalResist(), psi_stealth)
				-- Only do mimics if it's the player trying to see them.
				if self.player and actor:psiStealthMimic() then
					game:onTickEnd(function() actor:setMimicState(not hit) end)
					return true, 100
				else
					return hit, chance * psi_chance * 0.01
					end
				end

			return see, chance
			end

		--- Adjusts the psi stealth memory resistance bonus.
		function _M:psiStealthAlterMemory(source, add, mult)
			if source == 'all' then
				for _, source in pairs(table.keys(self.psi_stealth_damage or {})) do
					self:psiStealthAlterMemory(source, add, mult)
					end
				return end

			local mtable = self.psi_stealth_damage
			if not mtable then
				mtable = {}
				self.psi_stealth_damage = mtable end
			local memory = mtable[source] or 0
			local old_memory = memory
			memory = (memory * (mult or 1)) + (add or 0)
			if source.memory_resist then
				memory = old_memory + 100 * (memory - old_memory) / (100 + source.memory_resist)
				end
			if memory > 1 then memory = 1 end
			if memory <= 0 then memory = nil end
			mtable[source] = memory
			-- Force visibility to recheck.
			if self.can_see_cache then self.can_see_cache[source] = {} end
			end

		end)

util.add_superload('mod.class.NPC', function(_M)
		-- TODO figure out a better than hacking stealth?
		local tooltip = _M.tooltip
		function _M:tooltip(x, y, seen_by)
			local mod_stealth
			if game.player:psiStealthPower(self) and not game.player:attr('stealth') then
				mod_stealth = true
				game.player.stealth = -9999
				end

			local str = tooltip(self, x, y, seen_by)

			if str then
				local memory = table.get(self, 'psi_stealth_damage', game.player)
				if memory then
					str:add(true, ('Memory: %d%%'):format(memory * 100))
					end
				end

			if mod_stealth then game.player.stealth = nil end

			return str
			end
		end)

class:bindHook('DamageProjector:final', function(self, data)
		local Map = require 'engine.Map'

		if self.psiStealthPower and self:psiStealthPower() then
			local target = game.level.map(data.x, data.y, Map.ACTOR)
			local add = target.rank * data.dam / target.max_life
			target:psiStealthAlterMemory(self, add)
			end
		end)

class:bindHook('Actor:actBase:Effects', function(self)
		self:psiStealthAlterMemory('all', -0.02)
		end)
