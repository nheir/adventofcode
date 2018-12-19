function f(t)
  local bigt = {}
  for _,v in pairs(t) do
    local partial = {}
    for i=1,#v do
      local s = v:sub(1,i-1) .. v:sub(i+1)
      if bigt[s] then
        return s
      end
      table.insert(partial, s)
    end
    for _,s in pairs(partial) do
      bigt[s] = true
    end
  end
end

local t = {}
for l in io.lines() do
  table.insert(t,l)
end

print(f(t))
