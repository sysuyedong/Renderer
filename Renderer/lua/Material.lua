CheckerMaterial = {}
CheckerMaterial.__index = CheckerMaterial

function CheckerMaterial.new(scale, reflectiveness)
	local self = {}
	self.scale = scale
	self.reflectiveness = reflectiveness

	setmetatable(self, CheckerMaterial)
	return self
end

function CheckerMaterial:sample(ray, position, normal)
	local val = math.abs((math.floor(position.x * 0.1) + math.floor(position.z * self.scale)) % 2)
	return val < 1 and Color.Black or Color.White
end

PhongMaterial = {}
PhongMaterial.__index = PhongMaterial

function PhongMaterial.new(diffuse, specular, shininess, reflectiveness)
	local self = {}
	self.diffuse = diffuse
	self.specular = specular
	self.shininess = shininess
	self.reflectiveness = reflectiveness

	setmetatable(self, PhongMaterial)
	return self
end

function PhongMaterial:sample(ray, position, normal)
	local light_dir = Vector.new(1, 1, 1):normalize()
	local light_color = Color.White

	local n_dot_l = normal:dot(light_dir)
	local h = (light_dir - ray.d):normalize()
	local n_dot_h = normal:dot(h)
	local diffuse_term = self.diffuse * (math.max(n_dot_l, 0))
	local specular_term = self.specular * (math.pow(math.max(n_dot_h, 0), self.shininess))
	return light_color:modulate(diffuse_term + specular_term)
end