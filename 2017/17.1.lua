local input = io.read('n')
local t = { [0] = 0 }
local pos = 0
for i=1,2017 do
  pos = (pos + input)%i+1
  table.insert(t,pos,i)
end
print(t[pos+1])
