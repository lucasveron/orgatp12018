#include <mips/regdef.h>
#include <sys/syscall.h>

#include "constants.h"

# Size mensajes
#define BYTES_MENSAJE_ERROR_WRITE	52
#define BYTES_MENSAJE_ERROR_CLOSE_FILE	68
#define BYTES_MENSAJE_ERROR_LOAD_FILE	51

#define FILE_DESCRIPTOR_STDERR   	2


# Offsets and Stack Frames

#define STACK_FRAME_INIT_FILE 	8
#define OFFSET_FP_INIT_FILE 	4
#define OFFSET_GP_INIT_FILE 	0
#define OFFSET_FILE_INIT_FILE 	8

#define STACK_FRAME_LOAD_FILE_DESCRIPTOR 36
#define OFFSET_RA_LOAD_FILE_DESC 32
#define OFFSET_FP_LOAD_FILE_DESC 28
#define OFFSET_GP_LOAD_FILE_DESC 24
#define OFFSET_RETURN_LOAD_FILE_DESC 16

#define STACK_FRAME_CLOSE_FILE 32
#define OFFSET_RA_CLOSE_FILE 24
#define OFFSET_FP_CLOSE_FILE 20
#define OFFSET_GP_CLOSE_FILE 16

#define STACK_FRAME_WRITE_BUFFER_IN_OFILE 56
#define OFFSET_RA_W_BUF_IN_OF 48
#define OFFSET_FP_W_BUF_IN_OF 44
#define OFFSET_GP_W_BUF_IN_OF 40
#define OFFSET_QUANTITY_CH_IN_BUFFER_TO_LOAD_W_BUF_IN_OF 60
#define OFFSET_BUFFER_TO_LOAD_W_BUF_IN_OF 56
#define OFFSET_RETURN_W_BUF_IN_OF 32
#define OFFSET_BYTES_WRITE_W_BUF_IN_OF 28
#define OFFSET_BYTES_TO_WRITE_W_BUF_IN_OF 24
#define OFFSET_BYTES_WRITE_ACUM_W_BUF_IN_OF 20
#define OFFSET_COMPLETE_DELIVERY_W_BUF_IN_OF 16

#define STACK_FRAME_LOAD_FILE_DESC 40
#define LOAD_FILE_DESC 16
#define OFFSET_RA_LOAD_FILE 32
#define OFFSET_FP_LOAD_FILE 28
#define OFFSET_GP_LOAD_FILE 24
#define STACK_FRAME_CLOSE_FILE 32
#define OFFSET_RA_CLOSE_FILE 24
#define OFFSET_FP_CLOSE_FILE 20
#define OFFSET_GP_CLOSE_FILE 16
#define STACK_FRAME_LOAD_DATA_BUFFER 32
#define OFFSET_RA_LOAD_DATA_BUFFER 24
#define OFFSET_FP_LOAD_DATA_BUFFER 20
#define OFFSET_GP_LOAD_DATA_BUFFER 16
#define OFFSET_STORE_BYTE 8

#define STACK_FRAME_PUTCH 40
#define OFFSET_RA_PUTCH 32
#define OFFSET_FP_PUTCH 28
#define OFFSET_GP_PUTCH 24
#define OFFSET_CHARACTER_PUTCH 40
#define OFFSET_RETURN_PUTCH 20
#define OFFSET_RDO_PUTCH 16

#define STACK_FRAME_FLUSH 40
#define OFFSET_RA_FLUSH 32
#define OFFSET_FP_FLUSH 28
#define OFFSET_GP_FLUSH 24
#define OFFSET_RES_FLUSH 16

#define STACK_FRAME_WRITE_HEADER 112
#define OFFSET_RA_W_H 104
#define OFFSET_FP_W_H 100
#define OFFSET_GP_W_H 96
#define OFFSET_SIZE_Y_W_H 112
#define OFFSET_SIZE_X_W_H 116
#define OFFSET_SHADES_W_H 120
#define OFFSET_SP_W_H 84
#define OFFSET_CH_Y_DATA_W_H 16
#define OFFSET_CH_X_DATA_W_H 32
#define OFFSET_CH_SHADES_DATA_W_H 48
#define OFFSET_CH_X_LENGHT_W_H 44
#define OFFSET_CH_Y_LENGHT_W_H 28
#define OFFSET_CH_SHADES_LENGHT_W_H 60
#define OFFSET_QUANTITY_CH_IN_BUF_TO_LOAD_W_H 64
#define OFFSET_BUFF_TO_LOAD_W_H 88
#define OFFSET_IDX_W_H 68
#define OFFSET_I_W_H 72
#define OFFSET_RDO_WRITE_W_H 76
#define OFFSET_RETURN_W_H 80


##-----	initFile -----##

	.text
	.align	2
	.globl	initFile
	.ent	initFile
initFile:
	.frame	$fp,STACK_FRAME_INIT_FILE,ra		
        .set	noreorder
	.cpload	t9
	.set	reorder

	# Stack frame creation
        subu	sp,sp,STACK_FRAME_INIT_FILE

	.cprestore OFFSET_GP_INIT_FILE
	sw	$fp,OFFSET_FP_INIT_FILE(sp)
	sw	gp,OFFSET_GP_INIT_FILE(sp)
	
        # A partir de aca uso $fp en lugar de sp
        move	$fp,sp

        # Parametro
	# void initFile(FILE * file)
	sw	a0,OFFSET_FILE_INIT_FILE($fp)      # Guardo a0 (FILE * file) en la direccion OFFSET_FILE_INIT_FILE($fp)

        # fileOutput = file;
	lw	v0,OFFSET_FILE_INIT_FILE($fp)      # Cargo en v0 lo guardado en la direccion OFFSET_FILE_INIT_FILE($fp),
                                                   # que es file.
	sw	v0,fileOutput                      # Guardo lo que tiene v0 en la variable fileOutput (fileOutput = file)


	move	sp,$fp
	lw	$fp,OFFSET_FP_INIT_FILE(sp)
        
        # Destruyo el stackframe	
	addu	sp,sp,STACK_FRAME_INIT_FILE

        # Vuelvo a la funcion que me invoco
	j	ra

	.end	initFile
	
#---------------  loadFileDescriptor  ---------------#

        .text
	.align	2	
	.globl	loadFileDescriptor
	.ent	loadFileDescriptor
loadFileDescriptor:
	.frame	$fp,STACK_FRAME_LOAD_FILE_DESCRIPTOR,ra     # Reservo espacio para el stack frame de 
                                                            # STACK_FRAME_LOAD_FILE_DESCRIPTOR bytes
	.set	noreorder
	.cpload	t9
	.set	reorder
        
        # Creacion del stack frame
	subu	sp,sp,STACK_FRAME_LOAD_FILE_DESCRIPTOR

	.cprestore OFFSET_GP_LOAD_FILE_DESC
	sw	ra,OFFSET_RA_LOAD_FILE_DESC(sp)
	sw	$fp,OFFSET_FP_LOAD_FILE_DESC(sp)
	sw	gp,OFFSET_GP_LOAD_FILE_DESC(sp)

        # De aqui al fin de la funcion uso $fp en lugar de sp.
	move	$fp,sp

        # (fileOutput == NULL)?        
	lw	v0,fileOutput                 # Cargo en v0 la direccion del fileOutput.
	bne	v0,zero,$fileno               # IF (fileOutput != NULL) salto a $fileno.

        # fileOutput IS NULL

        # Escribo mensaje de error en la salida estandar para errores y hago return de la funcion.
        li a0,FILE_DESCRIPTOR_STDERR          # Cargo en a0 el FILE_DESCRIPTOR_STDERR = 2.
        la a1,MENSAJE_ERROR_LOAD_FILE         # Cargo en a1 el mensaje de error.
        li a2,BYTES_MENSAJE_ERROR_LOAD_FILE   # Cargo en a2 la cantidad de byes a escribir.
        syscall     # No controlo error porque sale de por si de la funcion por error.

	# return ERROR_FILE
        li      v0,ERROR_FILE                            # Cargo codigo de error, que sera el resultado de la funcion.
	sw	v0,OFFSET_RETURN_LOAD_FILE_DESC($fp)     # Guardo en la direccion OFFSET_RETURN_LOAD_FILE_DESC($fp) el 
                                                         # resultado de la funcion.
	b	$returnLoadFile
