.data
_vetor: .word 5:4200	# Cria a matriz na memória com todos os seus elementos iguais a "5"
.text
li $s6, 700			# $s6 = número total de linhas
li $s7, 6			# $s7 = número total de colunas
la $s0,_vetor			# $s0 = endereço base do vetor
move $t0,$zero			# $t0 = contador de linhas (variável "linha" do código de alto nível)
move $t1,$zero			# $t1 = contador de colunas (variável "coluna" do código de alto nível)
move $s1,$zero			# $s1 = resultado da soma

loop_externo:   
	slt $t6, $t0, $s6	# teste se linha é menor do que o número total de linhas
	beq $t6, $zero, saida
	move $t1, $zero		# coluna = 0
loop_interno:
	slt $t7, $t1, $s7	# teste se coluna é menor do que o número total de colunas
	beq $t7, $zero, itera_loop_externo
	mult $t0, $s7		
	mflo $t2		# $t2 = linha * (número de colunas)
	add $t2, $t2, $t1	# $t2 = linha * (número de colunas) + coluna
	sll $t2, $t2, 2		# $t2 é multiplicado por 4
	add $t2, $t2, $s0	# soma o endereço base do vetor a $t2
	lw $t3, 0($t2)		# lê um elemento da matriz a partir da memória
	add $s1, $s1, $t3	# soma valor da matriz ao acumulador de soma
	addi $t1,$t1,1		# coluna++
	j loop_interno
itera_loop_externo:
	addi $t0,$t0,1		# linha++
	j loop_externo

saida: 	
# intruções para finalizar o programa:
li $v0, 10
syscall