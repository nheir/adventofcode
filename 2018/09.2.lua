local function max_t(t)
	local max_v, max_i
	for i,v in pairs(t) do
		if max_i == nil or max_v < v then
			max_i = i
			max_v = v
		end
	end
	return max_i, max_v
end

local function f(m,n)
	local score = {}
	for i=0,m-1 do
		score[i] = 0
	end
	local cycle_next = {[0]=2,0,1}
	local cycle_prev = {[0]=1,2,0}
	local current = 2
	for i=3,n do
		if i % 23 == 0 then
			for _=1,7 do
				current = cycle_prev[current]
			end
			score[i%m] = score[i%m] + i + current
			cycle_prev[cycle_next[current]] = cycle_prev[current]
			cycle_next[cycle_prev[current]] = cycle_next[current]
			current = cycle_next[current]
		else
			current = cycle_next[current]
			cycle_next[i] = cycle_next[current]
			cycle_prev[i] = current
			cycle_prev[cycle_next[i]] = i
			cycle_next[cycle_prev[i]] = i
			current = i
		end
	end

	return select(2,max_t(score))
	
end


local m,n = io.read('a'):match('(%d+) players; last marble is worth (%d+) points')
m = tonumber(m)
n = tonumber(n)
print(f(m,n*100))