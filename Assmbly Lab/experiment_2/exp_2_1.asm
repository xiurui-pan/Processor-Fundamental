.data
    input_file: .asciiz "test2.dat"
    .align 4
    in_buffer: .space 0x800
    MAX_CAP: .byte 64

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
    addi $sp, $sp, -4
    jal dp_loop

    lw $ra, 4($sp)      #restore ra in sp
    addi $sp, $sp, 4
    move $a0, $v0       #print result
    li $v0, 1
    syscall

    li $v0 17
    syscall
    jr $ra

dp_loop:
    lw $t0, MAX_CAP     #address bias in $t0
    #addi $t0, 1 
    sll $t0, $t0, 2
    sub $t0, $zero, $t0
    add $sp, $sp, $t0   #allocate memory in stack

    li $t0, 0
    init:
        sll $t1, $t0, 2     #init cache_ptr array to 0
        add $t1, $sp, $t1
        sw $zero, 0($t1)
        addi $t0, $t0, 1
        blt $t0, 0x40, init

    li $t0, 0   #iter1 in t0
    outer_loop:
        bge $t0, $a0, end_outer_loop
        sll $t1, $t0, 3
        add $t1, $a1, $t1   #address bias of weight in $t1
        lw $s0, 0($t1)      #weight in s0
        lw $s1, 4($t1)      #val in s1

        move $t2, $a2       #iter2 in t2
        inner_loop:
            bltz $t2, end_inner_loop
            blt $t2, $s0, endif #if j >= weight
            sll $t1, $t2, 2     #address of cache_ptr[j] in t1
            add $t1, $sp, $t1
            
            sub $t3, $t2, $s0   #cache[j - weight] in t3
            sll $t3, $t3, 2
            add $t3, $sp, $t3
            lw $t3, 0($t3)
            add $t3, $t3, $s1   #t3 + val in t3

            lw $t4, 0($t1)      #cache[j] in t4
            ble $t4, $t3, else
            j endif
            else:
            sw $t3, 0($t1)

            endif:
            addi $t2, $t2 -1
            j inner_loop

        end_inner_loop:
        addi $t0, $t0, 1
        j outer_loop

    end_outer_loop:
    sll $t1, $a2, 2     #set reture value
    add $t1, $sp, $t1
    lw $v0, 0($t1)

    lw $t0, MAX_CAP     #restore sp
    #addi $t0, 1
    sll $t0, $t0, 2
    add $sp, $sp, $t0
    jr $ra

