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
	local r = rng.range(0, radius * base_size)

	local c
	if rng.percent(50) then
		c = {
			r = rng.float(0.0, 0.1),
			g = rng.float(0.7, 1.0),
			b = rng.float(0.0, 0.1),
			a = rng.float(0.3, 0.6),}
	else
		c = {
			r = rng.float(0.7, 1.0),
			g = rng.float(0.3, 0.7),
			b = rng.float(0.0, 0.1),
			a = rng.float(0.3, 0.6),}
		end

	return {
		trail = 1,
		life = rng.range(6, 15),
		size = rng.range(3, 9), sizev = 0.08, sizea = 0,

		x = r * math.cos(a), xv = 0, xa = 0,
		y = r * math.sin(a), yv = 0, ya = 0,
		dir = dir, dirv = 0, dira = 0,
		vel = rng.range(10, 30) / 10, velv = 0, vela = 0,

		r = c.r, rv = 0, ra = 0,
		g = c.g, gv = 0, ga = 0,
		b = c.b, bv = 0, ba = 0,
		a = c.a, av = 0, aa = 0,
	}
end, },
function(self)
	self.nb = (self.nb or 0) + 1
	if self.nb < 12 then
		self.ps:emit(10 + radius * radius * 10)
	end
end,
800
