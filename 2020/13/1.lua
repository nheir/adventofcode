local dep = io.read('n')
local rest = io.read('a')

local m = dep
local res = 0
for n in rest:gmatch("%d+") do
	n = tonumber(n)
	local nm = (-dep)%n
	if nm <= m then
		m = nm
		res = nm*n
	end
end

print(res)