local p = {}
for l in io.lines() do
	local cmd, n = l:match('(%w+) ([+-]%d+)')
	n = tonumber(n)
	p[#p+1] = { cmd=cmd, val=n}
end

local swap = {nop='jmp', jmp='nop'}
local size = #p
for k=1,size do
	if p[k].cmd ~= 'acc' then
		p[k].cmd = swap[p[k].cmd]
		local acc = 0
		local hasrun = {}
		local pc = 1
		while 0 <= pc and pc <= size and not hasrun[pc] do
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
		if pc == size+1 then
			print(acc)
			break
		end
		p[k].cmd = swap[p[k].cmd]
	end
end
