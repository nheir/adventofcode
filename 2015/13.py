l = open('input13').readlines()
l = [ d[:-2].split() for d in l[:-1]]
d = { (d[0],d[10]): ( 1 if d[2] == 'gain' else -1)*int(d[3]) for d in l }
m=0
def bt(start,s,u,v):
  global m
  if not s:
    m = max(m,v+d[start,u]+d[u,start])
    return
  for i in s:
    bt(start,s-{i},i,v+d[u,i]+d[i,u])

s = { u for u,v in d}
for u in s:
 d[0,u]=d[u,0]=0
bt(0,s,0,0)
print(m-709)

