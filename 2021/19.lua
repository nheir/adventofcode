local t = {}

local s
for l in io.lines() do
	if l == '' and s then
		t[#t+1] = s
		s = nil
	elseif l:sub(1,2) == '--' then
		s = {}
	else
		table.insert(s, load('return {' .. l .. '}')())
	end
end

local function scalar(a,b)
	return {a*b[1],a*b[2],a*b[3]}
end

local function cross(a,b)
	return {
		a[2]*b[3]-b[2]*a[3],
		a[3]*b[1]-b[3]*a[1],
		a[1]*b[2]-b[1]*a[2],
	}
end

local function dot(a,b)
	return a[1]*b[1] + a[2]*b[2] + a[3]*b[3]
end

local base = {
	{1,0,0},
	{0,1,0},
	{0,0,1},
}

local function rots(a)
	local t = {}
	for _,i in pairs(base) do
		for _,j in pairs(base) do
			if i ~= j then
				for s=0,3 do
					local s1 = 1-2*(s&1)
					local s2 = 1-1*(s&2)
					local i = scalar(s1,i)
					local j = scalar(s2,j)
					local k = cross(i,j)
					t[#t+1] = { dot(i,a), dot(j,a), dot(k,a) }
				end
			end
		end
	end
	return t
end

local function diff(a,b)
	return {
		a[1]-b[1],
		a[2]-b[2],
		a[3]-b[3],
	}
end

local function key(t)
	return string.unpack('I6', string.pack('i2i2i2', t[1], t[2], t[3]))
end

local function skey(n)
	return string.unpack('i2i2i2', string.pack('I6', n))
end

local function norm2(t)
	return dot(t,t)
end

local d = {}
for i=1,#t do
	d[i] = {}
	for j=1,#t[i] do
		d[i][j] = {}
		for k=1,#t[i] do
			local dif = diff(t[i][k], t[i][j])
			local n = norm2(dif)
			assert(not d[i][j][n])
			d[i][j][n] = k
		end
	end
end

local function inter(a,b)
	local count = 0
	for n in pairs(a) do
		if b[n] then
			count = count + 1
		end
	end
	return count
end

local function sinter(a,b)
	local mcount = 0
	local im, jm
	for i=1,#a do
		for j=1,#b do
			local count = inter(a[i], b[j])
			if count > mcount then
				im, jm = i, j
				mcount = count
			end
		end
	end
	return mcount, im, jm
end


local function unify(t, d, i, a, j, b)
	local v1 = t[i][a]
	local v2 = t[j][b]

	local rn1 = d[i][a]
	local rn2 = d[j][b]

	local rv1 = {}
	for _,v in ipairs(t[i]) do
		rv1[#rv1+1] = diff(v, v1)
	end

	local rv2 = {}
	for _,v in ipairs(t[j]) do
		rv2[#rv2+1] = rots(diff(v, v2))
	end
	for k=1,24 do
		local c = 0
		for n in pairs(rn1) do
			if rn2[n] then
				if norm2(diff(rv1[rn1[n]], rv2[rn2[n]][k])) == 0 then
					c = c + 1
				end
			end
		end
		if c >= 12 then
			return diff(v1, rots(v2)[k]), k
		end
	end
	return
end

local function transform(t, rot, drift)
	drift = scalar(-1, drift)
	for i,v in ipairs(t) do
		t[i] = diff(rots(v)[rot], drift)
	end
end

local toDo = {1}
local seen = {}

local scanners = {}
for i=1,#t do
	table.insert(scanners, {0,0,0})
end

while #toDo > 0 do
	local i = table.remove(toDo)
	if not seen[i] then
		seen[i] = true
		for j=1,#d do
			if not seen[j] then
				local c, a, b = sinter(d[i], d[j])
				if c >= 11 then
					local drift, rot = unify(t, d, i, a, j, b)
					transform(t[j], rot, drift)
					table.insert(toDo, j)
					scanners[j] = diff(scanners[j], drift)
				end
			end
		end
	end
end

local count = 0
local seen = {}
for i,v in ipairs(t) do
	for j,b in ipairs(v) do
		local k = key(b)
		if not seen[k] then
			count = count + 1
			seen[k] = true
		end
	end
end
print(count)

local max = 0
for i,s1 in ipairs(scanners) do
	for j,s2 in ipairs(scanners) do
		local d = diff(s1, s2)
		local m = math.abs(d[1])+math.abs(d[2])+math.abs(d[3])
		if m > max then
			max = m
		end
	end
end
print(max)
