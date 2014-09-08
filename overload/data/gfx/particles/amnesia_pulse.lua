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


base_size = 32

return { generator = function()
	local ad = rng.range(0, 360)
	local a = math.rad(ad + 15)
	local dir = math.rad(ad)
	local r = rng.range(0, 64)

	return {
		trail = 1,
		life = rng.range(6, 15),
		size = rng.range(3, 12), sizev = 0.08, sizea = 0,

		x = r * math.cos(a), xv = 0, xa = 0,
		y = r * math.sin(a), yv = 0, ya = 0,
		dir = dir, dirv = 0, dira = 0,
		vel = rng.range(10, 30) / 10, velv = 0, vela = 0,

		r = rng.range(0, 50)/255,  rv = 0, ra = 0,
		g = rng.range(0, 100)/255,  gv = 0, ga = 0,
		b = rng.range(150, 250)/255,  bv = 0, ba = 0,
		a = rng.range(50, 120)/255,  av = 0, aa = 0,
	}
end, },
function(self)
	self.nb = (self.nb or 0) + 1
	if self.nb < 16 then
		self.ps:emit(48)
	end
end,
800
