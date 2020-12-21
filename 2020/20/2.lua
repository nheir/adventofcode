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
        t.ouest = (t.ouest << 1) | t[i][1]
        t.est = (t.est << 1) | t[i][#t]
        t.rnord = (t.rnord << 1) | t[1][#t-i+1]
        t.rsud = (t.rsud << 1) | t[#t][#t-i+1]
        t.rouest = (t.rouest << 1) | t[#t-i+1][1]
        t.rest = (t.rest << 1) | t[#t-i+1][#t]
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

local function set2array(s)
    local t = {}
    for v in pairs(s) do
        table.insert(t,v)
    end
    return t
end

for b,t in pairs(bords) do
    bords[b] = set2array(t)
    t = bords[b]
    for i=1,#t do
        for j=i+1,#t do
            tuiles[t[i]].voisins[t[j]] = true
            tuiles[t[j]].voisins[t[i]] = true
        end
    end
end

local ret  = 1
local coin
for k,tuile in pairs(tuiles) do
    tuile.voisins = set2array(tuile.voisins)
    if #tuile.voisins == 2 and not coin then
        coin = k
    end
end

local function key(...)
    return string.format("%d %d", ...)
end

local function flipLR(t)
    t.nord, t.sud, t.est, t.ouest, t.rnord, t.rsud, t.rest, t.rouest =  t.rnord, t.rsud, t.ouest, t.est, t.nord, t.sud, t.rouest, t.rest
    for _,v in ipairs(t) do
        for i=1,#v/2 do v[i], v[#v-i+1] = v[#v-i+1], v[i] end
    end
end

local function rot(t)
    t.nord, t.sud, t.est, t.ouest, t.rnord, t.rsud, t.rest, t.rouest =  t.rouest, t.rest, t.nord, t.sud, t.ouest, t.est, t.rnord, t.rsud
    local tt = {}
    for i=1,#t do
        tt[i] = {}
        for j=1,#t do
            tt[i][j] = t[#t-j+1][i]
        end
    end
    for i=1,#t do t[i] = tt[i] end
end

local grid = { { coin } }
while #bords[tuiles[coin].nord] > 1 or #bords[tuiles[coin].ouest] > 1 do rot(tuiles[coin]) end

local i = 1
local debut = coin
while #bords[tuiles[debut].sud] > 1 do
    local a,b = table.unpack(bords[tuiles[debut].sud])
    local suivant = (b == debut) and a or b
    while tuiles[suivant].nord ~= tuiles[debut].sud and tuiles[suivant].rnord ~= tuiles[debut].sud do
        rot(tuiles[suivant]) 
    end
    if tuiles[suivant].rnord == tuiles[debut].sud then
        flipLR(tuiles[suivant])
    end
    i = i + 1
    grid[i] = {suivant}
    debut = suivant
end

for i=1,#grid do 
    local j = 1
    local debut = grid[i][1]
    while #bords[tuiles[debut].est] > 1 do
        local a,b = table.unpack(bords[tuiles[debut].est])
        local suivant = (b == debut) and a or b
        while tuiles[suivant].ouest ~= tuiles[debut].est and tuiles[suivant].est ~= tuiles[debut].est do
            rot(tuiles[suivant]) 
        end
        if tuiles[suivant].est == tuiles[debut].est then
            flipLR(tuiles[suivant])
        end
        j = j + 1
        grid[i][j] = suivant
        debut = suivant
    end
end

local sea_monster = {
    '                  # ',
    '#    ##    ##    ###',
    ' #  #  #  #  #  #   ',
}
for i,t in ipairs(sea_monster) do
    sea_monster[i] = sea_monster[i]:gsub(' ', '.')
end

local num = 0
local text_grid = {}
for x,ligne in ipairs(grid) do
    local i = (x-1)*(taille-2)
    for j=1,taille-2 do text_grid[i+j] = {} end
    for y,c in ipairs(ligne) do
        j = (y-1)*(taille-2)
        local t = tuiles[c]
        for m=2,taille-1 do
            for n=2,taille-1 do
                text_grid[i+m-1][j+n-1] = (t[m][n] == 1) and '#' or ' '
                num = num + t[m][n]
            end
        end
    end
end

for _=1,2 do
    for _=1,4 do
        local count = 0
        local text = {}
        for i,l in ipairs(text_grid) do
            text[i]=table.concat(l)
        end
        for i=2,#text-1 do
            local j
            repeat
                j = text[i]:find(sea_monster[2], j)
                if j 
                    and text[i-1]:find(sea_monster[1],j) == j
                    and text[i+1]:find(sea_monster[3],j) == j then
                    count = count + 1
                    j = j+#sea_monster[1]
                elseif j then
                    j = j+1
                end
            until not j
        end
        if count > 0 then 
            print(num - count*15)
            os.exit(0)
        end
        rot(text_grid)
    end
    flipLR(text_grid)
end
