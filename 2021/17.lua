local l = io.read('l')
local t = {}
for d in l:gmatch("%-?%d+") do
	t[#t+1] = tonumber(d)
end
local x1, x2, y1, y2 = table.unpack(t)

-- assume y2 <=0
local h1 = y1*(y1+1)//2
print(h1)

-- assume x1 >= 0
local function t(vx, vy)
	local x,y = 0,0
	while x <= x2 and y >= y1 do
		if x >= x1 and y <= y2 then
			return 1
		end
		x, y, vx, vy = x + vx, y + vy, math.max(vx - 1, 0), vy - 1
	end
	return 0
end

local vxMax = x2
local vyMax = -y1

local ret = 0
for vy=-vyMax,vyMax-1 do
	for vx=0,vxMax do
		ret = ret + t(vx, vy)
	end
end
print(ret)
