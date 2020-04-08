	.data
mask: 	.word 0xfffff83f
	.text
start: 	lw $t0, mask
	lw $s0, shifter
	and $s0, $s0, $t0
	andi $s2, $s2, 0x1f
	sll $s2, $s2, 6
	or $s0, $s0, $s2
	sw $s0, shifter
shifter: sll $s0, $s1, 0