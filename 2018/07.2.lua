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
	local ret = -1
	local pool = {}
	for a,v in pairs(G) do
		if v.deg == 0 then
			pool[#pool+1] = a
		end
	end
	local count = 0
	local worker = {}
	while count < #V do
		for i=#worker,1,-1 do
			local v = worker[i]
			v.t = v.t-1
			if v.t == 0 then
				count = count + 1
				for _,b in ipairs(G[v.a]) do
					G[b].deg = G[b].deg-1
					if G[b].deg == 0 then
						pool[#pool+1] = b
					end
				end
				table.remove(worker,i)
			end
		end
		table.sort(pool)

		for i=#worker+1,5 do
			if #pool == 0 then
				break
			end
			local v = { a = pool[1] }
			table.remove(pool,1)
			v.t = 61 + string.byte(v.a) - 0x41
			worker[i] = v
		end

		ret = ret + 1
	end

	return ret
end

local t = {}
for l in io.lines() do
  local a,b = l:match("Step (%a) must be finished before step (%a) can begin.")
  table.insert(t,{a=a,b=b})
end

print(f(t))