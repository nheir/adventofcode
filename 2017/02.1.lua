#!/usr/bin/env lua

local res = 0
for s in io.lines() do
	local m,M
	for d in s:gmatch('%d+') do
		d = tonumber(d)
		if not m or m > d then m = d end
		if not M or M < d then M = d end
	end
	if m and M then res = res + M - m end
end
print(res)

