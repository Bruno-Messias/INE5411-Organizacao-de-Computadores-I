.text	          	# Define o in�cio do Text Segment
.globl main      	# Define o in�cio do c�digo do usu�rio
main:            	# Label que define o in�cio do c�digo do usu�rio
add	$s0 $zero,$gp	# Copia o valor de $gp no registrador $s0
lbu	$t0, 0($s0)     # Copia o byte da posi��o de mem�ria [$s0+0] p/ $t0
sb	$t1, 1($s0)    	# Copia o byte menos significativo (� direita) de $t1 para a posi��o de                   
			# mem�ria indicada por [$s0+1]