$fileno:
        # ofd = fileno(fileOutput);
	lw	v0,fileOutput  # Carga en v0 el valor de fileOutput.
	lh	v0,14(v0)      # Carga en v0 el file descriptor, que esta en la posicion 14 dentro de la estructura de fileOutput.
	sw	v0,ofd         # Guarda el valor del registro v0 en la direccion de ofd.

        # return OKEY;
	sw	zero,OFFSET_RETURN_LOAD_FILE_DESC($fp)   # Guarda un 0 (=OKEY) en stack[OFFSET_RETURN_LOAD_FILE_DESC].
$returnLoadFile:
	lw	v0,OFFSET_RETURN_LOAD_FILE_DESC($fp)     # Cargo en v0 el resultado de la funcion (return).

        # Reconstruyo registros
	move	sp,$fp
	lw	ra,OFFSET_RA_LOAD_FILE_DESC(sp)
	lw	$fp,OFFSET_FP_LOAD_FILE_DESC(sp)

        # Destruye el stack frame.
	addu	sp,sp,STACK_FRAME_LOAD_FILE_DESCRIPTOR

	j	ra             # Regresa a la funcion llamante.

	.end	loadFileDescriptor

#--------------- end loadFileDescriptor ---------------#

#--------------- begin closeFile ----------------------#

	.text
	.align	2
	.globl	closeFile
	.ent	closeFile
closeFile:
	.frame	$fp,STACK_FRAME_CLOSE_FILE,ra
	.set	noreorder
	.cpload	t9
	.set	reorder

        # creacion del stack frame
	subu	sp,sp,STACK_FRAME_CLOSE_FILE

	.cprestore OFFSET_GP_CLOSE_FILE  
	sw	ra,OFFSET_RA_CLOSE_FILE(sp)
	sw	$fp,OFFSET_FP_CLOSE_FILE(sp)
	sw	gp,OFFSET_GP_CLOSE_FILE(sp)

        # de aqui al fin de la funcion uso $fp en lugar de sp.
	move	$fp,sp

        # (ofd == 1) ?        
	lw	v1,ofd                    # Carga en v1 el ofd        
	li	v0,1                      # Carga en v0 1
	bne	v1,v0,$IfFileOutputNull   # IF (ofd != 1) goto $IfFileOutputNull

        # ofd is equals to 1
	sw	zero,fileOutput           # fileOutput = NULL;

	b	$returnCloseFile          # Salto incondicional a $returnCloseFile
$IfFileOutputNull:
        # ofd is not equals to 1

        # (fileOutput != NULL) ?
	lw	v0,fileOutput             # Cargo en v0 fileOutput
	beq	v0,zero,$returnCloseFile  # IF (fileOutput == NULL) goto $returnCloseFile

        # Sino (fileOutput != NULL ) continuo
  
        lw	a0,ofd   	          # Pongo en a0 el 'file descriptor'
        li      v0, SYS_close
        syscall
        
        beq     a3,zero,$setOutputNull    # Si no hubo error, salto a $setOutputNull.
    
        # hubo error al querer escribir en el archivo => Mensaje de error. 
        li      a0,FILE_DESCRIPTOR_STDERR         # Cargo en a0 FILE_DESCRIPTOR_STDERR.
        la      a1,MENSAJE_ERROR_CLOSE_FILE
        li      a2,BYTES_MENSAJE_ERROR_CLOSE_FILE # Cargo en a2 la cantidad de bytes a escribir.
        li      v0, SYS_write
        syscall # No controlo error porque sale de por si de la funcion por error.

$setOutputNull:
	sw	zero,fileOutput            # Pongo un 0 (NULL) en la dirección del fileOutput
$returnCloseFile:
	move	sp,$fp                         # Iguala sp con fp.
	lw	ra,OFFSET_RA_CLOSE_FILE(sp)    # Carga en ra stack[OFFSET_RA_CLOSE_FILE] para retornar a la funcion llamante.
	lw	$fp,OFFSET_FP_CLOSE_FILE(sp)   # Carga en fp stack[OFFSET_FP_CLOSE_FILE].

	addu	sp,sp,STACK_FRAME_CLOSE_FILE   # Destruyo el stack frame.

	j	ra         # Regresa a la funcion llamante.

	.end	closeFile

#--------------- end closeFile ---------------#


#--------- begin writeBufferInOFile -----#

        .text
	.align	2
	.globl	writeBufferInOFile
	.ent	writeBufferInOFile
writeBufferInOFile:
	.frame	$fp,STACK_FRAME_WRITE_BUFFER_IN_OFILE,ra
	.set	noreorder
	.cpload	t9
	.set	reorder
	
	#Creacion del Stack Frame
	subu	sp,sp,STACK_FRAME_WRITE_BUFFER_IN_OFILE

	.cprestore OFFSET_GP_W_BUF_IN_OF
	sw	ra,OFFSET_RA_W_BUF_IN_OF(sp)
	sw	$fp,OFFSET_FP_W_BUF_IN_OF(sp)
	sw	gp,OFFSET_GP_W_BUF_IN_OF(sp)

	# A partir de aca uso el $fp en lugar del sp
        move	$fp,sp
	
	sw	a0,OFFSET_BUFFER_TO_LOAD_W_BUF_IN_OF($fp)                   # Guardo el registro a0 en la direcion [OFFSET_BUFFER_TO_LOAD_W_BUF_IN_OF
                                                                            # ($fp)] del Stack Frame
	sw	a1,OFFSET_QUANTITY_CH_IN_BUFFER_TO_LOAD_W_BUF_IN_OF($fp)    # Guardo el registro a1 en la direcion
                                                                            # [OFFSET_QUANTITY_CH_IN_BUFFER_TO_LOAD_W_BUF_IN_OF($fp)] del Stack Frame

        # (fileOutput == NULL || quantityCharactersInBufferToLoad <= 0) ?

        # (fileOutput == NULL) ?
	lw	v0,fileOutput                          # Cargo la direccion de la variable fileOutput en v0
	beq	v0,zero,$notWrite                      # IF (fileOutPut == NULL), goto $notWrite

        # fileOutput is not NULL

        # (quantityCharactersInBufferToLoad <= 0) ?
	lw	v0,OFFSET_QUANTITY_CH_IN_BUFFER_TO_LOAD_W_BUF_IN_OF($fp)     # Carga en v0 lo guardado en la direccion 
                                                                             # [OFFSET_QUANTITY_CH_IN_BUFFER_TO_LOAD_W_BUF_IN_OF($fp)] del Stack 
                                                                             # Frame, v0= quantityCharactersInBufferToLoad
	blez	v0,$notWrite                           # IF (quantityCharactersInBufferToLoad <= 0) goto $notWrite

        # quantityCharactersInBufferToLoad is > 0

	b	$inicializacionVariables               # Salto incondicional a $inicializacionVariables

$notWrite:
        # return OKEY;
	sw	zero,OFFSET_RETURN_W_BUF_IN_OF($fp)    # Guarda zero (= OKEY) en la direccion [OFFSET_RETURN_W_BUF_IN_OF($fp)] del Stack Frame
	b	$returnWriteBufferInOFile              # Branch a $returnWriteBufferInOFile
