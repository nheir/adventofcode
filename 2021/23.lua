local timer = (require "timer")()

io.read('l')
io.read('l')

local r2 = {}
for c in io.read('l'):gmatch("[ABCD]") do
	r2[#r2+1] = string.byte(c) - string.byte('A') + 1
end

local r1 = {}
for c in io.read('l'):gmatch("[ABCD]") do
	r1[#r1+1] = string.byte(c) - string.byte('A') + 1
end

local pA = { r1[1], r2[1] }
local pB = { r1[2], r2[2] }
local pC = { r1[3], r2[3] }
local pD = { r1[4], r2[4] }

local rpos = {
	[3]=true, [5]=true, [7]=true, [9]=true
}
local scost = {1,10,100,1000}

local function atoi(a,s)
	local i=0
	for _,k in ipairs(a) do
		i = (i << s) | k
	end
	return i
end

local function key(state)
	local h = atoi(state.hallway, 3) -- 33bits
	local r1 = atoi(state.r[1], 3)
	local r2 = atoi(state.r[2], 3)
	local r3 = atoi(state.r[3], 3)
	local r4 = atoi(state.r[4], 3)
	return r1 | (r2 << 6) | (r3 << 12) | (r4 << 18) | (h << 24)
end

local function dup(state)
	return {
		hallway={table.unpack(state.hallway)},
		r={
			{table.unpack(state.r[1])},
			{table.unpack(state.r[2])},
			{table.unpack(state.r[3])},
			{table.unpack(state.r[4])},
		}
	}
end

local function roomOk(r, v)
	for _,k in ipairs(r) do
		if k ~= v then return false end
	end
	return true
end

local function neigh(state, size)
	size = size or 2
	local states = {}
	for i=1,11 do
		if state.hallway[i] > 0 then
			local d = state.hallway[i]
			if roomOk(state.r[d], d) then
				local s = false
				-- is move possible
				for j=i+1,2*d+1 do
					if state.hallway[j] > 0 then break end
					if j == 2*d+1 then
						s = (size - #state.r[d] + j - i) * scost[d]
					end
				end
				for j=i-1,2*d+1,-1 do
					if state.hallway[j] > 0 then break end
					if j == 2*d+1 then
						s = (size - #state.r[d] + i - j) * scost[d]
					end
				end
				if s then
					local s, cost = dup(state), s
					s.hallway[i] = 0
					table.insert(s.r[d], d)
					s.cost = cost + state.cost
					table.insert(states, s)
				end
			end
		elseif not rpos[i] then
			for j=i+1,11 do
				if state.hallway[j] > 0 then break end
				if rpos[j] then
					local d = j // 2
					if not roomOk(state.r[d], d) then
						local s = dup(state)
						local top = table.remove(s.r[d])
						s.hallway[i] = top
						s.cost = (size - #s.r[d] + j - i) * scost[top] + state.cost
						table.insert(states, s)
					end
				end
			end
			for j=i-1,1,-1 do
				if state.hallway[j] > 0 then break end
				if rpos[j] then
					local d = j // 2
					if not roomOk(state.r[d], d) then
						local s = dup(state)
						local top = table.remove(s.r[d])
						s.hallway[i] = top
						s.cost = (size - #s.r[d] + i - j) * scost[top] + state.cost
						table.insert(states, s)
					end
				end
			end
		end
	end
	return states
end

local function insert(t, v, state)
	local k = #t+1
	while k > 1 and t[k>>1].v > v do
		t[k] = t[k>>1]
		k = k >> 1
	end
	t[k] = { v=v, state=state }
end

local function pop(t)
	local ret = t[1]
	local v = table.remove(t)
	local i = 1
	while t[2*i] do
		local m = i
		t[i] = v
		if t[2*i].v < t[m].v then m = 2*i end
		if t[2*i+1] and t[2*i+1].v < t[m].v then m = 2*i+1 end
		if m == i then break end
		t[i] = t[m]
		i = m
	end
	t[i] = v
	return ret
end

local function print_state(state, size)
	size = size or 2
	for i,k in ipairs(state.hallway) do
		io.write(tostring(k))
	end
	io.write('\n')
	for j=size,1,-1 do
		io.write('  ')
		for i=1,4 do
			io.write(tostring(state.r[i][j] or 0), ' ')
		end
		io.write('\n')
	end
end

local endStateKey = key({
	hallway={0,0,0,0,0,0,0,0,0,0,0},
	r={{1,1},{2,2},{3,3},{4,4}},
})

local hallway = {0,0,0,0,0,0,0,0,0,0,0}
local start = {hallway=hallway, r={pA, pB, pC, pD}, cost=0}
local queue = {}
local seen = {}
insert(queue, 0, start)

local counter = 0
local duplicates = 0

while #queue > 0 do
	local top = pop(queue).state
	local k = key(top)
	if not seen[k] then
		counter = counter + 1
		seen[k] = true
		if k == endStateKey then
			print_state(top)
			print(top.cost)
			break
		end
		for _,s in ipairs(neigh(top)) do
			insert(queue, s.cost, s)
		end
	else
		duplicates = duplicates + 1
	end
end

timer:log(string.format("Visited: %d, duplicates: %d, still in queue: %d", counter, duplicates, #queue))

local function longkey(state)
	local h = atoi(state.hallway, 3)
	local r1 = atoi(state.r[1], 3)
	local r2 = atoi(state.r[2], 3)
	local r3 = atoi(state.r[3], 3)
	local r4 = atoi(state.r[4], 3)
	return h, r1 | (r2 << 12) | (r3 << 24) | (r4 << 36)
end

local endStateKey1,endStateKey2 = longkey({
	hallway={0,0,0,0,0,0,0,0,0,0,0},
	r={{1,1,1,1},{2,2,2,2},{3,3,3,3},{4,4,4,4}},
})

local hallway = {0,0,0,0,0,0,0,0,0,0,0}
local start = {
	hallway=hallway,
	r={
		{pA[1], 4, 4, pA[2]},
		{pB[1], 2, 3, pB[2]},
		{pC[1], 1, 2, pC[2]},
		{pD[1], 3, 1, pD[2]},
	},
	cost=0
}

local queue = {}
local seen = {}
local counter = 0
local duplicates = 0
insert(queue, 0, start)

while #queue > 0 do
	local top = pop(queue).state
	local k1, k2 = longkey(top)
	if not seen[k1] or not seen[k1][k2] then
		counter = counter + 1
		seen[k1] = seen[k1] or {}
		seen[k1][k2] = true
		if k1 == endStateKey1 and k2 == endStateKey2 then
			print_state(top, 4)
			print(top.cost)
			break
		end
		for _,s in ipairs(neigh(top, 4)) do
			insert(queue, s.cost, s)
		end
	else
		duplicates = duplicates + 1
	end
end

timer:log(string.format("Visited: %d, duplicates: %d, still in queue: %d", counter, duplicates, #queue))