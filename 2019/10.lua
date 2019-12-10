local input = {}
local grid = {}
for l in io.lines() do
	local line = {}
	for i=1,#l do
		line[i] = l:sub(i,i)
	end
	grid[#grid+1] = line
end

local function gcd(a,b)
	if b < 0 then
		return gcd(a,-b)
	end
	if a < b then
		return gcd(b,a)
	end
	if b == 0 then
		return a
	end
	return gcd(b, a % b)
end

local dirs = {}
for u=-#grid+1,#grid-1 do
	for v=-#grid[1]+1,#grid[1]-1 do
		if gcd(u,v) == 1 then
			dirs[#dirs+1] = {u,v}
		end
	end
end

local max = 0
local coords

for i=1,#grid do
	for j=1,#grid do
		local val = 0
		for _,vect in ipairs(dirs) do
			local u,v = table.unpack(vect)
			local k = 1
			while grid[i+k*u] and grid[i+k*u][j+k*v] do
				if grid[i+k*u][j+k*v] == '#' then
					val = val + 1
					break
				end
				k = k + 1
			end
		end
		if val > max then
			max = val
			coords = {i,j}
		end
	end
end
print(max)

table.sort(dirs, function(a1,a2)
	a1 = math.atan(a1[2],a1[1])
	a2 = math.atan(a2[2],a2[1])
	return a1 > a2
end)

local i,j = table.unpack(coords)
local vapo = {}
for _,vect in ipairs(dirs) do
	local u,v = table.unpack(vect)
	local k = 1
	local asts = {}
	while grid[i+k*u] and grid[i+k*u][j+k*v] do
		if grid[i+k*u][j+k*v] == '#' then
			asts[#asts+1] = {i+k*u,j+k*v}
		end
		k = k + 1
	end
	if #asts > 0 then
		vapo[vect] = asts
	end
end

local c = 0
while c < 200 do
	for _,vect in ipairs(dirs) do
		if vapo[vect] then
			local r = vapo[vect][1]
			table.remove(vapo[vect], 1)
			c = c + 1
			if c == 200 then
				print((r[2]-1)*100+(r[1]-1))
				break
			end
			if #vapo[vect] == 0 then
				vapo[vect] = nil
			end
		end
	end
end

