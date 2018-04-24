#include <mips/regdef.h>
#include <sys/syscall.h>

#include "constants.h"

	#.file	1 "fileFunctions.c"
	#.section .mdebug.abi32
	#.previous
	#.abicalls
	.globl	quantityCharactersInBuffer
	.globl	quantityCharactersInBuffer
	.section	.bss
	.align	2
	.type	quantityCharactersInBuffer, @object
	.size	quantityCharactersInBuffer, 4
quantityCharactersInBuffer:
	.space	4
	.rdata
	.align	2
$LC0:
	.ascii	"[Error] No se ha especificado archivo de salida.\n\000"
	.text
	.align	2
$LC3:
	.ascii	"[Error] Hubo un error al escribir en el archivo. \n\000"
	.text
	.align	2
#---------------   ---------------#
	.globl	loadFileDescriptor
	.ent	loadFileDescriptor
#---------------   ---------------#
loadFileDescriptor:
	.frame	$fp,48,ra		# vars= 8, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	t9
	.set	reorder
	subu	sp,sp,48
	.cprestore 16
	sw	ra,40(sp)
	sw	$fp,36(sp)
	sw	gp,32(sp)
	move	$fp,sp
	lw	v0,fileOutput
	bne	v0,zero,$L18
	la	a0,__sF+176
	la	a1,$LC0
	la	t9,fprintf
	jal	ra,t9
	li	v0,1			# 0x1
	sw	v0,24($fp)
	b	$L17
$L18:
	lw	v0,fileOutput
	lh	v0,14(v0)
	sw	v0,ofd
	sw	zero,24($fp)
$L17:
	lw	v0,24($fp)
	move	sp,$fp
	lw	ra,40(sp)
	lw	$fp,36(sp)
	addu	sp,sp,48
	j	ra
	.end	loadFileDescriptor
	.size	loadFileDescriptor, .-loadFileDescriptor
	.rdata
	.align	2
$LC1:
	.ascii	"[Warning] El archivo de output no pudo ser cerrado corre"
	.ascii	"ctamente.\n\000"
	.text
	.align	2
	.globl	closeFile
	.ent	closeFile
closeFile:
	.frame	$fp,48,ra		# vars= 8, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	t9
	.set	reorder
	subu	sp,sp,48
	.cprestore 16
	sw	ra,40(sp)
	sw	$fp,36(sp)
	sw	gp,32(sp)
	move	$fp,sp
	lw	v1,ofd
	li	v0,1			# 0x1
	bne	v1,v0,$L20
	sw	zero,fileOutput
	b	$L19
$L20:
	lw	v0,fileOutput
	beq	v0,zero,$L19
	lw	a0,fileOutput
	la	t9,fclose
	jal	ra,t9
	sw	v0,24($fp)
	lw	v1,24($fp)
	li	v0,-1			# 0xffffffffffffffff
	bne	v1,v0,$L22
	la	a0,__sF+176
	la	a1,$LC1
	la	t9,fprintf
	jal	ra,t9
$L22:
	sw	zero,fileOutput
$L19:
	move	sp,$fp
	lw	ra,40(sp)
	lw	$fp,36(sp)
	addu	sp,sp,48
	j	ra
	.end	closeFile
	.size	closeFile, .-closeFile
	.rdata
	.align	3
$LC2:
	.word	0
	.word	1073741824
	.text
	.align	2
#---------------   ---------------#
#	.globl	convertIntToCharacter
#	.ent	convertIntToCharacter
#---------------   ---------------#
	.globl	writeBufferInOFile
	.ent	writeBufferInOFile
#---------------   ---------------#
writeBufferInOFile:
	.frame	$fp,64,ra		# vars= 24, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	t9
	.set	reorder
	subu	sp,sp,64
	.cprestore 16
	sw	ra,56(sp)
	sw	$fp,52(sp)
	sw	gp,48(sp)
	move	$fp,sp
	sw	a0,64($fp)
	sw	a1,68($fp)
	lw	v0,fileOutput
	beq	v0,zero,$L36
	lw	v0,68($fp)
	blez	v0,$L36
	b	$L35
$L36:
	sw	zero,40($fp)
	b	$L34
$L35:
	li	v0,1			# 0x1
	sw	v0,24($fp)
	sw	zero,28($fp)
	lw	v0,68($fp)
	sw	v0,32($fp)
$L37:
	lw	v1,24($fp)
	li	v0,1			# 0x1
	beq	v1,v0,$L39
	b	$L38
