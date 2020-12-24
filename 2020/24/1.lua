local t = {}

local function key(...)
	return string.format("%d %d", ...)
end

local function ikey(k)
	local a,b = k:match('(%-?%d+) (%-?%d+)')
	return tonumber(a), tonumber(b)
end

local tiles = {}
local count = 0

for l in io.lines() do
	local i = 1
	local x,y = 0,0
	while i <= #l do
		local p1,p2 = l:sub(i,i), l:sub(i,i+1)
		if p2 == 'se' then
			x,y = x+1,y-1
		elseif p2 == 'sw' then
			x,y = x-1,y-1
		elseif p2 == 'ne' then
			x,y = x+1,y+1
		elseif p2 == 'nw' then
			x,y = x-1,y+1
		elseif p1 == 'e' then
			x,y = x+2,y
		elseif p1 == 'w' then
			x,y = x-2,y
		end
		i = i + 1
		if p1 == 's' or p1 == 'n' then i = i + 1 end
	end
	tiles[key(x,y)] = not tiles[key(x,y)] or nil
	t[#t+1] = l
end

if arg[0] == '2.lua' then
	for _=1,100 do
		local ntiles = {}
		for k in pairs(tiles) do
			local x,y = ikey(k)
			ntiles[key(x+1,y-1)] = (ntiles[key(x+1,y-1)] or 0)+1
			ntiles[key(x-1,y-1)] = (ntiles[key(x-1,y-1)] or 0)+1
			ntiles[key(x+1,y+1)] = (ntiles[key(x+1,y+1)] or 0)+1
			ntiles[key(x-1,y+1)] = (ntiles[key(x-1,y+1)] or 0)+1
			ntiles[key(x+2,y)] = (ntiles[key(x+2,y)] or 0)+1
			ntiles[key(x-2,y)] = (ntiles[key(x-2,y)] or 0)+1
		end
		for k in pairs(ntiles) do
			if tiles[k] and (ntiles[k] ~= 1 and ntiles[k] ~= 2) then
				ntiles[k] = nil
			elseif not tiles[k] and ntiles[k] == 2 then
				ntiles[k] = true
			else
				ntiles[k] = tiles[k]
			end
		end
		tiles = ntiles
	end
end

local count = 0
for k in pairs(tiles) do
	count = count + 1
end

print(count)


