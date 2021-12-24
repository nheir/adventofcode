local vars = {
	w="w",
	x="x",
	y="y",
	z="z"
}

local step = 0

local opSym = {
	add='+',
	mul='*',
	div='/',
	mod='%',
	eql='=='
}

local ops = {
	add=function(a,b) return a+b end,
	mul=function(a,b) return a*b end,
	div=function(a,b) return a//b end,
	mod=function(a,b) return a%b end,
	eql=function(a,b) return a==b and 1 or 0 end
}

local n = 0
local tree = {
	x=0,
	y=0,
	z=0,
}

local stack = {}

local min = {9,9,9,9,9,9,9,9,9,9,9,9,9,9}
local max = {1,1,1,1,1,1,1,1,1,1,1,1,1,1}

local function next_step()
	local var = "v" .. tostring(step)
	vars.w = var
	if step > 0 then
		if tree.z[2][2][1] == "/" then
			local c = table.remove(stack)
			local a = tonumber(tree.x[2][3]:sub(2))+1
			local b = tonumber(c[2]:sub(2))+1
			local diff = c[3] + tree.x[2][2][3]
			if diff < 0 then a, b, diff = b, a, -diff end
			min[a] = 1+diff
			max[a] = 9
			min[b] = 1
			max[b] = 9-diff
		else -- tree.z[2][2][1] == "%"
			table.insert(stack, tree.y[2])
		end
	end
	for k in pairs(tree) do
		tree[k] = k .. tostring(step)
	end
	step = step + 1
end

for l in io.lines() do
	local cmd, a, b = l:match('(%S+) (%S) ?(%S*)')
	if cmd then
		if cmd == 'inp' then
			next_step()
		else
			b = tonumber(b) or vars[b]
			local va = tree[a]
			local vb = tree[b] or b
			if type(va) == "number" and type(vb) == 'number' then
				tree[a] = ops[cmd](tree[a], tree[b] or b)
			elseif cmd == 'mul' and (va == 0 or vb == 0) then
				tree[a] = 0
			elseif (cmd == 'div' or cmd == 'mod') and va == 0 then
				tree[a] = 0
			elseif (cmd == 'div' or cmd == 'mul') and vb == 1 then
			elseif cmd == 'mod' and vb == 1 then
				tree[a] = 0
			elseif cmd == 'add' and va == 0 then
				tree[a] = vb
			elseif cmd == 'add' and vb == 0 then
			elseif cmd == 'eql' and va == vb then
				tree[a] = 1
			else
				tree[a] = { opSym[cmd], tree[a], tree[b] or b }
			end
		end
	end
end

next_step()

for i=1,14 do
	max[i]=tostring(max[i])
	min[i]=tostring(min[i])
end

print(table.concat(max, ''))
print(table.concat(min, ''))