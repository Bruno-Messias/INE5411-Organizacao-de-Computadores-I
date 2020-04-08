.data
_save: .word 1,2,3,4,6,6,6,6		#-----inserir estimulo relatorio------
_k: .word 6	
#_meuArray: .word 9,9,9,1,9,9
.text
.globl main

main: 	#lw $s3,_i  # inicialização
	add 	$s3,$zero, $zero 
	lw	$s5,_k
	la 	$s6,_save

Loop: 
	sll 	$t1, $s3, 2    # corpo do laço
	add 	$t1, $t1, $s6 
	lw	$t0, 0($t1) 
	bne 	$t0, $s5, Exit    
	addi 	$s3, $s3, 1      
	j 	Loop
                
Exit: 	addi $v0, $zero, 1 # rotina para imprimir inteiro no console
	add $a0, $zero, $s3
	syscall     
