.data
    .a
    string: .asciiz "Hello World!\n"
    
.text
main:
    la $a0 string #�����ַ�����ַ
    li $v0 4      #4�����ӡ�ַ���
    syscall       #ִ��ϵͳ����

    li $v0 17     #17����exit
    syscall       #ִ��ϵͳ����
