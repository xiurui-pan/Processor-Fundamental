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
    bnez $a0, equal1    #if item_num == 0
    li $v0, 0
    jr $ra

    equal1:             #if item_num == 1
    li $t0, 1
    bne $a0, $t0, begin
    lw $t0, 0x0($a1)      #item_list[0].weight in t0
    blt $a2, $t0, endif1
    lw $v0, 0x4($a1)      #ret = item_list[0].value
    j return1
    endif1:
    li $v0, 0
    return1: 
    jr $ra

    begin:
    addi $sp, -0x1c     #save the current frame
    sw $a0, 0x0($sp)
    sw $a1, 0x4($sp)
    sw $a2, 0x8($sp)
    sw $ra, 0xc($sp)
    addi $a0, -1        #the first call
    addi $a1, 8
    jal dp_recur

    sw $s0, 0x10($sp)    #val_out in s0
    move $s0, $v0

    lw $a0, 0x0($sp)    #restore the frame
    lw $a1, 0x4($sp)
    lw $a2, 0x8($sp) 
    lw $t0, 0x0($a1)   #load item_list[0].weight
    sub $a2, $a2, $t0
    addi $a0, -1
    addi $a1, 8
    jal dp_recur        #the second call

    lw $a0, 0x0($sp)    #restore the frame
    lw $a1, 0x4($sp)
    lw $a2, 0x8($sp) 
    sw $s1, 0x14($sp)    #val_in in s1
    move $s1, $v0
    lw $t1, 4($a1)    #load item_list[0].value in t1
    add $s1, $s1, $t1

    lw $t0, 0($a1)    #load item_list[0].weight in t0
    blt $a2, $t0, return_out
    bgt $s0, $s1, return_out
    j return_in

    return_out:
    move $v0, $s0
    j return
    
    return_in:
    move $v0, $s1

    return:
    lw $s0, 0x10($sp)
    lw $s1, 0x14($sp)
    lw $ra, 0xc($sp)
    addi $sp, 0x1c
    jr $ra
