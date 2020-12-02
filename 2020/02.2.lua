local d = 0

for l in io.lines() do
	local m, n, c, p = l:match('^(%d+)%-(%d+) (%w): (%w+)$')
	m = tonumber(m)
	n = tonumber(n)
	if (p:sub(m,m) == c and p:sub(n,n) ~= c) or (p:sub(m,m) ~= c and p:sub(n,n) == c) then d = d + 1 end
end

print(d)