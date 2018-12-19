function f(s)
  local t = {string.byte(s,1,-1)}
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
  return #t
end

print(f(io.read("l")))
