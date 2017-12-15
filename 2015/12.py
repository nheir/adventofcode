import json
d = json.load(open('input12'))
def s(t):
 if isinstance(t,int):
  return t
 if not t or isinstance(t,str):
  return 0
 if isinstance(t,list):
  return sum(map(s,t))
 if isinstance(t,dict):
  if 'red' in t.values():
   return 0
  return sum(map(s,t.values()))
print(s(d))


