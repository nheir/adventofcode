local tab = {}

for n in string.gmatch(io.read("a"), "%-?%d+") do
	tab[#tab+1] = tonumber(n)
end

local mem = {}

table.move(tab, 1, #tab, 0, mem)

local function take_input()
	-- return 1 -- part 1
	return 5 -- part 2
end

local nparams = {
	[1] = 3,
	[2] = 3,
	[3] = 1,
	[4] = 1,
	[5] = 2,
	[6] = 2,
	[7] = 3,
	[8] = 3,
}

local ctp = 0
while mem[ctp] ~= 99 do
	local a,b,c,opcode = string.match(string.format('%05d',mem[ctp]), '(%d)(%d)(%d)(%d%d)')
	opcode = tonumber(opcode)
	local nparam = nparams[opcode]
	local params = {}
	for i=1,nparam do
		if ({c,b,a})[i] == '0' then
			params[i] = mem[mem[ctp+i]]
		else
			params[i] = mem[ctp+i]
		end
	end
	if opcode == 1 then
		mem[mem[ctp+nparam]] = params[1] + params[2]
	elseif opcode == 2 then
		mem[mem[ctp+nparam]] = params[1] * params[2]
	elseif opcode == 3 then
		mem[mem[ctp+nparam]] = take_input()
	elseif opcode == 4 then
		print(params[1])
	elseif opcode == 5 then
		if params[1] ~= 0 then
			ctp = params[2] - 3
		end
	elseif opcode == 6 then
		if params[1] == 0 then
			ctp = params[2] - 3
		end
	elseif opcode == 7 then
		mem[mem[ctp+nparam]] = (params[1] < params[2]) and 1 or 0
	elseif opcode == 8 then
		mem[mem[ctp+nparam]] = (params[1] == params[2]) and 1 or 0
	else
		print("Erreur")
		break
	end
	ctp = ctp + nparam + 1
end