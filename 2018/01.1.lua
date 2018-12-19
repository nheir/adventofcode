function f(s)
  local ret = load('return 0'..s:gsub('\n',''))()
  return ret
end

print(f(io.read("a")))
