local N,E,S,O = 0,1,2,3

local dir = {
	[N] = function (x,y) return x,y-1 end,
	[E] = function (x,y) return x+1,y end,
	[S] = function (x,y) return x,y+1 end,
	[O] = function (x,y) return x-1,y end,
}

local function print_graph(graph,lutins,w,h)
	local t = {}
	for j=0,h-1 do
		local s = {}
		for i=0,w-1 do
			s[i+1] = graph[j][i] or ' '
		end
		t[j+1] = s
	end
	for _,v in pairs(lutins) do
		t[v.y+1][v.x+1] = string.format('%d',v.d)
	end
	for i,v in ipairs(t) do
		t[i] = table.concat(v)
		print(t[i])
	end
	--print(table.concat(t, '\n'))
end

local function move(v,pos,graph)
	local x,y = dir[v.d](v.x,v.y)
	if pos[y][x] then 
		return false,x,y
	end
	pos[v.y][v.x] = nil
	v.x, v.y = x,y
	pos[y][x] = v
	if graph[y][x] == '\\' then
		v.d = (3-v.d)%4
	elseif graph[y][x] == '/' then
		v.d = (3*v.d+1)%4
	end
	if graph[y][x] == '+' then
		v.d = (v.d+v.s-1)%4
		v.s = (v.s + 1)%3
	end
	return true
end

local function f(graph, lutins, w, h)
	local pos = {}
	for j=0,h-1 do
		pos[j] = {}
	end
	for i,v in pairs(lutins) do
		v.s = 0
		v.i = i
		pos[v.y][v.x] = v
	end
	local t = 1
	while true do
		table.sort(lutins,function (a,b) return a.y < b.y or (a.y == b.y and a.x < b.x) end)
		for i,v in ipairs(lutins) do
			local b,x,y = move(v, pos, graph)
			if not b then
				return x,y,t
			end
		end
		t = t+1
	end
end

local graph = {}
local w = 1

local lutins = {}

local j = 0
for l in io.lines() do
	graph[j] = {}
	w = math.max(#l,w)
	for i=1,#l do
		local c = l:sub(i,i)
		local i = i-1
		if c == '<' then
			table.insert(lutins,{x=i,y=j,d=O})
			graph[j][i] = '-'
		elseif c == '^' then
			table.insert(lutins,{x=i,y=j,d=N})
			graph[j][i] = '|'
		elseif c == '>' then
			table.insert(lutins,{x=i,y=j,d=E})
			graph[j][i] = '-'
		elseif c == 'v' then
			table.insert(lutins,{x=i,y=j,d=S})
			graph[j][i] = '|'
		elseif c ~= ' ' then
			graph[j][i] = c
		end
	end
	j = j + 1
end

local h = j

print(f(graph,lutins, w, h))