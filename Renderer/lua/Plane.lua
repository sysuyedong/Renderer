Plane = {}
Plane.__index = Plane

function Plane.new(normal, d)
	local self = {}
	self.normal = normal
	self.d = d
	self.position = self.normal * d
	
	setmetatable(self, Plane)
	return self
end

function Plane:intersect(ray)
	local a = ray.d:dot(self.normal)
	if a >= 0 then
		return nil
	end
	local b = self.normal:dot(ray.o - self.position)
	local result = {}
	result.geometry = self
	result.distance = -b / a
	result.position = ray:getPoint(result.distance)
	result.normal = self.normal
	return result
end