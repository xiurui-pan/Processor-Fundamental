#t0:n
li $v0,5
syscall
move $t0,$v0
 #scanf("%d",&n);

sll $t5,$t0,2#t0=t0*4,the number of the bytes
move $a0,$t5
 li $v0,9
 syscall#arr = new int[n];
 move $s0,$v0
 #$s0:arr pointer to int[n]
addi $s1,$zero,0
sw $s1,0($s0)
#arr[0] = 0;
#s1=0
li $a0,8
li $v0,9
syscall#head = new int[2];
move $s2,$v0
#s2:head:pointer to int[2]
sw $s1,0($s2)#  head[0] = 0;
sw $s1,4($s2)#  head[1] = (int)NULL;

#s3:ptr
move $s3,$s2

#FOR_FUN
addi $s1,$zero,1
#$s1:i
P_FOR:
beq $s1,$t0,END_FOR

FOR:
sll $t1,$s1,2#t1:the number of bytes
add $t2,$s0,$t1#t2:the address of arr[i]
sw $s1,0($t2)#arr[i]=i
li $a0,8
li $v0,9
syscall#new int[2];
sw $v0,4($s3)#ptr[1] = (int)new int [2];
lw $s3,4($s3)#ptr = (int*)ptr[1];
sw $s1,0($s3)#ptr[0] = i;
sw $zero,4($s3)# ptr[1] = (int)NULL;
addi $s1,$s1,1
j P_FOR
END_FOR:


#for(i=0;i<n;i++){
#       printf("%d",arr[i]);
#   }
move $s1,$zero
#$s1:i
P_FOR_1:
beq $s1,$t0,END_FOR1
sll $t4,$s1,2#t4=4*s1
add $s6,$s0,$t4#s6=s6+4*s1(the address of arr[i])
FOR_1:
lw $a0,0($s6)
li $v0,1
syscall#  printf("%d",arr[i]);
addi $s1,$s1,1
j P_FOR_1
END_FOR1:

# ptr  = head;
move $s3,$s2

P_WHILE:#while(ptr!=NULL)
move $t3,$s3
beq $t3,$zero,ENDWHILE

WHILE:
lw $a0,0($s3)
li $v0,1
syscall  # printf("%d",ptr[0]);
lw $s3,4($s3)#ptr = (int*)ptr[1];
j P_WHILE

ENDWHILE:
