.data

.text
main:
    li $v0, 5   #read n, stored in s0
    syscall
    move $s0, $v0

    sll $t0, $s0, 2     #dynamically allocate heap memory for array
    move $a0, $t0
    li $v0, 9
    syscall
    move $s1, $v0       #address of allocated mem stored in s1

    li $t1, 0   #iterator in t1
    for1:
        bge $t1, $s0, endfor1
        li $v0, 5   #read a[i]
        syscall
        move $t0, $v0

        sll $t2, $t1, 2     #compute bias for array index, in t2
        add $a0, $s1, $t2   #compute address for site to be stored, in a0
        sw $t0, ($a0)
        addi $t1, $t1, 1
        j for1

    endfor1:
    li $t1, 0           #iterator in t1
    srl $s3, $s0, 1     #n/2 stored in s3

    for2:
        bge $t1, $s3, endfor2
        sll $t2, $t1, 2     #address of a[i] in a0
        add $a0, $s1, $t2

        sub $t2, $s0, $t1   #address of a[n-i-1] in a1
        addi $t2, $t2, -1
        sll $t2, $t2, 2
        add $a1, $s1, $t2

        lw $t0, ($a0)
        lw $t2, ($a1)
        sw $t0, ($a1)
        sw $t2, ($a0)
        addi $t1, $t1, 1
        j for2

    endfor2:
    li $t1, 0   #iterator in t1
    for3:
        bge $t1, $s0, endfor3
        sll $t2, $t1, 2     #compute the address bias of a[i] in a1
        add $a1, $s1, $t2
        lw $a0, ($a1)   #a[i] in a0
        li $v0, 1       #print a[i]
        syscall 
        addi $t1, $t1, 1
        j for3

    endfor3:
    li $v0 17
    syscal
    jr $ra

