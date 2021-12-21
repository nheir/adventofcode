local timer = (require "timer")()

local p1 = tonumber(io.read('l'):match(": (%d+)"))
local p2 = tonumber(io.read('l'):match(": (%d+)"))

local p = {p1-1,p2-1}
local score = {0,0}

local roll = 0
local d = 1
local turn = 1
while score[1] < 1000 and score[2] < 1000 do
	p[turn] = (p[turn] + 3*d+3) % 10
	score[turn] = score[turn] + p[turn] + 1
	d = d + 3
	roll = roll + 3
	turn = 3 - turn
end

timer:log("Simple game")
print(roll * math.min(score[1], score[2]))

local p = {p1-1,p2-1}

local pd = {}
for i=0,30 do
	pd[i] = {}
	for j=0,30 do
		pd[i][j] = {
			{0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,0,0,0,0,0,0},
		}
	end
end

pd[0][0][p1][p2] = 1

timer:log("Table initialization")

--
local comb = {}
for i=1,3 do
	for j=1,3 do
		for k=1,3 do
			comb[i+j+k] = (comb[i+j+k] or 0) + 1
		end
	end
end

for i=0,20 do
	for j=0,20 do
		for l=1,10 do
			for m=1,10 do
				local occ = pd[i][j][l][m]
				if occ > 0 then
					for k1,v1 in pairs(comb) do
						local pos1 = (l-1+k1) % 10 + 1
						if i+pos1 >= 21 then
							pd[i+pos1][j][pos1][m] = pd[i+pos1][j][pos1][m] + v1 * occ
						else
							for k2,v2 in pairs(comb) do
								local pos2 = (m-1+k2) % 10 + 1
								pd[i+pos1][j+pos2][pos1][pos2] = pd[i+pos1][j+pos2][pos1][pos2] + v1 * v2 * occ
							end
						end
					end
				end
			end
		end
	end
end
timer:log("Compute table [score1][score2][pos1][pos2]")

local count = {0,0}
for i=21,30 do
	for j=0,20 do
		for k=1,10 do
			for l=1,10 do
				count[1] = count[1] + pd[i][j][k][l]
				count[2] = count[2] + pd[j][i][k][l]
			end
		end
	end
end

timer:log("Sum victories")

print(math.max(count[1], count[2]))