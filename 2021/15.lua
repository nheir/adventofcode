function key(i,j)
	return (i<<16)|j
end

function skey(k)
	return (k>>16),k&0xffff
end

local timer = (require "timer")()
local t = {}

local w,h = 0,0
for l in io.lines() do
	local r = {}
	for d in l:gmatch('%d') do r[#r+1] = tonumber(d) end
	if #r > 0 then
		t[#t+1] = r
		w = #r
	end
end
h = #t
timer:log('Read')

local function insert(t, v, ij)
	local k = #t+1
	while k > 1 and t[k>>1].v > v do
		t[k] = t[k>>1]
		k = k >> 1
	end
	t[k] = { v=v, k=ij }
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


local q = {{v=0,k=key(1,1)}}
local r = {}
while q[1] do
	local p = pop(q)
	if not r[p.k] then
		r[p.k] = p.v
		if p.k == key(h,w) then break end
		local i,j = skey(p.k)
		for _,ij in ipairs {{i-1,j}, {i+1,j}, {i,j-1}, {i,j+1}} do
			local x,y = table.unpack(ij)
			if t[x] and t[x][y] and not r[key(x,y)]then
				insert(q, p.v + t[x][y], key(x,y))
			end
		end
	end
end

timer:log('Part 1')
print(r[key(h,w)])


local q = {{v=0,k=key(1,1)}}
local r = {}
while q[1] do
	local p = pop(q)
	if not r[p.k] then
		r[p.k] = p.v
		if p.k == key(5*h,5*w) then break end
		local i,j = skey(p.k)
		for _,ij in ipairs {{i-1,j}, {i+1,j}, {i,j-1}, {i,j+1}} do
			local x,y = table.unpack(ij)
			if x >= 1 and x <= h*5 and y >= 1 and y <= 5*w then
				local v = t[(x-1)%h+1][(y-1)%w+1]
				v = v + ((x-1) // h) + ((y-1) // w)
				v = (v-1)%9+1
				if not r[key(x,y)] then
					insert(q, p.v + v, key(x,y))
				end
			end
		end
	end
end

timer:log('Part 2')
print(r[key(5*h,5*w)])