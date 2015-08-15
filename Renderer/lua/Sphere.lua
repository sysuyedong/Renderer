Sphere = {}
Sphere.__index = Sphere

-- radius, position, emission, color, material
function Sphere.new(rad_, p_, e_, c_, refl_)
	local self = { rad = rad_, p = p_, e = e_, c = c_, refl = refl_ }
	self.sqRad = rad_ * rad_
	-- self.maxC = math.max(math.max(c_.x, c_.y), c_.z)
	-- self.cc = c_ * (1.0 / self.maxC)

	setmetatable(self, Sphere)
	return self
end

function Sphere:intersect(ray)
	local v = ray.o - self.p
	local a0 = v:sqrtLength() - self.sqRad
	local DdotV = ray.d:dot(v)

	if DdotV <= 0 then
		local discr = DdotV * DdotV - a0
		if discr >= 0 then
			local result = {}
			result.geometry = self
			result.distance = -DdotV - math.sqrt(discr)
			result.position = ray:getPoint(result.distance)
			result.normal = (result.position - self.p):normalize()
			return result
		end
	end
end