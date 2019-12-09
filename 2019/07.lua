local tab = {}

-- from my input

local function steps(ops)
	local n
	for i,v in ipairs(ops) do
		if v:sub(1,1) == '+' then
			n = coroutine.yield(n) + tonumber(v:sub(2))
		else
			n = coroutine.yield(n) * tonumber(v:sub(2))
		end
	end
	coroutine.yield(n)
end

local prog = {
	[0] = function (n)
		--return ((n*3 + 4)*3+3)*2
		return 30+18*n
	end,
	[1] = function (n)
		--return 2+2*(5+2*n)
		return 12+4*n
	end,
	[2] = function (n)
		--return 4+n
		return 4+n
	end,
	[3] = function (n)
		--return 5*(4+2*(4+n))
		return 60+10*n
	end,
	[4] = function (n)
		--return 3+3*(2+3*n)
		return 9+9*n
	end,
	[5] = function ()
		steps{'+1', '+2', '+1', '+1', '+2', '*2', '*2', '*2', '+2', '+1'}
	end,
	[6] = function ()
		steps{'*2', '+2', '*2', '*2', '*2', '+2', '+1', '*2', '+1', '+2'}
	end,
	[7] = function ()
		steps{'*2', '+1', '+2', '*2', '*2', '+1', '*2', '+1', '*2', '+1'}
	end,
	[8] = function ()
		steps{'+2', '*2', '*2', '+2', '+1', '+1', '+2', '+1', '*2', '+1'}
	end,
	[9] = function ()
		steps{'*2', '+2', '*2', '+2', '+2', '+1', '*2', '*2', '+2', '*2'}
	end,
}

-- PIL
function permgen (a, n)
  if n == 0 then
    coroutine.yield(a)
  else
    for i=1,n do
      a[n], a[i] = a[i], a[n]
      permgen(a, n - 1)
      a[n], a[i] = a[i], a[n]
    end
  end
end

function perm (a)
  local n = #a
  return coroutine.wrap(function () permgen(a, n) end)
end

local m = 0
for p in perm{0,1,2,3,4} do
	local v = 0
	for i=1,5 do
		v = prog[p[i]](v)
	end
	if v > m then
		m = v
	end
end

print(m)


local m = 0
for p in perm{5,6,7,8,9} do
	local co = {}
	for i=1,5 do
		co[i] = coroutine.create(prog[p[i]])
		coroutine.resume(co[i])
	end

	local v = 0
	local i = 1
	local statut, value = assert(coroutine.resume(co[i],v))
	while value do
		v = value
		i = (i%5) + 1
		statut, value = assert(coroutine.resume(co[i],v))
	end
	if v > m then
		m = v
	end
end

print(m)