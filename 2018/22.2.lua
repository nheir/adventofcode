local depth = tonumber(io.read("*l"):match("(%d+)"))
local tx,ty = io.read("*l"):match("(%d+),(%d+)")
tx,ty = tonumber(tx), tonumber(ty)

local _ero = {}
function ero(x,y)
	if not _ero[x] then _ero[x] = {} end
	if not _ero[x][y] then _ero[x][y] = (geo(x,y) + depth) % 20183 end
	return _ero[x][y]
end

local _geo = {}
function geo(x,y)
	if x == 0 then return y * 48271 end
	if y == 0 then return x * 16807 end
	if x == tx and y == ty then return 0 end
	if not _geo[x] then _geo[x] = {} end
	if not _geo[x][y] then _geo[x][y] = ero(x-1,y) * ero(x,y-1) end
	return _geo[x][y]
end

function typ(x,y)
	return ero(x,y) % 3
end

local dir = {
	N = function (x,y) return x,y+1 end,
	E = function (x,y) return x+1,y end,
	S = function (x,y) return x,y-1 end,
	W = function (x,y) return x-1,y end,
}

local opp = {
	N = 'S',
	E = 'W',
	S = 'N',
	W = 'E',
}

local graph = {}
graph.V = {}

function graph.get(x,y,o)
	local t = string.format('%d %d %d',x,y,o)
	local v = graph.V[t] or {x=x,y=y,o=o}
	graph.V[t] = v
	return graph.V[t]
end

function graph.adj(x,y,o)
	local v = graph.get(x,y,o)
	if graph[v] then
		return graph[v]
	end
	local adj = {}
	local t = typ(x,y)
	table.insert(adj, {v=graph.get(x, y, ((o==t) and (t+1) or t) % 3),cost=7})
	for d,f in pairs(dir) do
		local i,j = f(x,y)
		if i >= 0 and j >=0 then
			local tt = typ(i,j)
			if o == tt or o == (tt+1) % 3 then
				table.insert(adj, {v=graph.get(i,j,o),cost=1})
			end
		end
	end
	graph[v] = adj
	return adj
end

function h(x,y)
	return math.abs(x-tx) + math.abs(y-ty)
end


local Heap = {}
Heap.__index = Heap
function Heap.new()
	local t = setmetatable({}, Heap)
	Heap[t] = {}
	return t
end

function Heap:add(item, v)
	local self = Heap[self]
	local pos = #self+1
	local prev = pos // 2
	while prev > 0 and self[prev].prior > v do
		self[pos], pos, prev = self[prev], prev, prev // 2
	end
	self[pos] = { item=item, prior=v }
end

function Heap:pop()
	local self = Heap[self]
	local item = self[1].item
	self[1] = self[#self]
	self[#self] = nil
	local i = 1
	while true do
		local j = i
		if self[2*i] and self[2*i].prior < self[j].prior then
			j = 2*i
		end
		if self[2*i+1] and self[2*i+1].prior < self[j].prior then
			j = 2*i+1
		end
		if i == j then break end
		self[i], self[j] = self[j], self[i]
		i = j
	end
	return item
end

function Heap:empty()
	local self = Heap[self]
	return #self == 0
end

function Heap:flush()
	Heap[self] = {}
end

local visited = {}
local father = {}
local heap = Heap.new()
local target = graph.get(tx,ty,0)
heap:add({ v=graph.get(0,0,0), cost=0 },0)
local x,y = -1,-1
while not heap:empty() do
	local item = heap:pop()

	if not visited[item.v] then
		--print(item.v.x, item.v.y, item.cost)
		visited[item.v] = item.cost
		father[item.v] = item.prev

		if item.v == target then
			break
		end

		for _,v in ipairs(graph.adj(item.v.x, item.v.y, item.v.o)) do
			if not visited[v.v] then
				heap:add({ prev=item.v, v=v.v, cost = item.cost + v.cost }, item.cost + v.cost + h(v.v.x,v.v.y))
			end
		end
	end
end


print(visited[target])
