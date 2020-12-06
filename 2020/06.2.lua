local t = 0

local g = -1

for l in io.lines() do
	if l == '' then
		for v=1,26 do
			t = t + (g & 1)
			g = g >> 1
		end
		g = -1
	else
		local p = 0
		for _,v in ipairs{string.byte(l,1,#l)} do
			p = p | (1<<(v-string.byte('a')))
		end
		g = g & p
	end
end

for v=1,26 do
	t = t + (g & 1)
	g = g >> 1
end
print(t)