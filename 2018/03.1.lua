function tuple(a,b)
  return string.format('%d/%d',a,b)
end

function f(t)
  local bigt = {}
  local used = {}
  local ret = 0
  for _,v in pairs(t) do
    local x,y,w,h = v:match("(%d+),(%d+): (%d+)x(%d+)")
    for i=x,x+w-1 do
      for j=y,y+h-1 do
        local t = tuple(i,j)
        if bigt[t] and not used[t] then
          used[t] = true
          ret = ret + 1
        end
        bigt[t] = true
      end
    end
  end
  return ret
end

local t = {}
for l in io.lines() do
  table.insert(t,l)
end

print(f(t))
