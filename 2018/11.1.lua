local function f(n)
	--   (((x+10)*y+n)*(x+10)%1000)//100-5
	-- = (xxy+20xy+xn+100y+10n%1000)//100-5

	local t = {}
	for x=1,300 do 
		t[x] = {}
		for y=1,300 do
			t[x][y] = ((((x+10)*y+n)*(x+10))%1000)//100-5
		end
	end

	local max, max_x, max_y
	for x=1,300-2 do
		for y=1,300-2 do
			local v = 0
			for i=0,2 do
				for j=0,2 do
					v = v + t[x+i][y+j]
				end
			end
			if not max or v > max then
				max = v
				max_x = x
				max_y = y
			end
		end
	end

	return max_x,max_y,max
end

local n = io.read('n')
print(f(n%1000))