$inicializacionVariables:
        # int completeDelivery = FALSE;
	li	v0,FALSE                                        # Carga FALSE en v0.
	sw	v0,OFFSET_COMPLETE_DELIVERY_W_BUF_IN_OF($fp)    # Guardo v0=FALSE en la direccion [OFFSET_COMPLETE_DELIVERY_W_BUF_IN_OF] del 
                                                                # stack frame.

        # int bytesWriteAcum = 0;
	sw	zero,OFFSET_BYTES_WRITE_ACUM_W_BUF_IN_OF($fp)   # Guardo zero en la posicion [OFFSET_BYTES_WRITE_ACUM_W_BUF_IN_OF($fp)] del Stack
                                                                # frame.

        # int bytesToWrite = quantityCharactersInBufferToLoad;
	lw	v0,OFFSET_QUANTITY_CH_IN_BUFFER_TO_LOAD_W_BUF_IN_OF($fp)     # Carga en v0 la direccion 
                                                                             # [OFFSET_QUANTITY_CH_IN_BUFFER_TO_LOAD_W_BUF_IN_OF($fp)] del 
                                                                             # Stack Frame, v0 = quantityCharactersInBufferToLoad
	sw	v0,OFFSET_BYTES_TO_WRITE_W_BUF_IN_OF($fp)          # Guardo v0=bytesToWrite=quantityCharactersInBufferToLoad, en la posicion
                                                                   # [OFFSET_BYTES_TO_WRITE_W_BUF_IN_OF($fp)] del Stack frame.
$inicioCicloWhile:
        # while (completeDelivery == FALSE)
	lw	v1,OFFSET_COMPLETE_DELIVERY_W_BUF_IN_OF($fp)       # Cargo en v1 lo guardado en la direccion en la posicion
                                                                   # [OFFSET_COMPLETE_DELIVERY_W_BUF_IN_OF($fp)] del Stack frame.
	li	v0,FALSE                                   # Carga FALSE en v0
	beq	v1,v0,$mainWhile                       # Si (completeDelivery == FALSE), salto a $mainWhile, o sea, dentro del while.

        # completeDelivery is not FALSE
	b	$functionZero                          # Branch a $functionZero
$mainWhile:
        # int bytesWrite = write(ofd, bufferToLoad + bytesWriteAcum, bytesToWrite);
        lw	a0,ofd                                         # Cargo ofd en a0. a0 = ofd. Primer parametro de la funcion write.
	lw	v1,OFFSET_BUFFER_TO_LOAD_W_BUF_IN_OF($fp)      # Carga en el v1 lo guardado en la direccion [OFFSET_BUFFER_TO_LOAD_W_BUF_IN_OF($fp)]
                                                               # del stack frame, v1=bufferToLoad
	lw	v0,OFFSET_BYTES_WRITE_ACUM_W_BUF_IN_OF($fp)    # Carga en v0 lo guardado en la direccion [OFFSET_BYTES_WRITE_ACUM_W_BUF_IN_OF($fp)] 
                                                               # del stack frame.
	addu    v0,v1,v0                                       # v0 = buffertoLoad + bytesWriteAcum
	move    a1,v0                                          # Cargo en a1, lo obtenido en el paso anterior. Segundo parametro de la funcion write.
	lw	a2,OFFSET_BYTES_TO_WRITE_W_BUF_IN_OF($fp)      # Cargo en a2 lo guardado en la direccion [OFFSET_BYTES_TO_WRITE_W_BUF_IN_OF($fp)] 
                                                               # del Stack frame. Tercer parametro de la funcion write.
       	li      v0, SYS_write
   	syscall           # Seria int bytesWrite = write(ofd, bufferToLoad + bytesWriteAcum, bytesToWrite);
    	sw      v0,OFFSET_BYTES_WRITE_W_BUF_IN_OF($fp)
	beq     a3,zero,$continuacionCicloWhile        # El registro a3, devuelve 0/1 success/error
    
    	# Hubo error al querer escribir en el archivo => Mensaje de error. 
    	li      a0,FILE_DESCRIPTOR_STDERR              # Cargo en a0 FILE_DESCRIPTOR_STDERR.
    	la      a1,MENSAJE_ERROR_WRITE
    	li      a2,BYTES_MENSAJE_ERROR_WRITE           # Cargo en a2 la cantidad de bytes a escribir.
    	li      v0, SYS_write
    	syscall # No controlo error porque sale de por si de la funcion por error.

    	## return ERROR_WRITE;
    	li  v0,ERROR_WRITE                             # Cargo codigo de error, que sera el resultado de la funcion.
    	sw  v0,OFFSET_RETURN_W_BUF_IN_OF($fp)          # Guardo en la direccion OFFSET_RETURN_W_BUF_IN_OF($fp) el resultado de la funcion.

    	b  $returnWriteBufferInOFile
$continuacionCicloWhile:
        # bytesWriteAcum += bytesWrite;
        lw	v1,OFFSET_BYTES_WRITE_ACUM_W_BUF_IN_OF($fp)     # Cargo en v1 lo guardado en la direccion [OFFSET_BYTES_WRITE_ACUM_W_BUF_IN_OF($fp)]
                                                                # del stack frame, v1= zero
        lw	v0,OFFSET_BYTES_WRITE_W_BUF_IN_OF($fp)          # Cargo en v0 lo guardado en la direccion [OFFSET_BYTES_WRITE_W_BUF_IN_OF($fp)] del
                                                                # stack frame, v0=bytesWrite
        addu	v0,v1,v0                                        # bytesWriteAcum += bytesWrite , v0 = bytesWriteAcum
        sw	v0,OFFSET_BYTES_WRITE_ACUM_W_BUF_IN_OF($fp)     # Guardo v0=bytesWriteAcum en posicion [OFFSET_BYTES_WRITE_ACUM_W_BUF_IN_OF($fp)]
                                                                # del Stack Frame.

        # bytesToWrite = quantityCharactersInBufferToLoad - bytesWriteAcum;
        lw	v1,OFFSET_QUANTITY_CH_IN_BUFFER_TO_LOAD_W_BUF_IN_OF($fp)     # Cargo en v1 lo guardado en la posicion
                                                                             # [OFFSET_QUANTITY_CH_IN_BUFFER_TO_LOAD_W_BUF_IN_OF($fp)] 
                                                                             # del stack frame, v1=quantityCharactersInBufferToLoad
        lw	v0,OFFSET_BYTES_WRITE_ACUM_W_BUF_IN_OF($fp)                  # Cargo en v0 lo guardado en la posicion
                                                                             # [OFFSET_BYTES_WRITE_ACUM_W_BUF_IN_OF($fp)] del stack rame,
                                                                             # v0=bytesWriteAcum
        subu	v0,v1,v0                                                     # v0 = bytesToWrite = quantityCharactersInBufferToLoad - bytesWriteAcum;
        sw	v0,OFFSET_BYTES_TO_WRITE_W_BUF_IN_OF($fp)          # Guardo lo de v0 en la poiscion [OFFSET_BYTES_TO_WRITE_W_BUF_IN_OF($fp)] de
                                                                   # la memoria , v0=bytesToWrite

        # (bytesToWrite <= 0) ?
        lw	v0,OFFSET_BYTES_TO_WRITE_W_BUF_IN_OF($fp)          # Cargo en v0 la posicion [OFFSET_BYTES_TO_WRITE_W_BUF_IN_OF($fp)] de memoria,
                                                                   # v0 = bytesToWrite
        bgtz	v0,$inicioCicloWhile                      # IF(bytesToWrite > 0) goto $inicioCicloWhile

        # bytesToWrite is <= 0
        li      v0,TRUE
        sw	v0,OFFSET_COMPLETE_DELIVERY_W_BUF_IN_OF($fp)        # Guarda TRUE en posicion [OFFSET_COMPLETE_DELIVERY_W_BUF_IN_OF($fp)] de memoria.

        b	$inicioCicloWhile                      # Salto incondicional a $inicioCicloWhile.
