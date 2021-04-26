.data
   in_buff:.space 4004
   input_file:.asciiz "./a.in"
   output_file: .asciiz "./a.out"
.text
   la $a0,input_file
   li $a1,0
   #$a1:flag flag=0:read out flag=1:write in 
   li $a2,0#mode is ingnored
   li,$v0,13#open the file
   syscall
   move $a0,$v0
   la $a1,in_buff#Data staging area
   li $a2,4004#Bytes read in
   li $v0,14#read the file
   syscall

   li $v0 16
   syscall#close the file


   la $t0,in_buff
   lw $s0,0($t0)
   #s0:n(total number )
   addi $s1,$t0,4
   #s1 is the address where the words begin
   sll $t0,$s0,2
   #the total bytes of the words
   add $s2,$s1,$t0
   #$s2 is the address where the last word in
   move $a0,$s1
   addi $a1,$s2,-4
   #left=1 right=n(array from arr[1] to arr[n])
   jal SORT
   j EXIT

SORT:
   addi $sp,$sp,-16
   sw $ra,8($sp)
   sw $a0,4($sp)
   sw $a1,0($sp)
   move $t0,$a0
   move $t1,$a1
   #a0=i=t0
   #a1=j=t1(address)
   sub $t2,$t1,$t0
   #srl $t2,$t2,1 #(last-first)/2(fault:Inexhaustible)
   srl $t2,$t2,3
   sll $t2,$t2,2
   add $t2,$t2,$t0
   #the mid one's address
   lw $t2,0($t2)
   #t2=mid

LOOP:
   slt $t5,$t1,$t0
   #if j<i,then $t5=1
   beq $t5,1,RECUR_L
   lw $t3,0($t0)
   #t3=a[i]
   lw $t4,0($t1)
   #t4=a[j]

LOOP_I:
   slt $t5,$t3,$t2
   #if a[i]<mid then $t5=1
   beq $t5,0,LOOP_J
   addi $t0,$t0,4
   #i++
   lw $t3,0($t0)
   #t3:a[i]
   j LOOP_I

LOOP_J:
   slt $t5,$t2,$t4
   #mid<a[j]
   beq $t5,0,SWAP
   addi $t1,$t1,-4
   #j--
   lw $t4,0($t1)
   #t4=a[j]
   j LOOP_J

SWAP:
   slt $t5,$t1,$t0#if j<i
   beq $t5,1,RECUR_L
   sw $t3,0($t1)
   sw $t4,0($t0)
   #int tmp;
   #tmp = arr[i];
   #arr[i] = arr[j];
   #arr[j] = tmp;
   addi $t0,$t0,4
   #i++
   lw $t3,0($t0)
   addi $t1,$t1,-4
   #j--
   lw $t4,0($t1)
   j LOOP

RECUR_L:
   sw $t0,12($sp)
   slt $t5,$a0,$t1
   #if left<j $t5=1
   beq $t5,0,RECUR_R
   move $a1,$t1
   jal SORT
 
 RECUR_R:
   slt $t5,$t0,$a1
   #if i<r
   beq $t5,0,RETURN
   move $a0,$t0
   jal SORT

RETURN:
   lw $ra,8($sp)
   addi $sp,$sp,16
   lw $t0,12($sp)
   lw $a0,4($sp)
   lw $a1,0($sp)
   jr $ra


EXIT:
    la $a0,output_file
    li $a1, 1
    li $a2, 0
    li $v0, 13
    syscall
    move $a0,$v0
    la $a1,in_buff
    addi $a1,$a1,4
    add $a2,$s0,$zero
    sll $a2,$a2,2
    li $v0, 15 #15:write
    syscall
    li $v0 16
    syscall   
   