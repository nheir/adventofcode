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

function comp(a,b)
	return a.cost + a.h < b.cost + b.h
end

function h(x,y)
	return math.abs(x-tx) + math.abs(y-ty)
end

local visited = {}
local father = {}
local queue = {}
local target = graph.get(tx,ty,0)
table.insert(queue, {v=graph.get(0,0,0), cost=0, h=h(0,0)})
local x,y = 0,0
while #queue > 0 do
	local item = queue[1]
	table.remove(queue,1)

	if item.v.x > x then
		x = item.v.x
		print(x, item.v.y, item.cost, item.h)
	end
	if item.v.y > y then
		y = item.v.y
		print(item.v.x, y, item.cost, item.h)
	end


	if not visited[item.v] then
		--print(item.v.x,item.v.y,item.cost)
		visited[item.v] = item.cost
		father[item.v] = item.prev

		if item.v == target then
			break
		end

		for _,v in ipairs(graph.adj(item.v.x, item.v.y, item.v.o)) do
			if not visited[v.v] then
				table.insert(queue, { prev=item.v, v=v.v, cost = item.cost + v.cost, h=h(v.v.x,v.v.y)})
			end
		end
		table.sort(queue, comp)
	end
end


print(visited[target])
-- local cost = 0
-- while target do
-- 	print(target.x, target.y, typ(target.x, target.y), target.o)
-- 	assert(typ(target.x, target.y) == target.o or (typ(target.x, target.y)+1) % 3 == target.o)
-- 	if father[target] then
-- 		local prev = father[target]
-- 		if target.x == prev.x and target.y == prev.y and target.o ~= prev.o then
-- 			cost = cost + 7
-- 		elseif math.abs(target.x - prev.x) == 1 and target.y == prev.y and target.o == prev.o then
-- 			cost = cost + 1
-- 		elseif target.x == prev.x and math.abs(target.y - prev.y) == 1 and target.o == prev.o then
-- 			cost = cost + 1
-- 		else
-- 			print(prev.x, prev.y, typ(prev.x, prev.y), prev.o)
-- 			assert(false)
-- 		end
-- 	end
-- 	target = father[target]
-- end

-- print(cost)