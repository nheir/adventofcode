local input = io.read("l")
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

print(string.format(string.rep("%02x",16),table.unpack(hash)))
