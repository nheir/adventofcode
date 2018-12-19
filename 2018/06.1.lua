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

  local count = {[0] = 0}
  for i,v in ipairs(t) do
    count[i] = 0
  end

  local infinite = {[0] = true}
  for x=x_min,x_max do
    for y=y_min,y_max do
      local min = 1000
      local c
      for i,v in ipairs(t) do
        local dist = math.abs(x-v.x) + math.abs(y-v.y)
        if dist == min then
          c = 0
        elseif dist < min then
          min = dist
          c = i
        end
      end
      plane[x][y] = c
      if x == x_min or x == x_max or y == y_min or y == y_max then
        infinite[c] = true
      end
    end
  end


  for x=x_min,x_max do
    for y=y_min,y_max do
      count[plane[x][y]] = count[plane[x][y]] + 1
    end
  end

  local max = 0
  for i,v in ipairs(count) do
    if not infinite[i] and v > max then
      max = v
    end
  end

  return max
end

local t = {}
for l in io.lines() do
  local x,y = l:match("(%d+), (%d+)")
  table.insert(t,{x=tonumber(x),y=tonumber(y)})
end

print(f(t))
