local t = {}

local score = {
	[')'] = 3,
	[']'] = 57,
	['}'] = 1197,
	['>'] = 25137,
}

local score2 = {
	[')'] = 1,
	[']'] = 2,
	['}'] = 3,
	['>'] = 4,
}

local rev = {
	['('] = ')',
	['['] = ']',
	['{'] = '}',
	['<'] = '>',
}

local ret = 0
local ret2 = {}

for l in io.lines() do
	local s = {}
	local ok = true
	for c in l:gmatch('.') do
		if rev[c] then
			table.insert(s, rev[c])
		elseif c == s[#s] then
			s[#s] = nil
		else
			ret = ret + score[c]
			ok = false
			break
		end
	end
	if ok then
		local v = 0
		for i=#s,1,-1 do
			v = 5*v + score2[s[i]]
		end
		table.insert(ret2, v)
	end
end

print(ret)

table.sort(ret2)
print(ret2[(#ret2+1) >> 1])
