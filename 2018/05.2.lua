function g(t)
  local i = 1
  while i < #t do
  	if t[i] == t[i+1]~32 then
  		table.remove(t,i+1)
  		table.remove(t,i)
  		i = i-1
  	else
  		i = i+1
  	end
  end
  return t
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
	local min = #(g(remove(t,0x41)))
	for i=0x42,0x5a do
		local v = #(g(remove(t,i)))
		if v < min then
			min = v
		end
	end
	return min
end

print(f(io.read("l")))
