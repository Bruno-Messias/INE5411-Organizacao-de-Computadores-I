.text			# Define o ínício do Text Segment
.globl main		# Define início do código do usuário
main:			# Label que define do código do usuário
add	$s0, $zero, $gp # Copia o valor de $gp para $s0
lbu	$t0, 0($s0)	# Copia o byte da posição de memória [$s0+0] p/ $t0
lbu	$t1, 1($s0)	# Copia o byte da posição de memória [$s0+1] p/ $t1
lbu	$t2, 2($s0)	# Copia o byte da posição de memória [$s0+2] p/ $t2
lbu	$t3, 3($s0)	# Copia o byte da posição de memória [$s0+3] p/ $t3
lbu	$t4, 4($s0)	# Copia o byte da posição de memória [$s0+4] p/ $t4
lbu	$t5, 5($s0)	# Copia o byte da posição de memória [$s0+5] p/ $t5
lbu	$t6, 6($s0)	# Copia o byte da posição de memória [$s0+6] p/ $t6
lbu	$t7, 7($s0)	# Copia o byte da posição de memória [$s0+7] p/ $t7
lw	$t8, 0($s0)	# Copia a word da posição de memória [$s0+0] p/ $t8
