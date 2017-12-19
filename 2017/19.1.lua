local input = {}
for l in io.lines() do
  input[#input+1] = { l:byte(1,-1) }
end
local start = 1
while input[1][start] ~= 124 do start = start + 1 end
local moves = { {1,0},{0,1},{-1,0},{0,-1}}
local dir = 1
local pos = { 1, start }
local ret = {}
while true do
  repeat
    if 64 < input[pos[1]][pos[2]] and input[pos[1]][pos[2]] < 91 then
      ret[#ret+1] = input[pos[1]][pos[2]]
    end
    pos[1] = pos[1] + moves[dir][1]
    pos[2] = pos[2] + moves[dir][2]
  until not input[pos[1]] or not input[pos[1]][pos[2]] or input[pos[1]][pos[2]] == 43 or input[pos[1]][pos[2]] == 32
  if not input[pos[1]] or not input[pos[1]][pos[2]] or input[pos[1]][pos[2]] == 32 then
    break
  end
  local new_dir
  for i=0,2,2 do
    local p = { pos[1] + moves[(dir+i)%4+1][1], pos[2] + moves[(dir+i)%4+1][2] }
    if input[p[1]] and input[p[1]][p[2]] and input[p[1]][p[2]] ~= 32 then
      new_dir = (dir+i)%4+1
      break
    end
  end
  if not new_dir then
    break
  end
  dir = new_dir
end  
print(string.char(table.unpack(ret)))
