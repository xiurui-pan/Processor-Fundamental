.data

.text
main:
    li $v0, 5   #read n, stored in s0
    syscall
    move $s0, $v0

    sll $t0, $s0, 2
    sub $sp, $sp, $t0
    li $t1, 0   #iterator in t1
    for:
        bge $t1, $s0, endinput
        li $v0, 5
        syscall
        move $t0, $v0

        sll $t2, t1, 2  #compute bias for array index, in t2
        add $a0, $t2, $sp   #compute address for site to be stored, in a0
        sw $t0, ($a0)
        j for

    endinput:
