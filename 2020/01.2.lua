local ti = {}

for l in io.lines() do
	local n = tonumber(l)
	ti[n] = true
end

local t2 = {}
for i=1,2020 do
	for j=1,2020 do
		if ti[i] and ti[j] then
			t2[i+j] = i*j
		end
	end
end
local t3 = {}
for i=1,2020 do
	for j=1,2020 do
		if ti[i] and t2[j] then
			t3[i+j] = i*t2[j]
		end
	end
end

print(t3[2020])
