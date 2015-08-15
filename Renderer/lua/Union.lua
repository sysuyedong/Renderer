Union = {}
Union.__index = Union

function Union.new(set)
	local self = {}
	self.set = set
	setmetatable(self, Union)

	return self
end

function Union:intersect(ray)
	local min_distance = math.pow(2, 32)
	local min_result
	for k, v in pairs(self.set) do
		local result = v:intersect(ray)
		if result and result.distance < min_distance then
			min_distance = result.distance
			min_result = result
		end
	end
	return min_result
end