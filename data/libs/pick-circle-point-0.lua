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


-- Pick a random point from a circle.
util.pick_circle_point = function(x, y, radius)
	if not radius or radius < 0.5 then return x, y end
	local angle = math.rad(rng.range(0, 360))
	-- area is proportional to radius squared, so weight the random choice in the same way.
	local distance = math.sqrt(rng.float(0, radius * radius))
	x = math.floor(x + 0.5 + math.cos(angle) * distance)
	y = math.floor(y + 0.5 + math.sin(angle) * distance)
	return x, y
	end
