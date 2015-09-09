require ("lua.Camera")
require ("lua.Color")
require ("lua.Material")
require ("lua.Plane")
require ("lua.Ray")
require ("lua.Sphere")
require ("lua.Union")
require ("lua.Vector")
require ("lua.Light")

WindowWidth = WindowWidth or 256
WindowHeight = WindowHeight or 256

window_width = WindowWidth
window_height = WindowHeight

local w = WindowWidth - 10
local h = WindowHeight - 50
local max_depth = 20

function renderDepth(result)
	local c = 1 - math.min(result.distance / max_depth, 1)
	return Color.new(c, c, c)
end

function renderNormal(result)
	local r = (result.normal.x + 1) * 128 / 255
	local g = (result.normal.y + 1) * 128 / 255
	local b = (result.normal.z + 1) * 128 / 255
	return Color.new(r, g, b)
end

function renderMaterial(ray, result)
	local c = Color.Black
	if result.geometry.material then
		c = result.geometry.material:sample(ray, result.position, result.normal)
	end
	return c
end

function renderReflection(scene, ray, result, max_reflect)
	local c = Color.Black
	if result and result.geometry.material then
		local reflectiveness = result.geometry.material.reflectiveness or 0
		c = result.geometry.material:sample(ray, result.position, result.normal)
		c = c * (1 - reflectiveness)

		if reflectiveness > 0 and max_reflect > 0 then
			local reflect_dir = ray.d - result.normal * result.normal:dot(ray.d) * 2
			local reflect_ray = Ray.new(result.position, reflect_dir)
			local reflect_result = scene:intersect(ray)
			local reflect_color = renderReflection(scene, reflect_ray, reflect_result, max_reflect - 1)
			c = c + reflect_color * reflectiveness
		end
	end
	return c
end

function renderLight(scene, lights, result)
	local c = Color.Black
	if result.geometry then
		for k, light in ipairs(lights) do
			local light_sample = light:sample(scene, result.position)
			if light_sample ~= LightSample.Zero then
				local NdotL = result.normal:dot(light_sample.L)
				if NdotL >= 0 then
					c = c + light_sample.EL * NdotL
				end
			end
		end
	end

	return c
end

local plane = Plane.new(Vector.new(0, 1, 0), 0)
local sp1 = Sphere.new(10, Vector.new(-10, 10, -10))
local sp2 = Sphere.new(10, Vector.new(10, 10, -10))
plane.material = CheckerMaterial.new(0.1, 0.8)
sp1.material = PhongMaterial.new(Color.Red, Color.White, 16, 0.5)
sp2.material = PhongMaterial.new(Color.Blue, Color.White, 16, 0.5)
local scene = Union.new({plane, sp1, sp2})
local camera = Camera.new(Vector.new(0, 5, 18), Vector.new(0, 0, -1), Vector.new(0, 1, 0), 100)
local dir_light = DirectionLight.new(Color.White, Vector.new(-1.75, -2, -1.5))
local point_light = PointLight.new(Color.White * 100, Vector.new(0, 25, 0))
local spot_light = SpotLight.new(Color.White * 2000, Vector.new(25, 40, 20), Vector.new(-1, -1, -1), 20, 30, 0.5)
local lights = {}
-- table.insert(lights, dir_light)
-- table.insert(lights, point_light)
table.insert(lights, spot_light)

for y = 0, h - 1 do
	local sy = 1 - y / h
	for x = 0, w - 1 do
		local sx = x / w
		local ray = camera:generateRay(sx, sy)
		local result = scene:intersect(ray)
		local color = Color.Black
		if result then
			-- color = renderDepth(result)
			-- color = renderNormal(result)
			-- color = renderMaterial(ray, result)
			-- color = renderReflection(scene, ray, result, 3)
			color = renderLight(scene, lights, result)
		end
		DrawPixel(x, y, color.value)
	end
end