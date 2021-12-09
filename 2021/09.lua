local t = {}

for l in io.lines() do
	local r = {}
	for d in l:gmatch('%d') do r[#r+1] = tonumber(d) end
	if #r > 0 then t[#t+1] = r end
end

local m = {}
for i,r in ipairs(t) do
	for j,v in ipairs(r) do
		local a,b,c = r[j-1],r[j],r[j+1]
		if (not a or a > b) and (not c or b < c) then
			m[#m+1] = {i,j}
		end
	end
end

local ret = 0
local low = {}
for _,ij in pairs(m) do
	local i,j = table.unpack(ij)
	local a,b,c = (t[i-1] and t[i-1][j]), t[i][j], (t[i+1] and t[i+1][j])
	if (not a or a > b) and (not c or b < c) then
		table.insert(low, ij)
		ret = ret + b + 1
	end
end
print(ret)

local function flood(i,j,marked)
	if marked[(i<<10)|j] then return 0 end
	marked[(i<<10)|j] = true
	if t[i][j] == 9 then return 0 end
	local s = 1
	if t[i-1] and t[i-1][j] > t[i][j] then
		s = s + flood(i-1,j,marked)
	end
	if t[i+1] and t[i+1][j] > t[i][j] then
		s = s + flood(i+1,j,marked)
	end
	if t[i][j+1] and t[i][j+1] > t[i][j] then
		s = s + flood(i,j+1,marked)
	end
	if t[i][j-1] and t[i][j-1] > t[i][j] then
		s = s + flood(i,j-1,marked)
	end
	return s
end

local ret = {}
for _,ij in pairs(low) do
	local i,j = table.unpack(ij)
	table.insert(ret, flood(i,j,{}))
end
table.sort(ret)

print(ret[#ret]*ret[#ret-1]*ret[#ret-2])