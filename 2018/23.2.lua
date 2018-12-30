local nanobots = {}
for l in io.lines() do
	local x,y,z,r = l:match('pos=<(%-?%d+),(%-?%d+),(%-?%d+)>, r=(%d+)')
	x = tonumber(x)
	y = tonumber(y)
	z = tonumber(z)
	r = tonumber(r)
	table.insert(nanobots,{x=x,y=y,z=z,r=r})
end

local function dist(a,b)
	return math.abs(a.x-b.x)+math.abs(a.y-b.y)+math.abs(a.z-b.z)
end

local function intersect_box(a,b)
	local c = {}
	c.A = math.min(a.A,b.A)
	c.B = math.min(a.B,b.B)
	c.C = math.min(a.C,b.C)
	c.D = math.min(a.D,b.D)
	c.E = math.min(a.E,b.E)
	c.F = math.min(a.F,b.F)
	c.G = math.min(a.G,b.G)
	c.H = math.min(a.H,b.H)
	return c
end

local function intersect_non_empty(a,b)
	local c = intersect_box(a,b)
	return not (c.A + c.H < 0 or c.B + c.G < 0 or c.C + c.F < 0 or c.D + c.E < 0)
end

for i,a in ipairs(nanobots) do
	a.A = a.r+a.x+a.y+a.z
	a.B = a.r+a.x+a.y-a.z
	a.C = a.r+a.x-a.y+a.z
	a.D = a.r+a.x-a.y-a.z
	a.E = a.r-a.x+a.y+a.z
	a.F = a.r-a.x+a.y-a.z
	a.G = a.r-a.x-a.y+a.z
	a.H = a.r-a.x-a.y-a.z
end

local graph = {}
local count = 0
for i,a in ipairs(nanobots) do
	graph[i] = {}
	local size = 0
	for j,b in ipairs(nanobots) do
		if intersect_non_empty(a,b) then
			graph[i][j] = true
			size = size + 1
		end
	end
	graph[i][i] = nil
	graph[i].size = size - 1
end

local old_next = next
local function next(t,k)
	local k,v = k
	repeat
		k,v = old_next(t,k)
	until k ~= 'size'
	return k,v
end
local function pairs(t)
	return next, t, nil
end

local function intersect(a,b)
	local s = {}
	local size = 0
	for k in pairs(a) do
		if b[k] then
			s[k] = true
			size = size+1
		end
	end
	s.size = size + (s.size and (-1) or 0)
	return s
end

local function diff(a,b)
	local s = {}
	local size = 0
	for k in pairs(a) do
		if not b[k] then
			s[k] = true
			size = size+1
		end
	end
	s.size = size + (s.size and (-1) or 0)
	return s
end

local function merge(a,b)
	local s = {}
	local size = 0
	for k in pairs(a) do
		s[k] = true
		size = size+1
	end
	for k in pairs(b) do
		if not s[k] then
			s[k] = true
			size = size+1
		end
	end
	s.size = size + (s.size and (-1) or 0)
	return s
end

local function copy(a)
	return merge(a,{})
end

-- assuming everything will be fine
local function fisrt_max_clique(a,b,c)
	if b.size == 0 and c.size == 0 then
		return copy(a)
	end
	local u = next(merge(b,c))
	for v in pairs(b) do
		local ret = fisrt_max_clique(merge(a,{[v]=true}),intersect(b,graph[v]),intersect(c,graph[v]))
		if ret then
			return ret
		end
		b[v] = nil
		c[v] = true
	end
end

local start = {size=#nanobots}
for i=1,#nanobots do start[i] = true end
local res = fisrt_max_clique({size=0},start,{size=0})
local box = nanobots[next(res)]
for i in pairs(res) do
	box = intersect_box(box,nanobots[i])
end

print(math.max(box.A, box.B, box.C, box.D, box.E, box.F, box.G, box.H))