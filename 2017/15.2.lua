local input = io.read('a')
local seedA,seedB = input:match('(%d+)[%D]+(%d+)')
local function genA(prev)
  local mul = 16807
  repeat
    prev = (prev*mul) % 2147483647
  until prev & 0x3 == 0
  return prev
end
local function genB(prev)
  local mul = 48271
  repeat
    prev = (prev*mul) % 2147483647
  until prev & 0x7 == 0
  return prev
end
local count = 0
for i=1,5000000 do
  seedA = genA(seedA)
  seedB = genB(seedB)
  if (seedA & 0xffff) == (seedB & 0xffff) then
    count = count + 1
  end
end
print(count)
