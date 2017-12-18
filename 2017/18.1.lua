local input = {}
local reg = {}
for l in io.lines() do
  if #l == 0 then break end
  local cmd,arg = l:match('(%w%w%w) ([-%w ]+)')
  local arg2
  if cmd ~= 'snd' and cmd ~= 'rcv' then
    arg, arg2 = arg:match('(%w) (%-?%w+)')
  end
  if tonumber(arg) then
    arg = tonumber(arg)
    reg[arg] = arg
  else
    reg[arg] = 0
  end
  if arg2 and tonumber(arg2) then
    arg2 = tonumber(arg2)
    reg[arg2] = arg2
  elseif arg2 then
    reg[arg2] = 0
  end
  input[#input+1] = { cmd, arg, arg2 }
end
local pos = 1
local last_freq
while pos <= #input do
  local cmd, arg1, arg2 = table.unpack(input[pos])
  if cmd == 'snd' then
    last_freq = reg[arg1]
  elseif cmd == 'rcv' then
    if reg[arg1] then
      break
    end
  elseif cmd == 'set' then
    reg[arg1] = reg[arg2]
  elseif cmd == 'add' then
    reg[arg1] = reg[arg1] + reg[arg2]
  elseif cmd == 'mul' then
    reg[arg1] = reg[arg1] * reg[arg2]
  elseif cmd == 'mod' then
    reg[arg1] = reg[arg1] % reg[arg2]
  elseif cmd == 'jgz' then
    if reg[arg1] > 0 then
      pos = pos + reg[arg2] - 1
    end
  end
  pos = pos + 1
end
print(last_freq)
