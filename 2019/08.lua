local input = io.read('a')

local w,h,d = 25, 6, #input // (25*6)

local function counts(s)
	local c = {}
	for l in s:gmatch(".") do
		c[l] = (c[l] or 0) + 1
	end
	return c
end

local r = {['0']=w*h}
for i=1,d do
	local c = counts(input:sub(1+w*h*(i-1), w*h*i))
	if c['0'] < r['0'] then
		r = c
	end
end

print(r['1']*r['2'])

local res = {}
for i=1,d do
	local s = input:sub(1+w*h*(i-1), w*h*i)
	for i=1,w*h do
		if not res[i] or res[i] == '2' then
			res[i] = s:sub(i,i)
		end
	end
end

local i = 0
for _=1,6 do
	for _=1,25 do
		io.write((res[i] == '1') and '█' or ' ')
		i = i + 1
	end
	io.write('\n')
end