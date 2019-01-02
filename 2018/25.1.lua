local points = {}
for l in io.lines() do
	table.insert(points, load('return {'..l..'}')())
end

local function dist(a,b)
	local dist = 0
	for i=1,4 do
		dist = dist + math.abs(a[i]-b[i])
	end
	return dist
end

local graph = {}
for i,u in ipairs(points) do
	graph[i] = {}
	for j,v in ipairs(points) do
		if dist(u,v) <= 3 then
			graph[i][j] = true
		end
	end
end

local function merge(a,b)
	local t = {}
	for a in pairs(a) do
		t[a] = true
	end
	for b in pairs(b) do
		t[b] = true
	end
	return t
end

local function diff(a,b)
	local t = {}
	for a in pairs(a) do
		if not b[a] then
			t[a] = true
		end
	end
	return t
end

local count = 0

local used = {}
for i=1,#points do
	if not used[i] then
		local tovisit = {[i] = true}
		while next(tovisit) do
			local i = next(tovisit)
			used[i] = true
			for j in pairs(diff(graph[i],used)) do
				tovisit[j] = true
			end
			tovisit[i] = nil
		end
		count = count + 1
	end
end
print(count)
