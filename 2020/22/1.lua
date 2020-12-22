local file = {}
file.__index = file
function file:add(v)
    self[self.j] = v
    self.j = self.j + 1
end
function file:get()
    local v = self[self.i]
    self[self.i] = nil
    self.i = self.i + 1
    return v
end
function file:empty()
    return self.j <= self.i
end

local p1 = setmetatable({i=1,j=1}, file)
local p2 = setmetatable({i=1,j=1}, file)

local p = p1
for l in io.lines() do
    if l == '' then p = p2 
    elseif l:sub(1,1) == 'P' then
    else
        local n = tonumber(l)
        p:add(n)
    end
end

while not p1:empty() and not p2:empty() do
    local a,b = p1:get(), p2:get()
    if a > b then 
        p1:add(a)
        p1:add(b)
    else
        p2:add(b)
        p2:add(a)
    end
end

local p = p1:empty() and p2 or p1
local ret = 0
for i=p.i,p.j-1 do
    ret = ret + p[i]*(p.j-i)
end
print(ret)