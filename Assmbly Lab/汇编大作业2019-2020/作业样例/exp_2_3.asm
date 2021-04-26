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
NEW_HEAD:
   li $a0,8
   # int * head = new int[2];
   li $v0,9
   syscall
   move $s4,$v0
   #$s4:the address of head[](virtual_head)

   li $a0,8
   li $v0,9
   syscall
   move $s3,$v0
   #$s3:head
   move $t1,$s3
   #t1:a pointer:cur,move as time goes by
   move $t0,$s1
   #$t0 work as a counter from(1-n)*4
   #+4at a time

NEW:
   li $a0,8
   li $v0,9
   syscall
   lw $t2,0($t0)
   #t2=a[i](change as time goes by)
   #at first  a[1] (the array from a[1]~a[n])
   sw $t2,0($v0)
   #the new array new_a[1]=a[1](intotal new_a[2][8bytes])
   sw $zero,4($v0)
   #new_a[2]=null
   sw $v0,4($t1)
   move $t1,$v0
   #cur=new_a
   addi $t0,$t0,4
   #i++ counter+4
   blt $t0,$s2,NEW
   #if i<s2 continue the loop
   move $a0,$s3
   #a0:head(outer)=head
   jal SORT
   j EXIT

SORT:
   addi $sp,$sp,-20
   sw $ra,0($sp)
   sw $a0,4($sp)
   lw $t0,4($a0)
   #t0=head.next
   beq $t0,0,RETURN_HEAD
   #if head.next==null,then go to RETURN_HEAD
   move $t0,$a0#do 1 step a time t0:head(1)
   move $t1,$a0#do 2 step a time t1:head(2)

MID:
   lw $t2,4($t1)
   #t2=2.next
   beq $t2,0,RECUR
   #if 2.next==null goto RECUR
   move $t1,$t2
   #t1=2.next
   lw $t2,4($t1)
   #t2=2.next
   beq $t2,0,RECUR#
   #if 2.next==null go to RECUR
   move $t1,$t2
   #2=2.next
   lw $t0,4($t0)
   #1=1.next
   j MID

RECUR:
   lw $t2,4($t0)
   #t2=1.next
   move $t1,$t2
   #2=1.next
   sw $zero,4($t0)
   #1.next=null

RECUR_L:
   sw $t1,16($sp)
   jal SORT
   move $t3,$v0
   #1_head=sort(head)
   sw $t3,8($sp)

RECUR_R:
   move $a0,$t1
   #a0="2"
   jal SORT
   move $t4,$v0
   #R_HEAD=SORT(2)
   sw $t4,12($sp)
   move $a0,$t3
   #a0=L_HEAD
   move $a1,$t4
   #a1=R_HRAD
   jal MERGE
   #MERGE(L_HEAD,R_HEAD)
   j RETURN

RETURN_HEAD:
   move $v0,$a0#return head

RETURN:
   lw $ra,0($sp)
   addi $sp,$sp,20
   lw $t1,16($sp)
   lw $t4,12($sp)
   lw $t3,8($sp)
   lw $a0,4($sp)
   jr $ra

MERGE:
#$a0:left #$a1:right #t0:p_left  t1:p_right
#t4:p_right_temp  #t5:p_right_temp_next
   sw $a0,4($s4)
   #virtual_head.next=left
   move $t0,$s4
   #p_Left=virtual_head
   move $t1,$a1
   #p_right=right

LOOP:
LOOP_L:
   lw $t2,4($t0)
   #t2=p_left.next
   beq $t2,0,LINK_L
   #if p_left.next==null jump  to LINK_L
   lw $t2,0($t2)
   #t2=value of p_left_next
   lw $t3,0($t1)
   #t2=value of p.right
   blt $t3,$t2,LINK_L
   #if value p_right point to<value of   p_left.next
   #exit
   lw $t0,4($t0)
   #p_left=p_left.next
   j LOOP_L

 LINK_L:
   lw $t2,4($t0)
   #t2=l_left.next
   bne $t2,0,INIT_LOOP_R
   #if $t2(l_left.next)=null jump to
   sw $t1,4($t0)
   #p_left_next=p_right
   j EXIT_LOOP

INIT_LOOP_R:
   move $t4,$t1
   #p_right_temp=p_right

LOOP_R:
   lw $t2,4($t4)
   #t2=p_right.next
   beq $t2,0,SWAP
   #if p_right_temp.next==null SWAP
   lw $t2,0($t2) 
   #t2=value of p_right_t.next
   lw $t3,4($t0) 
   #t3=p_left.next
   lw $t3,0($t3) 
   #t3=value p_left.next
   blt $t3,$t2,SWAP 
   #value of p_left.next<value of p_r_t.next exit
   lw $t4,4($t4) 
   #p_right_temp=p_righr_t.next
   j LOOP_R

SWAP:
	lw $t5,4($t4) 
    #p_righr_temp_next=p_right_temp.next
	lw $t2,4($t0) 
    #t2=p_left.next
	sw $t2,4($t4) 
    #p_right_temp.next=p_left.next
	sw $t1,4($t0)
    #p_left.next=p_right
	move $t0,$t4 #p_left=p_right_temp
	move $t1,$t5 #p_right=p_right_temp_n
	beq $t1,0,EXIT_LOOP
    #p_right==null
	j LOOP

EXIT_LOOP:
    lw $t2,4($s4)
	move $v0,$t2 
    #return virttual_head.next
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
    #a1=out_buff
    lw $t1,4($s3)
    #cur->next=head->next=begin

GET_LIST:
    lw $t0,0($t1)
    #t0 =the word in cur
    sw $t0,0($a1)
    #a[i]=t0
	addi $a1,$a1,4 
    #i++
	lw $t1,4($t1) 
    #cur=cur.next
	bne $t1,$zero,GET_LIST 
    #if cur==null exit  

    la $a1,in_buff

    addi $a1,$a1,4
    move $a2,$s0
    sll $a2,$a2,2
    li $v0, 15 #15:write
    syscall
    li $v0 16
    syscall   
   



