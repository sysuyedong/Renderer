Camera = {}
Camera.__index = Camera

function Camera.new(eye, front, up, fov)
	local self = {}
	self.eye = eye
	self.front = front
	self.up = up
	self.fov = fov
	self.right = self.front:cross(self.up)
	self.fov_scale = math.tan(self.fov * 0.5 * math.pi / 180) * 2

	setmetatable(self, Camera)
	return self
end

function Camera:generateRay(x, y)
	local r = self.right * (x - 0.5) * self.fov_scale
	local u = self.up * (y - 0.5) * self.fov_scale
	return Ray.new(self.eye, (self.front + r + u):normalize())
end