#include <mips/regdef.h>
#include <sys/syscall.h>

	.file	1 "TestCaseTp1.2.c"
	#.section .mdebug.abi32
	#.previous
	#.abicalls
	.rdata
	.align	2
error_write:
	.ascii	"[Error] Hubo un error al escribir en el archivo. \n\000"
	.text
	.align	2
	.globl	writeBufferInOFile
	.ent	writeBufferInOFile
writeBufferInOFile:
	.frame	$fp,64,ra		# armo el stack frame de 64 bytes
	#.mask	0xd0000000,-8
	#.fmask	0x00000000,0
	.set	noreorder    # set metadata
	.cpload	t9           # ???
	.set	reorder      # delay slot
	subu	sp,sp,64     # creo stack frame de 64 bytes
	.cprestore 16        # ???
	sw	ra,56(sp)       # guardo ra en posicion 56
	sw	$fp,52(sp)      # guardo $fp en posicion 52
	sw	gp,48(sp)       # guardo gp en posicion 48
	move	$fp,sp      # alinea los punteros de $fp y sp
	sw	a0,64($fp)      # stack(64) = puntero a buffer(bufferToLoad)
	sw	a1,68($fp)      # stack(68) = quantityCharactersInBufferToLoad
	lw	v0,fileOutput   # cargo en v0 fileOutput
	beq	v0,zero,error_output   # if v0 = 0 salto <error_output>
	lw	v0,68($fp)       # guardo el fileOutput en stack(68)
	blez v0,error_output # si fileOutput < 0 salto <error_output>
	b	while_init       # salto a <while_init>
error_output:
	sw	zero,40($fp)
	b	return_error
while_init:
	li	v0,1			# pone un 1 en v0
	sw	v0,24($fp)      # stack(24) = FALSE = 1 = completeDelivery
	sw	zero,28($fp)    # stack(28) = bytesWriteAcum = 0
	lw	v0,68($fp)      # carga en v0 el fileOutput
	sw	v0,32($fp)      # stack(32) = fileOutput
check_delivery:
	lw	v1,24($fp)      # v1 = stack(24) = completeDelivery
	li	v0,1			# v0 = 1
	beq	v1,v0,while	    # if v1 == v0 salta a <while>
	b	save_zero       # sino salta a <save_zero>
while:
	lw	v1,64($fp)      # v1 = puntero al buffer
	lw	v0,28($fp)      # v0 = 0
	addu	v0,v1,v0    # v0 = v0 + v1
	lw	a0,ofd          # a0 = output file descriptor
	move	a1,v0       # a1 = v0
	lw	a2,32($fp)      # a2 = fileOutput
	la	t9,write        # t9 = * write
	jal	ra,t9           # llamada al syscall
	sw	v0,36($fp)      # stack(36) = return write(# chars escritos)
	lw	v0,36($fp)      # <Borrar>
	bgez v0,while_cont  # Si la cantidad de bytes escritos > 0 salto <while_cont>
	la	a0,__sF+176     # ???
	la	a1,error_write  # a1 = [error_write]
	la	t9,fprintf      # t9 - [$fprintf] ???
	jal	ra,t9           # llamada a $fprintf
	li	v0,3			# v0 = 3
	sw	v0,40($fp)      # stack(40) = cantidad de chars escritos(bytesWrite)
	b	return_error    # salta a <return_error>
while_cont:
	lw	v1,28($fp)      # v1 = stack(28) = bytesWriteAcum
	lw	v0,36($fp)      # v0 = bytesWrite(nro chars escritos)
	addu	v0,v1,v0    # v0 = v1 + v0
	sw	v0,28($fp)      # guarda el bytesWriteAcum nuevo.
	lw	v1,68($fp)      # v1 = quantityCharactersInBufferToLoad
	lw	v0,28($fp)      # v0 = bytesWriteAcum
	subu	v0,v1,v0    # v0 = v1 - v0
	sw	v0,32($fp)      # stack(32) = bytesToWrite
	lw	v0,32($fp)      # ???
	bgtz v0,check_delivery # branch si bytesToWrite > 0
	sw	zero,24($fp)    # stack(24) = completeDelivery = 0
	b	check_delivery  # branch <check_delivery>
save_zero:
	sw	zero,40($fp)    # bytesToWrite = 0
return_error:
	lw	v0,40($fp)      # v0 = stack(40) = bytesWrite
	move	sp,$fp      # iguala sp con $fp
	lw	ra,56(sp)       # ra = ra
	lw	$fp,52(sp)      # $fp = $fp
	addu	sp,sp,64    # ???
	j	ra              # ???
	.end	writeBufferInOFile
	.size	writeBufferInOFile, .-writeBufferInOFile
	.align	2
	.globl	main
	.ent	main
main:
	.frame	$fp,48,ra		# armo un stack frame de 48
	#.mask	0xd0000000,-8
	#.fmask	0x00000000,0
	.set	noreorder
	.cpload	t9
	.set	reorder
	subu	sp,sp,48
	.cprestore 16
	sw	ra,40(sp)
	sw	$fp,36(sp)
	sw	gp,32(sp)
	move	$fp,sp
	sw	a0,48($fp)
	sw	a1,52($fp)
	sw	a2,56($fp)
	li	v0,2			# 0x2
	sw	v0,24($fp)
	lw	a0,24($fp)
	la	t9,malloc
	jal	ra,t9
	sw	v0,28($fp)
	lw	v1,28($fp)
	li	v0,76			# 0x4c
	sb	v0,0(v1)
	lw	v0,28($fp)
	addu	v1,v0,1
	li	v0,86			# 0x56
	sb	v0,0(v1)
	li	v0,1			# 0x1
	sw	v0,ofd
	la	v0,__sF+88
	sw	v0,fileOutput
	lw	a0,28($fp)
	lw	a1,24($fp)
	la	t9,writeBufferInOFile
	jal	ra,t9
	move	v0,zero
	move	sp,$fp
	lw	ra,40(sp)
	lw	$fp,36(sp)
	addu	sp,sp,48
	j	ra
	.end	main
	.size	main, .-main

	.comm	fileOutput,4

	.comm	ofd,4
	.ident	"GCC: (GNU) 3.3.3 (NetBSD nb3 20040520)"
