local t = {}

local function insert(t, v, s)
	if not t[v] then
		t[v] = { c = 0 }
	end
	if #s > 0 then insert(t[v], string.byte(s) - string.byte('0'), s:sub(2,#s)) end
	t[v].c = t[v].c + 1 
end

local function max(t,i) 
	if not t[0] and not t[1] then return i end
	if not t[1] then return max(t[0], i<<1) end
	if not t[0] then return max(t[1], (i<<1) + 1) end
	if t[0].c > t[1].c then return max(t[0],i<<1) end	
	return max(t[1],(i<<1)+1)
end

local function min(t,i) 
	if not t[0] and not t[1] then return i end
	if not t[1] then return min(t[0], i<<1) end
	if not t[0] then return min(t[1], (i<<1) + 1) end
	if t[0].c <= t[1].c then return min(t[0],i<<1) end	
	return min(t[1],(i<<1)+1)
end

for l in io.lines() do
	if #l > 0 then insert(t, string.byte(l) - string.byte('0'), l:sub(2)) end
end

print(max(t,0))
print(min(t,0))
print(max(t,0)*min(t,0))
