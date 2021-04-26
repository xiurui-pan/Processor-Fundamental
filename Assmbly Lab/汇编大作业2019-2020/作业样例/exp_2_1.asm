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
    
    addi $t0,$s1,4
    #address of v[1]
    #i=1
    addi $t1,$s1,0
    #address of v[0]
    #j=0

    addi $t0,$s0,-1
    beq $t0,0,EXIT
    #ouput when n=1
    move $t0,$s1
    #the address where the words begin(change in function)
OUTER:
    #t1 address of v[j]
    lw $t3,0($t1)
    #t3:the value of v[j]
    addi $t2,$t1,4
    #t2:address of v[j+1]
    lw $t4,4($t1)
    #the value of v[j+1]
    slt $t5,$t4,$t3
    #t5=1 if v[j+1]<v[j]
    bne $t5,$zero,SWAP
    #if v[j]>v[J+1]  swap(v,j);
    j INNER

SWAP:
    sw $t4,0($t1)
    #v[j]=v[j+1]
    sw $t3,0($t2)
    #v[j+1]=v[j]
    beq $t1,$s1,INNER
    #if j==0,i++
    add $t1,$t1,-4
    #j--
    j OUTER
INNER:
    addi $t0,$t0,4
    #i++
    addi $t1,$t0,-4
    #j=i-1
    bne $t0,$s2,OUTER
    #if(i!=n) go back to OUTER
    j EXIT
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
   




