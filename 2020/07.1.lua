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

p['shiny gold'] = true

for _ in pairs(t) do
	for a,c in pairs(t) do
		for b in pairs(c) do
			if p[b] then
				p[a] = true
				break
			end
		end
	end
end

local c = -1
for a in pairs(t) do if p[a] then c = c + 1 end end
print(c)