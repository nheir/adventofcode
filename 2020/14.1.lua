local mem = {}
local mask0 = -1
local mask1 = 0

for l in io.lines() do
	if l:sub(1,4) == 'mask' then
		local m = l:sub(8)
		mask0 = 0
		mask1 = 0
		for c in m:gmatch('.') do
			mask0 = (mask0 << 1)
			mask1 = (mask1 << 1)
			if c == 'X' then
				mask0 = mask0 | 1
			elseif c == '1' then
				mask1 = mask1 | 1
			elseif c == '0' then
			end
		end
	else
		local a, v = l:match('mem%[(%d+)%] = (%d+)')
		a,v = tonumber(a), tonumber(v)
		mem[a] = (v & mask0) | mask1
	end
end

local res = 0
for _,v in pairs(mem) do
	res = res + v
end
print(res)
