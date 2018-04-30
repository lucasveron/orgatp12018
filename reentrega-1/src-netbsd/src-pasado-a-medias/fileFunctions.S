#include <mips/regdef.h>
#include <sys/syscall.h>

#include "constants.h"

# Size mensajes
#define BYTES_MENSAJE_ERROR_WRITE   52
#define BYTES_MENSAJE_ERROR_CLOSE_FILE   68
#define BYTES_MENSAJE_ERROR_LOAD_FILE   51

#define FILE_DESCRIPTOR_STDERR   2

	.globl	quantityCharactersInBuffer
	.globl	quantityCharactersInBuffer
	.section	.bss
	.align	2
	.type	quantityCharactersInBuffer, @object
	.size	quantityCharactersInBuffer, 4
quantityCharactersInBuffer:
	.space	4
	.text
	.align	2
	.globl	initFile
	.ent	initFile
initFile:
	.frame	$fp,16,ra		
        .set	noreorder
	.cpload	t9
	.set	reorder

	# Stack frame creation
        subu	sp,sp,16

	.cprestore 0
	sw	$fp,12(sp)
	sw	gp,8(sp)
	
        # A partir de aca uso $fp en lugar de sp
        move	$fp,sp

	# Guardo a0 en la direccion $fp(16)
	sw	a0,16($fp)
	lw	v0,16($fp)       #Cargo en v0 la posicion [16], v0 =a0
	sw	v0,fileOutput    #Guardo a0 en la variable fileOutput (FileOutput = file)


	move	sp,$fp
	lw	$fp,12(sp)
        
        # Destruyo el stackframe	
	addu	sp,sp,16

        # Vuelvo a la funcion que me invoco
	j	ra

	.end	initFile
	
	.rdata
	.align	2
$LC0:
	MENSAJE_ERROR_LOAD_FILE    #Llamo a la etiqueta MENSAJE_ERROR_LOAD_FILE
	.text
	.align	2

#---------------  loadFileDescriptor  ---------------#

	.globl	loadFileDescriptor
	.ent	loadFileDescriptor
loadFileDescriptor:
	.frame	$fp,48,ra     # reservo espacio para el stack frame de 48 bytes
	.set	noreorder
	.cpload	t9
	.set	reorder
        
        # creacion del stack frame
	subu	sp,sp,48
	.cprestore 16
	sw	ra,40(sp)
	sw	$fp,36(sp)
	sw	gp,32(sp)

        # de aqui al fin de la funcion uso $fp en lugar de sp.
	move	$fp,sp
        
        # cargo en v0 la direccion del fileOutput.
	lw	v0,fileOutput
        # if (fileOutput != NULL) brancheo
	bne	v0,zero,$fileno
        # if (fileOutput == NULL) continuo.
        # Hubo error al querer escribir en el archivo => Mensaje de error.
	#la	a0,__sF+176
	#la	a1,$LC0
	#la	t9,fprintf
	#jal	ra,t9
        li a0,FILE_DESCRIPTOR_STDERR          # Cargo en a0 el FILE_DESCRIPTOR_STDERR = 2.
        la a1,MENSAJE_ERROR_LOAD_FILE         # Cargo en 01 el mensaje de error.
        li a2,BYTES_MENSAJE_ERROR_LOAD_FILE   # Cargo en a2 la cantidad de byes a escribir.
        syscall     # No controlo error porque sale de por si de la funcion por error.

	# return ERROR_FILE
        li      v0,ERROR_FILE  # Cargo codigo de error, que sera el resultado de la funcion.
	sw	v0,24($fp)     # Guardo en la direccion 24($fp) el resultado de la funcion.
	b	$returnLoadFile
$fileno:
	lw	v0,fileOutput  # Carga en v0 el valor de fileOutput.
	lh	v0,14(v0)      # ???
	sw	v0,ofd         # Guarda el valor del registro v0 en la direccion de ofd.
	sw	zero,24($fp)   # Guarda un 0 en stack[24].
