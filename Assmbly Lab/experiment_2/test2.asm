main:
    li $a1, 0x1fff
    lw $a2, 0($a1)      #capacity in a2
    lw $a0, 4($a1)      #item_num in a0
    la $a1, 8($a1)      #item_list in a1

    sw $ra, 0($sp)      #store ra in sp
    addi $sp, $sp, -4
    jal dp_loop

dp_loop:
    addi $t0, zero, 40     #address bias in $t0
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

