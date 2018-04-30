	.file	1 "plotFunctions.c"
	.section .mdebug.abi32
	.previous
	.abicalls
	.text
	.align	2
	.globl	loadPixelBrightness
	.ent	loadPixelBrightness
loadPixelBrightness:
	.frame	$fp,72,$ra		# vars= 32, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,72
	.cprestore 16
	sw	$ra,64($sp)
	sw	$fp,60($sp)
	sw	$gp,56($sp)
	move	$fp,$sp
	sw	$a0,72($fp)
	addu	$a0,$fp,24
	lw	$a1,72($fp)
	la	$t9,convertIntToCharacter
	jal	$ra,$t9
	sw	$zero,40($fp)
	sw	$zero,44($fp)
$L18:
	lw	$v0,44($fp)
	lw	$v1,36($fp)
	slt	$v0,$v0,$v1
	bne	$v0,$zero,$L21
	b	$L19
$L21:
	lw	$v1,44($fp)
	addu	$v0,$fp,24
	addu	$v0,$v0,$v1
	lb	$v0,0($v0)
	move	$a0,$v0
	la	$t9,putch
	jal	$ra,$t9
	sw	$v0,40($fp)
	lw	$v0,40($fp)
	beq	$v0,$zero,$L20
	lw	$v0,40($fp)
	sw	$v0,48($fp)
	b	$L17
$L20:
	lw	$v0,44($fp)
	addu	$v0,$v0,1
	sw	$v0,44($fp)
	b	$L18
$L19:
	lw	$v0,40($fp)
	sw	$v0,48($fp)
$L17:
	lw	$v0,48($fp)
	move	$sp,$fp
	lw	$ra,64($sp)
	lw	$fp,60($sp)
	addu	$sp,$sp,72
	j	$ra
	.end	loadPixelBrightness
	.size	loadPixelBrightness, .-loadPixelBrightness
	.rdata
	.align	2
$LC0:
	.word	1082130432
	.text
	.align	2
	.globl	mips32_plot
	.ent	mips32_plot
mips32_plot:
	.frame	$fp,88,$ra		# vars= 48, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,88
	.cprestore 16
	sw	$ra,80($sp)
	sw	$fp,76($sp)
	sw	$gp,72($sp)
	move	$fp,$sp
	sw	$a0,88($fp)
	lw	$v0,88($fp)
	lw	$a0,44($v0)
	la	$t9,initFile
	jal	$ra,$t9
	la	$t9,loadFileDescriptor
	jal	$ra,$t9
	sw	$v0,24($fp)
	lw	$v0,24($fp)
	beq	$v0,$zero,$L24
	b	$L23
$L24:
	lw	$v1,88($fp)
	lw	$a1,88($fp)
	lw	$v0,88($fp)
	lw	$v0,40($v0)
	addu	$v0,$v0,-1
	lw	$a0,36($v1)
	lw	$a1,32($a1)
	move	$a2,$v0
	la	$t9,writeHeader
	jal	$ra,$t9
	sw	$v0,24($fp)
	lw	$v0,24($fp)
	beq	$v0,$zero,$L25
	b	$L23
$L25:
	sw	$zero,60($fp)
	lw	$v0,88($fp)
	l.s	$f0,4($v0)
	s.s	$f0,32($fp)
$L26:
	lw	$v0,88($fp)
	lw	$v1,60($fp)
	lw	$v0,36($v0)
	sltu	$v0,$v1,$v0
	bne	$v0,$zero,$L29
	b	$L27
$L29:
	sw	$zero,56($fp)
	lw	$v0,88($fp)
	l.s	$f0,0($v0)
	s.s	$f0,28($fp)
$L30:
	lw	$v0,88($fp)
	lw	$v1,56($fp)
	lw	$v0,32($v0)
	sltu	$v0,$v1,$v0
	bne	$v0,$zero,$L33
	b	$L31
