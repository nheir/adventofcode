function f(t)
  local plane = {}
  local x_min, y_min, x_max, y_max = 1000, 1000, 0, 0
  for _,v in ipairs(t) do
    if x_min > v.x then x_min = v.x end
    if x_max < v.x then x_max = v.x end
    if y_min > v.y then y_min = v.y end
    if y_max < v.y then y_max = v.y end
  end

  for x=x_min,x_max do plane[x] = {} end

  local count = 0

  local infinite = {[0] = true}
  for x=x_min,x_max do
    for y=y_min,y_max do
      local sum = 0
      for i,v in ipairs(t) do
        local dist = math.abs(x-v.x) + math.abs(y-v.y)
        sum = sum + dist
      end
      if sum < 10000 then
        count = count + 1
      end
    end
  end

  return count
end

local t = {}
for l in io.lines() do
  local x,y = l:match("(%d+), (%d+)")
  table.insert(t,{x=tonumber(x),y=tonumber(y)})
end

print(f(t))
