l = [3,1,1,3,3,2,2,1,1,3]
def a(l):
 k = []
 p,f = -1,0
 for i in range(len(l)):
  if p == l[i]:
   f += 1
  else:
   if p>0:
    k+=[f,p]
   p = l[i]
   f = 1
 k+=[f,p]
 return k

for _ in range(50):
 l=a(l)
print(len(l))
