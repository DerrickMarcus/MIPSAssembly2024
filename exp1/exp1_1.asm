.data
buffer: .space 8
input_file: .asciiz "a.in"
output_file: .asciiz "a.out"

.text
main:
    la $a0, input_file # �����ļ�����ַ���ص�a0
    li $a1, 0 # �ļ���ģʽΪ��ȡ��flag=0
    li $a2, 0 # mode is ignored ����Ϊ0�Ϳ�����
    li $v0, 13 # 13Ϊ���ļ��� syscall ���
    syscall # ���򿪳ɹ����ļ����������ص�v0

    move $a0, $v0 # �ļ����������뵽a0
    la $a1, buffer # buffer��ַ���ص�a1
    li $a2, 8 # ��ȡ8 byte��2������
    li $v0, 14 # 14Ϊ��ȡ�ļ��� syscall ���
    syscall
    li $v0, 16 # 16Ϊ�ر��ļ��� syscall ���
    syscall

    la $a0, output_file # ����ļ�����ַ���ص�a0
    li $a1, 1 # �ļ���ģʽΪд�룬flag=1
    li $a2, 0 # mode is ignored ����Ϊ0�Ϳ�����
    li $v0, 13 # 13Ϊ���ļ��� syscall ���
    syscall # ���򿪳ɹ����ļ����������ص�v0

    move $a0, $v0 # �ļ����������뵽a0
    la $a1, buffer # buffer��ַ���ص�a1
    li $a2, 8 # д��8 byte
    li $v0, 15 # 15Ϊд���ļ��� syscall ���
    syscall
    li $v0, 16 # 16Ϊ�ر��ļ��� syscall ���
    syscall

    li $v0, 5 # 5Ϊ��ȡ������ syscall ���
    syscall
    addi $a0, $v0, 10 # i=i+10
    li $v0, 1 # 1Ϊ��ӡ������ syscall ���
    syscall
