local t = {}
local ok = {}
local obj
for l in io.lines() do
    local v = tonumber(l)
    t[#t+1] = v
    if not obj and #t >= 26 then
        local found = false
        for i=#t-25,#t-1 do
            if ok[v - t[i]] then
                found = true
                break
            end
        end
        if not found then
            obj = v
        end
        ok[t[#t-25]] = ok[t[#t-25]] - 1
        if ok[t[#t-25]] == 0 then ok[t[#t-25]] = nil end
    end
    ok[v] = (ok[v] or 0) + 1
end

local val = {}
table.move(t, 1, #t, 1, val)
for k=1,#t do
    local found = false
    for i=k+1,#t do
        val[i] = val[i] + t[i-k]
        if obj == val[i] then
            print(math.min(table.unpack(t,i-k,i)) + math.max(table.unpack(t,i-k,i)))
            found = true
            break
        end
    end
    if found then break end
end
