function f(s)
  local t = load('return {'..s:gsub('\n',','):gsub('+','') .. '}')()
  local seen = {}
  local i = 1
  local val = 0
  while not seen[val] do
  	seen[val] = true
  	val = val + t[i]
  	i = i + 1
  	if i > #t then i = 1 end
  end
  return val
end

print(f(io.read("a")))
