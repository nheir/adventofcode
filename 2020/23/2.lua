local p = {}
for i in io.input():lines(1) do
	p[#p+1] = tonumber(i)
end

local N = 1000000

local suivant = {}
for i,k in ipairs(p) do
	suivant[k] = p[i+1] or 10
end
for i=10,N-1 do
	suivant[i] = i+1
end
suivant[1000000] = p[1]

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
for _=1,10000000 do
	k = move(k)
end

print(suivant[1]*suivant[suivant[1]])