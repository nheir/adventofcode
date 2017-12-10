local input = load('return {' .. io.read("a") .. '}')()
local pos = 0
local ss = 0
local t = {}
local len = 256 
for i=0,len-1 do t[i+1] = i end
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
table.move(t, 1, pos, len+1)
table.move(t, pos+1, pos+len, 1)

print(table.unpack(t))
print(t[1]*t[2])
