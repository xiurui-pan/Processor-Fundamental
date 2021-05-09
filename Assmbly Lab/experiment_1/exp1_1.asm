.data

.text
main:
    li $v0 5    #read integer i, stored in t0
    syscall
    move $t0 $v0
    li $v0 5    #read integer j, stored in t1
    syscall
    move $t1 $v0

    bgez $t0 flag   #whether i is negative
    sub $t0 $0 $t0  #set i to -i
    flag: bgez $t1 swap   #whether j is negative
    sub $t1 $0 $t1  #set j to -j

    swap:
        ble $t1 $t0 sum     #whether j > i
        move $t2 $t0
        move $t3 $t1
        move $t0 $t3
        move $t1 $t2

    sum:
        li $v1 0    #sum is stored in v1
        li $s0 0    #iterator is stored in s0
        loop:
            add $v1 $v1 $s0     #sum += temp
            addi $s0 $s0 1
            ble $s0 $t1 loop
        li $v0 1    #print sum
        move $a0 $v1
        syscall
        move $v0 $v1
    jr $ra
