local file = {}
file.__index = file
function file:add(v)
    self[self.j] = v
    self.j = self.j + 1
end
function file:get()
    local v = self[self.i]
    --self[self.i] = nil
    self.i = self.i + 1
    return v
end
function file:empty()
    return self.j <= self.i
end
function file:size()
    return self.j - self.i
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

function game(p1,p2,sub)
    local states = {}
    if sub then
        local m1 = math.max(table.unpack(p1,p1.i,p1.j-1))
        local m2 = math.max(table.unpack(p2,p2.i,p2.j-1))
        local min = math.min(math.min(table.unpack(p1,p1.i,p1.j-1)), math.min(table.unpack(p2,p2.i,p2.j-1)))
        if m1 > m2 and m1+min > p1:size() + p2:size()-2 then
            return 1
        end
    end
    while not p1:empty() and not p2:empty() do
        local key = table.concat(p1, ',', p1.i, p1.j-1) .. ' ' .. table.concat(p2, ',', p2.i, p2.j-1)
        if states[key] then
            return 1
        end
        states[key] = true
        local a,b = p1:get(), p2:get()
        if a > p1:size() or b > p2:size() then
            if a > b then
                p1:add(a)
                p1:add(b)
            else
                p2:add(b)
                p2:add(a)
            end
        else
            local pp1 = setmetatable({i=1,j=a+1}, file)
            local pp2 = setmetatable({i=1,j=b+1}, file)
            table.move(p1, p1.i, p1.i+a-1, 1, pp1)
            table.move(p2, p2.i, p2.i+b-1, 1, pp2)
            if game(pp1, pp2, true) == 1 then
                p1:add(a)
                p1:add(b)
            else
                p2:add(b)
                p2:add(a)
            end
        end
    end
    local winner = p1:empty() and 2 or 1
    return winner
end

local p = game(p1,p2) == 2 and p2 or p1
local ret = 0
for i=p.i,p.j-1 do
    ret = ret + p[i]*(p.j-i)
end
print(ret)