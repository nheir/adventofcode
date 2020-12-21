local t = {}

for l in io.lines() do
	local n = tonumber(l)
	if t[n] then print(n*(2020-n)) break end
	t[2020-n] = true
end
