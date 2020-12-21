local dirs = {{1,0},{0,1},{-1,0},{0,-1}}
local dir = 0

local x,y = 0,0
local wx, wy = 10,1

for l in io.lines() do
	local c = l:sub(1,1)
	local n = tonumber(l:sub(2,#l))

	if c == 'R' or c == 'L' then
		if c == 'R' then n = 360-n end
		if n == 90 then
			wx,wy = -wy, wx
		elseif n == 180 then
			wx,wy = -wx, -wy
		elseif n == 270 then
			wx,wy = wy, -wx
		end
	elseif c == 'F' then
		x,y = x+wx*n, y+wy*n
	else
		local d = ({
			E=dirs[1],
			N=dirs[2],
			W=dirs[3],
			S=dirs[4],
		})[c]
		wx,wy = wx+d[1]*n, wy+d[2]*n
	end
end

print(math.abs(x)+math.abs(y))
