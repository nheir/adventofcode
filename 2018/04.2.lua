function f(t)
  local hour = {}
  for j=0,59 do hour[j] = {} end
  local id
  for i=1,#t do
    local m,d,h,min,msg = table.unpack(t[i])
    if msg == "falls asleep" then
      for j=min,59 do hour[j][id] = (hour[j][id] or 0) + 1 end
    elseif msg == "wakes up" then
      for j=min,59 do hour[j][id] = hour[j][id] - 1 end
    else
      id = tonumber(msg:match("#(%d+)"))
    end
  end

  local minute_max, id_max, nb_max = 0,0,0
  for i=0,59 do
    for id,nb in pairs(hour[i]) do
      if nb > nb_max then
        nb_max = nb
        minute_max = i
        id_max = id
      end
    end
  end

  return minute_max * id_max
end

local t = {}
for l in io.lines() do
  local m,d,h,min,msg = l:match("%[1518%-(%d%d)%-(%d%d) (%d%d):(%d%d)%] (.+)")
  table.insert(t,{tonumber(m),tonumber(d),tonumber(h),tonumber(min),msg})
end

print(f(t))
