l = open('input14').readlines()
l = [ k.split() for k in l]
d = { k[0]:(int(k[3]),int(k[6]),int(k[13])) for k in l }
print(d)
t = 2503
b = [ (t // (b+c))*a*b + a*min(t % (b+c),b) for a,b,c in d.values() ]
print(max(b))
s = { u:-d[u][1] for u in d }
p = { u:0 for u in d }
pos = { u:0 for u in d }
for i in range(2503):
 for u in pos:
  if s[u] < 0:
   pos[u] += d[u][0]
  s[u] += 1
  if s[u] == d[u][2]:
   s[u] = -d[u][1]
 v = max(pos.values())
 for u in filter(lambda u: pos[u]==v,pos):
  p[u] += 1
print(max(p.values()))
