.data
_save: .word 9999,8,6,6,6,6,6,6,6,6
_k: .word 6
_error: .asciiz "Index Out of Bounds Exception"	
.text
.globl main
main: # inicialização
	add 	$s3,$zero, $zero 	#i <= 0
	lw 	$s5,_k
	la	$s6,_save
  	lw 	$t2, 4($s6)  #Para pegar a segunda posiçao do array - indica tamanho do vetor /offset Q2(a)/ t2 <= tamnaho do vetor
  	lb	
  	
Loop: # verificação de limites do arranjo
	sltu 	$t3, $s3, $t2
	beq 	$t3, $zero, IndexOutOfBounds
	
      # corpo do laço
	sll 	$t1, $s3, 2   
	add 	$t1, $t1, $s6 
	lw 	$t0, 8($t1) 			#Vetor so começa na 3 pos offset 2x2^2
	bne 	$t0, $s5, Exit    
	addi 	$s3, $s3, 1      
	j 	Loop
                

Exit: # rotina para imprimir inteiro no console
	addi 	$v0, $zero, 1
	add 	$a0, $zero, $s3
	syscall
	j 	End

IndexOutOfBounds: # rotina para imprimir mensagem de erro no console
	addi 	$v0, $zero, 4
	la	$a0, _error
	syscall
End:   
