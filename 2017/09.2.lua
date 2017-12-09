local input = io.read("a")
input = input:gsub("!.","")
local res = 0
for c in input:gmatch("<[^>]+>") do
  res = res + #c - 2
end
print(res)
