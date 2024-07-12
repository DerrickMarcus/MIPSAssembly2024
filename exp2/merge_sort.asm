# ������ҵ2024
# merge_sort.asm
.data
buffer: .space 4004 # 1001��������������С4004
compare_count: .word 0 # ���ֵΪ0��һ����
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
    li $a2, 4004 # д��4004 byte
    li $v0, 14 # ��ȡ�ļ�a.in
    syscall
    li $v0, 16 # �ر��ļ�a.in
    syscall

    la $s0, buffer # buffer��ַ���ص�s0
    lw $t0, 0($s0) # t0:N=buffer[0]
    la $t8, compare_count # t8���compare_count��ַ
    lw $t9, 0($t8) # t9:compare_count=0

    # create a linked list
    li $a0, 8 # ����8 byte�ռ�
    li $v0, 9 # ϵͳ���ã�int *head=new int[2]
    syscall
    move $s1, $v0 # s1���head�׵�ַ
    sw $0, 4($s1) # head[1]=NULL������Ϊ0
    move $s2, $s1 # int *pointer=head��s2���pointer��ַ
    li $t1, 1 # ѭ����������idx����ʼΪ1
create_linked_list:
    bgt $t1, $t0, create_complete # idx>N�˳�ѭ����idx<=N����ѭ��
    li $a0, 8 # ����8 byte�ռ�
    li $v0, 9 # ϵͳ����
    syscall
    sw $v0, 4($s2)
    # pointer[1]=(int)new int[2]�����¿��ٵ������׵�ַ�����pointer[1]
    lw $s2, 4($s2)
    # pointer=(int *)pointer[1]��pointerָ���¿��ٵ������׵�ַ
    sll $t2, $t1, 2 # t2=4*idx
    add $t2, $s0, $t2 # t2=buffer[idx]��ַ
    lw $t3, 0($t2) # t3=buffer[idx]
    sw $t3, 0($s2) # pointer[0]=buffer[idx]
    sw $0, 4($s2) # pointer[1]=(int)NULL
    
    addi $t1, $t1, 1 # idx++
    j create_linked_list # ��һ��ѭ��
    
create_complete:
    # ��ʱ���������
    lw $a0, 4($s1) # msort����a0=(int *)head[1]
    jal msort_ready # ����msort
    sw $v0, 4($s1) # ����ֵ��head[1]
    move $s2, $s1 # pointer=head


# ��ʼд���ļ�
write_in:
    la $a0, output_file # ����ļ�����ַ���ص�a0
    li $a1, 1 # �ļ���ģʽΪд�룬flag=1
    li $a2, 0 # mode is ignored
    li $v0, 13 # ���ļ�a.out
    syscall # ���򿪳ɹ����ļ����������ص�v0

    move $a0, $v0 # �ļ����������뵽a0
    move $t7, $v0 # �����ļ�������
    sw $t9, 0($t8) # ����compare_count
    move $a1, $t8 # compare_count��ַ���ص�a1
    li $a2, 4
    li $v0, 15 # fwrite(&compare_count, 4, 1, outfile)
    syscall

    move $s2, $s1 # pointer=head


# do ... while(1)
write_loop:
    lw $s2, 4($s2) # pointer=(int*)pointer[1]��ָ����һ��
    beq $s2, $0, write_complete # if pointer==NULL,break
    move $a0, $t7 # �ļ����������뵽a0
    move $a1, $s2 # a1=pointer
    li $a2, 4
    li $v0, 15 # fwrite(pointer, 4, 1, outfile)
    syscall
    j write_loop


write_complete:
    li $v0, 16 # �ر��ļ�a.out
    syscall
    li $v0, 10 # �˳�
    syscall


# msort��������a0=*head
# ���������ݹ������β���(int *)head[1]���������͵�head[1]ת��Ϊָ����һ���ڵ�����ĵ�ַ
# ��󷵻�ֵ����head[1]
# Ϊ����������βε�head��Ϊphead
msort_ready:
    lw $t2, 4($a0) # t2=phead[1]
    beq $t2, $0, msort_return_head # if phead[1]==NULL,return
    move $s3, $a0 # s3:stride_2_pointer,phead
    move $s4, $a0 # s4:stride_1_pointer,phead
    j msort_loop

msort_return_head:
    move $v0, $a0 # return phead
    jr $ra


