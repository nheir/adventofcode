local rules = {}

local function parse_rule(l)
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
	return tonumber(prod), rule
end

for l in io.lines() do
	if l == '' then break end
	local prod, rule = parse_rule(l)
	rules[prod] = rule
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

local lrules = {
	"S",
	S=lpeg.V("V0"),
	Va=lpeg.P("a"),
	Vb=lpeg.P("b")
}
for k in pairs(rules) do
	local vk = "V" .. tostring(k)
	for i,r in ipairs(rules[k]) do
		for j,n in ipairs(r) do
			r[j] = lpeg.V("V" .. tostring(n))
		end
		rules[k][i] = prod(r)
	end
	lrules[vk] = sum(rules[k])
end

lrules.V8 = lpeg.V('V42') ^ 1
lrules.V11 = lpeg.V('V42') * (lpeg.V("V11") ^ -1) * lpeg.V('V31')

lrules[1] = 'V8'
local grammar8 = lpeg.P(lrules)
lrules[1] = 'V11'
local grammar11 = lpeg.P(lrules)

local c = 0
for l in io.lines() do
	local ok = false
	for j=1,#l-1 do
		local t8 = grammar8:match(l:sub(1,j)) == j+1
		local t11 = grammar11:match(l:sub(j+1,#l)) == #l-j+1
		if t8 and t11 then
			ok = true
			c = c + 1
			break
		end
	end
end
print(c)