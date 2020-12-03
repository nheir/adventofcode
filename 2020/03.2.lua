local t = {}

local function split(s)
	local t = {}
	for c in s:gmatch('.') do
		t[#t+1] = c
	end
	return t
end

for l in io.lines() do
	t[#t+1] = split(l)
end

local tot = 1
for _,p in pairs{1,3,5,7} do
	local count = 0
	for i=1,#t do
		if t[i][(i-1)*p % #t[i] + 1] == '#' then count = count + 1
		end
	end
	tot = tot * count
end

local count = 0
for i=1,#t,2 do
	if t[i][((i-1)/2) % #t[i] + 1] == '#' then count = count + 1
	end
end
tot = tot * count

print(tot)