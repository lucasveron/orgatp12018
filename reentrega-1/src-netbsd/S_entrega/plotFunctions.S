#include <mips/regdef.h>
#include <sys/syscall.h>

#include "constants.h"


##-----	loadPixelBrightness -----##

	.text
	.align	2
	.globl	loadPixelBrightness
	.ent	loadPixelBrightness
loadPixelBrightness:
	.frame	$fp,72,ra
	.set	noreorder
	.cpload	t9
	.set	reorder

	# Stack frame creation
	subu	sp,sp,72

	.cprestore 16
	sw	ra,64(sp)
	sw	$fp,60(sp)
	sw	gp,56(sp)

	# de aqui al fin de la funcion uso $fp en lugar de sp.
	move	$fp,sp

	# Parametro
	# int loadPixelBrightness(unsigned int pixelBrightness)
	sw	a0,72($fp)	# Guardo en la direccion 72($fp) el parametro, que 
				# representa a la variable pixelBrightness.

	###########################################################################
	#  typedef struct character {						  #
	#	char data [MAX_LENGTH_CHARACTER];				  #
	#	int length;							  #
	#  } character;								  #
	#									  #
	#  Donde:  MAX_LENGTH_CHARACTER = 11					  #
	#  Se usa para transformar un int en una cadena de caracteres.		  #
	#  En C se tiene:							  #
	#    int								  #
	#	bytes = 4							  #
	#	Máximo = 2,147,483,647 (4,294,967,295 cuando es unsigned)	  #
	# 	Mínimo = -2,147,483,648 (0 cuando es unsigned)			  #
	#	Entonces reservo 11 bytes (10 numeros + 1 signo, si es negativo). #
	###########################################################################


	addu	a0,$fp,24
	lw	a1,72($fp)

	# character ch = convertIntToCharacter(pixelBrightness);
	#lw	a0,72($fp)	# Cargo en a0, la variable pixelBrightness, guardada en la direccion
				# 72($fp), que seria el parametro de la funcion.
	la	t9,convertIntToCharacter # Cargo en t9, la direccion de la funcion convertIntToCharacter.
	jal	ra,t9		# Invoco la funcion, salto a convertIntToCharacter.
	#sw	v0,25($fp)	# TODO VER SI ESTO ESTA BIEN, XQ LO AGREGUE YO
				# Guardo en la direccion 36($fp), el valor retornado por la funcion.
	
	# int rdo = OKEY;
	sw	zero,40($fp)	# OKEY = 0

	# int i; i = 0;
	sw	zero,44($fp)
$loopPutchLoadPixelBrightness:
	# for (i = 0; i < ch.length; i++)
	lw	v0,44($fp)	# Cargo en v0 lo guardado en la direccion 44($fp), que representa a
				# la variable i.
	lw	v1,36($fp)	# Cargo en v1 lo guardado en la direccion 36($fp), que representa a
				# la variable ch.length.

	# (i < ch.length) ?
	slt	v0,v0,v1
	bne	v0,FALSE,$insideOfTheLoopPutchLoadPixelBrightness # If (i < ch.length) goto 
							# $insideOfTheLoopPutchLoadPixelBrightness
	b	$loadTheResultToReturn	# Llego a la condicion de corte del loop, por lo cual se va 
					# cargar el resultado a ser retornado.

$insideOfTheLoopPutchLoadPixelBrightness:
	# rdo = putch(ch.data[i]);
	lw	v1,44($fp)	# Cargo en v1 el valor de la variable i, guardado en la direccion 
				# 44($fp).
	addu	v0,$fp,24	# Cargo en v0 la direccion donde se encuentra el primer elemento 
				# del array ch.data.
	addu	v0,v0,v1	# Me muevo i posiciones sobre ch.data.
	lb	v0,0(v0)	# Cargo el valor de ch.data en la posicion i, en v0.
	move	a0,v0		# Cargo en a0, el valor que tiene v0, que es ch.data[i]. Esto es
				# para pasarlo como parametro a la variable putch.
	la	t9,putch	# Cargo la direccion de la funcion putch.
	jal	ra,t9		# Ejecuto la funcion putch.
	sw	v0,40($fp)	# Guardo en la direccion 40($fp), que representa a la variable rdo,
				# lo retornado por la funcion putch.

	# (rdo != OKEY) ?
	lw	v0,40($fp)	# Cargo en v0 lo guardado en la direccion 40($fp)
	beq	v0,OKEY,$incrementInLoopPutchLoadPixelBrightness # If (rdo == OKEY) goto
								#  $incrementInLoopPutchLoadPixelBrightness

	# rdo is not OKEY
	lw	v0,40($fp)	# Cargo en v0 lo guardado en la direccion 40($fp), que representa la variable rdo.
	sw	v0,48($fp)	# Guardo en la direccion 48($fp), el valor de rdo, que va a ser donde se guarde el
				# resultado de la funcion.
	b	$returnLoadPixelBrightness # Salto incondicional para hacer el return de la funcion.
$incrementInLoopPutchLoadPixelBrightness:
	# i++
	lw	v0,44($fp)
	addu	v0,v0,1
	sw	v0,44($fp)
	b	$loopPutchLoadPixelBrightness
$loadTheResultToReturn:
	lw	v0,40($fp)	# Cargo en v0 lo guardado en la direccion 40($fp), que representa la variable rdo.
	sw	v0,48($fp)	# Guardo en la direccion 48($fp), el valor de rdo, que va a ser donde se guarde el
				# resultado de la funcion.
$returnLoadPixelBrightness:
	lw	v0,48($fp)	# Cargo en v0 lo guardado en la direccion 48($fp), que representa el resultado de la funcion.

	# reconstruyo los registros.
	move	sp,$fp
	lw	ra,64(sp)
	lw	$fp,60(sp)

	# destruyo stack frame
	addu	sp,sp,72

	# vuelvo a funcion llamante
	j	ra

	.end	loadPixelBrightness


##-----	mips32_plot -----##

	.text
	.align	2
	.globl	mips32_plot
	.ent	mips32_plot
mips32_plot:
	.frame	$fp,88,ra
	.set	noreorder
	.cpload	t9
	.set	reorder

	# Stack frame creation
	subu	sp,sp,88

	.cprestore 16
	sw	ra,80(sp)
	sw	$fp,76(sp)
	sw	gp,72(sp)

	# de aqui al fin de la funcion uso $fp en lugar de sp.
	move	$fp,sp

	# Parametro
	# void mips32_plot(param_t * parms)
	sw	a0,88($fp)	# Guardo en la dir 88($fp), la direccion de parms (param_t * parms).

	###################################################################
	#  Estructura de param_t:                                         #
	#                                                                 #
	#  typedef struct {                                               #
	#	float UL_re; /* upper left point, real part */            #
	#	float UL_im; /* upper left point, imaginary part */       #
	#	float LR_re; /* lower right point, real part */           #
	#	float LR_im; /* lower right point, imaginary part */      #
	#	float d_re;  /* pixel step, real part */                  #
	#	float d_im;  /* pixel step, imaginary part */             #
	#	float s_re;  /* seed of julia set, real part */           #
	#	float s_im;  /* seed of julia set, imaginary part */      #
	#                                                                 #
	#	size_t x_res;  /* horizontal resolution, e.g. 640 */      #
	#	size_t y_res;  /* vertical resolution, e.g. 480 */        #
	#	size_t shades; /* amount of shades of gray, e.g. 255 */   #
	#                                                                 #
	#	FILE *fp;                                                 #
	#  } param_t;                                                     #
	#                                                                 #
	###################################################################

	# initFile(parms->fp);
	lw	v0,88($fp)	# Cargo en v0, la dir a la que apunta parms.
	lw	a0,44(v0)	# Cargo en a0, la dir a la que apunta parms + 44 (que es FILE *),
				# que seria el parametro de la funcion.
	la	t9,initFile	# Cargo en t9 la direccion de la funcion initFile.
	jal	ra,t9		# Ejecuto la funcion initFile.

	# int rdo = loadFileDescriptor();
	la	t9,loadFileDescriptor	# Cargo en t9 la direccion de la funcion loadFileDescriptor.
	jal	ra,t9		# Ejecuto la funcion loadFileDescriptor.
	sw	v0,24($fp)	# Guardo en la direccion 24($fp) el resultado de la funcion loadFileDescriptor
				# que representa la variable rdo.

	# (rdo != OKEY) ?
	lw	v0,24($fp)	# Cargo en v0 lo guardado en la direccion 24($fp), que representa la 
				# variable rdo.
	beq	v0,OKEY,$writeHeader # If (rdo == OKEY) goto $writeHeader

	# rdo is not OKEY
	b	$returnMips32Plot # Salto incondicional a $returnMips32Plot.
$writeHeader:
	# rdo = writeHeader((unsigned)parms->y_res, (unsigned)parms->x_res, (unsigned)(parms->shades - 1));
	lw	v1,88($fp)
	lw	a1,88($fp)
	lw	v0,88($fp)
	lw	v0,40(v0)
	addu	v0,v0,-1
	lw	a0,36(v1)
	lw	a1,32(a1)
	move	a2,v0
	la	t9,writeHeader
	jal	ra,t9
	sw	v0,24($fp)
	lw	v0,24($fp)
	beq	v0,zero,$L25
	b	$returnMips32Plot
