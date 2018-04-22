#include <mips/regdef.h>
#include <sys/syscall.h>

############### begin funcion writeBufferInOFile ###############

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

############### end funcion writeBufferInOFile ###############

###############      begin funcion flush       ###############

flush:
	.frame	$fp,48,ra		# vars= 8, regs= 3/0, args= 16, extra= 8
	#.mask	0xd0000000,-8
	#.fmask	0x00000000,0
	.set	noreorder
	.cpload	t9
	.set	reorder
	subu	sp,sp,48      # armo stack frame de 48 bytes
	.cprestore 16
	sw	ra,40($sp)        # stack[40] = ra
	sw	$fp,36($sp)       # stack[36] = fp
	sw	gp,32($sp)        # stack[32] = gp
	move	$fp,$sp       # igualo fp y sp
	lw	v0,quantityCharactersInBuffer # v0 = quantityCharactersInBuffer = 0
	blez	v0,returnOK       # if( v0 <= 0 ) <returnOK>
	lw	a0,buffer         # a0 = buffer = ???
	lw	a1,quantityCharactersInBuffer # a1 = quantityCharactersInBuffer
	la	t9,writeBufferInOFile # t9 = puntero fn writeBufferInOFile
	jal	ra,t9             # llamada writeBufferInOFile
	sw	v0,24($fp)        # stack[24] = v0 = resultado writeBufferInOFile
	b	returnFlush
returnOK:
	sw	$zero,24($fp)     # stack[24] = 0
returnFlush:
	lw	$v0,24($fp)       # v0 = stack[24] = resultado writeBufferInOFile
	move	$sp,$fp       # iguala sp y fp
	lw	$ra,40($sp)       # ra = stack[40]
	lw	$fp,36($sp)       # fp = stack[36]
	addu	$sp,$sp,48    # destruye el stack frame
	j	$ra               # retorna ra
	.end	flush
	.size	flush, .-flush
	.align	2
	.globl	loadPixelBrightness
	.ent	loadPixelBrightness

###############      end funcion flush         ###############

###############      begin funcion closeFile   ###############
	#.file	1 "TestCase_closeFile.c"
	#.section .mdebug.abi32
	#.previous
	#.abicalls
	#.globl	ofd
	#.data
	#.align	2
	#.type	ofd, @object
	#.size	ofd, 4
#ofd:
#	.word	1
#	.rdata
#	.align	2
error_output_cf:
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
	la	a1,error_output_cf    # a1 = puntero error_output_cf
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
###############      end funcion closeFile     ###############

###############        begin funcion putch     ###############
	#.file	1 "TestCase_putch.c"
	#.section .mdebug.abi32
	#.previous
	#.abicalls
	#.globl	quantityCharactersInBuffer
	#.globl	quantityCharactersInBuffer
	#.section	.bss
	#.align	2
	#.type	quantityCharactersInBuffer, @object
	#.size	quantityCharactersInBuffer, 4
#quantityCharactersInBuffer:
	#.space	4
	#.globl	buffer
	#.globl	buffer
	#.align	2
	#.type	buffer, @object
	#.size	buffer, 4
#buffer:
	#.space	4
	#.text
	#.align	2
	#.globl	loadDataInBuffer
	#.ent	loadDataInBuffer

	.align	2
	.globl	putch
	.ent	putch
putch:
	.frame	$fp,56,ra	    # Arma stack frame de 56 bytes
	#.mask	0xd0000000,-8
	#.fmask	0x00000000,0
	.set	noreorder
	.cpload	t9
	.set	reorder
	subu	sp,sp,56            # posiciono el stack pointer(sp)
	.cprestore 16
	sw	ra,48(sp)           # stack[48] = ra
	sw	$fp,44(sp)          # stack[44] = fp
	sw	gp,40(sp)           # stack[40] = sp
	move	$fp,sp              # igualo fp y sp
	move	v0,a0               # v0 = a0
	sb	v0,24($fp)          # stack[24] = v0 = character
	lw	v0,quantityCharactersInBuffer # v0 = quantityCharactersInBuffer
	slt	v0,v0,100           # if( v0 < 100 ) v0 = 1 else v0 = 0. MAX_BUFFER es 100
	beq	v0,zero,writeBuffer        # if ( v0 > 100 ) <writeBuffer>
	lb	v0,24($fp)          # v0 = character
	move	a0,v0               # a0 = v0
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
	move	a0,v0               # a0 = vo
	la	t9,loadDataInBuffer # t9 = puntero fn loadDataInBuffer
	jal	ra,t9               # llamar fn loadDataInBuffer
	sw	v0,32($fp)          # stack[32] = response loadDataInBuffer
returnPutch:
	lw	v0,32($fp)         # v0 = stack[32] = return loadDataInBuffer
	move	sp,$fp             # iguala sp y fp
	lw	ra,48(sp)          # ra = stack[48]
	lw	$fp,44(sp)         # fp = stack[44]
	addu	sp,sp,56           # destruye stack frame
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
###############        end funcion putch       ###############

###############  begin funcion loadFileDescriptor   ###############
error_loadFile:
	.ascii	"[Error] No se ha especificado archivo de salida.\n\000"
	.text
	.align	2
	.globl	loadFileDescriptor
	.ent	loadFileDescriptor
loadFileDescriptor:
	.frame	$fp,48,ra	      # armo el stack frame de 48 bytes
	#.mask	0xd0000000,-8
	#.fmask	0x00000000,0
	.set	noreorder
	.cpload	t9
	.set	reorder
	subu	sp,sp,48              # posiciono el stack pointer
	.cprestore 16
	sw	ra,40(sp)             # stack[40] = ra
	sw	$fp,36(sp)            # stack[36] = fp
	sw	gp,32(sp)             # stack[32] = sp
	move	$fp,sp                # igualo fp y sp
	lw	v0,fileOutput         # v0 = puntero fileOutput
	bne	v0,zero,fileno        # if(v0 != 0) <fileno>
	la	a0,__sF+176           # ???
	la	a1,error_loadFile     # a1 = puntero error_loadFile
	la	t9,fprintf            # t9 = puntero fprintf
	jal	ra,t9                 # llama a fprintf
	li	v0,1		      # v0 = 1
	sw	v0,24($fp)            # stack[24] = v0 = 1
	b	returnLoadFile                  # salta <returnLoadFile>
fileno:
	lw	v0,fileOutput         # v0 = fileOutput
	lh	v0,14(v0)             # v0 = v0 + 14; le suma 14 a la 1/2 de los bytes(???)
	sw	v0,ofd                # guarda en dir ofd v0
	sw	zero,24($fp)          # stack[24] = 0
returnLoadFile:
	lw	v0,24($fp)            # v0 = stack[24]
	move	sp,$fp                # iguala sp y fp
	lw	ra,40(sp)             # ra = stack[40]
	lw	$fp,36(sp)            # fp = stack[36]
	addu	sp,sp,48              # destruye el stack frame
	j	ra                    # jump ra
	.end	loadFileDescriptor
	.size	loadFileDescriptor, .-loadFileDescriptor
	.rdata
	.align	2
###############  end funcion loadFileDescriptor     ###############
