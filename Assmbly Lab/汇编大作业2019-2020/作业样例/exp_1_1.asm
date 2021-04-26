.data
  in_buff:.space 4
  out_buff:.space 4
  input_file:.asciiz"./a.in"
  output_file:.asciiz"./a.out"
  space:.asciiz" "
  comma: .asciiz ", "
.word
.text
.globl main
main:
la $a0,input_file
li $a1,0#a1代表flag,flag0为读取，1为写入
li $a2,0#mode is ingnored
li $v0 13#13为打开文件的编号
syscall#若打开成功，文件描述符返回到$v0中
move $a0,$v0#将文件描述符载入到$a0中去
la $a1,in_buff#in_buff是数据暂存区
li $a2,4#读入数据的byte
li $v0,14#读取文件
syscall 

li $v0 16#关闭文件
syscall 


li $v0,5#从键盘读入一个整数
syscall

#初始化变量
la $s0,in_buff
la $s1,out_buff
lw $t0,0($s0)#
add $t0,$t0,$v0#求和
sw $t0,0($s1)#存字，将一个字从寄存器中取到内存中Memory【$s1】=t0


#打印整数
move $a0,$t0
li $v0,1
lw $t0,0($s1)
syscall

la $a0,output_file
li $a1,1#flag=1为写入状态
li $a2,0#mode is ingnored
li $v0,13#如果打开成功，文件描述符返回
syscall 

move $a0,$v0#将文件描述符载入到$a0中
la $a1,out_buff
li $a2,4#写入4byte
li $v0,15#写入文件
syscall


 li $v0 16#关闭文件
syscall