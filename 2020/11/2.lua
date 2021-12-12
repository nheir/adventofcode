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

local change = true
while change do
	change = false
	local nextgrid = {}
	for i=1,w do
		nextgrid[i] = {}
		for j=1,h do
			nextgrid[i][j] = 0
		end
	end
	for i=1,w do
		for j=1,h do
			if grid[i][j] == 1 then
				for x=-1,1 do
					for y=-1,1 do
						if x ~= 0 or y ~= 0 then
							for k=1,w+h do
								local x = i+k*x
								local y = j+k*y
								if x < 1 or x > w or y < 1 or y > h then break end
								if grid[x][y] then
									nextgrid[x][y] = nextgrid[x][y] + 1
									break
								end
							end
						end
					end
				end
			end
		end
	end

	for i=1,w do
		for j=1,h do
			if not grid[i][j] then nextgrid[i][j] = nil
			else
				local c = nextgrid[i][j]
				if c == 0 then
					nextgrid[i][j] = 1
					if grid[i][j] == 0 then change = true end
				elseif c > 4 and grid[i][j] == 1 then
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