local function f(n)
	local tab = {3,7}
	local l1,l2 = 1,2
	while #tab < n+10 do
		local r = tab[l1]+tab[l2]
		if r > 9 then
			table.insert(tab,1)
		end
		table.insert(tab,r%10)
		l1 = (l1+tab[l1]) % #tab + 1
		l2 = (l2+tab[l2]) % #tab + 1
	end
	return table.concat(tab, '', n+1, n+10)
end
print(f(io.read('n')))