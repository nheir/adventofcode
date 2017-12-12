local g = {}
for l in io.lines() do
  if #l == 0 then break end
  local v,a = l:match('(%d+) <%-> ([%d ,]+)')
  v = tonumber(v)
  local adj = {}
  for f in a:gmatch('(%d+)') do adj[#adj+1] = tonumber(f) end
  g[v] = adj
end
local m = {}
function walk(v,count)
  if m[v] then return count end
  m[v] = true
  for _,f in ipairs(g[v]) do
     count = walk(f,count)
  end
  return count + 1
end
local count = 0
for i=0,1999 do
  if not m[i] then
    count = count + 1
    walk(i,0)
  end
end
print(count)
