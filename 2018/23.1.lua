local nanobots = {}
for l in io.lines() do
	local x,y,z,r = l:match('pos=<(%-?%d+),(%-?%d+),(%-?%d+)>, r=(%d+)')
	x = tonumber(x)
	y = tonumber(y)
	z = tonumber(z)
	r = tonumber(r)
	table.insert(nanobots,{x=x,y=y,z=z,r=r})
end

local function dist(a,b)
	return math.abs(a.x-b.x)+math.abs(a.y-b.y)+math.abs(a.z-b.z)
end

local strong = nanobots[1]
for _,a in pairs(nanobots) do
	if strong.r < a.r then
		strong = a
	end
end

local ca = 0
for _,b in pairs(nanobots) do
	if dist(strong,b) <= strong.r then
		ca = ca + 1
	end
end

print(ca)

