local timer = (require "timer")()
local t = {}

for l in io.lines() do
	local r = {}
	for d in l:gmatch('%d') do r[#r+1] = tonumber(d) end
	if #r > 0 then t[#t+1] = r end
end
timer:log('Read')

local function flood(i,j,marked)
	if marked[(i<<16)|j] then return 0 end
	marked[(i<<16)|j] = true
	local s = 1
	for x=i-1,i+1 do
		if t[x] then
			for y=j-1,j+1 do
				if t[x][y] then
					t[x][y] = t[x][y] + 1
					if t[x][y] > 9 then
						t[x][y] = -1
						s = s + flood(x,y, marked)
					end
				end
			end
		end
	end
	return s
end

local function step()
	local p = {}
	for i,r in ipairs(t) do
		for j,v in ipairs(r) do
			r[j] = v+1
			if v >= 9 then
				p[#p+1] = {i,j}
			end
		end
	end
	local s = 0
	local m = {}
	for _,pair in pairs(p) do
		local i,j = table.unpack(pair)
		s = s + flood(i,j,m)
	end
	for v in pairs(m) do
		local i,j = v >> 16, v & 0xffff
		t[i][j] = 0
	end
	return s
end

local ret = 0
for i=1,100 do
	ret = ret + step()
end

timer:log('100 steps')
print(ret)

local ret = 0
for i=101,math.huge do
	if step() == 100 then
		ret = i
		break
	end
end

timer:log('Sync flash')
print(ret)