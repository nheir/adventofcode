local tab = {}

for n in string.gmatch(io.read("a"), "%-?%d+") do
	tab[#tab+1] = tonumber(n)
end

local mem = {}

table.move(tab, 1, #tab, 0, mem)

local function take_input()
	--return 1 -- part 1
	return 2 -- part 2
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
	[9] = 1,
}

setmetatable(mem, { __index = function () return 0 end })

local drawx, drawy = 0,0
local panels = {}

setmetatable(panels, { __index = function (t,k)
	t[k] = setmetatable({}, { __index = function (t,k) return 1 end })
	return t[k]
end })

local bound = {left=0,right=0,top=0,bottom=0}

local ball = {}
local paddle = {}

local action = 0

mem[0] = 2

local ctp = 0
local relative_base = 0
while mem[ctp] ~= 99 do
	--print(string.format("C: %d, RB: %d", ctp, relative_base))
	-- print("Mem:", table.unpack(mem))
	local a,b,c,opcode = string.match(string.format('%05d',mem[ctp]), '(%d)(%d)(%d)(%d%d)')
	opcode = tonumber(opcode)
	local nparam = nparams[opcode]
	local params = {}
	local add_params = {}
	for i=1,nparam do
		local mode = ({c,b,a})[i]
		if mode == '0' then
			params[i] = mem[mem[ctp+i]]
			add_params[i] = mem[ctp+i]
		elseif mode == '1' then
			params[i] = mem[ctp+i]
			add_params[i] = ctp+i
		elseif mode == '2' then
			params[i] = mem[mem[ctp+i]+relative_base]
			add_params[i] = mem[ctp+i]+relative_base
		end
	end
	--print(mem[ctp], table.unpack(params))
	if opcode == 1 then
		mem[add_params[nparam]] = params[1] + params[2]
	elseif opcode == 2 then
		mem[add_params[nparam]] = params[1] * params[2]
	elseif opcode == 3 then
		-- input
		if paddle.y < ball.y then
			mem[add_params[nparam]] = 1
		elseif paddle.y > ball.y then
			mem[add_params[nparam]] = -1
		else
			mem[add_params[nparam]] = 0
		end
	elseif opcode == 4 then
		-- output
		if action == 2 then
			if drawx == 0 and drawy == -1 then
				print(params[1])
			else
				panels[drawx][drawy] = params[1]
				if params[1] == 4 then
					ball = {x=drawx, y=drawy}
				end
				if params[1] == 3 then
					paddle = {x=drawx, y=drawy}
				end
				if drawx > bound.bottom then
					bound.bottom = drawx
				end
				if drawy > bound.right then
					bound.right = drawy
				end
				if drawx < bound.top then
					bound.top = drawx
				end
				if drawy < bound.left then
					bound.left = drawy
				end
			end
		elseif action == 0 then
			drawy = params[1]
		else
			drawx = params[1]
		end
		action = (action + 1) % 3
	elseif opcode == 5 then
		if params[1] ~= 0 then
			ctp = params[2] - 3
		end
	elseif opcode == 6 then
		if params[1] == 0 then
			ctp = params[2] - 3
		end
	elseif opcode == 7 then
		mem[add_params[nparam]] = (params[1] < params[2]) and 1 or 0
	elseif opcode == 8 then
		mem[add_params[nparam]] = (params[1] == params[2]) and 1 or 0
	elseif opcode == 9 then
		relative_base = relative_base + params[1]
	else
		print("Erreur")
		break
	end
	ctp = ctp + nparam + 1
end

local count = 0
for _,v in pairs(panels) do
	for _,v in pairs(v) do
		if v == 2 then
			count = count + 1
		end
	end
end

print(count)

for x=bound.top, bound.bottom do
	for y=bound.left, bound.right do
		io.write((panels[x][y] == 0) and '.' or tostring(panels[x][y]))
	end
	io.write('\n')
end


