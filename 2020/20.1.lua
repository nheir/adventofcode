local tuiles = {}
local taille

local function l2t(l)
    if l == '' then return end
    if l:sub(1,1) == '#' then 
        return 1, l2t(l:sub(2))
    end
    return 0, l2t(l:sub(2))
end

local function calcul_bords(t)
    t.nord = 0
    t.sud = 0
    t.est = 0
    t.ouest = 0
    t.rnord = 0
    t.rsud = 0
    t.rest = 0
    t.rouest = 0
    for i=1,taille do
        t.nord = (t.nord << 1) | t[1][i]
        t.sud = (t.sud << 1) | t[#t][i]
        t.est = (t.est << 1) | t[i][1]
        t.ouest = (t.ouest << 1) | t[i][#t]
        t.rnord = (t.rnord << 1) | t[1][#t-i+1]
        t.rsud = (t.rsud << 1) | t[#t][#t-i+1]
        t.rest = (t.rest << 1) | t[#t-i+1][1]
        t.rouest = (t.rouest << 1) | t[#t-i+1][#t]
    end
    t.voisins = {}
end

local num
local t = {}
for l in io.lines() do
    if l:sub(1,1) == 'T' then
        num = tonumber(l:match('%d+'))
    elseif l == '' then
        tuiles[num] = t
        calcul_bords(t)
        t = {}
    else
        t[#t+1] = {l2t(l)}
        taille = #t[1]
    end
end
if #t > 0 then
    tuiles[num] = t
    calcul_bords(t)
end 

local bords = {}
for id,tuile in pairs(tuiles) do
    for k,b in pairs(tuile) do
        if type(k) ~= 'number' then
            local t = bords[b] or {}
            t[id] = true
            bords[b] = t
        end
    end
end

for b,t in pairs(bords) do
    for k in pairs(t) do
        for kk in pairs(t) do
            if k ~= kk then
                tuiles[k].voisins[kk] = true
            end
        end
    end
end

local ret  = 1
for k,tuile in pairs(tuiles) do
    local t = {}
    for v in pairs(tuile.voisins) do
        table.insert(t,v)
    end
    tuile.voisins = t
    if #tuile.voisins == 2 then 
        print(k)
        ret = ret * k
    end
end
print(ret)