.data
.globl _argumento
.globl _entrada
_argumento: .word 0
_entrada:   .word 0	    # _entrada = 0   ->   A tecla ENTER n�o foi pressionada no teclado do MMIO
			    # _entrada > 0   ->   A tecla ENTER     foi pressionada no teclado do MMIO
			    #		         e a posi��o de mem�ria 0x90000010 ("_temp") cont�m um
			    # 			 n�mero com {_entrada - 1} d�gitos decimais.


.text
.globl main
main: 	
	nop #erro
	#1# Inicializar vari�veis
	lui  $s0, 0xFFFF      # - $s0 cont�m o endere�o base dos registradores localizados
			      #   na �rea de mem�ria denominada por MMIO (0xFFFF0000)
	la   $s1, _argumento

	#2# <Completar> Habilitar interrup��es para entradas de teclado
	
	ori $t2, $t2, 0x2
	sw $t2, 0($s0)

	# ------------------------------------------------------------------------------
	
	#3# Indicar o in�cio da execu��o do programa pela escrita de dois  
	#   caracteres ('I' e '\n') no display do simulador
	addi $a0,$zero,0x49
	jal putc
	addi $a0,$zero,0x0A
	jal putc
	
	#4# Aguardar a leitura de um novo argumento
wait:	# - Def.: Caso a posi��o de mem�ria "_entrada" esteja com o valor zero ent�o
	#	  aconteceu, necessariamente, a leitura de um novo argumento
	lw   $t0, 4($s1)  #_entrada
	beqz $t0, wait

	#5# Ler novo argumento e resetar "_entrada"
	lw   $t0, 0($s1)  #_argumento
	sw   $0,  4($s1)  #_entrada
	
	#5# Calcular o Fibonacci do argumento lido ($t0), i.e. F($t0)
	addi $t1, $zero, 0   # - F( i ) = 0,  para i = 0
	addi $t2, $zero, 1   # - F(i+1) = 1,  para i = 0
loop:	beqz $t0, fim	     # Invariante: $t1 cont�m F(i)
	add  $t3, $t2, $t1   # - F(i+2) = F(i) + F(i+1)
	move $t1, $t2        # - $t1 = F(i+1)
	move $t2, $t3	     # - $t2 = F(i+2)
	addi $t0, $t0, -1    # - i = i + 1   ou, equivalentemente, pode-se 
			     #   diminuir em uma unidade o argumento $t0
	j loop
fim:	
	#6# Imprimir o resultado no display do simulador
	nop #fim
	# - Imprimir "0x" no display,
	#   indicando que o valor que ser� impresso est� em hexadecimal
	ori  $a0, $zero, 0x30
	jal  putc
	ori  $a0, $zero, 0x78
	jal  putc
	# - Imprimir o resultado obtido no display.
	# |  Como a impress�o � feita em hexadecimal, o valor gravado no
	# | registrador � separado em 4 grupos de 4 bits para, ent�o, ser
	# | realizada a impress�o do s�mbolo correspondente ao valor de  
	# | cada grupo.
	# . Invariante: $s7 � o �ndice do bit mais a esquerda do grupo a ser tratado
	addi $s7, $zero, 32
extrair:
	addi $s7, $s7, -4	# Mover para pr�ximo grupo (i.e. para a direita)
	# . Extrair grupo de 4 bits
	srlv $a0, $t1, $s7	
	andi $a0, $a0, 0x000F
	# . Converter para ASCII
	slti $t0, $a0, 10
	bne  $t0, $zero, ascii
	addi $a0, $a0, 7	# Pular os 7 caracteres entre 9 e A: {':', ';', '<', '=', '>', '?', '@'}
ascii:	addi $a0, $a0, 0x30	# ASCII [0-9] :-> [0x30(48)-0x39(57)]; [10-15] :-> [0x41(65)-0x46(70)]
	# . Imprimir grupo
	jal  putc
	# . Caso ainda haja algum outro grupo, loop
	bnez $s7, extrair
	# - Imprimir '\n'
	addi $a0, $zero, 0x0A
	jal putc
	# - Imprimir '\n' (separador visual entre casos de teste)
	addi $a0, $zero, 0x0A
	jal putc
	
	# Voltar a aguardar novo argumento
	j wait




putc:	lui $a1, 0xFFFF	       # / O procedimento putc imprime um caracter ASCII no dispositivo de 
	sw  $a0, 0x0C($a1)     # | sa�da (display) usando a MMIO. Al�m de realizar a impress�o gravando
wait2:	lw  $a0, 8($a1)        # | o c�digo ASCCII na posi��o de mem�ria apropriada, o procedimento
	beq $a0, $zero, wait2  # | tamb�m testa o bit que indica se o caractere foi efetivamente
	jr  $ra                # \ impresso no display.
	

