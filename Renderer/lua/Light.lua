LightSample = {}
LightSample.__index = LightSample

function LightSample.new(L, EL)
	local self = {}
	self.L = L
	self.EL = EL
	setmetatable(self, LightSample)
	return self
end

LightSample.Zero = LightSample.new(Vector.Zero, Color.Black)

-- 方向光源
DirectionLight = {}
DirectionLight.__index = DirectionLight

function DirectionLight.new(irradiance, direction)
	local self = {}
	self.irradiance = irradiance
	self.direction = direction
	self.L = self.direction:normalize():negate()
	self.shadow = true
	setmetatable(self, DirectionLight)
	return self
end

function DirectionLight:sample(scene, position)
	if self.shadow then
		local shadow_ray = Ray.new(position, self.L)
		local shadow_result = scene:intersect(shadow_ray)
		if shadow_result and shadow_result.geometry then
			return LightSample.Zero
		end

		return LightSample.new(self.L, self.irradiance)
	end
end

-- 点光源
PointLight = {}
PointLight.__index = PointLight

function PointLight.new(intensity, position)
	local self = {}
	self.intensity = intensity
	self.position = position
	self.shadow = true
	setmetatable(self, PointLight)
	return self
end

function PointLight:sample(scene, position)
	local delta = self.position - position
	local rr = delta:sqrtLength()
	local r = math.sqrt(rr)
	local L = delta:normalize()

	if self.shadow then
		local shadow_ray = Ray.new(position, L)
		local shadow_result = scene:intersect(shadow_ray)
		if shadow_result and shadow_result.geometry and shadow_result.distance <= r then
			return LightSample.Zero
		end
	end

	local attenuation = 1 / rr
	return LightSample.new(L, self.intensity * attenuation)
end

-- 聚光灯
SpotLight = {}
SpotLight.__index = SpotLight

function SpotLight.new(intensity, position, direction, theta, phi, falloff)
	local self = {}
	self.intensity = intensity
	self.position = position
	self.direction = direction
	self.theta = theta
	self.phi = phi
	self.falloff = falloff
	self.shadow = true

	self.S = self.direction:normalize():negate()
	self.cos_theta = math.cos(self.theta * math.pi / 180 / 2)
	self.cos_phi = math.cos(self.phi * math.pi / 180 / 2)
	self.base_multiplier = 1 / (self.cos_theta - self.cos_phi)

	setmetatable(self, SpotLight)
	return self
end

function SpotLight:sample(scene, position)
	local delta = self.position - position
	local rr = delta:sqrtLength()
	local r = math.sqrt(rr)
	local L = delta:normalize()

	local spot
	local SdotL = self.S:dot(L)
	if SdotL >= self.cos_theta then
		spot = 1
	elseif SdotL <= self.cos_phi then
		spot = 0
	else
		spot = math.pow((SdotL - self.cos_phi) * self.base_multiplier, self.falloff)
	end

	if self.shadow then
		local shadow_ray = Ray.new(position, L)
		local shadow_result = scene:intersect(shadow_ray)
		if shadow_result and shadow_result.geometry and shadow_result.distance <= r then
			return LightSample.Zero
		end
	end

	local attenuation = 1 / rr
	return LightSample.new(L, self.intensity * attenuation * spot)
end