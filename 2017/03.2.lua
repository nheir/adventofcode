local input = io.read("n")

local s = {{0,1},{1,0},{0,-1},{-1,0}}
local function n(i,j,p)
  return i+s[p%4+1][1],j+s[p%4+1][2]
end

local function k(...)
  return string.format("%d %d", ...)
end

local t = {}
t[k(0,0)] = 1
local i,j = 0,0
local p = 0
while t[k(i,j)] < input do
  if not t[k(n(i,j,p+1))] then
    p = p+1
  end
  i,j = n(i,j,p)
  local res = 0
  for u=-1,1 do
    for v=-1,1 do
      res = res + (t[k(i+u,j+v)] or 0)
    end
  end
  t[k(i,j)] = res
end

print(t[k(i,j)])
