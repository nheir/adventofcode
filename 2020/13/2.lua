local dep = io.read('n')
local rest = io.read('a')

local i = 0
local eq = {}
for n in rest:gmatch("[%dx]+") do
	if n ~= 'x' then
		n = tonumber(n)
		eq[n] = (-i) % n
	end
	i = i + 1
end

function inv(a, m)
	local a0 = a
  local m0, q = m
  local x0, x1 = 0, 1

  if m == 1 then
     return 0
	end

  while a > 1 do
      q = a // m
      m, a = a % m, m
      x0, x1 = x1 - q * x0, x0
  end

  if x1 < 0 then
     x1 = x1 + m0
   end

  return x1
end

local  prod = 1
for k in pairs(eq) do
  prod = prod * k
end

local res = 0

for k, v in pairs(eq) do
  local pp = prod // k
  res = (res + v * inv(pp, k) * pp) % prod
end

print(res)