$returnLoadFile:
	lw	v0,24($fp)     # Cargo en v0 el contenido del stack[24] = ERROR_FILE
	move	sp,$fp         # Iguala sp con fp.
	lw	ra,40(sp)      # Carga en ra stack[40] para retornar a la funcion llamante.
	lw	$fp,36(sp)     # Carga en fp stack[36]. ???
	addu	sp,sp,48       # Rompe el stack frame.
	j	ra             # Regresa a la funcion llamante.
	.end	loadFileDescriptor
#--------------- end loadFileDescriptor ---------------#

#--------------- begin closeFile ----------------------#

	.text
	.align	2
	.globl	closeFile
	.ent	closeFile
closeFile:
	.frame	$fp,48,ra
	.set	noreorder
	.cpload	t9
	.set	reorder

        # creacion del stack frame
	subu	sp,sp,48
	.cprestore 16
        
	sw	ra,40(sp)
	sw	$fp,36(sp)
	sw	gp,32(sp)

        # de aqui al fin de la funcion uso $fp en lugar de sp.
	move	$fp,sp
        # carga en v1 el ofd
	lw	v1,ofd
        # carga en v0 1
	li	v0,1
        # if (ofd == 0) salto a  IfFileOutputNull
	bne	v1,v0,$IfFileOutputNull
	sw	zero,fileOutput
	b	$returnCloseFile
$IfFileOutputNull:
	lw	v0,fileOutput  # cargo en v0 fileOutput
        # if (fileOutput == NULL) return funcion closeFile
	beq	v0,zero,$returnCloseFile
        # Sino (fileOutput != NULL ) continuo
        
	#lw	a0,fileOutput  # cargo en a0 fileOutput
	#la	t9,fclose
	#jal	ra,t9
	#sw	v0,24($fp)
	#lw	v1,24($fp)
	#li	v0,-1
	#bne	v1,v0,$setOutputNull
	#la	a0,__sF+176
	#la	a1,MENSAJE_ERROR_CLOSE_FILE
	#la	t9,fprintf
	#jal	ra,t9
        
        lw	a0,ofd   	# a0 = file descriptor
        li      v0, SYS_close
        syscall
        
        beq     a3,zero,$setOutputNull # Si no hubo error, salto a $setOutputNull.
    
        # hubo error al querer escribir en el archivo => Mensaje de error. 
        li      a0,FILE_DESCRIPTOR_STDERR # Cargo en a0 FILE_DESCRIPTOR_STDERR.
        la      a1,MENSAJE_ERROR_CLOSE_FILE
        li      a2,BYTES_MENSAJE_ERROR_CLOSE_FILE # Cargo en a2 la cantidad de bytes a escribir.
        li      v0, SYS_write
        syscall # No controlo error porque sale de por si de la funcion por error.

$setOutputNull:
	sw	zero,fileOutput # Pongo un 0 en la dirección del fileOutput
$returnCloseFile:
	move	sp,$fp     # Iguala sp con fp.
	lw	ra,40(sp)  # Carga en ra stack[40] para retornar a la funcion llamante.
	lw	$fp,36(sp) # Carga en fp stack[36]. ???
	addu	sp,sp,48   # Rompe el stack frame.
	j	ra         # Regresa a la funcion llamante.
	.end	closeFile
#--------------- end closeFile ---------------#
	.rdata
	.align	2
	.globl	writeBufferInOFile
	.ent	writeBufferInOFile
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
	beq	v0,zero,$L26
	lw	v0,68($fp)
	blez	v0,$L26
	b	$L25
$L26:
	sw	zero,40($fp)
	b	$L24
$L25:
	li	v0,1			# 0x1
	sw	v0,24($fp)
	sw	zero,28($fp)
	lw	v0,68($fp)
	sw	v0,32($fp)
$L27:
	lw	v1,24($fp)
	li	v0,1			# 0x1
	beq	v1,v0,$L29
	b	$L28
$L29:
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
	bgez	v0,$L30
	la	a0,__sF+176
	la	a1,$LC2
	la	t9,fprintf
	jal	ra,t9
	li	v0,3			# 0x3
	sw	v0,40($fp)
	b	$L24
