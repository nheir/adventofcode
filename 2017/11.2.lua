local input = io.read("a")
local t = { n=0,ne=0,se=0,s=0,sw=0,nw=0,e=0 }
local function nsteps()
  local rules = {
    { 'n','s','e' },
    { 'ne','sw','e' },
    { 'se','nw','e' },
    { 'n','se','ne' },
    { 'ne','s','se' },
    { 'se','sw','s' },
    { 's','nw','sw' },
    { 'sw','n','nw' },
    { 'nw','ne','n' },
  }
  local did_smth = true
  while did_smth do
    did_smth = false
    for _,v in ipairs(rules) do
      local m = math.min(t[v[1]],t[v[2]])
      t[v[1]] = t[v[1]] - m
      t[v[2]] = t[v[2]] - m
      t[v[3]] = t[v[3]] + m
      if m > 0 then did_smth = true end
    end
  end
  local count = 0
  t.e = 0
  for k,v in pairs(t) do 
    count = count + v
  end
  return count
end
local count = 0
for d in input:gmatch("%w+") do
  t[d] = t[d]+1
  count = math.max(count,nsteps())
end
print(count)
