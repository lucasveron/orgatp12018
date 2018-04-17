	.file	1 "main.c"
	.section .mdebug.abi32
	.previous
	.abicalls
	.globl	x_res
	.data
	.align	2
	.type	x_res, @object
	.size	x_res, 4
x_res:
	.word	640
	.globl	y_res
	.align	2
	.type	y_res, @object
	.size	y_res, 4
y_res:
	.word	480
	.globl	upper_left_re
	.align	2
	.type	upper_left_re, @object
	.size	upper_left_re, 4
upper_left_re:
	.word	-1082130432
	.globl	upper_left_im
	.align	2
	.type	upper_left_im, @object
	.size	upper_left_im, 4
upper_left_im:
	.word	1065353216
	.globl	lower_right_re
	.align	2
	.type	lower_right_re, @object
	.size	lower_right_re, 4
lower_right_re:
	.word	1065353216
	.globl	lower_right_im
	.align	2
	.type	lower_right_im, @object
	.size	lower_right_im, 4
lower_right_im:
	.word	-1082130432
	.globl	seed_re
	.align	2
	.type	seed_re, @object
	.size	seed_re, 4
seed_re:
	.word	-1086712368
	.globl	seed_im
	.align	2
	.type	seed_im, @object
	.size	seed_im, 4
seed_im:
	.word	1044474785
	.globl	plot
	.globl	plot
	.section	.bss
	.align	2
	.type	plot, @object
	.size	plot, 4
plot:
	.space	4
	.globl	output
	.globl	output
	.align	2
	.type	output, @object
	.size	output, 4
output:
	.space	4
	.ident	"GCC: (GNU) 3.3.3 (NetBSD nb3 20040520)"