$functionZero:
        sw	zero,OFFSET_RETURN_W_BUF_IN_OF($fp)    # Guardo cero (=OKEY) en la posicion [OFFSET_RETURN_W_BUF_IN_OF($FP)] del Stack frame
$returnWriteBufferInOFile:
	lw	v0,OFFSET_RETURN_W_BUF_IN_OF($fp)      # Guarda en v0 lo que hay en la direccion [OFFSET_RETURN_W_BUF_IN_OF($FP)].

	move	sp,$fp 
	lw	ra,OFFSET_RA_W_BUF_IN_OF(sp)
	lw	$fp,OFFSET_FP_W_BUF_IN_OF(sp)

	addu	sp,sp,STACK_FRAME_WRITE_BUFFER_IN_OFILE  # Destruye el stack frante

	j	ra                                       # Regresa a la funcion llamante

 	.end	writeBufferInOFile

	
#---------------  end writeBufferInOFile ---------------#

#--------------- begin loadDataInBuffer ---------------#

	.text
	.align	2
	.globl	loadDataInBuffer
	.ent	loadDataInBuffer
loadDataInBuffer:
	.frame	$fp,STACK_FRAME_LOAD_DATA_BUFFER,ra
	.set	noreorder
	.cpload	t9
	.set	reorder

        # creacion de stack frame
	subu	sp,sp,STACK_FRAME_LOAD_DATA_BUFFER

	.cprestore 0
	sw	$fp,OFFSET_FP_LOAD_DATA_BUFFER(sp)
	sw	gp,OFFSET_GP_LOAD_DATA_BUFFER(sp)

        # de aqui al fin de la funcion uso $fp en lugar de sp.
	move	$fp,sp

        # Parametro
	#void loadDataInBuffer(char character)
        move	v0,a0      # muevo el parametro character, que se encuentra en a0, a v0.
	sb	v0,OFFSET_STORE_BYTE($fp)  # guardo en la direccion 8($fp), el contenido de v0, que es character.
	
        # buffer[quantityCharactersInBuffer] = character;
        # cargo en v1 la cantidad de caracteres que me voy a mover sobre buffer.
        lw	v1,quantityCharactersInBuffer
        #cargo la direccion de inicio de buffer.
	la	v0,buffer
        # guardo en v1 la nueva direccion sobre la variable buffer.
	addu	v1,v1,v0
        # cargo en v0 el valor de character (un byte), que esta en la dir 8($fp).
	lbu	v0,8($fp)
        # guardo en buffer+quantityCharactersInBuffer character
	sb	v0,0(v1)

        # quantityCharactersInBuffer++;
	lw	v0,quantityCharactersInBuffer
	addu	v0,v0,1
	sw	v0,quantityCharactersInBuffer
        
	move	sp,$fp
	lw	$fp,OFFSET_FP_LOAD_DATA_BUFFER(sp)
        # destruyo stack frame
	addu	sp,sp,STACK_FRAME_LOAD_DATA_BUFFER
        # vuelvo el control a funcion llamante
	j	ra
	.end	loadDataInBuffer

#--------------- end loadDataInBuffer ---------------#

#---------------      begin putch     ---------------#

	.text
	.align	2
	.globl	putch
	.ent	putch
putch:
	.frame	$fp,STACK_FRAME_PUTCH,ra
	
	.set	noreorder
	.cpload	t9
	.set	reorder
	
	# creacion del stack frame
	subu	sp,sp,STACK_FRAME_PUTCH	

	.cprestore OFFSET_GP_PUTCH
	sw	ra,OFFSET_RA_PUTCH(sp)
	sw	$fp,OFFSET_FP_PUTCH(sp)
	sw	gp,OFFSET_GP_PUTCH(sp)

	#A partir de aqui uso fp para moverme en lugar de sp
	move	$fp,sp

	move	v0,a0                             # Cargo en v0 el valor del registro a0, v0=character
	sb	v0,OFFSET_CHARACTER_PUTCH($fp)    # Guardo v0= character en poiscion [OFFSET_CHARACTER_PUTCH] del StackFrame
	lw	v0,quantityCharactersInBuffer     # Cargo en v0= quantityCharactersInBuffer
	slt	v0,v0,MAX_BUFFER                  # if (quantityCharactersInBuffer < MAX_BUFFER), cargo , devuelve 0/1 en false/True
	beq	v0,FALSE,$ifQuantityGreatEqualMaxBuffer # If False, quantityCharactersInBuffer >= MAX_BUFFER, goto
                                                        # $ifQuantityGreatEqualMaxBuffer

        # quantityCharactersInBuffer is < MAX_BUFFER

        # loadDataInBuffer(character);
	lb	v0,OFFSET_CHARACTER_PUTCH($fp)    # Cargo en v0 lo guardado en la posicion [OFFSET_CHARACTER_PUTCH] del stack frame,
                                                  # v0=character
	move	a0,v0                             # Cargo en a0 la posicion del v0. Primer parametro de la funcion, que es character.
	la	t9,loadDataInBuffer               # Cargo la direccion a la funcion loadDataInBuffer en el registro t9
	jal	ra,t9                             # Ejecuto la funcion loadDataInBuffer.

        # return OKEY;
	sw	zero,OFFSET_RETURN_PUTCH($fp)     # Guardo zero (= OKEY) en la posicion [OFFSET_RETURN_PUTCH] del stack frame 

	b	$exitPutch                        # Salto a la etiqueta $exitPutch
$ifQuantityGreatEqualMaxBuffer:
        # quantityCharactersInBuffer is >= MAX_BUFFER

        # int rdo = writeBufferInOFile(buffer, quantityCharactersInBuffer);
	la	a0,buffer                         # Cargo address buffer en a0,  ao= buffer
	lw	a1,quantityCharactersInBuffer     # Cargo quantityCharactersInBuffer word  en a1=quantityCharactersInBuffer
	la	t9,writeBufferInOFile             # Cargo direccion de la funcion writeBufferInOFile en t9
	jal	ra,t9                             # Llamo a la funcion, y guardo la direccion de retorno a esta funcion
	sw	v0,OFFSET_RDO_PUTCH($fp)          # Guardo el return de la function en la posicion [OFFSET_RDO_PUTCH] del stack frame.

        # (rdo != OKEY) ?
	lw	v0,OFFSET_RDO_PUTCH($fp)          # Cargo la posicion [OFFSET_RDO_PUTCH] del stack frame en v0 = rdo
 	beq	v0,OKEY,$executionLoadData        # if (rdo == OKEY) , if false, salta a $executionLoadData

        # rdo is not equals to OKEY
        lw	v0,OFFSET_RDO_PUTCH($fp)          # Cargo la posicion [OFFSET_RDO_PUTCH] del stack frame en v0 =rdo
        sw	v0,OFFSET_RETURN_PUTCH($fp)       # Guardo v0=rdo en la posicion [OFFSET_RETURN_PUTCH] del stack frame

        b	$exitPutch                        # Salgo incondicionalmente a $exitPutch
$executionLoadData:
        # rdo is equals to OKEY

        # quantityCharactersInBuffer = 0;
        sw	zero,quantityCharactersInBuffer   # Cargo zero en la word quantityCharactersInBuffer

        # loadDataInBuffer(character);
        lb	v0,OFFSET_CHARACTER_PUTCH($fp)    # Cargo la posicion [OFFSET_CHARACTER_PUTCH] del stack frame en v0=character
        move	a0,v0                             # Cargo en a0 lo guardado en v0 (character).
        la	t9,loadDataInBuffer               # Cargo la direccion de loadDataInBuffer en t9
        jal	ra,t9                             # Ejecuto la funcion loadDataInBuffer

        # return OKEY;
        sw	zero,OFFSET_RETURN_PUTCH($fp)     # Cargo zero (= OKEY) en la posicion [OFFSET_RETURN_PUTCH] del stackFrame
