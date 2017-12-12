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
print(walk(0,0))
