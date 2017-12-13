local res = 0
for s in io.lines() do
  local t = {}
  for d in s:gmatch('%d+') do
    table.insert(t, tonumber(d))
  end
  if #t == 0 then break end
  local b = false
  for i=1,#t do for j=i+1,#t do
    if t[i] % t[j] == 0 then
      res = res + t[i] / t[j]
      b = true
    end
    if t[j] % t[i] == 0 then
      res = res + t[j] / t[i]
      b = true
    end
    if b then break end
  end if b then break end end
end
print(res)
