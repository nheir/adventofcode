local function parse_line(l)
	local t = {}
	t[1] = l:match('%w+')
	for n in l:gmatch('%d+') do
		t[#t+1] = tonumber(n)
	end
	return t
end

-- machine
local M = {}
M.reg = {0,0,0,0,0,[0]=0}
function M.addr(a,b,c)
	M.reg[c] = M.reg[a] + M.reg[b]
end
function M.addi(a,b,c)
	M.reg[c] = M.reg[a] + b
end
function M.mulr(a,b,c)
	M.reg[c] = M.reg[a] * M.reg[b]
end
function M.muli(a,b,c)
	M.reg[c] = M.reg[a] * b
end
function M.banr(a,b,c)
	M.reg[c] = M.reg[a] & M.reg[b]
end
function M.bani(a,b,c)
	M.reg[c] = M.reg[a] & b
end
function M.borr(a,b,c)
	M.reg[c] = M.reg[a] | M.reg[b]
end
function M.bori(a,b,c)
	M.reg[c] = M.reg[a] | b
end
function M.setr(a,b,c)
	M.reg[c] = M.reg[a]
end
function M.seti(a,b,c)
	M.reg[c] = a
end
function M.eqrr(a,b,c)
	if a == 0 or b == 0 then
		print((a ~= 0) and M.reg[a] or M.reg[b])
		M.reg[c] = 1
	else
		M.reg[c] = M.reg[a] == M.reg[b] and 1 or 0
	end
end
function M.eqri(a,b,c)
	M.reg[c] = M.reg[a] == b and 1 or 0
end
function M.eqir(a,b,c)
	M.reg[c] = a == M.reg[b] and 1 or 0
end
function M.gtrr(a,b,c)
	M.reg[c] = M.reg[a] > M.reg[b] and 1 or 0
end
function M.gtri(a,b,c)
	M.reg[c] = M.reg[a] > b and 1 or 0
end
function M.gtir(a,b,c)
	M.reg[c] = a > M.reg[b] and 1 or 0
end

local l = io.read('l')
M.ip = tonumber(l:match('(%d)'))
local instructions = {}
l = io.read('l')
repeat 
	local inst = parse_line(l)
	if #inst == 4 then
		table.insert(instructions, inst)
	end
	l = io.read('l')
until not l

while instructions[M.reg[M.ip]+1] do
	local op,a,b,c = table.unpack(instructions[M.reg[M.ip]+1])
	-- print(op,a,b,c)
	M[op](a,b,c)
	M.reg[M.ip] = M.reg[M.ip] + 1
end
