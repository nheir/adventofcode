local function f(n)
	--   (((x+10)*y+n)*(x+10)%1000)//100-5

	local t = {}
	local max, max_x, max_y, max_size = -6
	for x=1,300 do
		t[x] = {}
		for y=1,300 do
			t[x][y] = ((((x+10)*y+n)*(x+10))%1000)//100-5
			if t[x][y] > max then
				max = t[x][y]
				max_x = x
				max_y = y
				max_size = 1
			end
		end
	end

	local t1,t2 = t,{}
	for size=2,300 do
		local tt = {}
		for x=1,300-size+1 do
			tt[x] = {}
			for y=1,300-size+1 do
				tt[x][y] = t1[x][y] + t1[x+1][y+1] + t[x+size-1][y] + t[x][y+size-1] - (t2[x+1] and t2[x+1][y+1] or 0)
				if tt[x][y] > max then
					max = tt[x][y]
					max_x = x
					max_y = y
					max_size = size
				end
			end
		end
		t1,t2 = tt,t1
	end

	return max_x,max_y,max_size
end

local n = io.read('n')
print(f(n%1000))