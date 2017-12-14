local t = {}
for l in io.lines() do
  if #l == 0 then break end
  local v,d = l:match('(%d+): (%d+)')
  t[tonumber(v)] = tonumber(d)
end
local res = 0
local function ok(x)
  for k,v in pairs(t) do
    if (k+x) % (2*v-2) == 0 then
      return false 
    end
  end
  return true
end
local i = 0
while not ok(i) do
  i = i + 1
end
print(i)
