function f(s)
  local t = {string.byte(s,1,-1)}
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
  return #t - count
end

print(f(io.read("l")))
