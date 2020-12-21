local t = 0
for l in io.lines() do
	local stack = {}
	local ret = 0
	local i = 1
	while i <= #l do
		if l:sub(i,i) == ' ' then
			i = i + 1
		elseif l:sub(i,i) == '(' then
			table.insert(stack, '(')
			i = i + 1
		elseif l:sub(i,i) == ')' then
			while type(stack[#stack]) == 'number' and stack[#stack-1] == '*' do
				stack[#stack-2] = stack[#stack-2] * stack[#stack]
				stack[#stack] = nil
				stack[#stack] = nil
			end
			table.remove(stack, #stack-1)
			i = i + 1
		elseif l:sub(i,i) == '*' then
			table.insert(stack, '*')
			i = i + 1
		elseif l:sub(i,i) == '+' then
			table.insert(stack, '+')
			i = i + 1
		else -- number
			local a,b,n = l:find('^(%d+)',i)
			table.insert(stack, tonumber(n))
			i = b + 1
		end
		if type(stack[#stack]) == 'number' then
			if stack[#stack-1] == '+' then
				stack[#stack-2] = stack[#stack-2] + stack[#stack]
				stack[#stack] = nil
				stack[#stack] = nil
			end
		end
	end
	while type(stack[#stack]) == 'number' and stack[#stack-1] == '*' do
		stack[#stack-2] = stack[#stack-2] * stack[#stack]
		stack[#stack] = nil
		stack[#stack] = nil
	end
	t = t + stack[#stack]
end

print(t)
