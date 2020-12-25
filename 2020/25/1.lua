local card = io.read('n')
local door = io.read('n')

local function exp_mod(a,b,c,acc)
	if b == 0 then return acc end
	acc = acc or 1
	local aa = (a*a) % c
	if b & 1 == 1 then
		return exp_mod(aa, b >> 1, c, (acc*a) % c)
	else
		return exp_mod(aa, b >> 1, c, acc)
	end
end

local g,N = 7,20201227
local n = N-1

local function rho_step(r, x, a, b)
	local cas = x % 3
	if cas == 2 then
		return (r*x)%N, a, (b+1)%n
	elseif cas == 0 then
		return (x*x)%N, (2*a)%n, (2*b)%n
	else
		return (g*x)%N, (a+1)%n, b
	end
end

local function rho(r)
	local x,a,b = 1,0,0
	local xx,aa,bb = x,a,b
	while true do
		x,a,b = rho_step(r, x, a, b)
		xx,aa,bb = rho_step(r, xx, aa, bb)
		xx,aa,bb = rho_step(r, xx, aa, bb)
		if x == xx then
			local B = (bb-b)%n
			local A = (aa-a)%n
			for i=1,n do
				if (A+B*i)%n == 0 and exp_mod(g, i, N) == r then
					return i
				end
			end
			error("meh")
		end
	end
end

local log_door = rho(door)
local ret = exp_mod(card, log_door, N)
print(ret)

