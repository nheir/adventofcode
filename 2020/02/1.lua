local d = 0

for l in io.lines() do
	local m, n, c, p = l:match('^(%d+)%-(%d+) (%w): (%w+)$')
	m = tonumber(m)
	n = tonumber(n)
	local count = 0
	for _ in p:gmatch(c) do count = count + 1 end
	if m <= count and count <= n then d = d + 1 end
end

print(d)