$L33:
	l.s	$f0,28($fp)
	s.s	$f0,36($fp)
	l.s	$f0,32($fp)
	s.s	$f0,40($fp)
	sw	$zero,64($fp)
$L34:
	lw	$v0,88($fp)
	lw	$v1,64($fp)
	lw	$v0,40($v0)
	sltu	$v0,$v1,$v0
	bne	$v0,$zero,$L37
	b	$L35
$L37:
	l.s	$f2,36($fp)
	l.s	$f0,36($fp)
	mul.s	$f4,$f2,$f0
	l.s	$f2,40($fp)
	l.s	$f0,40($fp)
	mul.s	$f0,$f2,$f0
	add.s	$f0,$f4,$f0
	mov.s	$f2,$f0
	s.s	$f2,52($fp)
	l.s	$f0,$LC0
	c.le.s	$f0,$f2
	bc1t	$L35
	lw	$v0,88($fp)
	l.s	$f2,36($fp)
	l.s	$f0,36($fp)
	mul.s	$f2,$f2,$f0
	l.s	$f0,24($v0)
	add.s	$f4,$f2,$f0
	l.s	$f2,40($fp)
	l.s	$f0,40($fp)
	mul.s	$f0,$f2,$f0
	sub.s	$f0,$f4,$f0
	s.s	$f0,44($fp)
	lw	$v0,88($fp)
	l.s	$f2,36($fp)
	l.s	$f0,40($fp)
	mul.s	$f0,$f2,$f0
	add.s	$f2,$f0,$f0
	l.s	$f0,28($v0)
	add.s	$f0,$f0,$f2
	s.s	$f0,48($fp)
	l.s	$f0,44($fp)
	s.s	$f0,36($fp)
	l.s	$f0,48($fp)
	s.s	$f0,40($fp)
	lw	$v0,64($fp)
	addu	$v0,$v0,1
	sw	$v0,64($fp)
	b	$L34
$L35:
	lw	$a0,64($fp)
	la	$t9,loadPixelBrightness
	jal	$ra,$t9
	sw	$v0,24($fp)
	lw	$v0,24($fp)
	beq	$v0,$zero,$L40
	lw	$v0,88($fp)
	lw	$a0,44($v0)
	la	$t9,closeFile
	jal	$ra,$t9
	b	$L23
$L40:
	li	$a0,32			# 0x20
	la	$t9,putch
	jal	$ra,$t9
	sw	$v0,24($fp)
	lw	$v0,24($fp)
	beq	$v0,$zero,$L32
	la	$t9,closeFile
	jal	$ra,$t9
	b	$L23
$L32:
	lw	$v0,56($fp)
	addu	$v0,$v0,1
	sw	$v0,56($fp)
	lw	$v0,88($fp)
	l.s	$f2,28($fp)
	l.s	$f0,16($v0)
	add.s	$f0,$f2,$f0
	s.s	$f0,28($fp)
	b	$L30
$L31:
	li	$a0,10			# 0xa
	la	$t9,putch
	jal	$ra,$t9
	sw	$v0,24($fp)
	lw	$v0,24($fp)
	beq	$v0,$zero,$L28
	la	$t9,closeFile
	jal	$ra,$t9
	b	$L23
$L28:
	lw	$v0,60($fp)
	addu	$v0,$v0,1
	sw	$v0,60($fp)
	lw	$v0,88($fp)
	l.s	$f2,32($fp)
	l.s	$f0,20($v0)
	sub.s	$f0,$f2,$f0
	s.s	$f0,32($fp)
	b	$L26
$L27:
	la	$t9,flush
	jal	$ra,$t9
	la	$t9,closeFile
	jal	$ra,$t9
$L23:
	move	$sp,$fp
	lw	$ra,80($sp)
	lw	$fp,76($sp)
	addu	$sp,$sp,88
	j	$ra
	.end	mips32_plot
	.size	mips32_plot, .-mips32_plot
	.ident	"GCC: (GNU) 3.3.3 (NetBSD nb3 20040520)"
