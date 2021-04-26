.data
.align 4
buffer:.space 4012
.align 4
outbuffer:.space 4012
.align 4
backup:.space 8208
in_file: .asciiz"a.in"
out_file:.asciiz"a.out"

.text
main:#s0_buffer t0_N s1_backup t1_head t2_pointer t3_idx
#打开文件
la $a0, in_file #input_file 是一个字符串
li $a1, 0 #flag 0为读取 1为写入
li $a2, 0 #mode is ignored 设置为0就可以了
li $v0, 13 #13 为打开文件的 syscall 编号
syscall # 如果打开成功 ， 文件描述符返回到$v0中
#读取文件
 move $a0,$v0 # 将文件描述符载入到 $a0中
 la $a1, buffer #buffer 为数据暂存区
 li $a2, 4004 #读取4004个byte
 li $v0, 14 #14 为读取文件的 syscall 编号
 #关闭文件
 syscall
 li $v0 16 #16 为关闭文件的 syscall 编号
 syscall
 
 la $s0,buffer
 lw $t0,0($s0)#N=buffer[0]
 la $s1,backup
 move $t1,$s1#head= new int[2]
 addi $s1,$s1,8
 sw $zero,4($t1)#head[1]=0
 move $t2,$t1#pointer=head
 li $t3,1#idx=1
loop:
 slt $t4,$t0,$t3#if(N<idx)
 bnez $t4,nloop
 sw $s1,4($t2)#pointer[1]=(int) new int [2];
 addi $s1,$s1,8
 lw $t2,4($t2)#pointer=(int *) pointer[1];
 sll $t4,$t3,2
 add $t4,$s0,$t4
 lw $t4,0($t4)#buffer[idx]
 sw $t4,0($t2)#pointer[0] = buffer[idx];
 sw $zero,4($t2)#pointer[1] = (int)NULL; 
 
 addi $t3,$t3,1
 j loop
nloop:
 lw $a0,4($t1)#(int *)head[1])
 
 addi $sp,$sp,-12
 sw $t1,0($sp)
 sw $t2,4($sp)
 sw $ra,8($sp)
 jal msort
 lw $t1,0($sp)
 lw $t2,4($sp)
 lw $ra,8($sp)
 addi $sp,$sp,12
 
 sw $v0,4($t1)#head[1] =(int) msort((int *)head[1]);
 move $t2,$t1#pointer=head;
  



la $s2,outbuffer
li $t3,0
loop2:
 lw $t2,4($t2)#pointer =(int *)pointer[1];
 beqz $t2,nloop2#if(pointer==NULL) break
 lw $t4,0($t2)
 sw $t4,0($s2)
 addi $s2,$s2,4
 addi $t3,$t3,4

j loop2
nloop2:
#新建文件
la $a0, out_file #output_file 是一个字符串
li $a1, 1 #flag 0为读取 1为写入
li $a2, 0 #mode is ignored 设置为0就可以了
li $v0, 13 #13 为打开文件的 syscall 编号
syscall # 如果打开成功 ， 文件描述符返回到$v0中
#写入文件
 move $a0,$v0 # 将文件描述符载入到 $a0中
 la $a1,outbuffer #fwrite(pointer)
 move $a2,$t3 #写入4*N个byte
 li $v0, 15 #15 为写入文件的 syscall 编号
syscall
#此时$a0 中的文件描述符没变
#直接调用 syscall 16 关闭它
li $v0 16 #16 为关闭文件的 syscall 编号
syscall
li $v0,10
syscall

msort:#a0_head t2_stride_2_pointer t1_stride_1_pointer 
 lw $t0,4($a0)#head[1]
 move $v0,$a0#return head;
 beqz $t0,return
 
 move $t2,$a0# int * stride_2_pointer = head;
 move $t1,$a0#int * stride_1_pointer = head;
 m_loop:
 lw $t3,4($t2)#stride_2_pointer[1]
 beqz $t3,m_nloop
 lw $t2,4($t2)#stride_2_pointer = (int *) stride_2_pointer [1];
 lw $t3,4($t2)#stride_2_pointer[1]
 beqz $t3,m_nloop
 lw $t2,4($t2)#stride_2_pointer = (int *) stride_2_pointer [1];
 lw $t1,4($t1)#stride_1_pointer = (int *) stride_1_pointer [1];
 j m_loop