$exitPutch:
        lw	v0,OFFSET_RETURN_PUTCH($fp)       # Cargo en v0 lo guardado en la posicion [OFFSET_RETURN_PUTCH] del stack frame,
                                                  # que es el resultado de la funcion.

        move	sp,$fp
        lw	ra,OFFSET_RA_PUTCH(sp)
        lw	$fp,OFFSET_FP_PUTCH(sp)

        #Destruccion stack frame
        addu	sp,sp,STACK_FRAME_PUTCH

        j	ra

        .end	putch
#---------------      end putch     ---------------#

#---------------     begin flush    ---------------#

	.text
        .align	2
        .globl	flush
        .ent	flush
flush:
    	.frame	$fp,STACK_FRAME_FLUSH,ra # reservo espacio para el stack frame de STACK_FRAME_FLUSH bytes
    	.set	noreorder
    	.cpload	t9
    	.set	reorder

    	# creacion del stack frame
    	subu	sp,sp,STACK_FRAME_FLUSH
	.cprestore 16
    	sw	ra,OFFSET_RA_FLUSH(sp)
    	sw	$fp,OFFSET_FP_FLUSH(sp)
    	sw	gp,OFFSET_GP_FLUSH(sp)
    	#A partir de aqui uso fp para moverme en lugar de sp

    	move	$fp,sp

    	lw	v0,quantityCharactersInBuffer      # Cargo en v0= quantityCharactersInBuffer
    	blez	v0,$returnZero                     # IF (quantityCharactersInBuffer > 0) , if v0<=0 llama a
    	la	a0,buffer                          # Cargo direccion  buffer en a0
    	lw	a1,quantityCharactersInBuffer      # Cargo word quantityCharactersInBuffer en a1
    	la	t9,writeBufferInOFile              # Cargo etiqueta writeBufferInOFile en t9
    	jal	ra,t9                              # writeBufferInOFile(buffer, quantityCharactersInBuffer)
    	sw	v0,OFFSET_RES_FLUSH($fp)           # Cargo v0 = resultado de la funcion en posicion [OFFSET_RES_FLUSH] del Stack frame
    	b	$exitFlush                         # Llamo a la funcion exitFlush
$returnZero:
    	sw	zero,OFFSET_RES_FLUSH($fp)         # Guarda zero en la posicion [OFFSET_RES_FLUSH] del stack frame, valor return por la funcion
$exitFlush:
    	lw	v0,OFFSET_RES_FLUSH($fp)           # Carga la posicion [OFFSET_RES_FLUSH] del stack Frame para return
    	#Destruccion del stack frame
        move	sp,$fp
	lw	ra,OFFSET_RA_FLUSH(sp)  # Recupero la info del ra.
	lw	$fp,OFFSET_FP_FLUSH(sp) # Recupero info fp antes de retornar.
	addu	sp,sp,STACK_FRAME_FLUSH
	j	ra
	.end	flush
#---------------    begin flush   ---------------#

#-------------- begin writeHeader  --------------#

        .text
	.align	2
	.globl	writeHeader
	.ent	writeHeader
writeHeader:
	.frame	$fp,STACK_FRAME_WRITE_HEADER,ra
	.set	noreorder
	.cpload	t9
	.set	reorder

        # Stack frame creation
	subu	sp,sp,STACK_FRAME_WRITE_HEADER

	.cprestore OFFSET_GP_W_H        
	sw	ra,OFFSET_RA_W_H(sp)
	sw	$fp,OFFSET_FP_W_H(sp)
	sw	gp,OFFSET_GP_W_H(sp)

        # de aqui al fin de la funcion uso $fp en lugar de sp.
	move	$fp,sp

        # Parametro
        # int writeHeader(unsigned int sizeY, unsigned int sizeX, unsigned int shades)
	sw	a0,OFFSET_SIZE_Y_W_H($fp)       # Guardo en la dir OFFSET_SIZE_Y_W_H($fp), el primer parametro
                                                # que viene en a0, y es sizeY.
	sw	a1,OFFSET_SIZE_X_W_H($fp)       # Guardo en la dir OFFSET_SIZE_X_W_H($fp), el segundo parametro
                                                # que viene en a1, y es sizeX.
	sw	a2,OFFSET_SHADES_W_H($fp)  	# Guardo en la dir OFFSET_SHADES_W_H($fp), el tercer 
                                                # parametro que viene en a2, y es shades.

        # character chY = convertIntToCharacter(sizeY);
	sw	sp,OFFSET_SP_W_H($fp)             # Guardo sp en la direccion OFFSET_SP_W_H($fp).
	addu	a0,$fp,OFFSET_CH_Y_DATA_W_H       # Cargo en a0 la direccion en donde espero se cargue el resultado de la
                                                  # ejecucion de la funcion convertIntToCharacter (chY), la cual es 
                                                  # $fp + OFFSET_CH_Y_DATA_W_H.
                                                  # Este es el primer parametro que recibe la funcion.
	lw	a1,OFFSET_SIZE_Y_W_H($fp)         # Cargo en a1 lo guardado en la direccion OFFSET_SIZE_Y_W_H($fp), que es 
                                                  # sizeY. Este es el segundo parametro que recibe la funcion convertIntToCharacter.
	la	t9,convertIntToCharacter          # Cargo en t9 la direccion de la funcion convertIntToCharacter.
	jal	ra,t9                             # Ejecuto la funcion convertIntToCharacter.


        # character chX = convertIntToCharacter(sizeX);
        addu	a0,$fp,OFFSET_CH_X_DATA_W_H       # Cargo en a0 la direccion en donde espero se cargue el resultado de la
                                                  # ejecucion de la funcion convertIntToCharacter (chX), la cual es 
                                                  # $fp + OFFSET_CH_X_DATA_W_H.
                                                  # Este es el primer parametro que recibe la funcion.
	lw	a1,OFFSET_SIZE_X_W_H($fp)         # Cargo en a1 lo guardado en la direccion OFFSET_SIZE_X_W_H($fp), que es
                                                  # sizeX. Este es el segundo parametro que recibe la funcion convertIntToCharacter.
	la	t9,convertIntToCharacter          # Cargo en t9 la direccion de la funcion convertIntToCharacter.
	jal	ra,t9                             # Ejecuto la funcion convertIntToCharacter.


        # character chShades = convertIntToCharacter(shades);
        addu	a0,$fp,OFFSET_CH_SHADES_DATA_W_H       # Cargo en a0 la direccion en donde espero se cargue el resultado de la
                                                       # ejecucion de la funcion convertIntToCharacter (chShades), la cual es 
                                                       # $fp + OFFSET_CH_SHADES_DATA_W_H.
                                                       # Este es el primer parametro que recibe la funcion.
	lw	a1,OFFSET_SHADES_W_H($fp)              # Cargo en a1 lo guardado en la direccion OFFSET_SHADES_W_H($fp), que 
                                                       # es shades. Este es el segundo parametro que recibe la funcion convertIntToCharacter.
	la	t9,convertIntToCharacter               # Cargo en t9 la direccion de la funcion convertIntToCharacter.
	jal	ra,t9                                  # Ejecuto la funcion convertIntToCharacter.


        # Quiero hacer: int quantityCharactersInBufferToLoad = 6 + chX.length + chY.length + chShades.length;

	lw	v1,OFFSET_CH_X_LENGHT_W_H($fp)      # Cargo en v1 lo guardado en la direccion OFFSET_CH_X_LENGHT_W_H($fp),
                                                    # que representa la variable chX.length.
	lw	v0,OFFSET_CH_Y_LENGHT_W_H($fp)      # Cargo en v0 lo guardado en la direccion OFFSET_CH_Y_LENGHT_W_H($fp),
                                                    # que representa la variable chY.length.
	addu	v1,v1,v0                            # Hago chX.length + chY.length, y guardo el resultado en v1.
	lw	v0,OFFSET_CH_SHADES_LENGHT_W_H($fp) # Cargo en v0 lo guardado en la direccion OFFSET_CH_SHADES_LENGHT_W_H($fp),
                                                    # que representa la variable chShades.length.
	addu	v0,v1,v0        # Hago (chX.length + chY.length) + chShades.length, y guardo el resultado en v0.
	addu	v0,v0,6         # Hago efectivamente la suma: 6 + chX.length + chY.length + chShades.length; y 
                                # cargo el resultado en v0.
	sw	v0,OFFSET_QUANTITY_CH_IN_BUF_TO_LOAD_W_H($fp)    # Guardo el resultado de la suma en la direccion 
                                                                 # OFFSET_QUANTITY_CH_IN_BUF_TO_LOAD_W_H($fp), que representa la
                                                                 # variable quantityCharactersInBufferToLoad.

        # char bufferToLoad [quantityCharactersInBufferToLoad];
	lw	v0,OFFSET_QUANTITY_CH_IN_BUF_TO_LOAD_W_H($fp)    # Cargo en v0 lo guardado en la direccion 
                                                                 # OFFSET_QUANTITY_CH_IN_BUF_TO_LOAD_W_H($fp), que representa la variable
                                                                 # quantityCharactersInBufferToLoad.
	addu	v0,v0,-1
	addu	v0,v0,1
	addu	v0,v0,7
	srl	v0,v0,3
	sll	v0,v0,3
	subu	sp,sp,v0
	addu	v0,sp,16
	sw	v0,OFFSET_BUFF_TO_LOAD_W_H($fp)      # Guardo en la dir OFFSET_BUFF_TO_LOAD_W_H($fp) bufferToLoad 
                                                     # (la direccion al primer elemento del array).

        # bufferToLoad[0] = 'P';
	li	v0,80                                # Cargo en v0 el caracter P (80 en ascii).
	lw	v1,OFFSET_BUFF_TO_LOAD_W_H($fp)      # Cargo en v1 bufferToLoad (la direccion al primer elemento del array).
	sb	v0,0(v1)                             # Guardo en la primer posicion del array, el caracter P (guardado en v0).

        # bufferToLoad[1] = '2';
	li	v0,50                                # Cargo en v0 el caracter 2 (50 en ascii).
	lw	a0,OFFSET_BUFF_TO_LOAD_W_H($fp)      # Cargo en a0 bufferToLoad (la direccion al primer elemento del array). 
	sb	v0,1(a0)                             # Guardo en la segunda posicion del array, el caracter 2 (guardado en v0).

        # bufferToLoad[2] = '\n';
	li	v0,10                                # Cargo en v0 el caracter \n (10 en ascii).
	lw	v1,OFFSET_BUFF_TO_LOAD_W_H($fp)      # Cargo en v1 bufferToLoad (la direccion al primer elemento del array).
	sb	v0,2(v1)                             # Guardo en la tercera posicion del array, el caracter \n (guardado en v0).

        # int idx = 3;
	li	v0,3                        # Cargo en v0 el inmediato 3.
	sw	v0,OFFSET_IDX_W_H($fp)      # Guardo en la direccion OFFSET_IDX_W_H($fp) la variable idx inicializada en 3.

        # int i; i = 0;
	sw	zero,OFFSET_I_W_H($fp)      # Guardo en la direccion OFFSET_I_W_H($fp) la variable i inicializada en 0.
$loopWriteHeaderChXInWriteHeader:
        # for (i = 0; i < chX.length; i++) 

        # (i < chX.length) ?
	lw	v0,OFFSET_I_W_H($fp)                # Cargo en v0 la variable i, que esta en la direccion OFFSET_I_W_H($fp).
	lw	v1,OFFSET_CH_X_LENGHT_W_H($fp)      # Cargo en v1 la variable chX.length, que esta en la direccion 
                                                    # OFFSET_CH_X_LENGHT_W_H($fp).
	slt	v0,v0,v1                            # Guardo en v0 TRUE si (i < chX.length), sino guardo FALSE.
	bne	v0,FALSE,$insideOfTheLoopWriteHeaderChX # Si (i < chX.length) es no es FALSE, o sea 
                                                        # es TRUE, goto $insideOfTheLoopWriteHeaderChX.

        # i is >= chX.length
	b	$loadSpaceInWriteHeader   # Salto incondicional a $loadSpaceInWriteHeader.
$insideOfTheLoopWriteHeaderChX:
        # bufferToLoad[idx] = chX.data[i];

        # bufferToLoad[idx]
	lw	v0,OFFSET_IDX_W_H($fp)               # Cargo en v0 lo guardado en la direccion OFFSET_IDX_W_H($fp), que 
                                                     # representa la variable idx.
	lw	v1,OFFSET_BUFF_TO_LOAD_W_H($fp)      # Cargo en v1 lo guardado en la direccion OFFSET_BUFF_TO_LOAD_W_H($fp),
                                                     # que representa la variable bufferToLoad.
	addu	a0,v1,v0        # Me muevo sobre el array. Hago bufferToLoad + idx. Cargo la nueva direccion
                                # sobre bufferToLoad en a0.

        # chX.data[i]
	addu	v1,$fp,OFFSET_CH_X_DATA_W_H        # Guardo en v1 la direccion resultante de hacer $fp+OFFSET_CH_X_DATA_W_H.
                                                   # Representa la direccion de la variable chX.data.
	lw	v0,OFFSET_I_W_H($fp)               # Cargo en v0 lo guardado en la direccion OFFSET_I_W_H($fp), que representa
                                                   # a la variable i.
	addu	v0,v1,v0        # Me muevo sobre el array. Hago chX.data + i. Cargo la nueva direccion
                                # sobre chX.data en v0.
	lbu	v0,0(v0)        # Cargo en v0 lo guardado en la direccion que tiene v0. O sea, hago chX.data[i] (un byte).
	sb	v0,0(a0)        # Guardo en la direccion guardada en a0 (bufferToLoad[idx]), lo obtenido en el paso
                                # anterior. O sea, hago efectivamente: bufferToLoad[idx] = chX.data[i];

        # idx ++;
	lw	v0,OFFSET_IDX_W_H($fp)      # Cargo en v0 lo guardado en la direccion OFFSET_IDX_W_H($fp), que representa la variable idx.
	addu	v0,v0,1                     # Incremento en 1 unidad a lo cargado en v0. Guardo resultado en v0.
	sw	v0,OFFSET_IDX_W_H($fp)      # Guardo en la direccion OFFSET_IDX_W_H($fp) el incremento. O sea, guardo el nuevo valor de idx.

        # i++
	lw	v0,OFFSET_I_W_H($fp)      # Cargo en v0 lo guardado en la direccion OFFSET_I_W_H($fp), que representa a la variable i.
	addu	v0,v0,1                   # Incremento en 1 unidad a lo cargado en v0. Guardo resultado en v0.
	sw	v0,OFFSET_I_W_H($fp)      # Guardo en la direccion OFFSET_I_W_H($fp) el incremento. O sea, guardo el nuevo valor de i.
	b	$loopWriteHeaderChXInWriteHeader # Salto incondicional a $loopWriteHeaderChXInWriteHeader.
