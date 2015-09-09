Color = {}
Color.__index = Color

function Color.new(red, green, blue)
	local self = { r =  red, g = green, b = blue }
	local r = red > 1 and 1 or red
	local g = green > 1 and 1 or green
	local b = blue > 1 and 1 or blue
	self.value = math.floor(255 * b )* math.pow(2, 16) + math.floor(255 * g) * math.pow(2, 8) + math.floor(255 * r)
	setmetatable(self, Color)
	return self
end

function Color.__add(a, b)
	local r = a.r + b.r
	local g = a.g + b.g
	local b = a.b + b.b
	r = r > 1 and 1 or r
	g = g > 1 and 1 or g
	b = b > 1 and 1 or b
	return Color.new(r, g, b)
end

function Color.__mul(c, factor)
	local r = c.r * factor
	local g = c.g * factor
	local b = c.b * factor
	-- r = r > 1 and 1 or r
	-- g = g > 1 and 1 or g
	-- b = b > 1 and 1 or b
	return Color.new(r, g, b)
end

function Color:modulate(c)
	return Color.new(self.r * c.r, self.g * c.g, self.b * c.b)
end

function Color.__tostring(color)
	return string.format("{red = %s, green = %s, blue = %s, value = %s}", color.r, color.g, color.b, color.value)
end

Color.White = Color.new(1, 1, 1)
Color.Black = Color.new(0, 0, 0)
Color.Red = Color.new(1, 0, 0)
Color.Green = Color.new(0, 1, 0)
Color.Blue = Color.new(0, 0, 1)