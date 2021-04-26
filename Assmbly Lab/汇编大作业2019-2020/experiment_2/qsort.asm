.data
in_buff: .space 5000
out_buff: .space 5000
input_file: .asciiz "a.in"
output_file: .asciiz "b.out"

.text
	
main:
	li   $v0, 13       # system call for open file
  	la   $a0, input_file     # output file name
  	li   $a1, 0        # Open for writing (flags are 0: read, 1: write)
  	li   $a2, 0        # mode is ignored
  	syscall            # open a file (file descriptor returned in $v0)
  	move $t3,$v0  # 将文件描述符载入到 $t3中,向a.out输出时要用
  	move $a0,$v0 # 将文件描述符载入到 $a0中
 	la $a1, in_buff #in_buff 为数据暂存区
 	li $a2, 4004 #读取4004byte
 	li $v0, 14 #14 为读取文件的 syscall 编号
 	syscall
 	li $v0 16 #16 为关闭文件的 syscall 编号
 	syscall
 	
 	la $s0, in_buff #s0存放了in_buff的首地址
  	#move $s1,$s0 #s1复制了首地址，以后要修改它
  	lw $s6,($s0) #s6里存放了要进行排序的长度
  	#addi $s1,$s1,4
  	
  	move $a0,$s0
  	li $a1,1
  	lw $a2,($s0) #传参
  	jal quicksort
  	
  	la $s4, out_buff
  	la $t0, in_buff
  	#move $t0,$s0 #重新复制
  	addi $t0,$t0,4
  	li $t3,1 #计数器
  	
  	jal copyarray
 	
  	
  	la $a0, output_file #准备open b.out
 	li $a1, 1 #flag 0为读取 1为写入
 	li $a2, 0
 	li $v0, 13 #13 为打开文件的 syscall 编号
 	syscall
 	
 	
 	
 	sll $s6,$s6,2
 	li   $v0, 15       # system call for write to file
  	move $a0, $t3      # file descriptor
  	la $a1,out_buff  #&(buffer[1])
  	move $a2,$s6
  	syscall
  	li $v0 16 #16 为关闭文件的 syscall 编号
  	syscall 
 
	li $v0 17     #17代表exit
 	syscall       #执行系统调用
  
 
 quicksort:
 	addi $sp,$sp,-28#保护现场！！！
 	sw $t2,24($sp)
 	sw $ra,20($sp)
 	sw $s1,16($sp)
 	sw $s2,12($sp)
 	sw $s3,8($sp)
 	sw $s4,4($sp)
 	sw $s5,($sp)
 	
 	
 	move $s1,$a0 #s1始终都是arr的首地址
 	move $s2,$a1 #s2记录left
 	move $s3,$a2 #s3记录right
 	move $s4,$s2 #s4记录i
 	move $s5,$s3 #s5记录j
 	sll $t1,$s2,2
 	add $t1,$t1,$s1 #t1存放了arr[left]的地址
 	lw $t2,($t1) #t2记录key

 loop1:	
 	
 	 	
 loopj:
 	sll $t4,$s5,2
 	add $t4,$t4,$s1 #arr[j]地址
 	lw $t5,($t4) #arr[j]
 	slt $t3,$t5,$t2 #arr[j]<key
 	bnez $t3,loopi
 	slt $t3,$s4,$s5 #i<j
 	beqz $t3,exit1
 	sub $s5,$s5,1 #j--
 	j loopj
 
 loopi:
 	sll $t6,$s4,2
 	add $t6,$t6,$s1
 	lw $t7,($t6) #arr[i]
 	slt $t3,$t2,$t7
 	bnez $t3,exit2
 	slt $t3,$s4,$s5 #i<j
 	beqz $t3,exit1
 	add $s4,$s4,1 #i++
 	j loopi
 
 exit2:
 	move $t3,$t7 #swap
 	sw $t5,($t6)
 	sw $t3,($t4)
 	j loop1	
 
 exit1:
 	sw $t7,($t1) #arr[left] = arr[i];
 	sw $t2,($t6) #arr[i] = key;
 	addi $t4,$s4,-1
 	slt $t3,$s2,$t4 #if(left < i-1)
 	bnez $t3,sortleft
 	addi $t5,$s4,1
 	slt $t3,$t5,$s3
 	bnez $t3,sortright
 	lw $t2,24($sp)
 	lw $ra,20($sp)
 	lw $s1,16($sp)
 	lw $s2,12($sp)
 	lw $s3,8($sp)
 	lw $s4,4($sp)
 	lw $s5,($sp)
 	addi $sp,$sp,24#恢复现场！
 	
 	
 	jr $ra
 
sortleft:
	move $a0,$s0
	move $a1,$s2
	move $a2,$t4
	jal quicksort

sortright:
	move $a0,$s0
	move $a1,$t5
	move $a2,$s3
	jal quicksort

copyarray:  #将修改后的存入out_buff中
	lw $s5,($t0)
	sw $s5,($s4)
	beq $t3,$s6,exit3 #s6是arr[0]，也就是长度
	addi $t3,$t3,1
	addi $t0,$t0,4
	addi $s4,$s4,4
	j copyarray

exit3:
	jr $ra  	
