local timer = (require "timer")()
local t = {}

local function linear(t, acc, d)
	acc = acc or {}
	d = d or 0
	if type(t) == 'number' then
		table.insert(acc, { v=t, d=d})
	else
		linear(t[1], acc, d+1)
		linear(t[2], acc, d+1)
	end
	return acc
end

for l in io.lines() do
	if l:sub(1,1) == '[' then
		l = 'return ' .. l:gsub('[%[%]]', { ['['] = '{', [']'] = '}' })
		t[#t+1] = linear(load(l)())
	end
end
timer:log("Read and linearize")

local function sum(a,b)
	local t = {}
	for _,p in ipairs(a) do
		table.insert(t, {v=p.v, d=p.d+1})
	end
	for _,p in ipairs(b) do
		table.insert(t, {v=p.v, d=p.d+1})
	end
	return t
end

local function reduce(a)
	local i = 1
	while i <= #a and a[i].d < 5 do i = i+1 end
	if i > #a then return false end
	if i > 1 then
		a[i-1].v = a[i-1].v + a[i].v
	end
	if i +1 < #a then
		a[i+2].v = a[i+2].v + a[i+1].v
	end
	a[i].v = 0
	a[i].d = a[i].d - 1
	table.remove(a, i+1)
	return true
end

local function split(a)
	local i = 1
	while i <= #a and a[i].v < 10 do i = i+1 end
	if i > #a then
		return false
	end
	local v = a[i].v // 2
	table.insert(a, i+1, { v=a[i].v - v, d=a[i].d+1 })
	a[i].v = v
	a[i].d = a[i].d+1
	return true
end

local function full_sum(a,b)
	a = sum(a,b)
	while true do
		if reduce(a) then
		elseif split(a) then
		else break end
	end
	return a
end

local function unlinear(a,i,d)
	i = i or 1
	d = d or 0
	if a[i].d == d then
		return a[i].v, i+1
	end
	local v1, j = unlinear(a, i, d+1)
	local v2, j = unlinear(a, j, d+1)
	return {v1, v2}, j
end

local function magnitude(a)
	if type(a) == 'number' then return a end
	return 3*magnitude(a[1]) + 2*magnitude(a[2])
end


local a = t[1]
for i=2,#t do
	a = full_sum(a, t[i])
end
timer:log("Sum of all")

local number = unlinear(a)
timer:log("De-linearize")
print(magnitude(number))

local max = 0
for i=1,#t do
	for j=i+1,#t do
		local v = magnitude(unlinear(full_sum(t[i],t[j])))
		if v > max then max = v end
		local v = magnitude(unlinear(full_sum(t[j],t[i])))
		if v > max then max = v end
	end
end
timer:log("All sums")

print(max)