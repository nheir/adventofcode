local input = {}
local reg = {}
for l in io.lines() do
  if #l == 0 then break end
  local cmd,a1,a2 = l:match('(%w+) (%-?%w+) (%-?%w+)')
  if tonumber(a1) then reg[a1] = tonumber(a1) end
  if tonumber(a2) then reg[a2] = tonumber(a2) end
  table.insert(input, { cmd, a1, a2 })
end
for _,v in ipairs{'a','b','c','d','e','f','g','h'} do
  reg[v] = 0
end
local count = 0
local pos = 1
while pos < #input do
  local cmd,a1,a2 = table.unpack(input[pos])
  if cmd == 'set' then
    reg[a1] = reg[a2]
  elseif cmd == 'sub' then
    reg[a1] = reg[a1] - reg[a2]
  elseif cmd == 'mul' then
    reg[a1] = reg[a1] * reg[a2]
    count = count + 1
  elseif reg[a1] ~= 0 then
    pos = pos + reg[a2] - 1
  end
  pos = pos + 1
end
print(count)
