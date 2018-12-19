function f(t)
  local sleep = 0
  local max = 0
  local guard = {}
  local id
  local max_id
  for i=1,#t do
    local m,d,h,min,msg = table.unpack(t[i])
    if msg == "falls asleep" then
      guard[id] = guard[id] - min
    elseif msg == "wakes up" then
      guard[id] = guard[id] + min
    else
      if id and guard[id] > max then
        max_id = id
        max = guard[id]
      end
      id = msg:match("#(%d+)")
      guard[id] = guard[id] or 0
    end
  end
  if guard[id] > max then
    max_id = id
    max = guard[id]
  end

  local hour = {}
  for j=0,59 do hour[j] = 0 end
  for i=1,#t do
    local m,d,h,min,msg = table.unpack(t[i])
    if msg == "falls asleep" then
      if id == max_id then
        for j=min,59 do hour[j] = hour[j] + 1 end
      end
    elseif msg == "wakes up" then
      if id == max_id then
        for j=min,59 do hour[j] = hour[j] - 1 end
      end
    else
      id = msg:match("#(%d+)")
    end
  end
  local max,j = 0
  for i=0,59 do
    if hour[i] > max then
      max = hour[i]
      j = i
    end
  end

  return max_id*j
end

local t = {}
for l in io.lines() do
  local m,d,h,min,msg = l:match("%[1518%-(%d%d)%-(%d%d) (%d%d):(%d%d)%] (.+)")
  table.insert(t,{tonumber(m),tonumber(d),tonumber(h),tonumber(min),msg})
end

print(f(t))
