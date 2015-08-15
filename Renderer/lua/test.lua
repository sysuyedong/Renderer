require ("Camera")
require ("Color")
require ("Plane")
require ("Ray")
require ("Sphere")
require ("Union")
require ("Vector")

local h = 400
local w = 300
local max_depth = 20

local sp = Sphere.new(10, Vector.new(0, 10, -10))
local camera = Camera.new(Vector.new(0, 10, 10), Vector.new(0, 0, -1), Vector.new(0, 1, 0), 90)
for y = 0, h - 1 do
	local sy = 1 - y / h
	for x = 0, w - 1 do
		local sx = x / w
		local ray = camera:generateRay(sx, sy)
		local result = sp:intersect(ray)
		local color = Color.new(0, 0, 0)
		if result then
			local depth = 1 - math.min(result.distance / max_depth, 1)
			color = Color.new(depth, depth, depth)
			print(color)
		end
	end
end