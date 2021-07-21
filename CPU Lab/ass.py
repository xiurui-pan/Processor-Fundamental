with open('machine.txt', 'r') as machine_code:
    compiled = open('compiled.txt', 'a')
    i = 0
    for line in machine_code:
        mystr = '   8\'d' + str(i) + ' : Instruction <= 32\'h' + line + ';'
        i = i + 1
        compiled.write(mystr)