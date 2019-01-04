function g(t)
  local next = {}
  local prev = {}
  for i=0,#t do
    next[i] = i+1
    prev[i] = i-1
  end
  local size = #t
  local count = 0
  local i = 1
  while i < size and next[i] <= size do
  	if t[i] == t[next[i]]~32 then
      next[prev[i]] = next[next[i]]
      prev[next[next[i]]] = prev[i]
  		i = prev[i]
      count = count + 2
  	else
  		i = next[i]
  	end
  end
  local ret = {}
  i = 0
  while i <= size do
  	table.insert(ret,t[i])
  	i = next[i]
  end
  return ret
end

function remove(t,i)
	local ret = {}
	for _,v in ipairs(t) do
		if v ~= i and v ~= i~32 then
			table.insert(ret,v)
		end
	end
	return ret
end

function f(s)
  local t = {string.byte(s,1,-1)}
	t = g(t)
	local min = #g(remove(t,0x41))
	for i=0x42,0x5a do
		local v = #g(remove(t,i))
		if v < min then
			min = v
		end
	end
	return min
end

print(f(io.read("l")))
