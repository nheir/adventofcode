local t = {}

local x = 0
local y = 0
local aim = 0
for l in io.lines() do
	local cmd, v = l:match('(%S+) (%d+)')
	if cmd == 'forward' then
		x = x + tonumber(v)
		y = y + tonumber(v)*aim
	elseif cmd == 'down' then
--		y = y + tonumber(v)
		aim = aim + tonumber(v)
	elseif cmd == 'up' then
--		y = y - tonumber(v)
		aim = aim - tonumber(v)
	end
end

print(x*aim)
print(x*y)
