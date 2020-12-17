local grid = {}

local function key(...)
	return string.format('%d %d %d', ...)
end

local function keytonum(s)
	local a,b,c = s:match("(-?%d+) (-?%d+) (-?%d+)")
	return tonumber(a), tonumber(b), tonumber(c)
end

local i = 0
for l in io.lines() do
	for j=0,#l-1 do
		if l:sub(j+1,j+1) == '#' then
			grid[key(i,j,0)] = 1
		end
	end
	i = i + 1
end

function inc(d,k)
	d[k] = (d[k] or 0) + 1
end
function dec(d,k)
	if d[k] == 1 then
		d[k] = nil
	elseif d[k] then
		d[k] = d[k] - 1
	end
end

for _=1,6 do
	local ng = {}
	for k in pairs(grid) do
		local x,y,z = keytonum(k)
		for dx=-1,1 do
			for dy=-1,1 do
				for dz=-1,1 do
					inc(ng,key(x+dx,y+dy,z+dz))
				end
			end
		end
		dec(ng,k)
	end
	for k,v in pairs(ng) do
		if grid[k] and 2 <= v and v <= 3 then
			ng[k] = 1
		elseif v == 3 then
			ng[k] = 1
		else
			ng[k] = nil
		end
	end
	grid = ng
end

local c = 0
for k in pairs(grid) do c = c + 1 end
print(c)
