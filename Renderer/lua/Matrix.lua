Matrix = Matrix or {}
Matrix.__index = Matrix

function Matrix.new(row, col)
	local self = {}
	self.row = row
	self.col = col

	for i = 0, self.row - 1 do
		self[i] = {}
		for j = 0, self.col - 1 do
			self[i][j] = 0
		end
	end

	setmetatable(self, Matrix)
	return self
end

function Matrix.__mul(a, b)
	local type_a = type(a)
	local type_b = type(b)
	if type_a == type_b then
		return a:mul(b)
	elseif type_a == "number" then
		return b:mulNum(a)
	elseif type_b == "number" then
		return a:mulNum(b)
	end
end

function Matrix:mulNum(num)
	local new_mat = Matrix.new(self.row, self.col)
	for i = 0, self.row - 1 do
		for j = 0, self.col - 1 do
			new_mat[i][j] = self[i][j] * num
		end
	end
	return new_mat
end

function Matrix:mul(matrix)
	if self.col ~= matrix.row then
		return
	end

	local new_mat = Matrix.new(self.row, matrix.col)
	for i = 0, self.row - 1 do
		new_mat[i] = {}
		for j = 0, matrix.col - 1 do
			new_mat[i][j] = 0
			for k = 0, self.col - 1 do
				new_mat[i][j] = new_mat[i][j] + self[i][k] * matrix[k][j]
			end
		end
	end

	return new_mat
end

-- 转置矩阵
function Matrix:transpose()
	local new_mat = Matrix.new(self.col, self.row)
	for i = 0, self.col - 1 do
		for j = 0, self.row - 1 do
			new_mat[i][j] = self[j][i]
		end
	end
	return new_mat
end

-- 逆矩阵
function Matrix:inverse()
	local det = self:determinant()
	if det == nil or det == 0 then
		return nil
	end
	local new_mat = Matrix.new(self.row, self.col)
	for i = 0, self.row - 1 do
		for j = 0, self.col - 1 do
			new_mat[i][j] = self:cofactor(j, i)
		end
	end
	return (1 / det) * new_mat
end

-- 行列式
function Matrix:determinant()
	if self.row ~= self.col then
		return
	end
	local det = 0
	if self.row == 2 then
		det = self[0][0] * self[1][1] - self[0][1] * self[1][0]
	else
		local row = 0
		for i = 0, self.col - 1 do
			det = det + self[row][i] * self:cofactor(row, i)
		end
	end

	return det
end

-- 余子式
function Matrix:cofactor(i, j)
	local sign = (i + j) % 2 == 0 and 1 or -1
	local mat = Matrix.new(self.row - 1, self.col - 1)
	local index = 0
	for r = 0, self.row - 1 do
		for c = 0, self.col - 1 do
			if r ~= i and c ~= j then
				local x = math.floor(index / (self.row - 1))
				local y = index % (self.col - 1)
				mat[x][y] = self[r][c]
				index = index + 1
			end
		end
	end
	return sign * mat:determinant()
end

function Matrix.__tostring(matrix)
	local str = "[ \n"
	for i = 0, matrix.row - 1 do
		local row = ""
		for j = 0, matrix.col - 1 do
			row = row .. matrix[i][j] .. (j == matrix.col - 1 and "" or  ",")
		end
		str = str .. row .. "\n"
	end
	return str .. " ]"
end

local mat1 = Matrix.new(4, 4)

mat1[0] = {[0] = 1, [1] = 0, [2] = 0, [3] = 1}
mat1[1] = {[0] = 0, [1] = 1, [2] = 0, [3] = 1}
mat1[2] = {[0] = 0, [1] = 0, [2] = 1, [3] = 1}
mat1[3] = {[0] = 0, [1] = 0, [2] = 0, [3] = 1}

local mat2 = Matrix.new(3, 3)
mat2[0] = {[0] = 0, [1] = 1, [2] = 2}
mat2[1] = {[0] = 3, [1] = 4, [2] = 5}
mat2[2] = {[0] = 6, [1] = 7, [2] = 8}

local mat3 = Matrix.new(3, 3)
mat3[0] = {[0] = 1, [1] = 1, [2] = 2}
mat3[1] = {[0] = 1, [1] = 3, [2] = 4}
mat3[2] = {[0] = 0, [1] = 2, [2] = 5}

print(mat3:inverse())