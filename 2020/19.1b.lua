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

if arg[0] == '19.2b.lua' then
	rules[8] = {{42},{42,8}}
	rules[11] = {{42,31},{42,11,31}}
end

local valid, valids
function valids(mot, i, j, vs, vi)
	if vi == #vs then
		return valid(mot, i, j, vs[#vs])
	end
	for k=i,j-(#vs-vi) do
		if valid(mot,i,k,vs[vi]) and valids(mot,k+1,j,vs,vi+1) then
			return true
		end
	end
end

local cache = {}
function valid(mot, i, j, v)
	if type(v) == 'string' then
	 	return mot:sub(i,j) == v
	end
	local key = mot:sub(i,j) .. tostring(v)
	if cache[key] then
		return cache[key] == 1
	end
	for _,r in ipairs(rules[v]) do
		if valids(mot, i, j, r, 1) then
			cache[key] = 1
			return true
		end
	end
	cache[key] = 0
end

local c = 0
for l in io.lines() do
	local test = not not valid(l,1,#l,0)
	--print(test,l)
	if test then c = c + 1 end
end
print(c)
