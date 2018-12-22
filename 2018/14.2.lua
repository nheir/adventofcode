local function f(n)
	local goal = {}
	local mod = 10 ^ #(tostring(n))
	local tab = {3,7}
	local l1,l2 = 1,2
	local m = 37
	while m ~= n do
		local r = tab[l1]+tab[l2]
		if r > 9 then
			table.insert(tab,1)
			m = (10*m+1)%mod
			if m == n then break end
		end
		table.insert(tab,r%10)
		m = (10*m+(r%10))%mod
		l1 = (l1+tab[l1]) % #tab + 1
		l2 = (l2+tab[l2]) % #tab + 1
	end
	return #tab-#(tostring(n))
end
print(f(io.read('n')))