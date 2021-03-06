local input = io.read('a')
local tg = { 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16 }
local td = { 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16 }
for c,a in input:gmatch('([sxp])([%w/]+)') do
  if c == 's' then
    local v = tonumber(a)
    table.move(td, 1, 16, 17)
    table.move(td, 17-v, 33-v, 1)
  elseif c == 'x' then
    local v1,v2 = a:match('(%d+)/(%d+)')
    v1,v2 = tonumber(v1)+1, tonumber(v2)+1
    td[v1], td[v2] = td[v2], td[v1]
  elseif c == 'p' then
    local v1, _, v2 = a:byte(1,3)
    v1, v2 = v1-96,v2-96
    tg[v1], tg[v2] = tg[v2], tg[v1]
  end
end
local function exp(p,n)
  local t = { table.unpack(p) }
  if n == 1 then
    return t
  end
  for i=1,16 do
    t[i] = p[p[i]]
  end
  t = exp(t,n//2)
  if n & 1 == 1 then
    for i=1,16 do
      t[i] = p[t[i]]
    end
  end
  return t
end
tg = exp(tg,1000000000)
td = exp(td,1000000000)
local t = {}
for i,v in ipairs(tg) do
  t[v] = i
end
tg = t
local p = {}
for i=1,16 do
  p[i] = tg[td[i]]+96
end
print(string.char(table.unpack(p)))

