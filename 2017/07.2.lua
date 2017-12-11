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
local r
for k in pairs(t) do
  if not p[k] then
    r = k
  end
end

function c(n)
  local vs = {}
  local ws = {}
  local w = 0
  for i,u in ipairs(t[n].f) do
    w = c(u)
    vs[i] = w
    ws[w] = (ws[w] or 0) + 1
  end
  for v,k in pairs(ws) do
    if k == #(t[n].f)-1 then
      if vs[1] ~= v then
        print(t[t[n].f[1]].w + vs[2]-vs[1])
      else
        print(t[t[n].f[1]].w + vs[1]-vs[2])
      end
      os.exit(0)
    end
  end
  return t[n].w + #(t[n].f) * w
end

c(r)