$loadSpaceInWriteHeader:
        # bufferToLoad[idx] = ' ';

        # bufferToLoad[idx]
	lw	v0,OFFSET_IDX_W_H($fp)               # Cargo en v0 lo guardado en la direccion OFFSET_IDX_W_H($fp), que
                                                     # representa la variable idx.
	lw	a0,OFFSET_BUFF_TO_LOAD_W_H($fp)      # Cargo en a0 lo guardado en la direccion OFFSET_BUFF_TO_LOAD_W_H($fp), que
                                                     # representa la variable bufferToLoad.
	addu	v1,a0,v0        # Me muevo sobre el array. Hago bufferToLoad + idx. Cargo la nueva direccion
                                # sobre bufferToLoad en v1.

        # ' ' (32 en ascii)
	li	v0,32           # Cargo en v0 el caracter ' '

        # Hago efectivamente: bufferToLoad[idx] = ' ';
	sb	v0,0(v1)

        # idx ++;
	lw	v0,OFFSET_IDX_W_H($fp)      # Cargo en v0 lo guardado en la direccion OFFSET_IDX_W_H($fp),
                                            # que representa la variable idx.
	addu	v0,v0,1                     # Incremento en 1 unidad a lo cargado en v0. Guardo resultado en v0.
	sw	v0,OFFSET_IDX_W_H($fp)      # Guardo en la direccion OFFSET_IDX_W_H($fp) el incremento. O sea,
                                            # guardo el nuevo valor de idx.

        # i = 0;
	sw	zero,OFFSET_I_W_H($fp)
$loopWriteHeaderChYInWriteHeader:
        # for (i = 0; i < chY.length; i++)

        # (i < chY.length)?
	lw	v0,OFFSET_I_W_H($fp)                # Cargo en v0 lo guardado en la direccion OFFSET_I_W_H($fp), 
                                                    # que representa a la variable i.
	lw	v1,OFFSET_CH_Y_LENGHT_W_H($fp)      # Cargo en v0 lo guardado en la direccion 36($fp), que representa la 
                                                    # variable chY.length.
	slt	v0,v0,v1                            # Guardo en v0 TRUE si (i < chX.length), sino guardo FALSE.
	bne	v0,FALSE,$insideOfTheLoopWriteHeaderChY   # Si (i < chY.length) es no es FALSE, o sea 
                                                          # es TRUE, goto $insideOfTheLoopWriteHeaderChY.

        # i is >= chy.length
	b	$loadLineBreakInWriteHeader         # Salto incondicional a $loadLineBreakInWriteHeader.
$insideOfTheLoopWriteHeaderChY:
        # bufferToLoad[idx] = chY.data[i];

        # bufferToLoad[idx]
	lw	v0,OFFSET_IDX_W_H($fp)               # Cargo en v0 lo guardado en la direccion OFFSET_IDX_W_H($fp),
                                                     # que representa la variable idx.
	lw	v1,OFFSET_BUFF_TO_LOAD_W_H($fp)      # Cargo en v1 lo guardado en la direccion OFFSET_BUFF_TO_LOAD_W_H($fp),
                                                     # que representa la variable bufferToLoad.
	addu	a0,v1,v0        # Me muevo sobre el array. Hago bufferToLoad + idx. Cargo la nueva direccion
                                # sobre bufferToLoad en a0.

        # chY.data[i]
	lw	v1,OFFSET_I_W_H($fp)              # Cargo en v1 lo guardado en la direccion OFFSET_I_W_H($fp),
                                                  # que representa a la variable i.
	addu	v0,$fp,OFFSET_CH_Y_DATA_W_H       # Guardo en v0 la direccion resultante de hacer 
                                                  # $fp+OFFSET_CH_Y_DATA_W_H. Representa la direccion de 
                                                  # la variable chY.data.
	addu	v0,v0,v1        # Me muevo sobre el array. Hago chY.data + i. Cargo la nueva direccion
                                # sobre chY.data en v0.
	lbu	v0,0(v0)        # Cargo en v0 lo guardado en la direccion que tiene v0. O sea, hago chY.data[i] (un byte).
	sb	v0,0(a0)        # Guardo en la direccion guardada en a0 (bufferToLoad[idx]), lo obtenido en el paso
                                # anterior. O sea, hago efectivamente: bufferToLoad[idx] = chY.data[i];

        # idx ++;       
	lw	v0,OFFSET_IDX_W_H($fp)      # Cargo en v0 lo guardado en la direccion OFFSET_IDX_W_H($fp), 
                                            # que representa la variable idx.
	addu	v0,v0,1                     # Incremento en 1 unidad a lo cargado en v0. Guardo resultado en v0.
	sw	v0,OFFSET_IDX_W_H($fp)      # Guardo en la direccion OFFSET_IDX_W_H($fp) el incremento. O sea, 
                                            # guardo el nuevo valor de idx.

        # i++
	lw	v0,OFFSET_I_W_H($fp)      # Cargo en v0 lo guardado en la direccion OFFSET_I_W_H($fp), 
                                          # que representa la variable i.
	addu	v0,v0,1                   # Incremento en 1 unidad a lo cargado en v0. Guardo resultado en v0.
	sw	v0,OFFSET_I_W_H($fp)      # Guardo en la direccion OFFSET_I_W_H($fp) el incremento. O sea, 
                                          # guardo el nuevo valor de i.

	b	$loopWriteHeaderChYInWriteHeader # Salto incondicional a $loopWriteHeaderChYInWriteHeader.
$loadLineBreakInWriteHeader:
        # bufferToLoad[idx] = '\n';

        # bufferToLoad[idx]
	lw	v0,OFFSET_IDX_W_H($fp)               # Cargo en v0 lo guardado en la direccion OFFSET_IDX_W_H($fp),
                                                     # que representa la variable idx.
	lw	a0,OFFSET_BUFF_TO_LOAD_W_H($fp)      # Cargo en a0 lo guardado en la direccion OFFSET_BUFF_TO_LOAD_W_H($fp),
                                                     # que representa la variable bufferToLoad.
	addu	v1,a0,v0        # Me muevo sobre el array. Hago bufferToLoad + idx. Cargo la nueva direccion
                                # sobre bufferToLoad en v1.

        # '\n'
	li	v0,10           # Cargo en v0 el inmediato 10, ya que el salto de linea en ascii es igual a 10 ('\n').

	sb	v0,0(v1)        # Guardo en la direccion guardada en v1 (bufferToLoad[idx]), lo obtenido en el paso
                                # anterior. O sea, hago efectivamente: bufferToLoad[idx] = '\n';

        # idx ++;
	lw	v0,OFFSET_IDX_W_H($fp)      # Cargo en v0 lo guardado en la direccion OFFSET_IDX_W_H($fp),
                                            # que representa la variable idx.
	addu	v0,v0,1                     # Incremento en 1 unidad a lo cargado en v0. Guardo resultado en v0.
	sw	v0,OFFSET_IDX_W_H($fp)      # Guardo en la direccion OFFSET_IDX_W_H($fp) el incremento. O sea, 
                                            # guardo el nuevo valor de idx.

        # i = 0
	sw	zero,OFFSET_I_W_H($fp)      # Esto se hace para hacer el loop siguiente.
$loopChShadesInWriteHeader:
        # for (i = 0; i < chShades.length; i++)

        # (i < chShades.length) ?
	lw	v0,OFFSET_I_W_H($fp)                     # Cargo en v0 lo guardado en la direccion OFFSET_I_W_H($fp),
                                                         # que representa la variable i.
	lw	v1,OFFSET_CH_SHADES_LENGHT_W_H($fp)      # Cargo en v0 lo guardado en la direccion OFFSET_CH_SHADES_LENGHT_W_H($fp),
                                                         # que representa la variable chShades.length.
	slt	v0,v0,v1                                 # Guardo en v0 TRUE si (i < chShades.length), sino guardo FALSE.
	bne	v0,FALSE,$insideOfTheLoopChShadesInWriteHeader   # Si (i < chShades.length) es no es FALSE, o sea
                                                                 # es TRUE, goto $insideOfTheLoopChShadesInWriteHeader.

        # i is >= chShades.length
	b	$loadLineBreakFinalInWriteHeader         # Salto incondicional a $loadLineBreakFinalInWriteHeader.
