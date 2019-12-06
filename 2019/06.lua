local graph = {}
local tree = {}
for u,v in string.gmatch(io.read('a'), '([%d%a]+)%)([%d%a]+)') do
	if not graph[u] then
		graph[u] = {}
	end
	if not graph[v] then
		graph[v] = {}
	end
	print(u,v)
	table.insert(graph[u], v)
	tree[v] = u
end

local counts = 0

local function count1(graph, u)
	local ret = 0
	for _,v in ipairs(graph[u]) do
		ret = ret + 1 + count1(graph, v)
	end
	counts = counts + ret
	return ret
end

local function branch(tree, u)
	if not u then return end
	return u, branch(tree, tree[u])
end

count1(graph, 'COM')
print(counts)

local you_b = {branch(tree, 'YOU')}
local san_b = {branch(tree, 'SAN')}

while you_b[#you_b] == san_b[#san_b] do
	you_b[#you_b] = nil
	san_b[#san_b] = nil
end

print(#you_b + #san_b - 2)
