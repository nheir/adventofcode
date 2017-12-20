local input = {}
for l in io.lines() do
  if #l == 0 then break end
  local p = {}
  for v in l:gmatch('%-?%d+') do
    p[#p+1] = tonumber(v)
  end
  input[#input+1] = p
end

local function norm_accel(p)
  return math.abs(p[7])+math.abs(p[8])+math.abs(p[9])
end

local min_accl
for i,p in ipairs(input) do
  if not min_accl or norm_accel(p) < min_accl then
    min_accl = norm_accel(p)
  end
end

local filter = {}
for i=#input,1,-1 do
  if min_accl == norm_accel(input[i]) then
    filter[#filter+1] = i
  end
end
-- pure luck, only one min
print(filter[1]-1)
