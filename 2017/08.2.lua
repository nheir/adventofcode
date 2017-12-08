local input = {}
local vs = {}
for l in io.lines() do
  if #l == 0 then break end
  local n1,sign,v1,n2,cmp,v2 = l:match('(%w+) (%w+) (%-?%d+) if (%w+) (%S+) (%-?%d+)')
  vs[n1] = true
  vs[n2] = true
  if cmp == "!=" then cmp = "~=" end
  if sign == "inc" then sign = '+' else sign = '-' end
  l = string.format([[if t['%s'] %s %s then t['%s'] = t['%s'] %s %s end m = math.max(m,t['%s'])]],n2,cmp,v2,n1,n1,sign,v1,n1)
  table.insert(input, l)
end
local v = {}
for k in pairs(vs) do 
  table.insert(v,"t['"..k.."']")
end
local code = "local m = 0 local t = {} " .. table.concat(v, '=0\n') .. '=0\n' .. table.concat(input, '\n') .. '\nreturn m'
print(load(code)())
