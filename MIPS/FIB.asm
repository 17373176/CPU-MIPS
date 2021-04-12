.data
  fibs: .space   200   #�����ݶ��б�����һ��ָ���ֽ������൱�ڿ�һ�����������洢��   
  size: .word  12     #���г���ֵ�洢ΪWord�߽��ϵ�32λ�֣��൱�����������±����ֵ
  space:.asciiz  " "          
  head: .asciiz  "The Fibonacci numbers are:\n"
  .text		#7-13��Ӧ��ʼ����������Ϊ�Ĵ������书��
        la   $t0, fibs      # load address of array  
        la   $t5, size      # load address of size variable  
        lw   $t5, 0($t5)    # load array size 
        li   $t2, 1         # 1 is first and second Fib. number 
        sw   $t2, 0($t0)    # F[0] = 1 
        sw   $t2, 4($t0)    # F[1] = F[0] = 1  
        addi $t1, $t5, -2   # Counter for loop, will execute (size-2) times  
  loop: lw   $t3, 0($t0)      
        lw   $t4, 4($t0)      
        add  $t2, $t3, $t4   
        sw   $t2, 8($t0)      
        addi $t0, $t0, 4    #ָ������һ������  
        addi $t1, $t1, -1   #ѭ���������� 
        bgtz $t1, loop      #���Ĵ����е�ֵ����0ʱ��ת����ǩ���ڵ�λ��   
        la   $a0, fibs      #���ر�ǩ��ַ 
        add  $a1, $zero, $t5 #����ջ�����ִ�С
        jal  print          #��ת������һ�еĵ�ַ������$ra�Ĵ����� 
        li   $v0, 10        #�˳� 
        syscall               
  print:add  $t0, $zero, $a0  
        add  $t1, $zero, $a1 
        la   $a0, head       
        li   $v0, 4         #��ӡ�ַ��� 
        syscall              
  out:  lw   $a0, 0($t0)     
        li   $v0, 1         #��ӡ����
        syscall              
        la   $a0, space     #��ӡ�ո�  
        li   $v0, 4           
        syscall              
        addi $t0, $t0, 4     
        addi $t1, $t1, -1    
        bgtz $t1, out        
        jr   $ra            #��ת�������$ra�Ĵ�����ַ��
