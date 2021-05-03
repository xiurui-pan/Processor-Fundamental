.data
    input_file: .asciiz "test.dat"
    .align 4
    in_buffer: .space 0x800

.text
main:
    la $a0, input_file   #open the file
    li $a1, 0
    li $a2, 0
    li $v0, 13
    syscall
    move $a0, $v0        #read the file
    la $a1, in_buffer
    li $a2, 0x800
    li $v0, 14
    syscall
    li $v0, 16           #close the file
    syscall
    lw $a2, 0($a1)      #capacity in a2
    lw $a0, 4($a1)      #item_num in a0
    la $a1, 8($a1)      #item_list in a1

    sw $ra, 0($sp)      #store ra in sp
    addi $sp, -4
    jal dp_recur

    addi $sp, 4
    lw $ra, 0($sp)
    move $a0, $v0       #print result
    li $v0, 1
    syscall
    jr $ra

dp_recur:
    bnez $a0, equal1
    li $v0, 0
    jr $ra

    equal1:    
    li $t0, 1
    bne $a0, $t0, begin
    lw $t0, 0($a0)      #item_list[0].weight in t0
    blt $a2, $t0, endif1
    lw $v0, 4($t0)      #ret = item_list[0].value
    j return1
    endif1:
    li $v0, 0
    return1: jr $ra

    begin:
    addi $sp, -0x10
    sw $a0, 0x0($sp)
    sw $a1, 0x4($sp)
    sw $a2, 0x8($sp)
    sw $ra, 0xc($sp)

    addi $a0, -1
    addi $a1, 1
    jal dp_recur
    



    