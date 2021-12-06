local t = {[0]=0,0,0,0,0,0,0,0,0}

local a = io.read('l')
for d in a:gmatch("%d+") do
	t[tonumber(d)] = (t[tonumber(d)] or 0) + 1
end

local function step(t)
	local z = t[0]
	for i=1,8 do t[i-1] = t[i] end
	t[8] = z
	t[6] = t[6]+z
end

for i=1,80 do
	step(t)
end

local s = 0
for i=0,8 do s = s + t[i] end
print(s)

for i=81,256 do
	step(t)
end

local s = 0
for i=0,8 do s = s + t[i] end
print(s)