m_nloop:
 lw $t2,4($t1)#stride_2_pointer = (int *)stride_1_pointer [1];
 sw $zero,4($t1)#stride_1_pointer[1] = (int)NULL;
 
 addi $sp,$sp,-24
 sw $a0,0($sp)
 sw $t1,4($sp)
 sw $t2,8($sp)
 sw $t3,12($sp)
 sw $t4,16($sp)
 sw $ra,20($sp)
 
 #move $a0,$a0
 jal msort#msort(head);
 move $t3,$v0# int * l_head = msort(head);
 
 sw $t3,12($sp)
 lw $t2,8($sp)
 move $a0,$t2#msort(stride_2_pointer)
 jal msort
 move $t4,$v0#int * r_head = msort(stride_2_pointer);
 sw $t4,16($sp)

 lw $a0,0($sp)
 lw $t1,4($sp)
 lw $t2,8($sp)
 lw $t3,12($sp)
 lw $t4,16($sp)
 lw $ra,20($sp)
 addi $sp,$sp,24
 
 addi $sp,$sp,-4
 sw $ra,0($sp)
 move $a0,$t3
 move $a1,$t4
 jal merge
 #move $v0,$v0
 lw $ra,0($sp)
 addi $sp,$sp,4
return:
 jr $ra
 
 merge:#a0_l_head a1_r_head t0_head t1_p_left t2_p_right  
 move $t0,$s1#new int[2];
 addi $s1,$s1,8
 sw $a0,4($t0)#head [1] = (int) l_head;
 move $t1,$t0#int * p_left = head;
 move $t2,$a1#int * p_right = r_head;
 
me_loop1:
 me_loop2:
  lw $t3,4($t1)#p_left[1]
  beqz $t3,me_nloop2#if(p_left[1] == (int)NULL ) break;
  lw $t3,0($t3)#(p_left[1])[0]
  lw $t4,0($t2)#p_right[0]
  slt $t3,$t4,$t3#if(((int *)p_left[1])[0]>p_right[0])
  bnez $t3,me_nloop2
  lw $t1,4($t1)#p_left = (int *)p_left[1];
  j me_loop2
 me_nloop2:
 lw $t3,4($t1)#p_left[1]
 bnez $t3,skip
  sw $t2,4($t1)#p_left[1] = (int)p_right;
  j me_nloop1#break
 skip:
  # t3_p_right_temp
  move $t3,$t2
  me_loop3:
   lw $t4,4($t3)#p_right_temp[1]
   beqz $t4,me_nloop3#break
   lw $t4,0($t4)#((int *)p_right_temp[1])[0]
   lw $t5,4($t1)#(int *)p_left[1]
   lw $t5,0($t5)#((int *)p_left[1])[0]
   slt $t4,$t5,$t4#if (...<...)
   bnez $t4,me_nloop3#break
   lw $t3,4($t3)#p_right_temp = (int * )p_right_temp[1];
   j me_loop3
  me_nloop3:
  #t4_temp_right_pointer_next
  lw $t4,4($t3)#int * temp_right_pointer_next = (int *)p_right_temp[1];
  lw $t5,4($t1)# p_left[1]
  sw $t5,4($t3)#p_right_temp[1] = p_left[1];
  sw $t2,4($t1)#p_left[1] = (int) p_right;
  move $t1,$t3#p_left = p_right_temp;
  move $t2,$t4#p_right = temp_right_pointer_next;
  beqz $t2,me_nloop1#break
  j me_loop1
me_nloop1: 
 
 lw $v0,4($t0)#rv = head[1];
 jr $ra

