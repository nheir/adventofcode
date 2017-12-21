local input = {}
local function rotate(l)
  local t = {}
  for p in l:gmatch('[#.]+') do
    t[#t+1] = { p:byte(1,-1) }
  end
  local r = {}
  for i=1,#t do
    r[i] = {}
    for j=1,#t do
      r[i][#t-j+1] = t[j][i]
    end
    r[i] = string.char(table.unpack(r[i]))
  end
  return table.concat(r, '/')
end
local function flip(l)
  local t = {}
  for p in l:gmatch('[#.]+') do
    t[#t+1] = { p:byte(1,-1) }
  end
  local r = {}
  for i=1,#t do
    r[i] = {}
    for j=1,#t do
      r[i][#t-j+1] = t[i][j]
    end
    r[i] = string.char(table.unpack(r[i]))
  end
  return table.concat(r, '/')
end

for l in io.lines() do
  if #l == 0 then break end
  local p,m = l:match('([#./]+) => ([#./]+)')
  for i=1,4 do
    input[p] = m
    input[flip(p)] = m
    p = rotate(p)
  end
end  

local function extract(v, i, j, s)
  local t = {}
  for u=1,s do
    t[u] = {}
    for w=1,s do
      t[u][w] = v[u+i-1][w+j-1]
    end
    t[u] = string.char(table.unpack(t[u]))
  end
  return table.concat(t, '/')
end

local function concat(b)
  local v = {}
  for i=1,#b do
    for j=1,#b do
      local t = {}
      for p in b[i][j]:gmatch('[#.]+') do
        t[#t+1] = p
      end
      b[i][j] = t
    end
  end
  for i=1,#b do
    for u=1,#b[i][1] do
      local t = {}
      for j=1,#b do
        t[#t+1] = b[i][j][u]
      end
      v[#v+1] = { string.byte(table.concat(t),1,-1) }
    end
  end
  return v
end

local function step(v,rules)
  local s = 3
  if #v & 1 == 0 then s = 2 end
  local g = {}
  for i=1,#v,s do
    local t = {}    
    for j=1,#v,s do
      t[#t+1] = input[extract(v, i, j, s)]
    end
    g[#g+1] = t
  end
  return concat(g)
end

local v = ".#./..#/###"
local t = {}
for p in v:gmatch('[#.]+') do
  t[#t+1] = { string.byte(p,1,-1) }
end
for i=1,5 do
  t = step(t, rules)
end
local v = {}
for i=1,#t do
  v[i] = string.char(table.unpack(t[i]))
end
local count = 0
for _ in table.concat(v):gmatch('#') do count = count + 1 end
print(count)

