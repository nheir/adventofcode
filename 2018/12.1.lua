local function f(init,rules)
	local m,M = 0,#init
	for _=1,20 do
		local t = {}
		for i=m-4,M+4 do
			local r = 0
			for j=-2,2 do
				r = (r << 1) + (init[i+j] or 0)
			end
			t[i] = rules[r]
		end
		m = m-4
		for i=m,M+4 do
			if t[i] == 1 then
				break
			end
			t[i] = nil
			m = m+1
		end
		M = M+4
		for i=M,m,-1 do
			if t[i] == 1 then
				break
			end
			t[i] = nil
			M = M-1
		end
		init = t;
	end

	local ret = 0
	for k,v in pairs(init) do
		ret = ret + v*k
	end

	return ret
end

local buf = io.read('l')
local init = {}
local it = 0
for c in buf:gmatch('[.#]') do
	init[it] = (c == '.') and 0 or 1
	it = it + 1
end

buf = io.read('a')
local rules = {}
for input,res in buf:gmatch('([.#]+) => ([.#])') do
	local r = 0
	for s=1,5 do
		r = r << 1
		if input:sub(s,s) == '#' then
			r = r + 1
		end
	end
	rules[r] = (res == '.') and 0 or 1
end

print(f(init,rules))