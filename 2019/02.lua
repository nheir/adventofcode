local tab = {}

for n in string.gmatch(io.read("a"), "%d+") do
	tab[#tab+1] = tonumber(n)
end

local mem = {}

for i=0,99 do
	for j=0,99 do
		table.move(tab, 1, #tab, 1, mem)
		mem[2] = i
		mem[3] = j

		local ctp = 1
		while mem[ctp] ~= 99 do
			a,b,c,d = table.unpack(mem, ctp, ctp+3)
			if a == 1 then
				mem[d+1] = mem[b+1] + mem[c+1]
			elseif a == 2 then
				mem[d+1] = mem[b+1] * mem[c+1]
			else
				break
			end
			ctp = ctp + 4
		end
		if mem[ctp] == 99 and mem[1] == 19690720 then
			print(string.format("%02d%02d",i,j))
			os.exit()
		end
	end
end