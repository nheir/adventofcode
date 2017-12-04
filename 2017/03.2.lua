input = 312051

t = {}
function k(...) return string.format("%d %d", ...) end
s = {{0,1},{1,0},{0,-1},{-1,0}}
function n(i,j,p) return i+s[p%4+1][1],j+s[p%4+1][2] end
t[k(0,0)] = 1
i,j=0,0
p = 0
while t[k(i,j)] < input do
  if not t[k(n(i,j,p+1))] then p = p+1 end
  i,j = n(i,j,p)
  t[k(i,j)] = 0
  for u=-1,1 do for v=-1,1 do
    if u ~= 0 or v ~= 0 then t[k(i,j)] = t[k(i,j)] + (t[k(i+u,j+v)] or 0) end
  end end
end

print(t[k(i,j)])