$insideOfTheLoopChShadesInWriteHeader:
        # bufferToLoad[idx] = chShades.data[i];

        # bufferToLoad[idx]
	lw	v0,OFFSET_IDX_W_H($fp)               # Cargo en v0 lo guardado en la direccion OFFSET_IDX_W_H($fp),
                                                     # que representa la variable idx.
	lw	v1,OFFSET_BUFF_TO_LOAD_W_H($fp)      # Cargo en v1 lo guardado en la direccion OFFSET_BUFF_TO_LOAD_W_H($fp),
                                                     # que representa la variable bufferToLoad.
	addu	a0,v1,v0        # Me muevo sobre el array. Hago bufferToLoad + idx. Cargo la nueva direccion
                                # sobre bufferToLoad en a0.

        # chShades.data[i];
	addu	v1,$fp,OFFSET_CH_SHADES_DATA_W_H       # Guardo en v1 la direccion resultante de hacer $fp+OFFSET_CH_SHADES_DATA_W_H.
                                                       # Representa la direccion de la variable chShades.data.
	lw	v0,OFFSET_I_W_H($fp)                   # Cargo en v0 lo guardado en la direccion OFFSET_I_W_H($fp), que 
                                                       # representa a la variable i.
	addu	v0,v1,v0        # Me muevo sobre el array. Hago chShades.data + i. Cargo la nueva direccion
                                # sobre chShades.data en v0.
	lbu	v0,0(v0)        # Cargo en v0 lo guardado en la direccion que tiene v0. O sea, hago chShades.data[i] (un byte).
	sb	v0,0(a0)        # Guardo en la direccion guardada en a0 (bufferToLoad[idx]), lo obtenido en el paso
                                # anterior. O sea, hago efectivamente: bufferToLoad[idx] = chShades.data[i];

        # idx ++;
	lw	v0,OFFSET_IDX_W_H($fp)      # Cargo en v0 lo guardado en la direccion OFFSET_IDX_W_H($fp),
                                            # que representa la variable idx.
	addu	v0,v0,1                     # Incremento en 1 unidad a lo cargado en v0. Guardo resultado en v0.
	sw	v0,OFFSET_IDX_W_H($fp)      # Guardo en la direccion OFFSET_IDX_W_H($fp) el incremento. O sea, 
                                            # guardo el nuevo valor de idx.

        # i++
	lw	v0,OFFSET_I_W_H($fp)      # Cargo en v0 lo guardado en la direccion OFFSET_I_W_H($fp), que representa la variable i.
	addu	v0,v0,1                   # Incremento en 1 unidad a lo cargado en v0. Guardo resultado en v0.
	sw	v0,OFFSET_I_W_H($fp)      # Guardo en la direccion OFFSET_I_W_H($fp) el incremento. O sea, guardo el nuevo valor de i.

	b	$loopChShadesInWriteHeader # Salto incondicional a $loopChShadesInWriteHeader.
$loadLineBreakFinalInWriteHeader:
        # bufferToLoad[idx] = '\n';

        # bufferToLoad[idx]
	lw	v0,OFFSET_IDX_W_H($fp)               # Cargo en v0 lo guardado en la direccion OFFSET_IDX_W_H($fp),
                                                     # que representa la variable idx.
	lw	a0,OFFSET_BUFF_TO_LOAD_W_H($fp)      # Cargo en a0 lo guardado en la direccion OFFSET_BUFF_TO_LOAD_W_H($fp),
                                                     # que representa la variable bufferToLoad.
	addu	v1,a0,v0        # Me muevo sobre el array. Hago bufferToLoad + idx. Cargo la nueva direccion
                                # sobre bufferToLoad en v1.

        # '\n'
	li	v0,10           # Cargo en v0 el inmediato 10, ya que el salto de linea en ascii es igual a 10 ('\n').

	sb	v0,0(v1)        # Guardo en la direccion guardada en v1 (bufferToLoad[idx]), lo obtenido en el paso
                                # anterior. O sea, hago efectivamente: bufferToLoad[idx] = '\n';

        # int rdoWrite = writeBufferInOFile(bufferToLoad, quantityCharactersInBufferToLoad);
	lw	a0,OFFSET_BUFF_TO_LOAD_W_H($fp)                   # Cargo en a0 lo guardado en la direccion OFFSET_BUFF_TO_LOAD_W_H($fp),
                                                                  # que representa la variable bufferToLoad.
                                                                  # Es el primer parametro de la funcion writeBufferInOFile.
	lw	a1,OFFSET_QUANTITY_CH_IN_BUF_TO_LOAD_W_H($fp)     # Cargo en a1 lo guardado en la direccion 
                                                                  # OFFSET_QUANTITY_CH_IN_BUF_TO_LOAD_W_H($fp), que representa 
                                                                  # la variable quantityCharactersInBufferToLoad. Es el segundo 
                                                                  # parametro de la funcion writeBufferInOFile.
	la	t9,writeBufferInOFile                   # Cargo el t9 la direccion de la funcion writeBufferInOFile.
	jal	ra,t9                                   # Ejecuto la funcion writeBufferInOFile.
	sw	v0,OFFSET_RDO_WRITE_W_H($fp)            # Guardo en la direccion OFFSET_RDO_WRITE_W_H($fp) lo que esta en v0, que es el 
                                                        # resultado de la funcion writeBufferInOFile. Esta representa la variable rdoWrite.

        # (rdoWrite != OKEY) ?
	lw	v0,OFFSET_RDO_WRITE_W_H($fp)            # Cargo en v0 lo guardado en la direccion OFFSET_RDO_WRITE_W_H($fp), que 
                                                        # representa la variable rdoWrite.
	beq	v0,OKEY,$returnOkeyInWriteHeader        # If (rdoWrite == OKEY) goto $returnOkeyInWriteHeader.

        # rdoWrite is not equals OKEY

        # closeFile();
	la	t9,closeFile    # Cargo en t9 la direccion de la funcion closeFile.
	jal	ra,t9           # Ejecuto la funcion closeFile.

        # return ERROR_WRITE;
	lw	sp,OFFSET_SP_W_H($fp)          # Cargo en sp lo guardado en la direccion OFFSET_SP_W_H($fp), que es sp.
	li	v0,ERROR_WRITE                 # Cargo el inmediato ERROR_WRITE en v0.
	sw	v0,OFFSET_RETURN_W_H($fp)      # Guardo en la direccion OFFSET_RETURN_W_H($fp) lo que tiene v0, que es 
                                               # el codigo ERROR_WRITE. En esta direccion se cargar el return de la funcion.

	b	$returnWriteHeader             # Salto incondicional a $returnWriteHeader.
$returnOkeyInWriteHeader:
        # return OKEY;
	lw	sp,OFFSET_SP_W_H($fp)          # Cargo en sp lo guardado en la direccion OFFSET_SP_W_H($fp), que es sp.
	sw	zero,OFFSET_RETURN_W_H($fp)    # Guardo en la direccion OFFSET_RETURN_W_H($fp) cero, que es el codigo OKEY.
                                               # En esta direccion se cargar el return de la funcion.
$returnWriteHeader:        
	lw	v0,OFFSET_RETURN_W_H($fp)      # Cargo en v0 lo que va a retornar la funcion, que esta guardado en la 
                                               # direccion OFFSET_RETURN_W_H($fp).

        # reconstruyo los registros.
	move	sp,$fp
	lw	ra,OFFSET_RA_W_H(sp)
	lw	$fp,OFFSET_FP_W_H(sp)

        # destruyo stack frame
	addu	sp,sp,STACK_FRAME_WRITE_HEADER

        # vuelvo a funcion llamante
	j	ra

	.end	writeHeader

#--------------- end  writeHeader  ---------------#


# ---------------------------------------------------------------------------- #

## Variables auxiliares

	.data

	.globl	quantityCharactersInBuffer
	.globl	quantityCharactersInBuffer
	.section	.bss
	.align	2
	.type	quantityCharactersInBuffer, @object
	.size	quantityCharactersInBuffer, 4
quantityCharactersInBuffer:
	.space	4


	.comm	fileOutput,4

	.comm	ofd,4

	.comm	buffer,MAX_BUFFER


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

