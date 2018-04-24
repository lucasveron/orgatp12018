#include <mips/regdef.h>
#include <sys/syscall.h>

#include "constants.h"

# Size mensajes
#define BYTES_MENSAJE_ERROR_WRITE   52
#define BYTES_MENSAJE_ERROR_CLOSE_FILE   68
#define BYTES_MENSAJE_ERROR_LOAD_FILE  	 51

#define FILE_DESCRIPTOR_STDERR	    2

	.globl	quantityCharactersInBuffer
	.globl	quantityCharactersInBuffer
	.section	.bss
	.align	2
	.type	quantityCharactersInBuffer, @object
	.size	quantityCharactersInBuffer, 4
quantityCharactersInBuffer:
	.space	4

#---------------  loadFileDescriptor  ---------------#

	.text
	.align	2
	.globl	loadFileDescriptor
	.ent	loadFileDescriptor
loadFileDescriptor:
	.frame	$fp,48,ra
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
	bne	v0,zero,$fileno
	
	# Hubo error al querer escribir en el archivo => Mensaje de error. 
        li      a0,FILE_DESCRIPTOR_STDERR # Cargo en a0 FILE_DESCRIPTOR_STDERR.
        la      a1,MENSAJE_ERROR_LOAD_FILE
        li      a2,BYTES_MENSAJE_ERROR_LOAD_FILE # Cargo en a2 la cantidad de bytes a escribir.
        li      v0, SYS_write
        syscall # No controlo error porque sale de por si de la funcion por error.

 	# return ERROR_FILE;
        li      v0,ERROR_FILE  # Cargo codigo de error, que sera el resultado de la funcion.
        sw      v0,24($fp)      # Guardo en la direccion 40($fp) el resultado de la funcion.

	b	$returnLoadFile
$fileno:
	lw	v0,fileOutput
	lh	v0,14(v0)
	sw	v0,ofd
	sw	zero,24($fp)
$returnLoadFile:
	lw	v0,24($fp)
	move	sp,$fp
	lw	ra,40(sp)
	lw	$fp,36(sp)
	addu	sp,sp,48
	j	ra
	.end	loadFileDescriptor
	.size	loadFileDescriptor, .-loadFileDescriptor


# ----------------- closeFile ---------
	.text
	.align	2
	.globl	closeFile
	.ent	closeFile
closeFile:
	.frame	$fp,48,ra
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
	bne	v1,v0,$IfFileOutputNull
	sw	zero,fileOutput
	b	$return
$IfFileOutputNull:
	lw	v0,fileOutput
	beq	v0,zero,$return
	
	# fileOutput is not NULL
	lw	a0,ofd   	# a0 = file descriptor
	li      v0, SYS_close
        syscall

	beq     a3,zero,$setOutputNull # Si no hubo error, salto a $setOutputNull.

        # Hubo error al querer escribir en el archivo => Mensaje de error. 
        li      a0,FILE_DESCRIPTOR_STDERR # Cargo en a0 FILE_DESCRIPTOR_STDERR.
        la      a1,MENSAJE_ERROR_CLOSE_FILE
        li      a2,BYTES_MENSAJE_ERROR_CLOSE_FILE # Cargo en a2 la cantidad de bytes a escribir.
        li      v0, SYS_write
        syscall # No controlo error porque sale de por si de la funcion por error.
$setOutputNull:
	sw	zero,fileOutput
$return:
	move	sp,$fp
	lw	ra,40(sp)
	lw	$fp,36(sp)
	addu	sp,sp,48
	j	ra
	.end	closeFile
	.size	closeFile, .-closeFile


#---------------   ---------------#
	.globl	writeBufferInOFile
	.ent	writeBufferInOFile
#---------------   ---------------#
writeBufferInOFile:
	.frame	$fp,64,ra
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
	beq	v0,zero,$return_no_data_to_save
	lw	v0,68($fp)
	blez	v0,$return_no_data_to_save
	b	$while_init
$return_no_data_to_save:
	sw	zero,40($fp)
	b	$return_write_buffer_in_OFile
$while_init:
	li	v0,1			# 0x1
	sw	v0,24($fp)
	sw	zero,28($fp)
	lw	v0,68($fp)
	sw	v0,32($fp)
$check_delivery:
	lw	v1,24($fp)
	li	v0,1			# 0x1
	beq	v1,v0,$while
	b	$return_okey
