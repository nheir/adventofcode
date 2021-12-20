local timer = (require "timer")()

local function bin(a)
	local t = {}
	for c in a:gmatch('.') do
		table.insert(t, c == '#' and 1 or 0)
	end
	return t
end

local rule = bin(io.read('l'))

io.read('l')

local pic = {}
for l in io.lines() do
	if l:sub(1,1):find('[%.#]') then
		table.insert(pic, bin(l))
	end
end

local doAlt = rule[1] == 1

local function get(t, i, j, default)
	return t[i] and t[i][j] or default
end

local function step(t, default)
	local r = {}
	for i=1,#t+2 do
		r[i] = {}
		for j=1,#t+2 do
			local c = 0
			for pi=-2,0 do
				for pj=-2,0 do
					c = (c << 1)|get(t,i+pi, j+pj, default)
				end
			end
			r[i][j] = rule[c+1]
		end
	end
	return r
end

local count = 0
for _,v in ipairs(step(step(pic,0),doAlt and 1 or 0)) do
	for _,k in ipairs(v) do
		count = count + k
	end
end
timer:log("Two steps")
print(count)

local result = pic
local alt = 0
for i=1,50 do
	result = step(result, doAlt and alt or 0)
	alt = 1 - alt
end
timer:log("50 steps")

local count = 0
for _,v in ipairs(result) do
	for _,k in ipairs(v) do
		count = count + k
	end
end
print(count)