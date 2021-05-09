Fib:
    #保护现场
    subi $sp, 8
    sw $s0, 0x0($sp)
    sw $s1, 0x4($sp)

    addi $s0, $a0, 0
    slti $t0, $s0, 3
    beqz $t0, Next
    addi $v0, $0, 1
    #恢复现场
    lw $s0, 0x0($sp)
    lw $s1, 0x4($sp)
    addi $s0, $s0, 8

    jr $ra

Next:
    addi $s1, $0, 0
    #调用Fib(n-1)
    subi $sp, 4
    sw $a0, 0x0($sp)
    subi $a0, 1
    jal Fib

    add $s1, $v0, $s1
    #调用Fib(n-2)
    subi $a0, 1
    jal Fib

    add $s1, $v0, $s1
    addi $v0, $s1, 0
    #恢复现场
    lw $a0, 0x0($sp)
    lw $s0, 0x4($sp)
    lw $s1, 0x8($sp)
    addi $sp, $sp, 0xc
    
    jr $ra 