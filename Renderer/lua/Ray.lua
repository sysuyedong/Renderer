-- 光线函数 r(t) = o + td, t >= 0
-- o为发起点，d为方向(单位向量)，t为距离

Ray = {}
Ray.__index = Ray

function Ray.new(o_, d_)
	local self = { o = o_, d = d_ }
	setmetatable(self, Ray)
	return self
end

function Ray:getPoint(t)
	return self.o + self.d * t
end