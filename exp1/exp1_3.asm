.text
main:
    li $v0, 5 # �������鳤��n
    syscall
    move $t0, $v0 # t0�е�ֵΪn

    move $a0, $t0
    sll $a0, $a0, 2 # ���õĴ������Ϊn*4������2λ
    li $v0, 9 # ϵͳ���ã����ٳ���Ϊn�Ŀռ䣬a=new int[n]
    syscall
    move $s0, $v0 # �����׵�ַΪs0

    li $t1, 0 # ѭ����������i����ʼΪ0

scanf_loop:
    bge $t1, $t0, reverse_ready # i>=n�˳�ѭ����i<n����ѭ��
    li $v0, 5 # ϵͳ���ã���������
    syscall
    sll $t2, $t1, 2 # t2=t1*4,ƫ�Ƶ�ַ
    add $t2, $s0, $t2 # �����׵�ַ��t2Ϊa[i]��ַ
    sw $v0, 0($t2) # ���a[i]
    addi $t1, $t1, 1 # i++
    j scanf_loop # ��һ��ѭ��

reverse_ready:
    li $t1, 0 # ѭ����������i����ʼΪ0
    srl $t2, $t0, 1 # n����1λ��ѭ����������Ϊn/2

reverse_loop:
    bge $t1, $t2, printf_ready # i>=n/2�˳�ѭ����i<n/2����ѭ��
    sll $t3, $t1, 2 # t3=i*4��a[i]��ƫ����
    add $t3, $s0, $t3 # t3Ϊa[i]�ĵ�ַ
    lw $t4, 0($t3) # t4=a[i]
    addi $t4, $t4, 1 # t4=a[i]+1

    sub $t5, $t0, $t1 # t5=n-i
    subi $t5, $t5, 1 # t5=n-i-1
    sll $t5, $t5, 2 # t5=(n-i-1)*4��a[n-i-1]��ƫ����
    add $t5, $s0, $t5 # t5Ϊa[n-i-1]�ĵ�ַ
    lw $t6, 0($t5) # t6=a[n-i-1]
    addi $t6, $t6, 1 # t6=a[n-i-1]+1

    sw $t6, 0($t3) # a[i]=a[n-i-1]+1
    sw $t4, 0($t5) # a[n-i-1]=a[i]+1
    addi $t1, $t1, 1 # i++
    j reverse_loop # ��һ��ѭ��

printf_ready:
    li $t1, 0 # ѭ����������i����ʼΪ0

printf_loop:
    bge $t1, $t0, exit # i>=n�˳�ѭ����i<n����ѭ��
    sll $t2, $t1, 2 # t2=i*4
    add $t2, $s0, $t2 # t2Ϊa[i]��ַ
    lw $a0, 0($t2) # a[i]װ�뵽����a0
    li $v0, 1 # ϵͳ���ã���ӡ����
    syscall
    addi $t1, $t1, 1 # i++
    j printf_loop # ��һ��ѭ��

exit:
    li $v0, 10 # ϵͳ���ã��˳�����
    syscall