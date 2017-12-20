local input = {}
for l in io.lines() do
  if #l == 0 then break end
  local p = {}
  for v in l:gmatch('%-?%d+') do
    p[#p+1] = tonumber(v)
  end
  input[#input+1] = p
end
local function collide(p1,p2)
  local ks
  for i=1,3 do
    local ksl
    local a = (p1[i+6] - p2[i+6]) / 2
    local b = p1[i+3] - p2[i+3] + a
    local c = p1[i+0] - p2[i+0]
    if a == 0 and b == 0 and c ~= 0 then
      return false
    elseif a == 0 and b ~= 0 then
      local v = -c/b
      ksl = {}
      if v >= 0 and math.floor(v) == v then
        ksl = { v }
      end
    elseif a ~= 0 then
      ksl = {}
      local d = b*b-4*a*c
      if d < 0 then return false end
      local k1 = (-b+math.sqrt(d)) / (2*a)
      local k2 = (-b-math.sqrt(d)) / (2*a)
      if k1 == math.floor(k1) and k1 >= 0 then
        ksl = { k1 }
      end
      if k2 == math.floor(k2) and k2 >= 0 then
	ksl[#ksl+1] = k2
      end
    end
    if not ks then
      ks = ksl
    elseif ksl then
      local a = {}
      for _,k in ipairs(ks) do a[k] = true end
      ks = {}
      for _,k in ipairs(ksl) do
        if a[k] then
	  ks[#ks+1] = k
	end
      end
      if #ks == 0 then
        return false
      end
    end  
  end
  local v
  for k in pairs(ks or {}) do
    if not v or v > k then
      v = k
    end
  end
  return v or 0 
end
local collisions = {}
local max_time = 0
for i=1,#input do
  for j=i+1,#input do
    local v = collide(input[i],input[j])
    if v then
      max_time = (max_time < v) and v or max_time
      collisions[v] = collisions[v] or {}
      table.insert(collisions[v], {i,j})
    end
  end
end
local deleted = {}
for i=0,max_time do
  local colls = {}
  collisions[i] = collisions[i] or {}
  for _,c in ipairs(collisions[i]) do
    if not deleted[c[1]] and not deleted[c[2]] then
      colls[#colls+1] = c
    end
  end
  for _,c in ipairs(colls) do
    deleted[c[1]] = true
    deleted[c[2]] = true
  end
end
local count = 0
for k in pairs(deleted) do
 count = count + 1
end
print(#input - count)
