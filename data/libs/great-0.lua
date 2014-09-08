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


local get = util.getval

class:bindHook('ToME:load', function(self, data)
		local Map = require 'engine.Map'

		local Effects = require 'engine.interface.ActorTemporaryEffects'
		Effects:newEffect {
			name = 'GRAYSWANDIR_GREAT',
			desc = 'You Feel Great!',
			long_desc = function(self, eff)
				return [[You feel great! You feel fine! You feel perfect!]]
				end,
			type = 'mental',
			subtype = {illusion = true, confuse = true,},
			status = 'detrimental',
			parameters = {},
			on_gain = function(self, eff) return '#Target# feels great!', '+GREAT!' end,
			check_death = function(self, eff)
				if self.life - (eff.damage or 0) < self.die_at then
					self:removeEffect(eff.effect_id, nil, true)
					end end,
			add_damage = function(self, eff, damage)
				eff.damage = (eff.damage or 0) + damage
				self:callEffect(eff.effect_id, 'check_death') end,
			heal_damage = function(self, eff, heal)
				eff.damage = (eff.damage or 0) - heal
				if eff.damage <= 0 then eff.damage = nil end end,
			activate = function(self, eff)
				return self:autoTemporaryValues({}, {great_shader = 1,})
				end,
			deactivate = function(self, eff)
				if eff.damage then
					game.logSeen(self, '%s awakens to painful reality, noticing %d damage!',
						self.name:capitalize(), eff.damage)
					self:takeHit(eff.damage, self)
					end
				end,
			on_merge = function(self, old, new)
				old.damage = (old.damage or 0) + (new.damage or 0)
				old.dur = math.min(old.dur + new.dur, 20)
				return old
				end,
			on_timeout = function(self, eff)
				self:callEffect(eff.effect_id, 'check_death') end,}

		local DamageType = require 'engine.DamageType'
		-- Physical damage, has a chance to apply the GREAT effect. If they
		-- have the great effect, this damage doesn't show up in the log.
		DamageType:newDamageType {
			type = 'GRAYSWANDIR_SNUGGLES',
			name = 'physical',
			projector = function(src, x, y, type, params)
				local target = game.level.map(x, y, Map.ACTOR)
				if not target then return 0 end

				if 'table' ~= _G.type(params) then params = {dam = params} end
				local dam = params.dam or 10
				local chance = params.chance or 30
				local duration = params.duration or 4
				local power = params.power or 'combatMindpower'
				power = get(src[power], src)
				local save = params.save or 'combatMentalResist'
				save = get(target[save], target)

				local great = target:hasEffect('EFF_GRAYSWANDIR_GREAT')

				if not great and rng.percent(chance) and target:checkHit(power, save) then
					target:setEffect('EFF_GRAYSWANDIR_GREAT', duration, {})
					great = target:hasEffect('EFF_GRAYSWANDIR_GREAT')
					end

				local physical = DamageType:get 'PHYSICAL'
				local realdam = 0
				local takeHit
				if great then
					physical.hideMessage = true
					takeHit = rawget(target, 'takeHit')
					target.takeHit = function(self, value, src, death_note)
						realdam = realdam + value
						return false, value
						end end

				local result = DamageType.defaultProjector(src, x, y, 'PHYSICAL', params.dam)

				if great then
					physical.hideMessage = false
					target.takeHit = takeHit
					game.logSeen(target, '%s snuggles %s.', src.name:capitalize(), target.name)
					target:callEffect('EFF_GRAYSWANDIR_GREAT', 'add_damage', realdam)
					end

				return result end,}
		end)

util.add_superload('mod.class.Actor', function(_M)
		local regenLife = _M.regenLife
		function _M:regenLife()
			local regen = self.life_regen * util.bound((self.healing_factor or 1), 0, 2.5)
			local overheal = self.life + regen - self.max_life
			local great = self:hasEffect 'EFF_GRAYSWANDIR_GREAT'
			if overheal > 0 and great then
				self:callEffect(great.effect_id, 'heal_damage', overheal) end
			regenLife(self) end

		local heal = _M.heal
		function _M:heal(value, src)
			local overheal = self.life + value - self.max_life
			local great = self:hasEffect 'EFF_GRAYSWANDIR_GREAT'
			if overheal > 0 and great then
				self:callEffect(great.effect_id, 'heal_damage', overheal) end
			heal(self, value, src) end

		end)

util.add_superload('mod.class.Player', function(_M)
		local updateMainShader = _M.updateMainShader
		function _M:updateMainShader()
			updateMainShader(self)
			if not game.fbo_shader then return end

			local pf = game.posteffects or {}
			if self:attr('great_shader') then
				game.fbo_shader:setUniform('colorize', {0.9, 0.9, 0.4, 0.6,})
				end
			end
		end)
