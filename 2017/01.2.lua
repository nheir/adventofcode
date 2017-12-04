function f(s)
  local t = load('return {'..s:gsub('%d','%1,')..'}')() 
  local ret = 0
  for i=1,#t/2 do
    ret = (t[i] == t[i+#t/2]) and (ret+t[i]) or ret 
  end
  return ret*2
end

print(f(io.read("a")))
