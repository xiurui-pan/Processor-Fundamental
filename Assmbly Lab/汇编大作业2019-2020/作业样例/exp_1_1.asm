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
li $a1,0#a1����flag,flag0Ϊ��ȡ��1Ϊд��
li $a2,0#mode is ingnored
li $v0 13#13Ϊ���ļ��ı��
syscall#���򿪳ɹ����ļ����������ص�$v0��
move $a0,$v0#���ļ����������뵽$a0��ȥ
la $a1,in_buff#in_buff�������ݴ���
li $a2,4#�������ݵ�byte
li $v0,14#��ȡ�ļ�
syscall 

li $v0 16#�ر��ļ�
syscall 


li $v0,5#�Ӽ��̶���һ������
syscall

#��ʼ������
la $s0,in_buff
la $s1,out_buff
lw $t0,0($s0)#
add $t0,$t0,$v0#���
sw $t0,0($s1)#���֣���һ���ִӼĴ�����ȡ���ڴ���Memory��$s1��=t0


#��ӡ����
move $a0,$t0
li $v0,1
lw $t0,0($s1)
syscall

la $a0,output_file
li $a1,1#flag=1Ϊд��״̬
li $a2,0#mode is ingnored
li $v0,13#����򿪳ɹ����ļ�����������
syscall 

move $a0,$v0#���ļ����������뵽$a0��
la $a1,out_buff
li $a2,4#д��4byte
li $v0,15#д���ļ�
syscall


 li $v0 16#�ر��ļ�
syscall