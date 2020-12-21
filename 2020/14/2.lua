local mem = {}
local mask = 0
local pos = {}

function w(a,b,p)
	if #p == 0 then
		mem[a] = b
	else
		local d = p[#p]
		table.remove(p)
		w(a & (~d),b,p)
		w(a | d,b,p)
		p[#p+1] = d
	end
end


for l in io.lines() do
	if l:sub(1,4) == 'mask' then
		local m = l:sub(8)
		mask = 0
		pos = {}
		local i = 35
		for c in m:gmatch('.') do
			mask = (mask << 1)
			if c == 'X' then
				pos[#pos+1] = 1 << i
			elseif c == '1' then
				mask = mask | 1
			elseif c == '0' then
			end
			i = i - 1
		end
	else
		local a, v = l:match('mem%[(%d+)%] = (%d+)')
		a,v = tonumber(a), tonumber(v)
		a = a | mask
		w(a,v,pos)
	end
end

local res = 0
for _,v in pairs(mem) do
	res = res + v
end
print(res)