$while:
	lw	v1,64($fp)
	lw	v0,28($fp)
	addu	v0,v1,v0

	lw	a0,ofd          # a0 = output file descriptor
	move	a1,v0       	# a1 = v0 = bufferToLoad + bytesWriteAcum
	lw	a2,32($fp)      # a2 = bytesToWrite
	li      v0, SYS_write
        syscall  # Seria int bytesWrite = write(ofd, bufferToLoad + bytesWriteAcum, bytesToWrite);

	beq     a3,zero,$save_bytes_write # Si no hubo error, salto a $save_bytes_write.

	# Hubo error al querer escribir en el archivo => Mensaje de error. 
        li      a0,FILE_DESCRIPTOR_STDERR # Cargo en a0 FILE_DESCRIPTOR_STDERR.
        la      a1,MENSAJE_ERROR_WRITE
        li      a2,BYTES_MENSAJE_ERROR_WRITE # Cargo en a2 la cantidad de bytes a escribir.
        li      v0, SYS_write
        syscall # No controlo error porque sale de por si de la funcion por error.

        # return ERROR_WRITE;
        li      v0,ERROR_WRITE  # Cargo codigo de error, que sera el resultado de la funcion.
        sw      v0,40($fp)      # Guardo en la direccion 40($fp) el resultado de la funcion.
        b       $return_write_buffer_in_OFile

$save_bytes_write:
	sw	v0,36($fp)
	lw	v1,28($fp)
	lw	v0,36($fp)
	addu	v0,v1,v0
	sw	v0,28($fp)
	lw	v1,68($fp)
	lw	v0,28($fp)
	subu	v0,v1,v0
	sw	v0,32($fp)
	lw	v0,32($fp)
	bgtz	v0,$check_delivery
	sw	zero,24($fp)
	b	$check_delivery
$return_okey:
	sw	zero,40($fp)
$return_write_buffer_in_OFile:
	lw	v0,40($fp)
	move	sp,$fp
	lw	ra,56(sp)
	lw	$fp,52(sp)
	addu	sp,sp,64
	j	ra
	.end	writeBufferInOFile
	.size	writeBufferInOFile, .-writeBufferInOFile
	.align	2

	.text
	.align  2
	.globl	putch
	.ent	putch
#---------------   ---------------#
putch:
	.frame	$fp,56,ra
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
	beq	v0,zero,$writeBuffer
	lb	v0,24($fp)
	move	a0,v0
	la	t9,loadDataInBuffer
	jal	ra,t9
	sw	zero,32($fp)
	b	$returnPutch
$writeBuffer:
	la	a0,buffer
	lw	a1,quantityCharactersInBuffer
	la	t9,writeBufferInOFile
	jal	ra,t9
	sw	v0,28($fp)
	lw	v0,28($fp)
	beq	v0,zero,$exeLoadData
	lw	v0,28($fp)
	sw	v0,32($fp)
	b	$returnPutch
$exeLoadData:
	sw	zero,quantityCharactersInBuffer
	lb	v0,24($fp)
	move	a0,v0
	la	t9,loadDataInBuffer
	jal	ra,t9
	sw	zero,32($fp)
$returnPutch:
	lw	v0,32($fp)
	move	sp,$fp
	lw	ra,48(sp)
	lw	$fp,44(sp)
	addu	sp,sp,56
	j	ra
	.end	putch
	.size	putch, .-putch

#---------------   ---------------#

	.text
	.align	2

	.globl	flush
	.ent	flush
flush:
	.frame	$fp,48,ra
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
	blez	v0,$returnOK
	la	a0,buffer
	lw	a1,quantityCharactersInBuffer
	la	t9,writeBufferInOFile
	jal	ra,t9
	sw	v0,24($fp)
	b	$returnFlush
$returnOK:
	sw	zero,24($fp)
$returnFlush:
	lw	v0,24($fp)
	move	sp,$fp
	lw	ra,40(sp)
	lw	$fp,36(sp)
	addu	sp,sp,48
	j	ra
	.end	flush
	.size	flush, .-flush
	.align	2

#--------------------

	.comm	fileOutput,4

	.comm	ofd,4

	.comm	buffer,100



## Mensajes de error

	.rdata	
	
	.align	2

MENSAJE_ERROR_WRITE:
	.ascii	"[Error] Hubo un error al escribir en el archivo. \n\000"

MENSAJE_ERROR_CLOSE_FILE:
	.ascii	"[Warning] El archivo de output no pudo ser cerrado corre"
	.ascii	"ctamente.\n\000"

MENSAJE_ERROR_LOAD_FILE:
	.ascii	"[Error] No se ha especificado archivo de salida.\n\000"


