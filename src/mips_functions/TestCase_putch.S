#include <mips/regdef.h>
#include <sys/syscall.h>

	.file	1 "TestCase_putch.c"
	#.section .mdebug.abi32
	#.previous
	#.abicalls
	.globl	quantityCharactersInBuffer
	.globl	quantityCharactersInBuffer
	#.section	.bss
	.align	2
	.type	quantityCharactersInBuffer, @object
	.size	quantityCharactersInBuffer, 4
quantityCharactersInBuffer:
	.space	4
	.globl	buffer
	.globl	buffer
	.align	2
	.type	buffer, @object
	.size	buffer, 4
buffer:
	.space	4
	.text
	.align	2
	.globl	loadDataInBuffer
	.ent	loadDataInBuffer
loadDataInBuffer:
	.frame	$fp,24,ra		# vars= 8, regs= 2/0, args= 0, extra= 8
	#.mask	0x50000000,-4
	#.fmask	0x00000000,0
	.set	noreorder
	.cpload	t9
	.set	reorder
	subu	sp,sp,24
	.cprestore 0
	sw	$fp,20(sp)
	sw	gp,16(sp)
	move	$fp,sp
	move	v0,a0
	sb	v0,8($fp)
	move	v0,zero
	move	sp,$fp
	lw	$fp,20(sp)
	addu	sp,sp,24
	j	ra
	.end	loadDataInBuffer
	.size	loadDataInBuffer, .-loadDataInBuffer
	.align	2
	.globl	writeBufferInOFile
	.ent	writeBufferInOFile
writeBufferInOFile:
	.frame	$fp,16,ra		# vars= 0, regs= 2/0, args= 0, extra= 8
	#.mask	0x50000000,-4
	#.fmask	0x00000000,0
	.set	noreorder
	.cpload	t9
	.set	reorder
	subu	sp,sp,16
	.cprestore 0
	sw	$fp,12(sp)
	sw	gp,8(sp)
	move	$fp,sp
	sw	a0,16($fp)
	sw	a1,20($fp)
	move	v0,zero
	move	sp,$fp
	lw	$fp,12(sp)
	addu	sp,sp,16
	j	ra
	.end	writeBufferInOFile
	.size	writeBufferInOFile, .-writeBufferInOFile
	.align	2
	.globl	putch
	.ent	putch
putch:
	.frame	$fp,56,ra		# Arma stack frame de 56 bytes
	#.mask	0xd0000000,-8
	#.fmask	0x00000000,0
	.set	noreorder
	.cpload	t9
	.set	reorder
	subu	sp,sp,56        # posiciono el stack pointer(sp)
	.cprestore 16
	sw	ra,48(sp)           # stack[48] = ra
	sw	$fp,44(sp)          # stack[44] = fp
	sw	gp,40(sp)           # stack[40] = sp
	move	$fp,sp          # igualo fp y sp
	move	v0,a0           # v0 = a0
	sb	v0,24($fp)          # stack[24] = v0 = character
	lw	v0,quantityCharactersInBuffer # v0 = quantityCharactersInBuffer
	slt	v0,v0,100           # if( v0 < 100 ) v0 = 1 else v0 = 0. MAX_BUFFER es 100
	beq	v0,zero,writeBuffer        # if ( v0 > 100 ) <writeBuffer>
	lb	v0,24($fp)          # v0 = character
	move	a0,v0           # a0 = v0
	la	t9,loadDataInBuffer # t9 = puntero loadDataInBuffer
	jal	ra,t9               # saltar t9
	sw	v0,32($fp)          # stack[32] = v0 = return loadDataInBuffer
	b	returnPutch                # saltar <returnPutch>
writeBuffer:
	lw	a0,buffer           # a0 = buffer
	lw	a1,quantityCharactersInBuffer # a1 = quantityCharactersInBuffer
	la	t9,writeBufferInOFile # t9 = puntero fn writeBufferInOFile
	jal	ra,t9               # saltar a fn writeBufferInOFile
	sw	v0,28($fp)          # stack[28] = rdo
	lw	v0,28($fp)          # nada
	beq	v0,zero,exeLoadData        # if(v0 == 0 ) <exeLoadData>
	lw	v0,28($fp)          # v0 = rdo
	sw	v0,32($fp)          # stack[32] = v0 = rdo
	b	returnPutch         # saltar returnPutch
exeLoadData:
	sw	zero,quantityCharactersInBuffer # quantityCharactersInBuffer = 0
	lb	v0,24($fp)          # v0 = stack[24] = character
	move	a0,v0           # a0 = vo
	la	t9,loadDataInBuffer # t9 = puntero fn loadDataInBuffer
	jal	ra,t9               # llamar fn loadDataInBuffer
	sw	v0,32($fp)          # stack[32] = response loadDataInBuffer
returnPutch:
	lw	v0,32($fp)         # v0 = stack[32] = return loadDataInBuffer
	move	sp,$fp         # iguala sp y fp
	lw	ra,48(sp)          # ra = stack[48]
	lw	$fp,44(sp)         # fp = stack[44]
	addu	sp,sp,56       # destruye stack frame
	j	ra                 # return putch
	.end	putch
	.size	putch, .-putch
	.rdata
	.align	2
charTest:
	.ascii	"L\000"
	.align	2
charOK:
	.ascii	"[OK]\000"
	.align	2
charERROR:
	.ascii	"[ERROR]\000"
	.text
	.align	2
	.globl	main
	.ent	main
main:
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
	la	v0,charTest
	sll	v0,v0,24
	sra	v0,v0,24
	move	a0,v0
	la	t9,putch
	jal	ra,t9
	sw	v0,24($fp)
	lw	v0,24($fp)
	bne	v0,zero,$L23
	la	a0,__sF+88
	la	a1,charOK
	la	t9,fprintf
	jal	ra,t9
	b	$L24
$L23:
	la	a0,__sF+88
	la	a1,charERROR
	la	t9,fprintf
	jal	ra,t9
$L24:
	move	v0,zero
	move	sp,$fp
	lw	ra,40(sp)
	lw	$fp,36(sp)
	addu	sp,sp,48
	j	ra
	.end	main
	.size	main, .-main
	.ident	"GCC: (GNU) 3.3.3 (NetBSD nb3 20040520)"