# do ... while(1)
msort_loop:
    lw $t3, 4($s3) # t3=(int *)stride_2_pointer[1]
    beq $t3, $0, msort_recursion # if t3==NULL,break
    lw $s3, 4($s3)
    # stride_2_pointer=(int *)stride_2_pointer[1]��ָ����һ��
    
    lw $t3, 4($s3) # t3=(int *)stride_2_pointer[1]
    beq $t3, $0, msort_recursion # if t3==NULL,break
    lw $s3, 4($s3)
    # stride_2_pointer=(int *)stride_2_pointer[1]��ָ����һ��
    
    lw $s4, 4($s4)
    # stride_1_pointer=(int *)stride_1_pointer[1]��ָ����һ��
    j msort_loop


msort_recursion:
    lw $s3, 4($s4) # stride_2_pointer=(int *)stride_1_pointer[1]
    sw $0, 4($s4) # stride_1_pointer[1]=(int)NULL;

    addi $sp, $sp, -16 # ջָ�������ƶ�16
    sw $ra, 12($sp) # ����ra
    sw $a0, 8($sp) # ����a0=phead
    sw $s3, 4($sp) # ����s3=stride_2_pointer
    sw $s4, 0($sp) # ����s4=stride_1_pointer
    jal msort_ready # msort(head)������a0����

    lw $a0, 4($sp) # �ڶ����ݹ����a0��ȡ��stride_2_pointer
    sw $v0, 4($sp) # �����һ���ݹ鷵��ֵv0=l_head
    jal msort_ready # msort(stride_2_pointer)

    move $a2, $v0 # merge����a2=r_head
    lw $a1, 4($sp) # merge����a1=l_head
    jal merge_ready # ����merge(l_head,r_head)
    lw $ra, 12($sp) # �ָ�ra
    addi $sp, $sp, 16 # �ָ�ջָ��λ��
    jr $ra


# merge��������a1=*l_head��a2=*r_head
merge_ready:
    # Ϊ���������merge�������ڵ�head��Ϊnhead
    li $a0, 8
    li $v0, 9 # *nhead=new int[2]��v0Ϊnhead��ַ
    syscall
    move $t1, $v0 # t1=nhead
    sw $a1, 4($t1) # nhead[1]=l_head
    move $s5, $t1 # s5:p_left,=nhead
    move $s6, $a2 # s6:p_right,=r_head

merge_loop_outer:
    j merge_loop_inner1


merge_loop_inner1:
    lw $t2, 4($s5) # t2=p_left[1]
    beq $t2, $0, merge_continue # if p_left[1]==NULL,break
    addi $t9, $t9, 1 # compare_count++
    lw $t3, 0($t2) # t3=((int *)p_left[1])[0]
    lw $t4, 0($s6) # t4=p_right[0]
    bgt $t3, $t4, merge_continue # if ((int *)p_left[1])[0]>p_right[0],break
    lw $s5, 4($s5) # p_left=(int *)p_left[1]��ָ����һ��
    j merge_loop_inner1 # ��һ����ѭ��1


merge_continue:
    lw $t2, 4($s5) # t2=p_left[1]
    beq $t2, $0, merge_break # if p_left[1]==NULL,break
    move $t3, $s6 # t3:p_right_temp,=p_right
    j merge_loop_inner2


merge_break:
    sw $s6, 4($s5) # p_left[1]=(int)p_right
    j merge_end # break


merge_loop_inner2:
    lw $t4, 4($t3) # t4=p_right_temp[1]
    beq $t4, $0, merge_loop_insert # if p_right_temp[1]==(int)NULL,break
    addi $t9, $t9, 1 # compare_count++
    lw $t5, 0($t4) # t5=((int *)p_right_temp[1])[0]
    lw $t6, 4($s5) # t6=p_left[1]
    lw $t7, 0($t6) # t7=((int *)p_left[1])[0]
    bgt $t5, $t7, merge_loop_insert # if ((int *)p_right_temp[1])[0]>((int *)p_left[1])[0],break
    lw $t3, 4($t3) # p_right_temp=(int *)p_right_temp[1]ָ����һ��
    j merge_loop_inner2 # ��һ����ѭ��2


merge_loop_insert:
    lw $t4, 4($t3) # t4:int *temp_right_pointer_next,(int *)p_right_temp[1]
    lw $t5, 4($s5) # t5=p_left[1]
    sw $t5, 4($t3) # p_right_temp[1]=p_left[1]
    sw $s6, 4($s5) # p_left[1]=(int)p_right
    move $s5, $t3 # p_left=p_right_temp
    move $s6, $t4 # p_right=temp_right_pointer_next
    beq $s6, $0, merge_end # if p_right==NULL,break
    j merge_loop_outer # ��һ����ѭ��


merge_end:
    lw $v0, 4($t1) # return (int*)rv,=nhead[1]
    jr $ra
