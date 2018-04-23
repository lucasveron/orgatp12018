#include <mips/regdef.h>
#include <sys/syscall.h>

	.file	1 "TestCase_closeFile.c"
	#.section .mdebug.abi32
	#.previous
	#.abicalls
	.globl	ofd
	.data
	.align	2
	.type	ofd, @object
	.size	ofd, 4
ofd:
	.word	1
	.rdata
	.align	2
error_output:
	.ascii	"[Warning] El archivo de output no pudo ser cerrado corre"
	.ascii	"ctamente.\n\000"
	.text
	.align	2
	.globl	closeFile
	.ent	closeFile
closeFile:
	.frame	$fp,48,ra		# armo stack frame de 48 bytes
	#.mask	0xd0000000,-8
	#.fmask	0x00000000,0
	.set	noreorder
	.cpload	t9
	.set	reorder
	subu	sp,sp,48      # posiciono el stack pointer(sp)
	.cprestore 16
	sw	ra,40(sp)         # stack[40] = ra
	sw	$fp,36(sp)         # stack[36] = fp
	sw	gp,32(sp)         # stack[32] = gp
	move	$fp,sp         # igualo fp y sp
	lw	v1,ofd             # v1 = ofd
	li	v0,1			    # v0 = 1
	bne	v1,v0,IfFileOutputNull        # if(v1 != v0) <IfFileOutputNull>
	sw	zero,fileOutput    # puntero fileOutput = 0
	b	return                # saltar <return>
IfFileOutputNull:
	lw	v0,fileOutput      # v0 = puntero fileOutput
	beq	v0,zero,return    # if( v0 == 0 ) <return>
	lw	a0,fileOutput      # a0 = puntero fileOutput
	la	t9,fclose          # t9 = puntero fclose
	jal	ra,t9             # llamada a fclose
	sw	v0,24($fp)         # stack[24] = result
	lw	v1,24($fp)         # v1 = stack[24]
	li	v0,-1   			# v0 = -1
	bne	v1,v0,setOutputNull # if( v1 != v0 ) <setOutputNull>
	la	a0,__sF+176        # ???
	la	a1,error_output    # a1 = puntero error_output
	la	t9,fprintf         # t9 = puntero fprintf
	jal	ra,t9             # llamada fprintf
setOutputNull:
	sw	zero,fileOutput    # puntero fileOutput = 0
return:
	move	sp,$fp         # igualo sp y fp
	lw	ra,40(sp)         # ra = stack[40]
	lw	$fp,36(sp)         # fp = stack[36]
	addu	sp,sp,48      # destruye stack pointer
	j	ra                 # saltar ra
	.end	closeFile       # fin closeFile
	.size	closeFile, .-closeFile
	.align	2
	.globl	main
	.ent	main
main:
	.frame	$fp,40,ra		# vars= 0, regs= 3/0, args= 16, extra= 8
	#.mask	0xd0000000,-8
	#.fmask	0x00000000,0
	.set	noreorder
	.cpload	t9
	.set	reorder
	subu	sp,sp,40
	.cprestore 16
	sw	ra,32(sp)
	sw	$fp,28(sp)
	sw	gp,24(sp)
	move	$fp,sp
	la	v0,__sF+88
	sw	v0,fileOutput
	la	t9,closeFile
	jal	ra,t9
	move	v0,zero
	move	sp,$fp
	lw	ra,32(sp)
	lw	$fp,28(sp)
	addu	sp,sp,40
	j	ra
	.end	main
	.size	main, .-main

	.comm	fileOutput,4
	.ident	"GCC: (GNU) 3.3.3 (NetBSD nb3 20040520)"
