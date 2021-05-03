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
    jal dp_search

    addi $sp, 4
    lw $ra, 0($sp)
    move $a0, $v0       #print result
    li $v0, 1
    syscall
    jr $ra

dp_search:
    li $v0, 0       #value_max in v0

    li $t0, 0       #state_cnt in t0
    li $s0, 1
    sll $s0, $s0, $a0   #0x1 << item_num in s0  
    outer_loop:
        bge $t0, $s0, end_outer_loop
        li $s1, 0   #weight in s1
        li $s2, 0   #val in $s2

        li $t1, 0   #i in t1
        inner_loop:
            bge $t1, $a0, end_inner_loop
            srl $t2, $t0, $t1   #flag in t2
            andi $t2, 0x1
            beq $t2, $zero, endif1
            sll $t3, $t1, 3     #address of item_list[i] in $t3
            add $t3, $t3, $a1
            lw $t4, 0($t3)
            add $s1, $s1, $t4
            lw $t4, 4($t3)
            add $s2, $s2, $t4

            endif1:
            addi $t1, 1
            j inner_loop

        end_inner_loop:
        bgt $s1, $a2, endif2
        ble $s2, $v0, endif2
        move $v0, $s2

        endif2:
        addi $t0, 1
        j outer_loop

    end_outer_loop:
    jr $ra

