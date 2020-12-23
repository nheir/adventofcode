local p = {}
for i in io.input():lines(1) do
	p[#p+1] = tonumber(i)
end

local N = #p

local suivant = {}
for i,k in ipairs(p) do
	suivant[k] = p[i%N+1]
end

function move(v)
	local a = suivant[v]
	local b = suivant[a]
	local c = suivant[b]
	local t = {[a]=true,[b]=true,[c]=true}
	local dest = (v-2)%N+1
	while t[dest] do
		dest = (dest-2)%N+1
	end
	suivant[v] = suivant[c]
	suivant[c] = suivant[dest]
	suivant[dest] = a
	return suivant[v]
end

local k = p[1]
for _=1,100 do
	k = move(k)
end

local k = 1
for i=2,N do
	k = suivant[k]
	io.write(tostring(k))
end