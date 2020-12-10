local t = {}
for a in io.lines() do
	t[#t+1] = tonumber(a)
end
table.sort(t)

local d = {[1] = 1, [3]= 1}
for i=2,#t do
	local di = t[i] - t[i-1]
	d[di] = (d[di] or 0) + 1
end
print(d[1] * d[3])
