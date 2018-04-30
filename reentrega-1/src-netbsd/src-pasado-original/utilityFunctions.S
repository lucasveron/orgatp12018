#include <mips/regdef.h>
#include <sys/syscall.h>

#	#.file	1 "utilityFunctions.c"
#	#.section .mdebug.abi32
#	#.previous
#	#.abicalls
	.rdata
	.align	3
$LC0:
	.word	0
	.word	1073741824
	.text
	.align	2
	.globl	convertIntToCharacter
	.ent	convertIntToCharacter
convertIntToCharacter:
	.frame	$fp,56,ra		# vars= 40, regs= 2/0, args= 0, extra= 8
	.mask	0x50000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	t9
	.set	reorder
	subu	sp,sp,56
	.cprestore 0
	sw	$fp,52(sp)
	sw	gp,48(sp)
	move	$fp,sp
	sw	a0,56($fp)
	sw	a1,60($fp)
	sw	zero,20($fp)
	sw	zero,24($fp)
	lw	v0,60($fp)
	bne	v0,zero,$L18
	lw	v1,24($fp)
	addu	v0,$fp,8
	addu	v1,v0,v1
	li	v0,48			# 0x30
	sb	v0,0(v1)
	lw	v0,24($fp)
	addu	v0,v0,1
	sw	v0,24($fp)
	b	$L19
$L18:
	sw	zero,28($fp)
$L20:
	lw	v0,24($fp)
	slt	v0,v0,11
	beq	v0,zero,$L19
	lw	v0,60($fp)
	bne	v0,zero,$L22
	b	$L19
$L22:
	lw	a0,60($fp)
	li	v0,-859045888			# 0xffffffffcccc0000
	ori	v0,v0,0xcccd
	multu	a0,v0
	mfhi	v0
	srl	v1,v0,3
	move	v0,v1
	sll	v0,v0,2
	addu	v0,v0,v1
	sll	v0,v0,1
	subu	v0,a0,v0
	sw	v0,28($fp)
	lw	v1,24($fp)
	addu	v0,$fp,8
	addu	v1,v0,v1
	lbu	v0,28($fp)
	addu	v0,v0,48
	sb	v0,0(v1)
	lw	v1,60($fp)
	li	v0,-859045888			# 0xffffffffcccc0000
	ori	v0,v0,0xcccd
	multu	v1,v0
	mfhi	v0
	srl	v0,v0,3
	sw	v0,60($fp)
	lw	v0,24($fp)
	addu	v0,v0,1
	sw	v0,24($fp)
	b	$L20
$L19:
	lw	v0,24($fp)
	sw	v0,20($fp)
	lw	v1,20($fp)
	li	v0,1			# 0x1
	bne	v1,v0,$L24
	lw	v0,8($fp)
	lw	v1,56($fp)
	sw	v0,0(v1)
	lw	v0,12($fp)
	lw	v1,56($fp)
	sw	v0,4(v1)
	lw	v0,16($fp)
	lw	v1,56($fp)
	sw	v0,8(v1)
	lw	v0,20($fp)
	lw	v1,56($fp)
	sw	v0,12(v1)
	b	$L17
$L24:
	l.s	$f0,20($fp)
	cvt.d.w	$f2,$f0
	l.d	$f0,$LC0
	div.d	$f0,$f2,$f0
	s.d	$f0,32($fp)
	sw	zero,24($fp)
	lw	v0,20($fp)
	addu	v0,v0,-1
	sw	v0,28($fp)
$L25:
	l.s	$f0,24($fp)
	cvt.d.w	$f2,$f0
	l.d	$f0,32($fp)
	c.lt.d	$f2,$f0
	bc1t	$L29
	b	$L26
$L29:
	l.s	$f0,28($fp)
	cvt.d.w	$f2,$f0
	l.d	$f0,32($fp)
	c.le.d	$f0,$f2
	bc1t	$L27
	b	$L26
$L27:
	lw	v1,24($fp)
	addu	v0,$fp,8
	addu	v0,v0,v1
	lbu	v0,0(v0)
	sb	v0,40($fp)
	lw	v1,28($fp)
	addu	v0,$fp,8
	addu	v0,v0,v1
	lbu	v0,0(v0)
	sb	v0,41($fp)
	lw	v1,24($fp)
	addu	v0,$fp,8
	addu	v1,v0,v1
	lbu	v0,41($fp)
	sb	v0,0(v1)
	lw	v1,28($fp)
	addu	v0,$fp,8
	addu	v1,v0,v1
	lbu	v0,40($fp)
	sb	v0,0(v1)
	lw	v0,24($fp)
	addu	v0,v0,1
	sw	v0,24($fp)
	lw	v0,28($fp)
	addu	v0,v0,-1
	sw	v0,28($fp)
	b	$L25
$L26:
	lw	v0,8($fp)
	lw	v1,56($fp)
	sw	v0,0(v1)
	lw	v0,12($fp)
	lw	v1,56($fp)
	sw	v0,4(v1)
	lw	v0,16($fp)
	lw	v1,56($fp)
	sw	v0,8(v1)
	lw	v0,20($fp)
	lw	v1,56($fp)
	sw	v0,12(v1)
$L17:
	lw	v0,56($fp)
	move	sp,$fp
	lw	$fp,52(sp)
	addu	sp,sp,56
	j	ra
	.end	convertIntToCharacter
	.size	convertIntToCharacter, .-convertIntToCharacter
	.ident	"GCC: (GNU) 3.3.3 (NetBSD nb3 20040520)"
