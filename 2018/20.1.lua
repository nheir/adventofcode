function parse_list(buf,i)
	local r = {type='list'}
	local rr
	i = i-1
	repeat
		rr,i = parse_regex(buf,i+1)
		table.insert(r,rr)
	until buf:sub(i,i) == ')'
	return r,i
end

function parse_regex(buf,i)
	local r = {type='cat'}
	while i < #buf do
		local c = buf:sub(i,i)
		if c == 'N' or c == 'E' or c == 'S' or c == 'W' then
			table.insert(r,c)
			i = i + 1
		elseif c == '(' then
			local rr
			rr, i = parse_list(buf, i+1)
			table.insert(r,rr)
			i = i + 1
		else
			return r,i
		end
	end
	return r
end

io.read(1)
local regex = parse_regex(io.read('l'),1)

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

local function tuple(x,y)
	return string.format('%d %d', x,y)
end

local graph = {}
graph.V = {}

function graph.get(x,y)
	local v = graph.V[tuple(x,y)] or {x=x,y=y}
	graph.V[tuple(x,y)] = v
	graph[v] = graph[v] or {}
	return v
end

function graph.add(x,y,D)
	local i,j = dir[D](x,y)
	local a = graph.get(x,y)
	local b = graph.get(i,j)
	graph[a][D] = b
	graph[b][opp[D]] = a
end

local function build_graph(pos,r)
	local next_pos = {}
	if r == 'N' or r == 'S' or r == 'E' or r == 'W' then
		for _,p in ipairs(pos) do
			local x,y = table.unpack(p)
			graph.add(x,y,r)
			table.insert(next_pos,{dir[r](x,y)})
		end
	elseif r.type == 'cat' then
		for i=1,#r do
			pos = build_graph(pos,r[i])
		end
		next_pos = pos
	elseif r.type == 'list' then
		local tmp = {}
		for i=1,#r do
			for _,p in ipairs(build_graph(pos,r[i])) do
				tmp[tuple(table.unpack(p))] = p
			end
		end
		for _,p in pairs(tmp) do
			table.insert(next_pos, p)
		end
	end

	return next_pos
end

build_graph({{0,0}}, regex)

local m = 0
local to_visit = {graph.get(0,0)}
local dists = {}
dists[graph.get(0,0)] = 0
while #to_visit > 0 do
	m = m + 1
	local next_visit = {}
	for _,u in ipairs(to_visit) do
		for d,v in pairs(graph[u]) do
			if not dists[v] then
				dists[v] = m
				table.insert(next_visit, v)
			end
		end
	end
	to_visit = next_visit
end

print(m-1)