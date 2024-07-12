.text
main:
    li $v0, 5 # ϵͳ���ã�����n
    syscall
    move $a0, $v0 # a0�е�ֵΪn
    jal Hanoi # ����Hanoi����
    move $a0, $v0 # ������浽a0
    li $v0, 1 # ϵͳ���ã���ӡ���
    syscall
    li $v0, 10 # ϵͳ���ã��˳�����
    syscall

Hanoi:
    addi $sp, $sp, -8 # ջָ�������ƶ�8
    sw $ra, 4($sp) # ra��ջ
    sw $a0, 0($sp) # a0��ջ������n��a0��
    slti $t0, $a0, 2 # t0=(n<2)
    beq $t0, $0, recursion # t0=0��n>=2������ת���ݹ�
    li $v0, 1 # n=1, return 1
    addi $sp, $sp, 8 # �ָ�ջָ��λ��
    jr $ra # ������һ�㺯��

# n>1�����
recursion:
    addi $a0, $a0, -1 # n=n-1
    jal Hanoi
    lw $a0, 0($sp)
    lw $ra, 4($sp) # ȡ����һ�㺯����n��ra
    addi $sp, $sp, 8 # �ָ�ջָ��λ��
    sll $v0, $v0, 1 # 2*Hanoi(n-1)
    addi $v0, $v0, 1 # 2*Hanoi(n-1)+1
    jr $ra # ������һ�㺯��
