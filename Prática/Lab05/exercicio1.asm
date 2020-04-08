.data
# Arranjo a ser ordenado:
_v: .word 9,8,7,6,5,4,3,2,1,-1
_k: .word 2 #valor de k

.text
.globl main
main:
# Inicialização dos parâmetros:
la $a0, _v
lw $a1, _k
jal swap
li $v0, 10	#exit syscall
syscall

#corpo do procedimento
swap:
sll $t0, $a1, 2
add $t0, $t0, $a0
lw $t1, 0($t0)
lw $t2, 4($t0)
sw $t2, 0($t0)
sw $t1, 4($t0)
# retorno ao programa principal
jr $ra
