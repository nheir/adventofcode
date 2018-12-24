local ground = {}
local translate = {['.'] = 1, ['|'] = 2, ['#'] = 3}
local i = 1
for l in io.lines() do
	local t = {}
	for i=1,#l do
		t[i] = translate[l:sub(i,i)]
	end
	ground[i] = t
	i = i+1
end

local function rule(x,y,ground) 
	local c = {0,0,0}
	for i=-1,1 do
		if ground[x+i] then
			for j=-1,1 do
				if c[ground[x+i][y+j]] and (i ~= 0 or j ~= 0) then
					c[ground[x+i][y+j]] = c[ground[x+i][y+j]] + 1
				end
			end
		end
	end
	if ground[x][y] == 1 then
		if c[2] >= 3 then
			return 2
		end
	elseif ground[x][y] == 2 then
		if c[3] >= 3 then
			return 3
		end
	else
		if c[3] == 0 or c[2] == 0 then
			return 1
		end
	end
	return ground[x][y]
end

-- assuming it becomes periodic in last 1000 minutes with more than 4
local limit = 1000
local counts = {}
for _=1,limit do
	local next_ground = {}
	for x=1,#ground do
		next_ground[x] = {}
		for y=1,#ground[x] do
			next_ground[x][y] = rule(x,y,ground)
		end
	end
	ground = next_ground

	local count = {0,0,0}
	for x=1,#ground do
		for y=1,#ground[x] do
			count[ground[x][y]] = count[ground[x][y]] + 1
		end
	end
	table.insert(counts,count[2]*count[3])
end

local function is_period(T)
	local last = #counts
	for i=0,3 do
		for j=last,last-T+1,-1 do
			if counts[j-i*T] ~= counts[j-T-i*T] then
				return false
			end
		end
	end
	return true
end


local T = 1
while not is_period(T) do T = T + 1 end

local offset = (1000000000-limit) % T
print(counts[#counts+offset-T])