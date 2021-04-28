.data

.text
main:
li $v0 5    #read integer i, stored in t0
syscall
move $t0 $v0
li $v0 5    #read integer j, stored in t1
syscall
move $t1 $v0

