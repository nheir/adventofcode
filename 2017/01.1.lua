function f(s)
  local t = load('return {'..s:gsub('%d','%1,')..'}')() 
  local ret = 0
  for i=1,#t do
    ret = (t[i] == t[i%#t+1]) and (ret+t[i]) or ret 
  end
  return ret
end

print(f(io.read("a")))
