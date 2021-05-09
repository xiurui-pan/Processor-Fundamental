.data
buff: .space 0x8
input_file: .asciiz "a.in"
output_file: .asciiz "a.out"

.text
main:
    la $a0, input_file  #open file
    li $a1, 0
    li $a2, 0
    li $v0, 13
    syscall

    move $a0, $v0   #read 8 bytes / 2 words from file
    la $a1, buff
    li $a2, 4
    li $v0, 14
    syscall
    addi $a1, 0x4
    li $v0, 14
    syscall
    li $v0, 16  #close file
    syscall

    li $v0, 5   #read a num from input
    syscall
    move $a0, $v0       #store the 3rd num / max_num in $a0

    li $t0, 0
    for:
        lw $t1, ($a1)   #load buffer[id] into t1
        bge $a0, $t1, flag
        move $a0, $t1   #max_num = buffer[id]
        flag: addi $t0, 1
        addi $a1, -0x4
        blt $t0, 2, for
    addi $a1, 0x4

    move $t3, $a0   #save the max_num in t3
    li $v0, 1   #print max_num
    syscall

    la $a0, output_file     #open output file 
    li $a1, 1
    li $a2, 0
    li $v0, 13
    syscall
    move $a0, $v0

    la $a1, buff
    sw $t3, ($a1)
    li $a2, 4
    li $v0, 15
    syscall

    li $v0, 16
    syscall
    jr $ra
