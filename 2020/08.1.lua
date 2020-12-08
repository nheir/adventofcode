local p = {}
for l in io.lines() do
	local cmd, n = l:match('(%w+) ([+-]%d+)')
	n = tonumber(n)
	p[#p+1] = { cmd=cmd, val=n}
end

local acc = 0
local hasrun = {}
local pc = 1
while not hasrun[pc] do
	hasrun[pc] = true
	if p[pc].cmd == 'acc' then
		acc = acc + p[pc].val
		pc = pc + 1
	elseif p[pc].cmd == 'jmp' then
		pc = pc + p[pc].val
	elseif p[pc].cmd == 'nop' then
		pc = pc + 1
	end
end

print(acc)