main:
    addi $a1, $zero, 0x03c
    lw $a2, 0($a1)      #capacity in a2
    lw $a0, 4($a1)      #item_num in a0
    addi $a1, $a1, 8      #item_list in a1

    sw $ra, 0($sp)      #store ra in sp
    addi $sp, $sp, -4
    jal dp_loop

    lw $ra, 4($sp)      #restore ra in sp
    addi $sp, $sp, 4
    add $a0, $zero, $v0       #print result
    jal display_bcd

dp_loop:
    addi $t0, $zero, 0x40     #address bias in $t0
    sll $t0, $t0, 2
    sub $t0, $zero, $t0
    add $sp, $sp, $t0   #allocate memory in stack

    addi $t0, $zero, 0
    #init:
    #    sll $t1, $t0, 2     #init cache_ptr array to 0
    #    add $t1, $sp, $t1
    #    sw $zero, 0($t1)
    #    addi $t1, $zero, 0x40
    #    addi $t0, $t0, 1
        #blt $t0, $t1, init
    #    slt $at, $t0, $t1
    #    bne $at, $zero, init

    addi $t0, $zero, 0   #iter1 in t0
    outer_loop:
        #bge $t0, $a0, end_outer_loop
        slt $at, $t0, $a0
        beq $at, $zero, end_outer_loop
        sll $t1, $t0, 3
        add $t1, $a1, $t1   #address bias of weight in $t1
        lw $s0, 0($t1)      #weight in s0
        lw $s1, 4($t1)      #val in s1

        add $t2, $zero, $a2       #iter2 in t2
        inner_loop:
            #blt $t2, $zero, end_inner_loop
            slt $at, $t2, $zero
            bne $at, $zero, end_inner_loop
            #blt $t2, $s0, endif #if j >= weight
            slt $at, $t2, $s0
            bne $at, $zero, endif
            sll $t1, $t2, 2     #address of cache_ptr[j] in t1
            add $t1, $sp, $t1
            
            sub $t3, $t2, $s0   #cache[j - weight] in t3
            sll $t3, $t3, 2
            add $t3, $sp, $t3
            lw $t3, 0($t3)
            add $t3, $t3, $s1   #t3 + val in t3

            lw $t4, 0($t1)      #cache[j] in t4
            #ble $t4, $t3, else
            slt $at, $t3, $t4
            beq $at, $zero, else
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

    addi $t0, $zero, 0x40     #restore sp
    #addi $t0, 1
    sll $t0, $t0, 2
    add $sp, $sp, $t0
    jr $ra


display_bcd:
    lui  $s0, 0x4000

    andi $t3, $a0, 0xf000
    srl  $t3, $t3, 0xc
    andi $t2, $a0, 0x0f00
    srl  $t2, $t2, 0x8
    andi $t1, $a0, 0x00f0
    srl  $t1, $t1, 0x4
    andi $t0, $a0, 0x000f
    
    addi $s1, $zero, 1
    addi $s2, $zero, 2
    addi $s3, $zero, 3
    addi $s4, $zero, 4
    
    display_loop:
    bne  $s7, $zero, scan4
    addi $s7, $zero, 4

scan4:
    sll $s6, $s1, 11
    add $a1, $zero, $t3
    jal bcd_table
    add $s6, $s6, $a3
    sw  $s6, 0x10($s0)
scan3:
    sll $s6, $s1, 10
    add $a1, $zero, $t2
    jal bcd_table
    add $s6, $s6, $a3
    sw  $s6, 0x10($s0)
scan2:
    sll $s6, $s1, 9
    add $a1, $zero, $t1
    jal bcd_table
    add $s6, $s6, $a3
    sw  $s6, 0x10($s0)
scan1:
    sll $s6, $s1, 8
    add $a1, $zero, $t0
    jal bcd_table
    add $s6, $s6, $a3
    sw  $s6, 0x10($s0)
    j   scan4

bcd_table:
    beq         $a1, $zero, zero
    addi        $a2, $a1, -1
    beq         $a2, $zero, one
    addi        $a2, $a1, -2
    beq         $a2, $zero, two
    addi        $a2, $a1, -3
    beq         $a2, $zero, three
    addi        $a2, $a1, -4
    beq         $a2, $zero, four
    addi        $a2, $a1, -5
    beq         $a2, $zero, five
    addi        $a2, $a1, -6
    beq         $a2, $zero, six
    addi        $a2, $a1, -7
    beq         $a2, $zero, seven
    addi        $a2, $a1, -8
    beq         $a2, $zero, eight
    addi        $a2, $a1, -9
    beq         $a2, $zero, nine
    addi        $a2, $a1, -10
    beq         $a2, $zero, ten
    addi        $a2, $a1, -11
    beq         $a2, $zero, eleven
    addi        $a2, $a1, -12
    beq         $a2, $zero, twelve
    addi        $a2, $a1, -13
    beq         $a2, $zero, thirteen
    addi        $a2, $a1, -14
    beq         $a2, $zero, fourteen
    addi        $a2, $a1, -15
    beq         $a2, $zero, fifteen

zero:
    addi	    $a3, $zero, 0xc0
    jr		    $ra
one:
    addi        $a3, $zero, 0xf9
    jr          $ra
two:
    addi        $a3, $zero, 0xa4
    jr          $ra
three:
    addi        $a3, $zero, 0xb0
    jr          $ra
four:
    addi        $a3, $zero, 0x99
    jr          $ra
five:
    addi        $a3, $zero, 0x92
    jr          $ra
six:
    addi        $a3, $zero, 0x82
    jr          $ra
seven:
    addi        $a3, $zero, 0xf8
    jr          $ra
eight:
    addi        $a3, $zero, 0x80
    jr          $ra
nine:
    addi        $a3, $zero, 0x90
    jr          $ra
ten:
    addi        $a3, $zero, 0x88
    jr          $ra
eleven:
    addi        $a3, $zero, 0x83
    jr          $ra
twelve:
    addi        $a3, $zero, 0xa7
    jr          $ra
thirteen:
    addi        $a3, $zero, 0xa1
    jr          $ra
fourteen:
    addi        $a3, $zero, 0x86
    jr          $ra
fifteen:
    addi        $a3, $zero, 0x8e
    jr          $ra
    
