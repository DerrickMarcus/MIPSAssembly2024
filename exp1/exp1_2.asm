.text
main:
    li $v0, 5 # ����i
    syscall
    move $t0, $v0 # t0�е�ֵΪi
    li $v0, 5 # ����j
    syscall
    move $t1, $v0 # t1�е�ֵΪj

    sub $t0, $0, $t0 # 0-i��ȡi���෴��
    slt $t3, $t1, $0 # ��j<0��t3Ϊ1������Ϊ0
    beqz $t3, ready # ��t3=0����j>=0����ת��ready
    sub $t1, $0, $t1 # j<0��ȡj���෴��

# ѭ��ǰ��׼��
ready:
    li $t2, 0 # ѭ����������temp����ʼΪ0

loop:
    bge $t2, $t1, end_loop # temp>=j����ѭ��,temp<j����ѭ��
    addi $t0, $t0, 1 # i+=1
    addi $t2, $t2, 1 # temp++
    j loop # ��һ��ѭ��

end_loop:
    move $a0, $t0
    li $v0, 1 # ��ӡi
    syscall
    move $v0, $t0 # ��������浽v0

