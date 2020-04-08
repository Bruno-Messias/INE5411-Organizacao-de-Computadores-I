## Exception Handler ##
# Interrupt: Excode = 0
# Overflow: ExCode = 12
# Status  $12
# Cause   $13
# EPC     $14

.kdata 0x90000000
# Espaço para salvamento de contexto:
_save: .word 0,0,0,0

# Espaço para salvamento do valor que está sendo digitado:
_temp: .word 0
_size: .word 0




.ktext 0x80000180	# Reloca o tratador para residir no endereço emitido pelo HW
# -------------------------------------------------------------------------------------------------
# Etapa 1: Salvamento de contexto em memória (pilha não pode ser usada)
lui $k0, 0x9000
sw  $ra, 0($k0)
sw  $at, 4($k0)
sw  $t0, 8($k0)
sw  $t1, 12($k0)

# -------------------------------------------------------------------------------------------------
# Etapa 2: Decodificação do registrador Cause
# <Completar> Isole o código ExcCode do registrador Cause para identificar a causa da exceção.
# 	      Armazene este código no registrado $k0. 

mfc0 $k0, $13
srl $k0, $k0, 2
andi $k0, $k0, 0xf


# -------------------------------------------------------------------------------------------------
# Etapa 3: Tratamento de Interrupção - Leitura de caracteres
# <Completar> Caso o código seja de interrupção, o tratador chama o procedimento "lechar" e pula 
#             para "done". Senão o tratador pula para a etapa seguinte "overflow".

bnez $k0, overflow
jal lechar
j done


# -------------------------------------------------------------------------------------------------
# Etapa 4: Tratamento de overflow
# <Completar> Caso o código seja de overflow, o tratador deve, ao final de sua execução
#            (Etapa 7), reiniciar o programa.
overflow:
addi $k1, $0, 0xc #overflow
bne $k0, $k1, done
la $k0, main
mtc0 $k0, $14




# ------------------------------------------------------------------------------------------
# Etapa 5: Preparação do sistema para novas exceções
# <Completar> Limpe o registrador Cause e habilite novas interrupções no registrador Status
done:
mtc0 $0, $13
mfc0 $k0, $12
ori $k0, $k0, 0x1
mtc0 $k0, $12





# ------------------------------------------------------------------------------------------
# Etapa 6: Restauração de contexto
lui $k0, 0x9000
lw  $ra, 0($k0)
lw  $at, 4($k0)
lw  $t0, 8($k0)
lw  $t1, 12($k0)
  
# -------------------------------------------------------------------------------------------------
# Etapa 7: Retorno ao fluxo normal de execução
eret              # retorna para o endereço indicado em EPC




# Função para leitura de caractere
lechar:	
	#1# Ler o valor digitador no teclado da memória
	lui $k0, 0xFFFF
	lw  $k0, 4($k0)
	#2# Caso o valor for ENTER (ASCII 0xA)
	li  $k1, 0x0A
	bne $k0, $k1, cont
	# - Checar se algum número foi digitado
	la  $k1, _temp
	lw  $t1, 4($k1)
	beq $t1, $zero, erro
	# - Ler e resetar os valores {_temp, _size}
	lw  $t0, 0($k1)
	sw  $zero, 0($k1)
	sw  $zero, 4($k1)
	# - Gravar {_temp, _size} -> {_argumento, _entrada}
	la  $k1, _argumento
	sw  $t0, 0($k1)
	sw  $t1, 4($k1)
	j end
cont:	
	#3# Caso contrário combine o valor lido com o armazenado em "_temp"
	addi $k0, $k0, -0x30    # Subtrai 0x30, convertendo ASCII para inteiro
	# Marca 1
	sltiu $k1, $k0, 10    # Marca 1
	beq $k1, $zero, erro
	la  $k1, _temp    # - Se o valor for numérico (de 0 a 9), lê o valor armazenado em
	lw  $t0, 0($k1)   #   "_temp", multiplica por 10, e soma ao valor digitado.
	li  $t1, 10       #   Isso é feito para "construir" o número a partir dos valores digitados.
	mult $t0, $t1
	mflo $t0
	add $t0, $t0, $k0
	sw  $t0, 0($k1)
	# Marca 2
	addi $k0, $k0, 0x30   # Adiciona 0x30, convertendo inteiro para ASCII # Marca 2
	#4# E atualize _size
	lw  $t0, 4($k1)
	addiu $t0, $t0, 1
	sw  $t0, 4($k1)
	j end
erro:   
	#5# Em caso de erro preparar para imprimir "e" no display
	la $k1, _temp
	sw $zero, 0($k1)
	sw $zero, 4($k1)
	li $k0, 0x65
end:	
	#5# Imprimir $k0 no display e retornar
	lui $k1, 0xFFFF
	sw  $k0, 0x0C($k1)
	jr $ra

