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

local function run_until_rcv(pos, reg, buff, value) 
  if pos > #input then return pos,0 end

  local nsnd = 0
  while pos <= #input do
    local cmd, arg1, arg2 = table.unpack(input[pos])
    if cmd == 'snd' then
      buff[#buff+1] = reg[arg1]
      nsnd = nsnd + 1
    elseif cmd == 'rcv' then
      if value then
        reg[arg1] = value
        value = nil
      else
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

  return pos, nsnd
end

local pos = { 1, 1 }
local nsnd = { 0, 0 }
local buff = { {}, {} }
local regs = { reg, {} }
for k,v in pairs(reg) do
  regs[2][k] = v
end
regs[1]['p'] = 0
regs[2]['p'] = 1

local did_smth = true
while did_smth do
  did_smth = false
  for i=1,2 do
    local value
    if #buff[3-i] > 0 then value = table.remove(buff[3-i],1) end
    local p, n = run_until_rcv(pos[i], regs[i], buff[i], value)
    if value or p ~= pos[i] then
      did_smth = true
    end
    pos[i] = p
    nsnd[i] = nsnd[i] + n
  end
end
print(nsnd[2])
