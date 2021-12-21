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

local comb = {}
for i=1,3 do
	for j=1,3 do
		for k=1,3 do
			comb[i+j+k] = (comb[i+j+k] or 0) + 1
		end
	end
end

local cache = {}
local function get_cache(cache, first, ...)
	if not first then return cache end
	if not cache then return cache end
	return get_cache(cache[first], ...)
end

local function set_cache(cache, value, first, ...)
	if not ... then
		cache[first] = value
	else
		if not cache[first] then cache[first] = {} end
		set_cache(cache[first], value, ...)
	end
end

local function rec(pos1, pos2, score1, score2)
	if score2 >= 21 then return {0,1} end
	local v = get_cache(cache, pos1, pos2, score1, score2)
	if v then return v end
	v = {0,0}
	for k,n in pairs(comb) do
		local pos1 = (pos1 + k - 1) % 10 + 1
		local r = rec(pos2, pos1, score2, score1 + pos1)
		v[1] = v[1] + n*r[2]
		v[2] = v[2] + n*r[1]
	end
	set_cache(cache, v, pos1, pos2, score1, score2)
	return v
end

local count = rec(p1, p2, 0, 0)
timer:log("Compute victories")

print(math.max(count[1], count[2]))