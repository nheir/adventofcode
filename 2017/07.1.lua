local t = {}
local p = {}
for v in io.lines() do
  if #v == 0 then break end
  local n,w,r = v:match('(%w+) %((%d+)%)(.*)')
  local f = {}
  for u in r:gmatch('%w+') do
    table.insert(f,u)
    p[u] = n
  end
  t[n] = { w = tonumber(w), f = f }
end
for k in pairs(t) do
  if not p[k] then
    print(k)
  end
end
