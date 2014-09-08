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


local tiles = math.ceil(math.sqrt(tx*tx+ty*ty))
local tx = tx * engine.Map.tile_w
local ty = ty * engine.Map.tile_h
local length = math.sqrt(tx*tx+ty*ty)
local direction = math.atan2(ty, tx)
local offsetLength = engine.Map.tile_w * 0.3

-- Populate the beam based on the forks
return { blend_mode = core.particles.BLEND_SHINY, generator = function()
	local angle = direction
	local rightAngle = direction + math.rad(90)
	local r = rng.range(2, length)
	local spread_percent = r / length * 0.7 + 0.3
	local offset = rng.range(-offsetLength, offsetLength) * spread_percent

	local cr, cg, cb
	if rng.percent(50) then
		cr = rng.range(128, 216) / 255
		cg = 32 / 255
		cb = rng.range(128, 216) / 255
	else
		cr = rng.range(128, 216) / 255
		cg = rng.range(64, 108) / 255
		cb = 32 / 255
	end

	return {
		life = 5, trail=1,
		size = rng.range(6, 8), sizev = -0.4, sizea = 0,

		x = r * math.cos(angle) + math.cos(rightAngle) * offset, xv = 0, xa = 0,
		y = r * math.sin(angle) + math.sin(rightAngle) * offset, yv = 0, ya = 0,
		dir = angle + math.rad(180), dirv = 0, dira = 0,
		vel = rng.range(1, 3), velv = 0, vela = 0,

		r = cr, rv = 0, ra = 0,
		g = cg, gv = 0, ga = 0,
		b = cb, bv = 0, ba = 0,
		a = rng.range(80, 196) / 255, av = 0, aa = 0,
	}
end, },
function(self)
	self.ps:emit(12*tiles)
end,
5*12*tiles

--[==[
-- Populate the beam based on the forks
return { blend_mode = core.particles.BLEND_SHINY, generator = function()
	local angle = direction
	local rightAngle = direction + math.rad(90)
	local radius = rng.range(2, length)
	local spread_percent = r / length * 0.7 + 0.3
	local offset = rng.range(-offsetLength, offsetLength) * spread_percent

	local r, g, b
	--[[
	if rng.percent(50) then
	--]]
		r = rng.range(150, 250) / 255
		g = rng.range(100, 160) / 255
		b = rng.range(10, 30) / 255
		--[[
	else
		r = rng.range(150, 250) / 255
		g = rng.range(10, 30) / 255
		b = rng.range(150, 250) / 255
	end
		--]]

	return {
		life = 5, trail=1,
		size = rng.range(6, 8), sizev = -0.4, sizea = 0,

		x = radius * math.cos(angle) + math.cos(rightAngle) * offset, xv = 0, xa = 0,
		y = radius * math.sin(angle) + math.sin(rightAngle) * offset, yv = 0, ya = 0,
		dir = angle + math.rad(180), dirv = 0, dira = 0,
		vel = rng.range(1, 3), velv = 0, vela = 0,

		r = 0.5, rv = 0, ra = 0,
		g = 0.5, gv = 0, ga = 0,
		b = 0.5, bv = 0, ba = 0,
		a = rng.range(80, 196) / 255, av = 0, aa = 0,
	}
end, },
function(self)
	self.ps:emit(12*tiles)
end,
5*12*tiles
--]==]
