local m = 0
local t = {}
for l in io.lines() do
	local i,j = 0,128
	for k=1,7 do
		if l:sub(k,k) == 'F' then
			j = (i+j) // 2
		else
			i = (i+j) // 2
		end
	end
	local row = i
	i,j = 0,8
	for k=8,10 do
		if l:sub(k,k) == 'L' then
			j = (i+j) // 2
		else
			i = (i+j) // 2
		end
	end
	local col = i
	t[8*row+col] = true
end

for i=1,128*8+7 do
	if  t[i-1] and  t[i+1] and not t[i] then
		print(i)
	end
end