.data
in_buff: .space 512
out_buff: .space 512
input_file: .asciiz "example.in"
output_file: .asciiz "example.out"
comma: .asciiz ", "
.text
la $a0, input_file #input_file ��һ���ַ���
li $a1, 0 #flag 0Ϊ��ȡ 1Ϊд��
li $a2, 0 #mode is ignored ����Ϊ0�Ϳ�����
li $v0, 13 #13 Ϊ���ļ��� syscall ���
syscall # ����򿪳ɹ� �� �ļ����������ص�$v0��
 move $a0,$v0 # ���ļ����������뵽 $a0��
 la $a1, in_buff #in_buff Ϊ�����ݴ���
 li $a2, 512 #��ȡ512��byte
 li $v0, 14 #14 Ϊ��ȡ�ļ��� syscall ���
 syscall
 li $v0 16 #16 Ϊ�ر��ļ��� syscall ���
 syscall

#��ַ��ʼ����ѭ��������ֵΪN
la $s0, in_buff
la $s1, out_buff
lw $s2, 0($s0)
li $t0, 0

#��ַ��4 ѭ��������1
for: addi $s0, $s0, 4
addi $t0, $t0, 1
lw $t1, 0($s0)
sw $t1, 0($s1)
addi $s1, $s1, 4
#��ӡ����
move $a0, $t1
li $v0, 1
syscall
#��ӡ����
la $a0, comma
li $v0, 4
syscall
bne $t0 $s2 for

la $a0, output_file #output_file ��һ���ַ���
li $a1, 1 #flag 0Ϊ��ȡ 1Ϊд��
li $a2, 0 #mode is ignored ����Ϊ0�Ϳ�����
li $v0, 13 #13 Ϊ���ļ��� syscall ���
syscall # ����򿪳ɹ� �� �ļ����������ص�$v0��

move $a0,$v0 # ���ļ����������뵽 $a0��
la $a1, out_buff #in_buff Ϊ�����ݴ���
sll $s2 $s2 2
move $a2, $s2 #д��512��byte
li $v0, 15 #15 Ϊд���ļ��� syscall ���
syscall
#��ʱ$a0 �е��ļ�������û��
#ֱ�ӵ��� syscall 16 �ر���
li $v0 16 #16 Ϊ�ر��ļ��� syscall ���
syscall
