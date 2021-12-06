local t = {}

local function key(i,j)
	return string.format("%d,%d", i, j)
end

local count = 0
for l in io.lines() do
	local x1,y1,x2,y2 = l:match('(%d+),(%d+) %-> (%d+),(%d+)')
	x1,y1,x2,y2 = tonumber(x1),tonumber(y1),tonumber(x2),tonumber(y2)
	local xs = (x1 == x2) and 0 or (x1 < x2) and 1 or -1
	local ys = (y1 == y2) and 0 or (y1 < y2) and 1 or -1
	while x1 ~= x2 or y1 ~= y2 do
		t[key(x1,y1)] = (t[key(x1,y1)] or 0) + 1
		if t[key(x1,y1)] == 2 then count = count + 1 end
		x1 = x1 + xs
		y1 = y1 + ys
	end
	t[key(x1,y1)] = (t[key(x1,y1)] or 0) + 1
	if t[key(x1,y1)] == 2 then count = count + 1 end
end

print(count)