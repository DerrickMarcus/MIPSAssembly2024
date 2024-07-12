# ������ҵ2024
# binary_insert_sort.asm
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
    lw $a1, 0($a0) # binary_insertion_sort����a1=N=buffer[0]������Ԫ�ظ���
    addi $a0, $a0, 4 # binary_insertion_sort����a0=buffer[1]��ַ����v[0]��ַ
    li $t0, 0 # compare_count=0
    jal binary_insertion_sort_ready # ����binary_insertion_sort


exit:
    la $s0, buffer # buffer��ַ���ص�s0
    lw $t1, 0($s0) # t1��ʱ�������N
    sw $t0, 0($s0) # buffer[0]=compare_count

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


# binary_insort_sort����������a0=v[0]��ַ��a1=���г���N
binary_insertion_sort_ready:
    addi $sp, $sp, -12 # ջָ�������ƶ�12
    sw $ra, 8($sp) # ����ra
    sw $a0, 4($sp) # ����a0
    sw $a1, 0($sp) # ����a1
    li $t1, 1 # ѭ����������i����ʼΪ1


binary_insertion_sort_loop:
    bge $t1, $a1, binary_insertion_sort_end # i>=N�˳�ѭ����i<N����ѭ��

    move $a1, $t1 # binary_search����a1=i
    li $a2, 0 # binary_search����a2=left=0
    addi $a3, $t1, -1 # binary_search����a3=right=i-1
    jal binary_search # ����binary_search
    lw $a1, 0($sp) # �ָ�a1�����ܱ�binary_search�޸ģ�
    lw $a0, 4($sp) # �ָ�a0�����ܱ�binary_search�޸ģ�

    move $a3, $v0 # insert����a3=place��������λ��k
    move $a2, $t1 # insert����a2=i
    jal insert_ready # ����insert
    lw $a0, 4($sp) # �ָ�a0�����ܱ�insert�޸ģ�

    addi $t1, $t1, 1 # i++
    j binary_insertion_sort_loop # ��һ��ѭ��


binary_insertion_sort_end:
    lw $a1, 0($sp) # �ָ�a1
    lw $a0, 4($sp) # �ָ�a0
    lw $ra, 8($sp) # �ָ�ra
    addi $sp, $sp, 12 # �ָ�ջָ��λ��
    jr $ra # ����


# binary_search����������a0=v[0]��ַ��a1Ϊ������Ԫ���±�i��a2Ϊleft��a3Ϊright
binary_search:
    addi $sp, $sp, -20 # ջָ�������ƶ�20
    sw $ra, 16($sp) # ����ra
    sw $a0, 12($sp) # ����a0
    sw $a1, 8($sp) # ����a1
    sw $a2, 4($sp) # ����a2
    sw $a3, 0($sp) # ����a3

    bgt $a2, $a3, binary_search_return # left>right,return left
    add $t2, $a2, $a3 # t2=left+right
    srl $t2, $t2, 1 # t2=mid
    addi $t0, $t0, 1 # compare_count++

    sll $t3, $t2, 2 # t3=4*mid
    add $t3, $a0, $t3 # t3=v[mid]�ĵ�ַ
    lw $t4, 0($t3) # t4=v[mid]
    sll $t5, $a1, 2 # t5=4*i
    add $t5, $a0, $t5 # t5=v[i]�ĵ�ַ
    lw $t6, 0($t5) # t6=v[i]
    bgt $t4, $t6, binary_search_continue_left # v[mid]>v[i]
    j binary_search_continue_right # v[mid]<=v[i]


binary_search_return:
    move $v0, $a2 # return left
    j binary_search_end


# binary_search(v, left, mid - 1, i)
binary_search_continue_left:
    addi $a3, $t2, -1 # right=mid-1
    j binary_search_recursion

# binary_search(v, mid + 1, right, i)
binary_search_continue_right:
    addi $a2, $t2, 1 # left=mid+1
    j binary_search_recursion

# ��ʼ�ݹ�
binary_search_recursion:
    jal binary_search


binary_search_end:
    lw $a3, 0($sp) # �ָ�a3
    lw $a2, 4($sp) # �ָ�a2
    lw $a1, 8($sp) # �ָ�a1
    lw $a0, 12($sp) # �ָ�a0
    lw $ra, 16($sp) # �ָ�ra
    addi $sp, $sp, 20 # �ָ�ջָ��λ��
    jr $ra # ����


# insert����������a0Ϊv[0]��ַ��a2Ϊ������Ԫ���±�i��a3Ϊ����λ��k
insert_ready:
    addi $sp, $sp, -16 # ջָ�������ƶ�16
    sw $ra, 12($sp) # ����ra
    sw $a0, 8($sp) # ����a0
    sw $a2, 4($sp) # ����a2
    sw $a3, 0($sp) # ����a3
    sll $t2, $a2, 2 # t2=4*i
    add $t2, $a0, $t2 # t2=v[i]�ĵ�ַ
    lw $t3, 0($t2) # t3=v[i]=tmp
    addi $t4, $a2, -1 # ѭ����������j����ʼΪi-1


insert_loop:
    blt $t4, $a3, insert_end # j<k�˳�ѭ����j>=k����ѭ��
    sll $t5, $t4, 2 # t5=4*j
    add $t5, $a0, $t5 # t5=v[j]�ĵ�ַ
    lw $t6, 0($t5) # t6=v[j]
    sw $t6, 4($t5) # v[j+1]=v[j]
    addi $t4, $t4, -1 # j--
    j insert_loop # ��һ��ѭ��


insert_end:
    sll $t5, $a3, 2 # t5=4*k
    add $t5, $a0, $t5 # t5=v[k]�ĵ�ַ
    sw $t3, 0($t5) # v[k]=tmp
    lw $a3, 0($sp) # �ָ�a3
    lw $a2, 4($sp) # �ָ�a2
    lw $a0, 8($sp) # �ָ�a0
    lw $ra, 12($sp) # �ָ�ra
    addi $sp, $sp, 16 # �ָ�ջָ��λ��
    jr $ra # ����
