local t = {}

for l in io.lines() do
	table.insert(t, tonumber(l))
end

local ret = 0
for i=2, #t do 
	if t[i-1] < t[i] then
		ret = ret + 1
	end
end

print(ret)

local ret = 0
for i=4,#t do
	if t[i-3] < t[i] then
		ret = ret + 1
	end
end

print(ret)
