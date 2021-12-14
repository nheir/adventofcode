local timer = (require "timer")()

local counts = {}
local ccounts = {}

local input = io.read('l')
ccounts[input:sub(1,1)] = 1
for i=2,#input do
	local s = input:sub(i-1,i)
	local c = input:sub(i,i)
	counts[s] = (counts[s] or 0) + 1
	ccounts[c] = (ccounts[c] or 0) + 1
end

local rules = {}
for l in io.lines() do
	local a,b,c = l:match('(%S)(%S) %-> (%S)')
	if a then
		rules[a .. b] = { a .. c, c .. b, c }
	end
end
timer:log("Read")

local function step(counts)
	local ret = {}
	for k,v in pairs(counts) do
		local a,b,c = table.unpack(rules[k])
		ret[a] = (ret[a] or 0) + v
		ret[b] = (ret[b] or 0) + v
		ccounts[c] = (ccounts[c] or 0) + v
	end
	return ret
end

for i=1,10 do
	counts = step(counts)
end
timer:log("10 steps")

local m,M
for k,v in pairs(ccounts) do
	if not m or ccounts[m] > v then
		m = k
	end
	if not M or ccounts[M] < v then
		M = k
	end
end
print(ccounts[M]-ccounts[m])


for i=11,40 do
	counts = step(counts)
end
timer:log("+30 steps")

local m,M
for k,v in pairs(ccounts) do
	if not m or ccounts[m] > v then
		m = k
	end
	if not M or ccounts[M] < v then
		M = k
	end
end
print(ccounts[M]-ccounts[m])


