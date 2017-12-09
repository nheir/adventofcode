local input = io.read("a")
input = input:gsub("!.","")
input = input:gsub("<[^>]+>","")
local res = 0
local p = 0
for c in input:gmatch(".") do
  if c == '{' then
    p = p + 1
  elseif c == '}' then
    res = res + p
    p = p-1
  end
end
print(res)
