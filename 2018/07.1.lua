function f(t)
	local G = {}
	local V = {}
	for _,v in pairs(t) do
		if not G[v.a] then
			V[#V+1] = v.a
			G[v.a] = { deg = 0 }
		end
		if not G[v.b] then
			V[#V+1] = v.b
			G[v.b] = { deg = 0}
		end
		G[v.b].deg = G[v.b].deg+1

		table.insert(G[v.a],v.b)
	end
	function comp(a,b)
		return G[a].deg < G[b].deg or (G[a].deg == G[b].deg and a < b)
	end
	local ret = {}
	for i=1,#V do
		table.sort(V,comp)
		ret[i] = V[i]
		G[ret[i]].deg = -1
		for _,b in ipairs(G[ret[i]]) do
			G[b].deg = G[b].deg-1
		end
	end

	return table.concat(ret)
end

local t = {}
for l in io.lines() do
  local a,b = l:match("Step (%a) must be finished before step (%a) can begin.")
  table.insert(t,{a=a,b=b})
end

print(f(t))