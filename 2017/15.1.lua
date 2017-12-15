local input = io.read('a')
local seedA,seedB = input:match('(%d+)[%D]+(%d+)')
local mulA,mulB = 16807,48271
local function gen(prev,fact)
  return (prev*fact)%2147483647
end
local count = 0
for i=1,40000000 do
  seedA = gen(seedA,mulA)
  seedB = gen(seedB,mulB)
  if (seedA & 0xffff) == (seedB & 0xffff) then
    count = count + 1
  end
end
print(count)
