function intersec_rec(a,b)
  local x1,y1,w1,h1 = table.unpack(a)
  local x2,y2,w2,h2 = table.unpack(b)
  return intersec_seg(x1,x1+w1-1,x2,x2+w2-1) and intersec_seg(y1,y1+h1-1,y2,y2+h2-1)
end

function intersec_seg(a,b,c,d)
  return (a <= c and c <= b) or (c <= a and a <= d)
end

function f(t)
  for i=1,#t do
    local ok = true
    for j=1,#t do
      if i ~= j and intersec_rec(t[i],t[j]) then
        ok = false
        break
      end
    end
    if ok then
      return i
    end
  end
  return ret
end

local t = {}
for l in io.lines() do
  local x,y,w,h = l:match("(%d+),(%d+): (%d+)x(%d+)")
  table.insert(t,{tonumber(x),tonumber(y),tonumber(w),tonumber(h)})
end

print(f(t))
