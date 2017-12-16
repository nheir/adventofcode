r = [ 
("Al", ["Th","F"]),
("Al", ["Th","Rn","F","Ar"]),
("B", ["B","Ca"]),
("B", ["Ti","B"]),
("B", ["Ti","Rn","F","Ar"]),
("Ca", ["Ca","Ca"]),
("Ca", ["P","B"]),
("Ca", ["P","Rn","F","Ar"]),
("Ca", ["Si","Rn","F","Y","F","Ar"]),
("Ca", ["Si","Rn","Mg","Ar"]),
("Ca", ["Si","Th"]),
("F", ["Ca","F"]),
("F", ["P","Mg"]),
("F", ["Si","Al"]),
("H", ["C","Rn","Al","Ar"]),
("H", ["C","Rn","F","Y","F","Y","F","Ar"]),
("H", ["C","Rn","F","Y","Mg","Ar"]),
("H", ["C","Rn","Mg","Y","F","Ar"]),
("H", ["H","Ca"]),
("H", ["N","Rn","F","Y","F","Ar"]),
("H", ["N","Rn","Mg","Ar"]),
("H", ["N","Th"]),
("H", ["O","B"]),
("H", ["O","Rn","F","Ar"]),
("Mg", ["B","F"]),
("Mg", ["Ti","Mg"]),
("N", ["C","Rn","F","Ar"]),
("N", ["H","Si"]),
("O", ["C","Rn","F","Y","F","Ar"]),
("O", ["C","Rn","Mg","Ar"]),
("O", ["H","P"]),
("O", ["N","Rn","F","Ar"]),
("O", ["O","Ti"]),
("P", ["Ca","P"]),
("P", ["P","Ti"]),
("P", ["Si","Rn","F","Ar"]),
("Si", ["Ca","Si"]),
("Th", ["Th","Ca"]),
("Ti", ["B","P"]),
("Ti", ["Ti","Ti"]),
("e", ["H","F"]),
("e", ["N","Al"]),
("e", ["O","Mg"])
]


s = ["O","Rn","P","B","P","Mg","Ar","Ca","Ca","Ca","Si","Th","Ca","Ca","Si","Th","Ca","Ca","P","B","Si","Rn","F","Ar","Rn","F","Ar","Ca","Ca","Si","Th","Ca","Ca","Si","Th","Ca","Ca","Ca","Ca","Ca","Ca","Si","Rn","F","Y","F","Ar","Si","Rn","Mg","Ar","Ca","Si","Rn","P","Ti","Ti","B","F","Y","P","B","F","Ar","Si","Rn","Ca","Si","Rn","Ti","Rn","F","Ar","Si","Al","Ar","P","Ti","B","P","Ti","Rn","Ca","Si","Al","Ar","Ca","P","Ti","Ti","B","P","Mg","Y","F","Ar","P","Ti","Rn","F","Ar","Si","Rn","Ca","Ca","F","Ar","Rn","Ca","F","Ar","Ca","Si","Rn","Si","Rn","Mg","Ar","F","Y","Ca","Si","Rn","Mg","Ar","Ca","Ca","Si","Th","P","Rn","F","Ar","P","B","Ca","Si","Rn","Mg","Ar","Ca","Ca","Si","Th","Ca","Si","Rn","Ti","Mg","Ar","F","Ar","Si","Th","Si","Th","Ca","Ca","Si","Rn","Mg","Ar","Ca","Ca","Si","Rn","F","Ar","Ti","B","P","Ti","Rn","Ca","Si","Al","Ar","Ca","P","Ti","Rn","F","Ar","P","B","P","B","Ca","Ca","Si","Th","Ca","P","B","Si","Th","P","Rn","F","Ar","Si","Th","Ca","Si","Th","Ca","Si","Th","Ca","P","Ti","B","Si","Rn","F","Y","F","Ar","Ca","Ca","P","Rn","F","Ar","P","B","Ca","Ca","P","B","Si","Rn","Ti","Rn","F","Ar","Ca","P","Rn","F","Ar","Si","Rn","Ca","Ca","Ca","Si","Th","Ca","Rn","Ca","F","Ar","Y","Ca","Si","Rn","F","Ar","B","Ca","Ca","Ca","Si","Th","F","Ar","P","B","F","Ar","Ca","Si","Rn","F","Ar","Rn","Ca","Ca","Ca","F","Ar","Si","Rn","F","Ar","Ti","Rn","P","Mg","Ar","F"]
for i in s:
 print(i)
exit(0)
c = "e"
l = [(''.join(s),0)]
seen = { i:set() for i in range(1,len(l[0][0])+1) }

def occ(o,c):
  i = o.find(c)
  l = []
  while i != -1:
    yield i
    i = o.find(c,i+len(c))

d = [ (u,''.join(v)) for u,v in r ]

while l:
  c,t = l.pop(0)
  print(c,t)
  for u,v in d:
    e = len(v)
    if "e" == u:
      if c != v:
        continue
      else:
        print(t+1)
        exit(0)
    for i in occ(c,v):
      if c[i:i+e] == v:
        a = c[:i]+u+c[i+e:]
        if a not in seen[len(a)]:
            l.append((a,t+1))
            seen[len(a)].add(a)
