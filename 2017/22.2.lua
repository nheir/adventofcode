local input = {}
local function key(i,j)
  return string.format('%d %d', i, j)
end
local i = 1
for l in io.lines() do
  if #l == 0 then break end
  for j,v in ipairs{ string.byte(l, 1, -1) } do
    if v == 35 then
      input[key(i,j)] = 'inf'
    end
  end
  i = i + 1
end
local i,j = i // 2, i // 2
local dir = 3
local moves = {{1,0},{0,1},{-1,0},{0,-1}}
local count = 0
for _=1,10000000 do
 if not input[key(i,j)] then
    dir = dir % 4 + 1
    input[key(i,j)] = 'weak'
  elseif input[key(i,j)] == 'weak' then
    input[key(i,j)] = 'inf'
    count = count + 1
  elseif input[key(i,j)] == 'inf' then
    dir = (dir + 2) % 4 + 1
    input[key(i,j)] = 'flag'
  else
    dir = (dir + 1) % 4 + 1
    input[key(i,j)] = nil
  end
  i,j = i + moves[dir][1], j + moves[dir][2]
end
print(count)
