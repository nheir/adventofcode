local input = io.read('n')
local pos = 0
local v
for i=1,50000000 do
  pos = (pos + input)%i+1
  if pos == 1 then
    v = i
  end
end
print(v)
