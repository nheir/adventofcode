function f(s)
  local t = load('return {'..s:gsub('-?%d+','%1,')..'}')() 
  local ret = 0
  local i = 1
  while i <= #t do
    i,t[i] = i+t[i], (t[i] < 3) and (t[i]+1) or (t[i]-1)
    ret = ret + 1 
  end
  return ret
end

print(f(io.read("a")))
