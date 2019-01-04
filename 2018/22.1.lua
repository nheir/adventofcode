local depth = tonumber(io.read("l"):match("(%d+)"))
local tx,ty = io.read("l"):match("(%d+),(%d+)")
tx,ty = tonumber(tx), tonumber(ty)

local _ero = {}
function ero(x,y)
	if not _ero[x] then _ero[x] = {} end
	if not _ero[x][y] then _ero[x][y] = (geo(x,y) + depth) % 20183 end
	return _ero[x][y]
end

local _geo = {}
function geo(x,y)
	if x == 0 then return y * 48271 end
	if y == 0 then return x * 16807 end
	if x == tx and y == ty then return 0 end
	if not _geo[x] then _geo[x] = {} end
	if not _geo[x][y] then _geo[x][y] = ero(x-1,y) * ero(x,y-1) end
	return _geo[x][y]
end

function typ(x,y)
	return ero(x,y) % 3
end

local count = 0
for x=0,tx do
	for y=0,ty do
		count = count + typ(x,y)
	end
end
print(count)
