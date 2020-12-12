local dirs = {{1,0},{0,1},{-1,0},{0,-1}}
local dir = 0

local x,y = 0,0

for l in io.lines() do
	local c = l:sub(1,1)
	local n = tonumber(l:sub(2,#l))

	if c == 'R' then
		dir = (dir - (n//90))%4
	elseif c == 'L' then
		dir = (dir + (n//90))%4
	else
		local d = ({
			F=dirs[dir+1],
			E=dirs[1],
			N=dirs[2],
			W=dirs[3],
			S=dirs[4],
		})[c]
		x,y = x+d[1]*n, y+d[2]*n
	end
end

print(math.abs(x)+math.abs(y))