$L30:
	lw	v1,28($fp)
	lw	v0,36($fp)
	addu	v0,v1,v0
	sw	v0,28($fp)
	lw	v1,68($fp)
	lw	v0,28($fp)
	subu	v0,v1,v0
	sw	v0,32($fp)
	lw	v0,32($fp)
	bgtz	v0,$L27
	sw	zero,24($fp)
	b	$L27
$L28:
	sw	zero,40($fp)
$L24:
	lw	v0,40($fp)
	move	sp,$fp
	lw	ra,56(sp)
	lw	$fp,52(sp)
	addu	sp,sp,64
	j	ra
	.end	writeBufferInOFile
	.size	writeBufferInOFile, .-writeBufferInOFile
	.align	2
	.globl	loadDataInBuffer
	.ent	loadDataInBuffer
loadDataInBuffer:
	.frame	$fp,24,ra		# vars= 8, regs= 2/0, args= 0, extra= 8
	.mask	0x50000000,-4
	.fmask	0x00000000,0
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
	lw	v1,quantityCharactersInBuffer
	la	v0,buffer
	addu	v1,v1,v0
	lbu	v0,8($fp)
	sb	v0,0(v1)
	lw	v0,quantityCharactersInBuffer
	addu	v0,v0,1
	sw	v0,quantityCharactersInBuffer
	move	sp,$fp
	lw	$fp,20(sp)
	addu	sp,sp,24
	j	ra
	.end	loadDataInBuffer
	.size	loadDataInBuffer, .-loadDataInBuffer
	.align	2
	.globl	putch
	.ent	putch
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
	beq	v0,zero,$L34
	lb	v0,24($fp)
	move	a0,v0
	la	t9,loadDataInBuffer
	jal	ra,t9
	sw	zero,32($fp)
	b	$L33
$L34:
	la	a0,buffer
	lw	a1,quantityCharactersInBuffer
	la	t9,writeBufferInOFile
	jal	ra,t9
	sw	v0,28($fp)
	lw	v0,28($fp)
	beq	v0,zero,$L35
	lw	v0,28($fp)
	sw	v0,32($fp)
	b	$L33
$L35:
	sw	zero,quantityCharactersInBuffer
	lb	v0,24($fp)
	move	a0,v0
	la	t9,loadDataInBuffer
	jal	ra,t9
	sw	zero,32($fp)
$L33:
	lw	v0,32($fp)
	move	sp,$fp
	lw	ra,48(sp)
	lw	$fp,44(sp)
	addu	sp,sp,56
	j	ra
	.end	putch
	.size	putch, .-putch
	.align	2
	.globl	flush
	.ent	flush
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
	blez	v0,$L37
	la	a0,buffer
	lw	a1,quantityCharactersInBuffer
	la	t9,writeBufferInOFile
	jal	ra,t9
	sw	v0,24($fp)
	b	$L36
$L37:
	sw	zero,24($fp)
$L36:
	lw	v0,24($fp)
	move	sp,$fp
	lw	ra,40(sp)
	lw	$fp,36(sp)
	addu	sp,sp,48
	j	ra
	.end	flush
	.size	flush, .-flush
	.align	2
	.globl	writeHeader
	.ent	writeHeader
writeHeader:
	.frame	$fp,120,ra		# vars= 80, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	t9
	.set	reorder
	subu	sp,sp,120
	.cprestore 16
	sw	ra,112(sp)
	sw	$fp,108(sp)
	sw	gp,104(sp)
	move	$fp,sp
	sw	a0,120($fp)
	sw	a1,124($fp)
	sw	a2,128($fp)
	sw	sp,92($fp)
	addu	a0,$fp,24
	lw	a1,120($fp)
	la	t9,convertIntToCharacter
	jal	ra,t9
	addu	v0,$fp,40
	move	a0,v0
	lw	a1,124($fp)
	la	t9,convertIntToCharacter
	jal	ra,t9
	addu	v0,$fp,56
	move	a0,v0
	lw	a1,128($fp)
	la	t9,convertIntToCharacter
	jal	ra,t9
	lw	v1,52($fp)
	lw	v0,36($fp)
	addu	v1,v1,v0
	lw	v0,68($fp)
	addu	v0,v1,v0
	addu	v0,v0,6
	sw	v0,72($fp)
	lw	v0,72($fp)
	addu	v0,v0,-1
	addu	v0,v0,1
	addu	v0,v0,7
	srl	v0,v0,3
	sll	v0,v0,3
	subu	sp,sp,v0
	addu	v0,sp,16
	sw	v0,96($fp)
	li	v0,80			# 0x50
	lw	v1,96($fp)
	sb	v0,0(v1)
	li	v0,50			# 0x32
	lw	a0,96($fp)
	sb	v0,1(a0)
	li	v0,10			# 0xa
	lw	v1,96($fp)
	sb	v0,2(v1)
	li	v0,3			# 0x3
	sw	v0,76($fp)
	sw	zero,80($fp)
