local grid = {}

for l in io.lines() do
	grid[#grid+1] = table.pack(string.byte(l, 1, #l))
end

local w = #grid
local h = #grid[1]

local trans = {[string.byte('L')]=0,[string.byte('#')]=1,}

for i=1,w do
	for j=1,h do
		grid[i][j] = trans[grid[i][j]]
	end
end

local step = 1
local change = true
while change do
	-- for i=1,w do
	-- 	for j=1,h do
	-- 		io.write(grid[i][j] or ' ')
	-- 	end
	-- 	io.write('\n')
	-- end
	-- print("step", step)
	-- step = step + 1
	change = false
	local nextgrid = {}
	for i=1,w do
		nextgrid[i] = {}
		for j=1,h do
			if grid[i][j] then
				local c = - (grid[i][j] or 0)
				for x=i-1,i+1 do
					for y=j-1,j+1 do
						c = c + ((grid[x] or {})[y] or 0)
					end
				end
				if c == 0 then
					nextgrid[i][j] = 1
					if grid[i][j] == 0 then change = true end
				elseif c > 3 and grid[i][j] == 1 then
					nextgrid[i][j] = 0
					change = true
				else
					nextgrid[i][j] = grid[i][j]
				end
			end
		end
	end
	grid = nextgrid
end

local c = 0

for i=1,w do
	for j=1,h do
		c = c + (grid[i][j] or 0)
	end
end

print(c)