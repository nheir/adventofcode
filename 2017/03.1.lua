print((function ()
  n = io.read("n")
  if n == 1 then 
    return 0
  else
    m = math.floor((math.sqrt(n)-1) / 2)*2 + 1
    if n == m*m then
      return m-1
    end
    n = n - m*m
    while n > 0 do n = n - (m+1) end
    if -n < (m+1)/2 then 
      n = n + (m+1) 
    else 
      n = -n 
    end
    return n
  end
end)())
