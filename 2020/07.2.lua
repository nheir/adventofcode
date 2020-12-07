local t = {}

for l in io.lines() do
	local ty, reste = l:match('([%w%s]+) bags? contain (.*)')
	local content = {}
	for v,t in reste:gmatch('(%d+) ([%w%s]+) bags?') do
		content[t] = tonumber(v)
	end
	t[ty] = content
end

local p = {}

for _ in pairs(t) do
	for a,c in pairs(t) do
		local tot = 0
		for b,am in pairs(c) do
			tot = tot + am * (p[b] or 0) + am
		end
		p[a] = tot
	end
end

print(p['shiny gold'])