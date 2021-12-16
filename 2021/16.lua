local t = {}

local function get(s, i, n)
	local v = 0
	for k=i,i+n-1 do
		local j = ((k-1) >> 2)+1
		local k = 3 - ((k-1) & 3)
		v = (v << 1) | ((s[j] >> k) & 1)
	end
	return v
end

local function parseValue(s, cur)
	local value = 0
	repeat
		local continue = get(t, cur, 1)
		value = (value << 4) | get(t, cur+1, 4)
		cur = cur + 5
	until continue == 0
	return value, cur
end

local ops = {
	[0] = function (t) -- 0: sum
		local s = 0
		for i=1,#t do s = s + t[i] end
		return s
	end,
	function (t) -- 1: mul
		local s = 1
		for i=1,#t do s = s * t[i] end
		return s
	end,
	function (t) -- 2: min
		local s = t[1]
		for i=1,#t do if t[i] < s then s = t[i] end end
		return s
	end,
	function (t) -- 3: max
		local s = t[1]
		for i=1,#t do if t[i] > s then s = t[i] end end
		return s
	end,
	function () return 0 end, -- 4
	function (t) -- 5: greater than
		return (t[1] > t[2]) and 1 or 0
	end,
	function (t) -- 6: less than
		return (t[1] < t[2]) and 1 or 0
	end,
	function (t) -- 7: equal to
		return (t[1] == t[2]) and 1 or 0
	end,
}

local version_sum = 0

local function parse(s, c)
	local version = get(s, c, 3)
	version_sum = version_sum + version
	local id = get(s, c+3, 3)
	if id == 4 then
		return parseValue(s, c+6)
	else
		local values = {}
		local lengthID = get(s, c+6, 1)
		local cur = c+7
		if lengthID == 0 then
			local subLength = get(s, cur, 15)
			cur = cur + 15
			local n = cur
			while n - cur < subLength do
				values[#values+1], n = parse(s, n)
			end
			cur = n
		else
			local subNum = get(s, cur, 11)
			cur = cur + 11
			for i=1,subNum do
				values[#values+1], cur = parse(s, cur)
			end
		end
		return ops[id](values), cur
	end
end

local l = io.read('l')
for c in l:gmatch('[0-9A-F]') do
	table.insert(t, tonumber(c, 16))
end

local v = parse(t, 1)
print(version_sum)
print(v)