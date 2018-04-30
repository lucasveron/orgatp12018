	.file	1 "generic.c"
	.section .mdebug.abi32
	.previous
	.abicalls
	.rdata
	.align	2
$LC0:
	.ascii	"P2\n\000"
	.align	2
$LC1:
	.ascii	"%u\n\000"
	.align	2
$LC3:
	.ascii	"i/o error.\n\000"
	.align	2
$LC4:
	.ascii	"cannot flush output file.\n\000"
	.align	2
$LC2:
	.word	1082130432
	.text
	.align	2
	.globl	generic
	.ent	generic
generic:
	.frame	$fp,80,$ra		# vars= 40, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,80
	.cprestore 16
	sw	$ra,72($sp)
	sw	$fp,68($sp)
	sw	$gp,64($sp)
	move	$fp,$sp
	sw	$a0,80($fp)
	lw	$v0,80($fp)
	lw	$a0,44($v0)
	la	$a1,$LC0
	la	$t9,fprintf
	jal	$ra,$t9
	lw	$v0,80($fp)
	lw	$v1,80($fp)
	lw	$a0,44($v0)
	la	$a1,$LC1
	lw	$a2,32($v1)
	la	$t9,fprintf
	jal	$ra,$t9
	lw	$v0,80($fp)
	lw	$v1,80($fp)
	lw	$a0,44($v0)
	la	$a1,$LC1
	lw	$a2,36($v1)
	la	$t9,fprintf
	jal	$ra,$t9
	lw	$v1,80($fp)
	lw	$v0,80($fp)
	lw	$v0,40($v0)
	addu	$v0,$v0,-1
	lw	$a0,44($v1)
	la	$a1,$LC1
	move	$a2,$v0
	la	$t9,fprintf
	jal	$ra,$t9
	sw	$zero,56($fp)
	lw	$v0,80($fp)
	l.s	$f0,4($v0)
	s.s	$f0,28($fp)
$L18:
	lw	$v0,80($fp)
	lw	$v1,56($fp)
	lw	$v0,36($v0)
	sltu	$v0,$v1,$v0
	bne	$v0,$zero,$L21
	b	$L19
$L21:
	sw	$zero,52($fp)
	lw	$v0,80($fp)
	l.s	$f0,0($v0)
	s.s	$f0,24($fp)
$L22:
	lw	$v0,80($fp)
	lw	$v1,52($fp)
	lw	$v0,32($v0)
	sltu	$v0,$v1,$v0
	bne	$v0,$zero,$L25
	b	$L20
$L25:
	l.s	$f0,24($fp)
	s.s	$f0,32($fp)
	l.s	$f0,28($fp)
	s.s	$f0,36($fp)
	sw	$zero,60($fp)
$L26:
	lw	$v0,80($fp)
	lw	$v1,60($fp)
	lw	$v0,40($v0)
	sltu	$v0,$v1,$v0
	bne	$v0,$zero,$L29
	b	$L27
$L29:
	l.s	$f2,32($fp)
	l.s	$f0,32($fp)
	mul.s	$f4,$f2,$f0
	l.s	$f2,36($fp)
	l.s	$f0,36($fp)
	mul.s	$f0,$f2,$f0
	add.s	$f0,$f4,$f0
	mov.s	$f2,$f0
	s.s	$f2,48($fp)
	l.s	$f0,$LC2
	c.le.s	$f0,$f2
	bc1t	$L27
	lw	$v0,80($fp)
	l.s	$f2,32($fp)
	l.s	$f0,32($fp)
	mul.s	$f2,$f2,$f0
	l.s	$f0,24($v0)
	add.s	$f4,$f2,$f0
	l.s	$f2,36($fp)
	l.s	$f0,36($fp)
	mul.s	$f0,$f2,$f0
	sub.s	$f0,$f4,$f0
	s.s	$f0,40($fp)
	lw	$v0,80($fp)
	l.s	$f2,32($fp)
	l.s	$f0,36($fp)
	mul.s	$f0,$f2,$f0
	add.s	$f2,$f0,$f0
	l.s	$f0,28($v0)
	add.s	$f0,$f0,$f2
	s.s	$f0,44($fp)
	l.s	$f0,40($fp)
	s.s	$f0,32($fp)
	l.s	$f0,44($fp)
	s.s	$f0,36($fp)
	lw	$v0,60($fp)
	addu	$v0,$v0,1
	sw	$v0,60($fp)
	b	$L26
$L27:
	lw	$v0,80($fp)
	lw	$a0,44($v0)
	la	$a1,$LC1
	lw	$a2,60($fp)
	la	$t9,fprintf
	jal	$ra,$t9
	bgez	$v0,$L24
	la	$a0,__sF+176
	la	$a1,$LC3
	la	$t9,fprintf
	jal	$ra,$t9
	li	$a0,1			# 0x1
	la	$t9,exit
	jal	$ra,$t9
$L24:
	lw	$v0,52($fp)
	addu	$v0,$v0,1
	sw	$v0,52($fp)
	lw	$v0,80($fp)
	l.s	$f2,24($fp)
	l.s	$f0,16($v0)
	add.s	$f0,$f2,$f0
	s.s	$f0,24($fp)
	b	$L22
$L20:
	lw	$v0,56($fp)
	addu	$v0,$v0,1
	sw	$v0,56($fp)
	lw	$v0,80($fp)
	l.s	$f2,28($fp)
	l.s	$f0,20($v0)
	sub.s	$f0,$f2,$f0
	s.s	$f0,28($fp)
	b	$L18
$L19:
	lw	$v0,80($fp)
	lw	$a0,44($v0)
	la	$t9,fflush
	jal	$ra,$t9
	beq	$v0,$zero,$L33
	la	$a0,__sF+176
	la	$a1,$LC4
	la	$t9,fprintf
	jal	$ra,$t9
	li	$a0,1			# 0x1
	la	$t9,exit
	jal	$ra,$t9
$L33:
	lw	$v0,80($fp)
	lw	$a0,44($v0)
	la	$t9,fclose
	jal	$ra,$t9
	move	$sp,$fp
	lw	$ra,72($sp)
	lw	$fp,68($sp)
	addu	$sp,$sp,80
	j	$ra
	.end	generic
	.size	generic, .-generic
	.ident	"GCC: (GNU) 3.3.3 (NetBSD nb3 20040520)"
