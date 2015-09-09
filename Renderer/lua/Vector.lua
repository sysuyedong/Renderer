Vector = {}
Vector.__index = Vector

function Vector.new(x_, y_, z_)
	local self = { x = x_, y = y_, z = z_}
	setmetatable(self, Vector)
	return self
end
	
function Vector.__add(a, b)
	return Vector.new(a.x + b.x, a.y + b.y, a.z + b.z)
end

function Vector.__sub(a, b)
	return Vector.new(a.x - b.x, a.y - b.y, a.z - b.z)
end

function Vector.__mul(a, b)
	return Vector.new(a.x * b, a.y * b, a.z * b)
end

function Vector.__div(a, b)
	return Vector.new(a.x / b, a.y / b, a.z / b)
end

-- component-wise multiplication
function Vector:multiply(b)
	return Vector.new(self.x * b.x, self.y * b.y, self.z * b.z)
end

function Vector:normalize()
    return self * (1.0 / math.sqrt(self.x * self.x + self.y * self.y + self.z * self.z))
end

function Vector:dot(b)
	return self.x * b.x + self.y * b.y + self.z * b.z
end

function Vector:cross(b)
	return Vector.new(self.y * b.z - self.z * b.y, self.z * b.x - self.x * b.z, self.x * b.y - self.y * b.x)
end

function Vector:sqrtLength()
	return self.x * self.x + self.y * self.y + self.z * self.z
end

function Vector:negate()
	return Vector.new(-self.x, -self.y, -self.z)
end

-- cross product
function Vector.__mod(a, b)
    return Vector.new(a.y * b.z - a.z * b.y, a.z * b.x - a.x * b.z, a.x * b.y - a.y * b.x)
end

function Vector.__tostring(v)
	return string.format("{%s, %s, %s}", v.x, v.y, v.z)
end

Vector.Zero = Vector.new(0, 0, 0)
Vector.XAxis = Vector.new(1, 0, 0)
Vector.YAxis = Vector.new(0, 1, 0)
Vector.ZAxis = Vector.new(0, 0, 1)