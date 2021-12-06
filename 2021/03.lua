local t = {}
local val = {}

local size = 0

local n = 0
for l in io.lines() do 
	local i = 1
	for c in l:gmatch('[01]') do
		t[i] = (t[i] or 0) + string.byte(c) - string.byte('0')
		i = i + 1
	end
	if i > 2 then 
		table.insert(val, tonumber(l, 2))
		size = i-1
		n = n + 1 
	end
end

local gamma = 0
local epsilon = 0

for i,v in ipairs(t) do
	gamma = gamma << 1
	epsilon = epsilon << 1
	if v > n / 2 then
		gamma = gamma + 1
	else
		epsilon = epsilon + 1
	end
end

print(n, gamma, epsilon)
print(gamma*epsilon)

table.sort(val)

local li, lj, ci, cj = 1, #val, 1, #val

local p = size
for i=size,0,-1 do
	if li == lj then break end
	local n = li
	while n <= lj and val[n] & (1 << i) == 0 do n = n + 1 end
	if (n-li) <= (lj-li+1)/2 then
		li = n
	else
		lj = n-1
	end
end
local p = size
for i=size,0,-1 do
	if ci == cj then break end
	local n = ci
	while n <= cj and val[n] & (1 << i) == 0 do n = n + 1 end
	if (n-ci) <= (cj-ci+1)/2 then
		cj = n - 1
	elseif n <= lj then
		ci = n
	end
end

print(ci, cj, val[ci])
	
print(val[ci]*val[li])
