local graph = {}
for l in io.lines() do
  if #l == 0 then break end
  local a,b = l:match('(%d+)/(%d+)')
  a,b = tonumber(a),tonumber(b)
  graph[a] = graph[a] or {}
  table.insert(graph[a], b)
  graph[b] = graph[b] or {}
  table.insert(graph[b], a)
end
local m = {}
local ret,lret = -1,-1
local function walk(i,p,l)
  if lret < l or (lret == l and ret < p) then
    ret = p
    lret = l
  end
  for _,k in ipairs(graph[i]) do
    if not m[i*#graph+k] and not m[k*#graph+i] then
      m[i*#graph+k] = true
      walk(k,p+i+k,l+1)
      m[i*#graph+k] = nil
    end
  end
end
walk(0,0,0)
print(ret)
