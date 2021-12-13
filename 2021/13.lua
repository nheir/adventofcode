function key(i,j)
	return (i<<16)|j
end

function skey(k)
	return (k>>16),k&0xffff
end

local timer = (require "timer")()

local t = {}

local fold_in = {}
for l in io.lines() do
	local i,j = l:match("(%d+),(%d+)")
	if i then
		t[key(tonumber(i),tonumber(j))] = true
	end
	local c, v = l:match("fold along ([xy])=(%d+)")
	if c then
		table.insert(fold_in, { [c]=tonumber(v) })
	end
end
timer:log("Read")

local width = math.huge
local height = math.huge

for n,s in ipairs(fold_in) do
	if s.x then width = s.x-1 end
	if s.y then height = s.y-1 end
	local r = {}
	for k in pairs(t) do
		local i,j = skey(k)
		if s.x then
			if i == s.x then
			elseif i > s.x then
				r[key(s.x+s.x-i,j)] = true
			else
				r[k] = true
			end
		end
		if s.y then
			if j == s.y then
			elseif j > s.y then
				r[key(i,s.y+s.y-j)] = true
			else
				r[k] = true
			end
		end
	end
	t = r
	if n == 1 then
		local ret = 0
		for k in pairs(t) do
			ret = ret + 1
		end
		timer:log("1st fold")
		print(ret)
	end
end
timer:log("All folds")

for j=0,height do
	for i=0,width do
		io.write(t[key(i,j)] and '#' or '.')
	end
	io.write('\n')
end

