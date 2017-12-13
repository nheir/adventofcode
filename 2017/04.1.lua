local ret = 0
for l in io.lines() do
  local s = {}
  for w in l:gmatch("%w+") do
     if s[w] then
       ret = ret - 1
       break
     end
     s[w] = true
  end
  ret = ret + 1
end

print(ret)
