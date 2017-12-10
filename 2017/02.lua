#!/usr/bin/env lua

function first()
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
	return res
end

function second()
	local res = 0
	for s in io.lines() do
		local t = {}
		for d in s:gmatch('%d+') do
			table.insert(t, tonumber(d))
		end
		if #t == 0 then break end
		local b = false
		for i=1,#t do for j=i+1,#t do
			if t[i] % t[j] == 0 then res = res + t[i] / t[j] b = true end
			if t[j] % t[i] == 0 then res = res + t[j] / t[i] b = true end
			if b then break end
		end if b then break end end
	end
	return res
end

-- print(first())
print(second())
