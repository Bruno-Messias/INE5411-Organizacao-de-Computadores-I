.data
#Secao 1 : variaveis f, g, h, i, j
#armazenadas em memoria (inicializacao)
_f: .word 0
_g: .word 4
_h: .word 1
_i: .word 4
_j: .word 6
#secao 2: jump adress table
jat:
.word L0
.word L1
.word L2
.word L3
.word L4
.word default

.text
.globl main
main:
#secao 3: registradores recebem valores
#inicializados (exceto variavel k)
lw $s0, _f
lw $s1, _g
lw $s2, _h
lw $s3, _i
lw $s4, _j

#carrega endrecco base da jat:
la $t4, jat

#testa se k esta no intervalo [0,4]
#caso contrario default
sltiu $t0, $s5, 5
beq $t0, $zero, default

#secao 5: calcula o endereco de jat [k]
sll $t1, $s5, 2		# multiplica por 4 o valor de k
add $t1, $t1, $t4	# adiciona o resultado acima com o valor base de da JAT
lw $t1, 0($t1)		# carrega em $t1 o valor resultado dos calculos acima

#secao 6: desvia para o endereco em jat[k]
jr $t1			# pula para a label apropriada

#secao 7 codifica as alternativas de execucao

L0:
add $s0, $s3, $s4
j exit
L1:
add $s0, $s1, $s2
j exit
L2:
add $t2, $s5, $s1
sub $s0, $t2, $s2
j exit
L3:
sub $s0, $s3, $s2
j exit
L4:
sub $s0, $s2, $s3
j exit
default:
add $t2, $s2, $s3
sub $s0, $t2, $s4
exit:
