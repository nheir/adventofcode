local t = {}
local nt = {}
local seq = {}

local i = 1
local last
for n in io.read('a'):gmatch('%d+') do
	n = tonumber(n)
	last = n
	t[n],nt[n] = nt[n],i
	i = i + 1
end

for j=i, 30000000 do
	if t[last] then
		last = nt[last] - t[last]
	else
		last = 0
	end
	t[last],nt[last] = nt[last],j
end

print(last)
