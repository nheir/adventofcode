local function knot_hash(input)
  input = { string.byte(input, 1, #input) }
  table.move({ 17, 31, 73, 47, 23 }, 1, 5, #input+1, input)
  local pos = 0
  local ss = 0
  local t = {}
  local len = 256
  for i=0,len-1 do t[i+1] = i end
  for _=1,64 do
    for _,l in ipairs(input) do
      for i=1,l//2 do
        t[i],t[l-i+1] = t[l-i+1],t[i]
      end
      local dec = (l + ss) % len
      pos = (pos - dec + len) % len
      table.move(t, 1, dec, len+1)
      table.move(t, dec+1, dec+len, 1)
      ss = ss + 1
    end
  end
  table.move(t, 1, pos, len+1)
  table.move(t, pos+1, pos+len, 1)
  local hash = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,}
  for i=0,15 do
    for j=1,16 do
      hash[i+1] = hash[i+1] ~ t[i*16+j]
    end
  end
  return hash
end
local function hash2bytes(hash)
  local bytes = {}
  for k,v in ipairs(hash) do
    for i=8,0,-1 do
      if (v >> i) & 0x1 == 1 then
	bytes[k*8-i] = true
      else
      end
    end
  end
  return bytes
end
local input = io.read('l')
local bytes = {}
for i=0,127 do
  bytes[#bytes+1] = hash2bytes(knot_hash(input .. '-' .. i))
end
local graph = {}
for i=1,128 do
  for k in pairs(bytes[i]) do
    graph[i*128+k] = graph[i*128+k] or {}
    if bytes[i][k+1] then
      table.insert(graph[i*128+k],i*128+k+1)
    end
    if bytes[i][k-1] then
      table.insert(graph[i*128+k],i*128+k-1)
    end
    if i > 1 then
      if bytes[i-1][k] then
        table.insert(graph[i*128+k],(i-1)*128+k)
        table.insert(graph[(i-1)*128+k],i*128+k)
      end
    end
  end
end
local m = {}
function walk(v,count)
  if m[v] then return count end
  m[v] = true
  for _,f in ipairs(graph[v]) do
    count = walk(f,count)
  end
  return count + 1
end
local count = 0
for i in pairs(graph) do
  if not m[i] then
    count = count + 1
    walk(i,0)
  end
end
print(count)
