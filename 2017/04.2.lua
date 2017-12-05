local ret = 0
local function sort(s)
  local t = {s:byte(1,-1)}
  table.sort(t)
  return string.char(table.unpack(t))
end

for l in io.lines() do
  local s = {}
  for w in l:gmatch("%w+") do
    w = sort(w)
    if s[w] then 
      ret = ret - 1
      break
    end
    s[w] = true
  end
  ret = ret + 1
 end

print(ret)
