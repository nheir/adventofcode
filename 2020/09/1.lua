local t = {}
local ok = {}
for l in io.lines() do
    local v = tonumber(l)
    t[#t+1] = v
    if #t >= 26 then
        local found = false
        for i=#t-25,#t-1 do
            if ok[v - t[i]] then
                found = true
                break
            end
        end
        if not found then
            print(v)
        end
        ok[t[#t-25]] = ok[t[#t-25]] - 1
        if ok[t[#t-25]] == 0 then ok[t[#t-25]] = nil end
    end
    ok[v] = (ok[v] or 0) + 1
end