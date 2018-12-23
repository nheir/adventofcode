local function parse_line(l)
	local t = {}
	for n in l:gmatch('%d+') do
		t[#t+1] = tonumber(n)
	end
	return t
end

local rules = {}
local instructions = {}

local l = io.read('l')
repeat 
	if l:find('Before') then
		local before = parse_line(l)
		local inst = parse_line(io.read('l'))
		local after = parse_line(io.read('l'))
		table.insert(rules, { before = before, inst = inst, after = after})
	else
		local inst = parse_line(l)
		if #l == 4 then
			table.insert(instructions, inst)
		end
	end
	l = io.read('l')
until not l

-- machine
local M = {}
M.reg = {0,0,0,[0]=0}
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
	M.reg[c] = M.reg[a] == M.reg[b] and 1 or 0
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

local opfuns = {}
for k,v in pairs(M) do
	if k ~= 'reg' then
		table.insert(opfuns, v)
	end
end

function reset(a,b,c,d)
	M.reg[0] = a or 0
	M.reg[1] = b or 0
	M.reg[2] = c or 0
	M.reg[3] = d or 0
end

local candidates = {}
for _,v in pairs(opfuns) do
	local t = {}
	for i=0,15 do t[i] = true end
	t.size = 16
	candidates[v] = t
end

local count = 0
for _,rule in ipairs(rules) do
	local op,a,b,c = table.unpack(rule.inst)
	local i = 0
	for opfun in pairs(candidates) do
		reset(table.unpack(rule.before))
		opfun(a,b,c)
		local ok = true
		for i=1,4 do
			if M.reg[i-1] ~= rule.after[i] then
				ok = false
				break
			end
		end
		if ok then i = i + 1 end
	end
	if i > 2 then count = count + 1 end
end
print(count)