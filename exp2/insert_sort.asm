# ������ҵ2024
# insert_sort.asm
.data
buffer: .space 4004 # 1001��������������С4004
input_file: .asciiz "a.in"
output_file: .asciiz "a.out"


.text
main:
    la $a0, input_file # �����ļ�����ַ���ص�a0
    li $a1, 0 # �ļ���ģʽΪ��ȡ��flag=0
    li $a2, 0 # mode is ignored
    li $v0, 13 # ���ļ�a.in
    syscall # ���򿪳ɹ����ļ����������ص�v0

    move $a0, $v0 # �ļ����������뵽a0
    la $a1, buffer # buffer��ַ���ص�a1
    li $a2, 4004
    li $v0, 14 # ��ȡ�ļ�a.in
    syscall
    li $v0, 16 # �ر��ļ�a.in
    syscall

    la $a0, buffer # buffer��ַ���ص�a0
    lw $a1, 0($a0) # insertion_sort����a1=N=buffer[0]������Ԫ�ظ���
    addi $a0, $a0, 4 # insertion_sort����a0=buffer[1]�ĵ�ַ����v[0]�ĵ�ַ
    addi $s0, $0, 0 # compare_count=0
    jal insertion_sort_ready # ����insertion_sort


exit:
    la $t0, buffer # buffer��ַ���ص�t0
    lw $t1, 0($t0) # ʹ��t1��ʱ����N
    sw $s0, 0($t0) # buffer[0]=compare_count

    la $a0, output_file # ����ļ�����ַ���ص�a0
    li $a1, 1 # �ļ���ģʽΪд�룬flag = 1
    li $a2, 0 # mode is ignored
    li $v0, 13 # ���ļ�a.out
    syscall # ���򿪳ɹ����ļ����������ص�v0

    move $a0, $v0 # �ļ����������뵽a0
    la $a1, buffer # buffer��ַ���ص�a1
    addi $t1, $t1, 1 # t1=N+1
    sll $a2, $t1, 2 # a2=4*t1=4*(N+1)��д����ֽ���
    li $v0, 15 # д���ļ�a.out
    syscall
    li $v0, 16 # �ر��ļ�a.out
    syscall
    li $v0, 10 # �˳�
    syscall


# insert_sort����������a0Ϊv[0]��ַ��a1Ϊ���и���N
insertion_sort_ready:
    addi $sp, $sp, -12 # ջָ�������ƶ�12
    sw $ra, 8($sp) # ����ra
    sw $a0, 4($sp) # ����a0
    sw $a1, 0($sp) # ����a1
    addi $s1, $0, 1 # ѭ����������i����ʼΪ1


insertion_sort_loop:
    slt $t1, $s1, $a1 # t1=(i<N)
    beq $t1, $0, insertion_sort_end # i>=N�˳�ѭ����i<N����ѭ��
    addi $a2, $s1, 0 # search����a2=i
    jal search_ready # ����search
    addi $a3, $v0, 0 # insert����a3=place��������λ��k
    jal insert_ready # ����insert
    addi $s1, $s1, 1 # i++
    j insertion_sort_loop # ��һ��ѭ��


insertion_sort_end:
    lw $a1, 0($sp) # �ָ�a1
    lw $a0, 4($sp) # �ָ�a0
    lw $ra, 8($sp) # �ָ�ra
    addi $sp, $sp, 12 # �ָ�ջָ��λ��
    jr $ra # ����


# search����������a0Ϊv[0]��ַ��a2Ϊ������Ԫ���±�i
search_ready:
    sll $t1, $a2, 2 # t1=4*i
    add $t1, $a0, $t1 # t1=v[i]�ĵ�ַ
    lw $t1, 0($t1) # t1=v[i]=tmp
    addi $t2, $a2, -1 # ѭ����������t2=j����ʼΪi-1


search_loop:
    slt $t3, $t2, $0 # t3=(j<0)
    bne $t3, $0, search_end # j<0�˳�ѭ����j>=0����ѭ��
    addi $s0, $s0, 1 # compare_count++
    sll $t3, $t2, 2 # t3=4*j
    add $t3, $a0, $t3 # t3=v[j]�ĵ�ַ
    lw $t3, 0($t3) # t3=v[j]
    slt $t4, $t1, $t3 # t4=(v[j]>tmp)
    beq $t4, $0, search_end # if v[j]<=tmp,break
    addi $t2, $t2, -1 # j--
    j search_loop # ��һ��ѭѭ��


search_end:
    addi $v0, $t2, 1 # return j+1
    jr $ra # ����


# insert����������a0Ϊv[0]��ַ��a2Ϊ������Ԫ���±�i��a3Ϊ����λ��k
insert_ready:
    sll $t1, $a2, 2 # t1=4*i
    add $t1, $a0, $t1 # t1=v[i]�ĵ�ַ
    lw $t1, 0($t1) # t1=tmp=v[i]
    addi $t2, $a2, -1 # ѭ����������t2=j����ʼΪi-1


insert_loop:
    slt $t3, $t2, $a3 # t3=(j<k)
    bne $t3, $0, insert_end # j<k�˳�ѭ����j>=k����ѭ��
    sll $t3, $t2, 2 # t3=4*j
    add $t3, $a0, $t3 # t3=v[j]�ĵ�ַ
    lw $t4, 0($t3) # t4=v[j]
    sw $t4, 4($t3) # v[j+1]=v[j]
    addi $t2, $t2, -1 # j--
    j insert_loop # ��һ��ѭ��


insert_end:
    sll $t2, $a3, 2 # t2=4*k
    add $t2, $a0, $t2 # t2=v[k]�ĵ�ַ
    sw $t1, 0($t2) # v[k]=tmp
    jr $ra # ����
