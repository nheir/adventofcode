local t = {}

local a = io.read('l')
local sum = 0
local count = 0
local max = 0
for d in a:gmatch("%d+") do
    d = tonumber(d)
	t[d] = (t[d] or 0) + 1
    sum = sum + d
    count = count + 1
    if d > max then max = d end
end

local j = 0
local mid = 0
for i=0,max do
    j = j + (t[i] or 0)
    mid = i
    if j >= count >> 1 then
        break
    end
end

local ret = 0
for d,r in pairs(t) do
    local dist = math.abs(d - mid)
    ret = ret + dist*r
end
print(ret)

local moy = math.floor(sum / count)

local floor = 0
local ceil = 0
for d,r in pairs(t) do
    local dist = math.abs(d - moy)
    floor = floor + (dist*(dist+1) >> 1)*r
    local dist = math.abs(d - moy - 1)
    ceil = ceil + (dist*(dist+1) >> 1)*r
end
print(math.min(floor, ceil))