$L39:
	lw	v1,64($fp)
	lw	v0,28($fp)
	addu	v0,v1,v0
	lw	a0,ofd
	move	a1,v0
	lw	a2,32($fp)
	la	t9,write
	jal	ra,t9
	sw	v0,36($fp)
	lw	v0,36($fp)
	bgez	v0,$L40
	la	a0,__sF+176
	la	a1,$LC3
	la	t9,fprintf
	jal	ra,t9
	li	v0,3			# 0x3
	sw	v0,40($fp)
	b	$L34
$L40:
	lw	v1,28($fp)
	lw	v0,36($fp)
	addu	v0,v1,v0
	sw	v0,28($fp)
	lw	v1,68($fp)
	lw	v0,28($fp)
	subu	v0,v1,v0
	sw	v0,32($fp)
	lw	v0,32($fp)
	bgtz	v0,$L37
	sw	zero,24($fp)
	b	$L37
$L38:
	sw	zero,40($fp)
$L34:
	lw	v0,40($fp)
	move	sp,$fp
	lw	ra,56(sp)
	lw	$fp,52(sp)
	addu	sp,sp,64
	j	ra
	.end	writeBufferInOFile
	.size	writeBufferInOFile, .-writeBufferInOFile
	.align	2
#---------------   ---------------#
#	.globl	writeHeader
#	.ent	writeHeader
#---------------   ---------------#
#writeHeader:
#---------------   ---------------#
#	.globl	loadDataInBuffer
#	.ent	loadDataInBuffer
#---------------   ---------------#
	.globl	putch
	.ent	putch
#---------------   ---------------#
putch:
	.frame	$fp,56,ra		# vars= 16, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	t9
	.set	reorder
	subu	sp,sp,56
	.cprestore 16
	sw	ra,48(sp)
	sw	$fp,44(sp)
	sw	gp,40(sp)
	move	$fp,sp
	move	v0,a0
	sb	v0,24($fp)
	lw	v0,quantityCharactersInBuffer
	slt	v0,v0,100
	beq	v0,zero,$L58
	lb	v0,24($fp)
	move	a0,v0
	la	t9,loadDataInBuffer
	jal	ra,t9
	sw	zero,32($fp)
	b	$L57
$L58:
	la	a0,buffer
	lw	a1,quantityCharactersInBuffer
	la	t9,writeBufferInOFile
	jal	ra,t9
	sw	v0,28($fp)
	lw	v0,28($fp)
	beq	v0,zero,$L59
	lw	v0,28($fp)
	sw	v0,32($fp)
	b	$L57
$L59:
	sw	zero,quantityCharactersInBuffer
	lb	v0,24($fp)
	move	a0,v0
	la	t9,loadDataInBuffer
	jal	ra,t9
	sw	zero,32($fp)
$L57:
	lw	v0,32($fp)
	move	sp,$fp
	lw	ra,48(sp)
	lw	$fp,44(sp)
	addu	sp,sp,56
	j	ra
	.end	putch
	.size	putch, .-putch
	.align	2
#---------------   ---------------#
	.globl	flush
	.ent	flush
#---------------   ---------------#
flush:
	.frame	$fp,48,ra		# vars= 8, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	t9
	.set	reorder
	subu	sp,sp,48
	.cprestore 16
	sw	ra,40(sp)
	sw	$fp,36(sp)
	sw	gp,32(sp)
	move	$fp,sp
	lw	v0,quantityCharactersInBuffer
	blez	v0,$L61
	la	a0,buffer
	lw	a1,quantityCharactersInBuffer
	la	t9,writeBufferInOFile
	jal	ra,t9
	sw	v0,24($fp)
	b	$L60
$L61:
	sw	zero,24($fp)
$L60:
	lw	v0,24($fp)
	move	sp,$fp
	lw	ra,40(sp)
	lw	$fp,36(sp)
	addu	sp,sp,48
	j	ra
	.end	flush
	.size	flush, .-flush
	.align	2
#---------------   ---------------#
#	.globl	loadPixelBrightness
#	.ent	loadPixelBrightness
#---------------   ---------------#
#	.globl	mips32_plot
#	.ent	mips32_plot
#---------------   ---------------#

	.comm	fileOutput,4

	.comm	ofd,4

	.comm	buffer,100
	.ident	"GCC: (GNU) 3.3.3 (NetBSD nb3 20040520)"