$L25:
	sw	zero,60($fp)
	lw	v0,88($fp)
	l.s	$f0,4(v0)
	s.s	$f0,32($fp)
$L26:
	lw	v0,88($fp)
	lw	v1,60($fp)
	lw	v0,36(v0)
	sltu	v0,v1,v0
	bne	v0,zero,$L29
	b	$L27
$L29:
	sw	zero,56($fp)
	lw	v0,88($fp)
	l.s	$f0,0(v0)
	s.s	$f0,28($fp)
$L30:
	lw	v0,88($fp)
	lw	v1,56($fp)
	lw	v0,32(v0)
	sltu	v0,v1,v0
	bne	v0,zero,$L33
	b	$L31
$L33:
	l.s	$f0,28($fp)
	s.s	$f0,36($fp)
	l.s	$f0,32($fp)
	s.s	$f0,40($fp)
	sw	zero,64($fp)
$L34:
	lw	v0,88($fp)
	lw	v1,64($fp)
	lw	v0,40(v0)
	sltu	v0,v1,v0
	bne	v0,zero,$L37
	b	$L35
$L37:
	l.s	$f2,36($fp)
	l.s	$f0,36($fp)
	mul.s	$f4,$f2,$f0
	l.s	$f2,40($fp)
	l.s	$f0,40($fp)
	mul.s	$f0,$f2,$f0
	add.s	$f0,$f4,$f0
	mov.s	$f2,$f0
	s.s	$f2,52($fp)
	l.s	$f0,$LC0
	c.le.s	$f0,$f2
	bc1t	$L35
	lw	v0,88($fp)
	l.s	$f2,36($fp)
	l.s	$f0,36($fp)
	mul.s	$f2,$f2,$f0
	l.s	$f0,24(v0)
	add.s	$f4,$f2,$f0
	l.s	$f2,40($fp)
	l.s	$f0,40($fp)
	mul.s	$f0,$f2,$f0
	sub.s	$f0,$f4,$f0
	s.s	$f0,44($fp)
	lw	v0,88($fp)
	l.s	$f2,36($fp)
	l.s	$f0,40($fp)
	mul.s	$f0,$f2,$f0
	add.s	$f2,$f0,$f0
	l.s	$f0,28(v0)
	add.s	$f0,$f0,$f2
	s.s	$f0,48($fp)
	l.s	$f0,44($fp)
	s.s	$f0,36($fp)
	l.s	$f0,48($fp)
	s.s	$f0,40($fp)
	lw	v0,64($fp)
	addu	v0,v0,1
	sw	v0,64($fp)
	b	$L34
$L35:
	lw	a0,64($fp)
	la	t9,loadPixelBrightness
	jal	ra,t9
	sw	v0,24($fp)
	lw	v0,24($fp)
	beq	v0,zero,$L40
	lw	v0,88($fp)
	lw	a0,44(v0)
	la	t9,closeFile
	jal	ra,t9
	b	$returnMips32Plot
$L40:
	li	a0,32			# 0x20
	la	t9,putch
	jal	ra,t9
	sw	v0,24($fp)
	lw	v0,24($fp)
	beq	v0,zero,$L32
	la	t9,closeFile
	jal	ra,t9
	b	$returnMips32Plot
$L32:
	lw	v0,56($fp)
	addu	v0,v0,1
	sw	v0,56($fp)
	lw	v0,88($fp)
	l.s	$f2,28($fp)
	l.s	$f0,16(v0)
	add.s	$f0,$f2,$f0
	s.s	$f0,28($fp)
	b	$L30
$L31:
	li	a0,10			# 0xa
	la	t9,putch
	jal	ra,t9
	sw	v0,24($fp)
	lw	v0,24($fp)
	beq	v0,zero,$L28
	la	t9,closeFile
	jal	ra,t9
	b	$returnMips32Plot
$L28:
	lw	v0,60($fp)
	addu	v0,v0,1
	sw	v0,60($fp)
	lw	v0,88($fp)
	l.s	$f2,32($fp)
	l.s	$f0,20(v0)
	sub.s	$f0,$f2,$f0
	s.s	$f0,32($fp)
	b	$L26
$L27:
	la	t9,flush
	jal	ra,t9
	la	t9,closeFile
	jal	ra,t9
$returnMips32Plot:
	move	sp,$fp
	lw	ra,80(sp)
	lw	$fp,76(sp)
	addu	sp,sp,88
	j	ra
	.end	mips32_plot
	.size	mips32_plot, .-mips32_plot


# ---------------------------------------------------------------------------- #

## Variables auxiliares


	.rdata
	.align	2
$LC0:
	.word	1082130432





