local input = io.read("a")
local t = load('return {'..input:gsub('%d+','%1,')..'}')()

local function k(t)
  return string.char(table.unpack(t))
end

local function max(t)
  local j=1
  for i=1,#t do
    if t[j] < t[i] then
      j = i
    end
  end
  return j,t[j]
end

local s = {}
local c = 0
while not s[k(t)] do
  s[k(t)] = true
  c = c + 1
  local i,v = max(t)
  t[i] = 0
  for j=1,v do t[(i+j-1)%#t+1] = t[(i+j-1)%#t+1] + 1 end
end
print(c)
