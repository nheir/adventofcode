p = open("input23").readlines()
instr = [ l.strip().replace(',','').split() for l in p]

register = { 'a':1 , 'b':0 }

pt = 0
end = len(instr)
while pt < end:
    inst = instr[pt]
    print(pt,inst)
    if inst[0] == 'hlf':
        register[inst[1]] //= 2
    elif inst[0] == 'tpl':
        register[inst[1]] *= 3
    elif inst[0] == 'inc':
        register[inst[1]] += 1
    elif inst[0] == 'jmp':
        pt += int(inst[1])-1
    elif inst[0] == 'jie':
        if not register[inst[1]] & 1:
            pt += int(inst[2])-1
    elif inst[0] == 'jio':
        if register[inst[1]] == 1:
            pt += int(inst[2])-1
    pt += 1
print(register)
