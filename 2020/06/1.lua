local t = 0

local g = {}
for l in io.lines() do
	if l == '' then
		g = {}
	else
		for _,v in ipairs{string.byte(l,1,#l)} do
			t = t + (g[v] or 1)
			g[v] = 0
		end
	end
end

print(t)