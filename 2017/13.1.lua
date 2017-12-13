local t = {}
for l in io.lines() do
  if #l == 0 then break end
  local v,d = l:match('(%d+): (%d+)')
  t[tonumber(v)] = tonumber(d)
end
local res = 0
for k,v in pairs(t) do
  if k % (2*v-2) == 0 then
    res = res + k*v 
  end
end
print(res)
