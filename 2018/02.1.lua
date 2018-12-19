function f(t)
  local two = 0
  local three = 0
  for _,v in pairs(t) do
    local count = {}
    local max = 1
    for l in v:gmatch('%w') do
      count[l] = (count[l] or 0) + 1
    end
    local recap = {}
    for _,v in pairs(count) do
      recap[v] = true
    end
    if recap[3] then
      three = three + 1
    end
    if recap[2] then
      two = two + 1
    end
  end
  return three * two
end

local t = {}
for l in io.lines() do
  table.insert(t,l)
end

print(f(t))