$L39:
	lw	v0,80($fp)
	lw	v1,52($fp)
	slt	v0,v0,v1
	bne	v0,zero,$L42
	b	$L40
$L42:
	lw	v0,76($fp)
	lw	v1,96($fp)
	addu	a0,v1,v0
	addu	v1,$fp,40
	lw	v0,80($fp)
	addu	v0,v1,v0
	lbu	v0,0(v0)
	sb	v0,0(a0)
	lw	v0,76($fp)
	addu	v0,v0,1
	sw	v0,76($fp)
	lw	v0,80($fp)
	addu	v0,v0,1
	sw	v0,80($fp)
	b	$L39
$L40:
	lw	v0,76($fp)
	lw	a0,96($fp)
	addu	v1,a0,v0
	li	v0,32			# 0x20
	sb	v0,0(v1)
	lw	v0,76($fp)
	addu	v0,v0,1
	sw	v0,76($fp)
	sw	zero,80($fp)
$L43:
	lw	v0,80($fp)
	lw	v1,36($fp)
	slt	v0,v0,v1
	bne	v0,zero,$L46
	b	$L44
$L46:
	lw	v0,76($fp)
	lw	v1,96($fp)
	addu	a0,v1,v0
	lw	v1,80($fp)
	addu	v0,$fp,24
	addu	v0,v0,v1
	lbu	v0,0(v0)
	sb	v0,0(a0)
	lw	v0,76($fp)
	addu	v0,v0,1
	sw	v0,76($fp)
	lw	v0,80($fp)
	addu	v0,v0,1
	sw	v0,80($fp)
	b	$L43
$L44:
	lw	v0,76($fp)
	lw	a0,96($fp)
	addu	v1,a0,v0
	li	v0,10			# 0xa
	sb	v0,0(v1)
	lw	v0,76($fp)
	addu	v0,v0,1
	sw	v0,76($fp)
	sw	zero,80($fp)
$L47:
	lw	v0,80($fp)
	lw	v1,68($fp)
	slt	v0,v0,v1
	bne	v0,zero,$L50
	b	$L48
$L50:
	lw	v0,76($fp)
	lw	v1,96($fp)
	addu	a0,v1,v0
	addu	v1,$fp,56
	lw	v0,80($fp)
	addu	v0,v1,v0
	lbu	v0,0(v0)
	sb	v0,0(a0)
	lw	v0,76($fp)
	addu	v0,v0,1
	sw	v0,76($fp)
	lw	v0,80($fp)
	addu	v0,v0,1
	sw	v0,80($fp)
	b	$L47
$L48:
	lw	v0,76($fp)
	lw	a0,96($fp)
	addu	v1,a0,v0
	li	v0,10			# 0xa
	sb	v0,0(v1)
	lw	a0,96($fp)
	lw	a1,72($fp)
	la	t9,writeBufferInOFile
	jal	ra,t9
	sw	v0,84($fp)
	lw	v0,84($fp)
	beq	v0,zero,$L51
	la	t9,closeFile
	jal	ra,t9
	lw	sp,92($fp)
	li	v0,3			# 0x3
	sw	v0,88($fp)
	b	$L38
$L51:
	lw	sp,92($fp)
	sw	zero,88($fp)
$L38:
	lw	v0,88($fp)
	move	sp,$fp
	lw	ra,112(sp)
	lw	$fp,108(sp)
	addu	sp,sp,120
	j	ra
	.end	writeHeader
	.size	writeHeader, .-writeHeader

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
