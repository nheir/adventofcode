local t = {}
local m = 0
for a in io.lines() do
	-- assert(not t[tonumber(a)])
	t[tonumber(a)] = true
	m = math.max(m, tonumber(a))
end

t[0] = true
t[m+3] = true

local count = {}
count[m+1] = 0
count[m+2] = 0
count[m+3] = 1

for i=m,0,-1 do
	count[i] = 0
	if t[i] then
		for k=1,3 do
			count[i] = count[i] + count[i+k]
		end
	end
end

print(count[0])