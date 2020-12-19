local rules = {}
for l in io.lines() do
	if l == '' then break end
	local rule = {}
	local prod, recep = l:match('(%d+): (.*)')
	for r in recep:gmatch('([^|]+)') do
		local term = r:match('"([ab])"')
		if term then table.insert(rule, {term})
		else
			local t = {}
			for n in r:gmatch('%d+') do
				table.insert(t, tonumber(n))
			end
			table.insert(rule, t)
		end
	end
	rules[tonumber(prod)] = rule
end

local lpeg = require "lpeg"

local function sum(t)
	local ret = t[1]
	for i=2,#t do ret=ret+t[i] end
	return ret
end

local function prod(t)
	local ret = t[1]
	for i=2,#t do ret=ret*t[i] end
	return ret
end

local lrules = {"v0", va=lpeg.P("a"),  vb=lpeg.P("b")}
for k in pairs(rules) do
	local vk = "v" .. tostring(k)
	for i,r in ipairs(rules[k]) do
		for j,n in ipairs(r) do
			r[j] = lpeg.V("v" .. tostring(n))
		end
		rules[k][i] = prod(r)
	end
	lrules[vk] = sum(rules[k])
end

local grammar = lpeg.P(lrules)

local c = 0
for l in io.lines() do
	local test = grammar:match(l) == #l+1
	if test then
		c = c + 1
	end
end
print(c)