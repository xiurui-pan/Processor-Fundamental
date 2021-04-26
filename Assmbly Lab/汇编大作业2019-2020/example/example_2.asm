 .data
    stringz: .asciiz "Hello World!\n"
    string: .ascii "Hello World!\n"
    #��array���뵽4byte�߽�
    .align 4  #û����仰���ܻ����
    array: .space  512
    #���³���������Զ����뵽��Ӧ�߽�
    barray: .byte  1,2,3,4
    harray: .half  1,2,3,4
    warray: .word  1,2,3,4
    
    
.text
main:
    la $a0 stringz #�����ַ�����ַ
    li $v0 4      #4�����ӡ�ַ���
    syscall       #ִ��ϵͳ����
    
    la $a0 string #�����ַ�����ַ
    li $v0 4      #4�����ӡ�ַ���
    syscall       #ִ��ϵͳ����
    
    la $t0 barray #����byte�����ַ
    lb $a0 0($t0) #��ȡbarray[0]
    li $v0 1      #1�����ӡһ������
    syscall       #��ӡarray[0]������
    lb $a0 1($t0) #��ȡbarray[1]
    li $v0 1      #1�����ӡһ������
    syscall       #��ӡarray[0]������
    lb $a0 2($t0) #��ȡbarray[2]
    li $v0 1      #1�����ӡһ������
    syscall       #��ӡarray[0]������
    lb $a0 3($t0) #��ȡbarray[3]
    li $v0 1      #1�����ӡһ������
    syscall       #��ӡarray[0]������
    
    li $a0 10 #10�����з�'\n'
    li $v0 11 #11�����ӡ�ַ�
    syscall   #������
    
    la $t0 array #����array�ĵ�ַ
    li $t1 123   
    sw $t1 0($t0) #��array[0]��λ�ô���123
    lw $a0 0($t0) #��ȡarray[0]������
    li $v0 1      #1�����ӡһ������
    syscall       #��ӡarray[0]������
    
    
    li $v0 17     #17����exit
    syscall       #ִ��ϵͳ����
