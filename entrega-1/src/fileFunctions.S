#include <mips/regdef.h>
#include <sys/syscall.h>

#include "constants.h"

# Size mensajes
#define BYTES_MENSAJE_ERROR_WRITE   52
#define BYTES_MENSAJE_ERROR_CLOSE_FILE   68
#define BYTES_MENSAJE_ERROR_LOAD_FILE  	 51

#define FILE_DESCRIPTOR_STDERR	    2


############### begin funcion writeBufferInOFile ###############

	.text
	.align	2
	.globl	writeBufferInOFile
	.ent	writeBufferInOFile
writeBufferInOFile:
	.frame	$fp,64,ra
	.set	noreorder	# set metadata
	.cpload	t9           
	.set	reorder		# delay slot

	subu	sp,sp,64	# creo stack frame de 64 bytes

	.cprestore 16        
	sw	ra,56(sp)       # guardo ra en posicion 56
	sw	$fp,52(sp)      # guardo $fp en posicion 52
	sw	gp,48(sp)       # guardo gp en posicion 48

	# de aqui al fin de la funcion uso $fp en lugar de sp.
	move	$fp,sp      

	# Parametro
	# int writeBufferInOFile(char * bufferToLoad, int quantityCharactersInBufferToLoad)
	sw	a0,64($fp)      # stack(64) = puntero a bufferToLoad
	sw	a1,68($fp)      # stack(68) = quantityCharactersInBufferToLoad

	# (fileOutput == NULL || quantityCharactersInBufferToLoad <= 0) ?

	# (fileOutput == NULL) ?
	lw	v0,fileOutput   # cargo en v0 fileOutput
	beq	v0,zero,return_no_data_to_save # if fileOutput = NULL salto <return_no_data_to_save>

	# (quantityCharactersInBufferToLoad <= 0) ?
	lw	v0,68($fp)	# guardo el fileOutput en stack(68)
	blez v0,return_no_data_to_save # si quantityCharactersInBufferToLoad <= 0 salto <return_no_data_to_save>

	b	while_init      # salto a <while_init>
return_no_data_to_save:
	sw	zero,40($fp)	# OKEY = 0
	b	return_write_buffer_in_OFile
while_init:
	
	# int completeDelivery = FALSE;
	li	v0,FALSE	# pone un 0 en v0
	sw	v0,24($fp)      # stack(24) = FALSE = 0 = completeDelivery

	# int bytesWriteAcum = 0;
	sw	zero,28($fp)    # stack(28) = bytesWriteAcum = 0

	# int bytesToWrite = quantityCharactersInBufferToLoad;
	lw	v0,68($fp)      # carga en v0 el quantityCharactersInBufferToLoad
	sw	v0,32($fp)      # stack(32) = bytesToWrite
check_delivery:	
	# (completeDelivery == FALSE) ?
	lw	v1,24($fp)      # v1 = stack(24) = completeDelivery
	li	v0,FALSE	# v0 = FALSE
	beq	v1,v0,while	# if v1 == v0 salta a <while>
	b	return_okey       # sino salta a <return_okey>
while:
	# int bytesWrite = write(ofd, bufferToLoad + bytesWriteAcum, bytesToWrite);

	# bufferToLoad + bytesWriteAcum
	lw	v1,64($fp)      # v1 = puntero al buffer
	lw	v0,28($fp)      # v0 = bytesWriteAcum
	addu	v0,v1,v0        # v0 = v0 + v1 - bufferToLoad + bytesWriteAcum


	lw	a0,ofd          # a0 = output file descriptor
	move	a1,v0       	# a1 = v0 = bufferToLoad + bytesWriteAcum
	lw	a2,32($fp)      # a2 = bytesToWrite
	li      v0, SYS_write
        syscall  # Seria int bytesWrite = write(ofd, bufferToLoad + bytesWriteAcum, bytesToWrite);

        beq     a3,zero,save_bytes_write # Si no hubo error, salto a saveBytesWrite.

        # Hubo error al querer escribir en el archivo => Mensaje de error. 
        li      a0,FILE_DESCRIPTOR_STDERR # Cargo en a0 FILE_DESCRIPTOR_STDERR.
        la      a1,MENSAJE_ERROR_WRITE
        li      a2,BYTES_MENSAJE_ERROR_WRITE # Cargo en a2 la cantidad de bytes a escribir.
        li      v0, SYS_write
        syscall # No controlo error porque sale de por si de la funcion por error.

        # return ERROR_WRITE;
        li      v0,ERROR_WRITE  # Cargo codigo de error, que sera el resultado de la funcion.
        sw      v0,40($fp)      # Guardo en la direccion 40($fp) el resultado de la funcion.
        b       return_write_buffer_in_OFile
save_bytes_write:
	sw	v0,36($fp)	# stack(36) = bytesWrite (# chars escritos)

	lw	v0,36($fp)	# v0 = bytesWrite
	lw	v1,28($fp)      # v1 = stack(28) = bytesWriteAcum

	# bytesWriteAcum += bytesWrite;
	addu	v0,v1,v0    	# v0 = v1 + v0
	sw	v0,28($fp)      # guarda el bytesWriteAcum nuevo.

	# bytesToWrite = quantityCharactersInBufferToLoad - bytesWriteAcum;
	lw	v1,68($fp)      # v1 = quantityCharactersInBufferToLoad
	lw	v0,28($fp)      # v0 = bytesWriteAcum
	subu	v0,v1,v0    	# v0 = v1 - v0
	sw	v0,32($fp)      # stack(32) = bytesToWrite

	# (bytesToWrite <= 0) ?
	lw	v0,32($fp)      # v0 = bytesToWrite
	bgtz    v0,check_delivery # branch si bytesToWrite > 0

	# bytesToWrite is <= 0
	li 	v0,TRUE
	sw	v0,24($fp)    # stack(24) = completeDelivery = TRUE
	b	check_delivery  # branch <check_delivery>
return_okey:
	sw	zero,40($fp)    # 0 = OKEY
return_write_buffer_in_OFile:
	lw	v0,40($fp)      # v0 = return of the function
	move	sp,$fp          # iguala sp con $fp
	lw	ra,56(sp)       
	lw	$fp,52(sp)      

	# destruyo stack frame
	addu	sp,sp,64

	# vuelvo a funcion llamante
	j	ra              

	.end	writeBufferInOFile


############### end funcion writeBufferInOFile ###############

###############      begin funcion flush       ###############

	.align	2
	.globl	flush
	.ent	flush
flush:
	.frame	$fp,48,ra
	.set	noreorder
	.cpload	t9
	.set	reorder

	subu	sp,sp,48      # armo stack frame de 48 bytes

	.cprestore 16
	sw	ra,40(sp)      # stack[40] = ra
	sw	$fp,36(sp)     # stack[36] = fp
	sw	gp,32(sp)	# stack[32] = gp

	move	$fp,sp		# igualo fp y sp

	# (quantityCharactersInBuffer > 0) ?
	lw	v0,quantityCharactersInBuffer # v0 = quantityCharactersInBuffer = 0
	blez	v0,returnOK     # if( v0 <= 0 ) <returnOK>

	# return writeBufferInOFile(buffer, quantityCharactersInBuffer);
	lw	a0,buffer       # a0 = la dir del primer elemento de buffer
	lw	a1,quantityCharactersInBuffer # a1 = quantityCharactersInBuffer
	la	t9,writeBufferInOFile # t9 = puntero fn writeBufferInOFile
	jal	ra,t9           # llamada writeBufferInOFile
	sw	v0,24($fp)      # stack[24] = v0 = resultado writeBufferInOFile
	b	returnFlush
returnOK:
	# return OKEY;
	sw	zero,24($fp)    # stack[24] = 0
returnFlush:
	lw	v0,24($fp)      # v0 = stack[24] = resultado writeBufferInOFile
	move	sp,$fp		# iguala sp y fp
	lw	ra,40(sp)       # ra = stack[40]
	lw	$fp,36(sp)      # fp = stack[36]

	addu	sp,sp,48	# destruye el stack frame

	j	ra              # retorna ra

	.end	flush

###############      end funcion flush         ###############

###############      begin funcion closeFile   ###############

	.text
	.align	2
	.globl	closeFile
	.ent	closeFile
closeFile:
	.frame	$fp,48,ra
	.set	noreorder
	.cpload	t9
	.set	reorder

	subu	sp,sp,48	# posiciono el stack pointer(sp)

	.cprestore 16
	sw	ra,40(sp)       # stack[40] = ra
	sw	$fp,36(sp)      # stack[36] = fp
	sw	gp,32(sp)       # stack[32] = gp

	move	$fp,sp         	# igualo fp y sp

	# (ofd == 1) ?
	lw	v1,ofd		# v1 = ofd
	li	v0,1		# v0 = 1
	bne	v1,v0,IfFileOutputNull # if(v1 != v0) <IfFileOutputNull>
	sw	zero,fileOutput # puntero fileOutput = 0
	b	return          # saltar <return>
IfFileOutputNull:
	# (fileOutput != NULL) ?
	lw	v0,fileOutput   # v0 = puntero fileOutput
	beq	v0,zero,return  # if( v0 == NULL ) <return>

	# fileOutput is not NULL
	lw	a0,ofd   	# a0 = file descriptor
	li      v0, SYS_close
        syscall
	
	beq     a3,zero,setOutputNull # Si no hubo error, salto a setOutputNull.

        # Hubo error al querer escribir en el archivo => Mensaje de error. 
        li      a0,FILE_DESCRIPTOR_STDERR # Cargo en a0 FILE_DESCRIPTOR_STDERR.
        la      a1,MENSAJE_ERROR_CLOSE_FILE
        li      a2,BYTES_MENSAJE_ERROR_CLOSE_FILE # Cargo en a2 la cantidad de bytes a escribir.
        li      v0, SYS_write
        syscall # No controlo error porque sale de por si de la funcion por error.

setOutputNull:
	sw	zero,fileOutput	# puntero fileOutput = 0
return:
	move	sp,$fp         # igualo sp y fp
	lw	ra,40(sp)      # ra = stack[40]
	lw	$fp,36(sp)     # fp = stack[36]

	addu	sp,sp,48       # destruye stack pointer

	j	ra                 # saltar ra

	.end	closeFile       # fin closeFile

###############      end funcion closeFile     ###############

###############        begin funcion putch     ###############

	.text
	.align	2
	.globl	putch
	.ent	putch
putch:
	.frame	$fp,56,ra
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

###############        end funcion putch       ###############

###############  begin funcion loadFileDescriptor   ###############

	.text
	.align	2
	.globl	loadFileDescriptor
	.ent	loadFileDescriptor
loadFileDescriptor:
	.frame	$fp,48,ra
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


 	# Hubo error al querer escribir en el archivo => Mensaje de error. 
        li      a0,FILE_DESCRIPTOR_STDERR # Cargo en a0 FILE_DESCRIPTOR_STDERR.
        la      a1,MENSAJE_ERROR_LOAD_FILE
        li      a2,BYTES_MENSAJE_ERROR_LOAD_FILE # Cargo en a2 la cantidad de bytes a escribir.
        li      v0, SYS_write
        syscall # No controlo error porque sale de por si de la funcion por error.

        # return ERROR_FILE;
        li      v0,ERROR_FILE  # Cargo codigo de error, que sera el resultado de la funcion.
        sw      v0,24($fp)      # Guardo en la direccion 40($fp) el resultado de la funcion.
        b       returnLoadFile # salta <returnLoadFile>
fileno:
	lw	v0,fileOutput         # v0 = fileOutput
	lh	v0,14(v0)             # v0 = v0 + 14; me muevo hasta el file descriptor
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

###############  end funcion loadFileDescriptor     ###############



# ---------------------------------------------------------------------------- #



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



