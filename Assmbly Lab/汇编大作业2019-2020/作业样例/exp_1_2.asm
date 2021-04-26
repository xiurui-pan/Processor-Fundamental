
#t0:i
#t1:j
li $v0,5
syscall
move $t0,$v0
li $v0,5
syscall
#scanf("%d",&i);
#scanf("%d",&j);
move $t1,$v0
P_WHILE:
seq $s0,$t0,$zero
seq $s1,$t1,$zero   
add $s0,$s0,$s1
bne $s0,$zero,ENDWHILE#s0£¡=0  When one or more of the two conditions is not satisfied
WHILE:
sle $s0,$t1,$t0
beq $s0,$zero,THEN#Compare the size of i and j  if j>i s0=0,do THEN
#else
j ENDIF
THEN:
#then?
add $t2,$zero,$t0#temp=i
add $t0,$zero,$t1#i=j
add $t1,$zero,$t2#j=temp
ENDIF:
sub $t0,$t0,$t1#i=i-j
j P_WHILE#return to test whether the two conditions are satisfied
ENDWHILE:
move $a0,$t1
li $v0,1#printf("%d",j);
syscall
