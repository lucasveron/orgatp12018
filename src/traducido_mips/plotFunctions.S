#include <mips/regdef.h>
#include <sys/syscall.h>



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
	sw	a0,88($fp)    # Guardo en la dir 88($fp), la direccion de parms (param_t * parms).

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

	# fileOutput = parms->fp;
	lw	v0,88($fp)    # Cargo en v0, la dir a la que apunta parms.
	lw	v0,44(v0)     # Cargo en v0, la dir a la que apunta parms + 44 (que es FILE *).
	sw	v0,fileOutput # Guardo en la variable global fileOuput, el FILE * guardado en v0.

	# int rdo = loadFileDescriptor();
	la	t9,loadFileDescriptor # Cargo en t9, la direccion de la funcion loadFileDescriptor.
	jal	ra,t9         # Salto a loadFileDescriptor
	sw	v0,24($fp)    # Guardo en la dir 24($fp) el resultado de al funcion, que esta en v0.

	# (rdo != OKEY) ?
	lw	v0,24($fp)    # Cargo en v0 lo que hay en la dir 24($fp), que es rdo.
	beq	v0,OKEY,$writeHeader # If (rdo == OKEY) goto $writeHeader

	# rdo is not OKEY
	b	$returnMips32Plot # Salto incondicional a $returnMips32Plot.
$writeHeader:
	# rdo = writeHeader((unsigned)parms->y_res, (unsigned)parms->x_res, (unsigned)(parms->shades - 1));
	lw	v1,88($fp)    # Cargo en v1, la dir a la que apunta parms.
	lw	a1,88($fp)    # Cargo en a1, la dir a la que apunta parms.
	lw	v0,88($fp)    # Cargo en v0, la dir a la que apunta parms.

	# (parms->shades - 1)
	lw	v0,40(v0)     # Cargo en v0, el contenido apuntado por *parms + 40, que seria shades (parms->shades).
	addu	v0,v0,-1      # A shades le resto 1. Guardo en v0 el resultado de parms->shades - 1.

	# (parms->y_res)
	lw	a0,36(v1)     # Cargo en a0, lo apuntado por *parms + 36, que seria y_res (parms->y_res).

	# (parms->x_res)
	lw	a1,32(a1)     # Cargo en a1, lo apuntado por *parms + 32, que seria y_res (parms->x_res).

	move	a2,v0         # Muevo a a2, el contenido de v0, que es el resultado de parms->shades - 1.

	la	t9,writeHeader # Cargo en t9, la direccion de memoria de la funcion writeHeader.
	jal	ra,t9         # Salto a writeHeader, ejecuto la funcion.
	sw	v0,24($fp)    # Guardo en rdo, dir 24($fp), el resultado de la funcion writeHeader.

	# (rdo != OKEY) ?
	lw	v0,24($fp)    # Cargo en v0, rdo, guardado en la dir 24($fp).
	beq	v0,OKEY,$loopPixel # If (rdo == OKEY) goto $loopPixel.

	# rdo is not equal to OKEY
	b	$returnMips32Plot # Salto incondicional a $returnMips32Plot.

$loopPixel:
	
	# for (y = 0, ci = parms->UL_im; y < parms->y_res; ++y, ci -= parms->d_im)

	# y = 0
	sw	zero,60($fp)  # Guardo en la dir 60($fp) el valor 0, que seria y = 0.

	# ci = parms->UL_im
	lw	v0,88($fp)    # Cargo en v0 la dir apuntada por parms (* parms), guardada en la dir 88($fp).
	l.s	$f0,4(v0)     # Cargo en f0 lo apuntado por *parms + 4, que es UL_im (es float).
	s.s	$f0,32($fp)   # Guardo en la dir 32($fp) el valor guardado en f0, que es UL_im (float), que seria ci.
$loopInY:

	# (y < parms->y_res) ?
	lw	v0,88($fp)    # Cargo en v0 la dir apuntada por parms (* parms), guardada en la dir 88($fp).
	lw	v1,60($fp)    # Cargo en v1 y, guardado en la dir 60($fp).
	lw	v0,36(v0)     # Cargo en v0, lo apuntado por *parms + 36, que seria y_res (parms->y_res).
	sltu	v0,v1,v0      # Guardo en v0 TRUE si y < parms->y_res, sino guardo FALSE.
	bne	v0,FALSE,$loopInX  # Si no es FALSE, es TRUE, continuo el for, salto a $loopInX.

	# y is not less than parms->y_res
	b	$flushRestData # Salto incondicional a $flushRestData.
$loopInX:

	# for (x = 0, cr = parms->UL_re; x < parms->x_res; ++x, cr += parms->d_re)

	# x = 0
	sw	zero,56($fp)  # Guardo en la dir 56($fp) el valor 0, que seria x = 0.

	# cr = parms->UL_re
	lw	v0,88($fp)    # Cargo en v0 la dir apuntada por parms (* parms), guardada en la dir 88($fp).
	l.s	$f0,0(v0)     # Cargo en f0 lo apuntado por *parms, que es UL_re (es float).
	s.s	$f0,28($fp)   # Guardo en la dir 28($fp) el valor guardado en f0, que es UL_re (float), que seria cr.
$conditionLoopInX:

	# (x < parms->x_res) ?
	lw	v0,88($fp)    # Cargo en v0 la dir apuntada por parms (* parms), guardada en la dir 88($fp).
	lw	v0,32(v0)     # Cargo en v0 lo guardado en la dir *parms+32, que es x_res.
	lw	v1,56($fp)    # Cargo en v1 lo guardado en la dir 56($fp), que seria x.
	sltu	v0,v1,v0      # Guardo en v0 TRUE si x < parms->x_res, sino guardo FALSE.
	bne	v0,FALSE,$insideOfTheLoopInX # Si no es FALSE, es TRUE, continuo dentro del for, salto a $insideOfTheLoopInX.

	# x is not less than parms->x_res
	b	$putLineBreak # Salto incondicional a $putLineBreak.
$insideOfTheLoopInX:

	# zr = cr;
	l.s	$f0,28($fp)    # Cargo en f0 lo guardado en la dir 28($fp), que es cr (es float).
	s.s	$f0,36($fp)    # Guardo en la dir 36($fp), que representa a zr, lo que tiene f0.

	# zi = ci;
	l.s	$f0,32($fp)    # Cargo en f0 lo guardado en la dir 32($fp), que es ci (es float).
	s.s	$f0,40($fp)    # Guardo en la dir 40($fp), que representa a zi, lo que tiene f0.

	# for (c = 0; c < parms->shades; ++c)

	# c = 0
	sw	zero,64($fp)   # Guardo en la dir 64($fp) el valor 0, que representa a la variable c.
$loopShades:

	# (c < parms->shades) ?
	lw	v0,88($fp)    # Cargo en v0 la dir apuntada por parms (* parms), guardada en la dir 88($fp).
	lw	v0,40(v0)     # Cargo en v0 lo guardado en la dir *parms+40, que es shades.
	lw	v1,64($fp)    # Cargo en v1 lo guardado en la dir 64($fp), que seria c.
	sltu	v0,v1,v0      # Guardo en v0 TRUE si c < parms->shades, sino guardo FALSE.
	bne	v0,FALSE,$insideOfTheLoopShades # Si no es FALSE, es TRUE, continuo dentro 
                                                # del for, salto a $insideOfTheLoopShades.

	# c is not less than parms->shades
	b	$savePixelBrightness # Salto incondicional a $savePixelBrightness.
$insideOfTheLoopShades:
	# ((absz = zr*zr + zi*zi) >= 4.0f) ?

	# (absz = zr*zr + zi*zi)

	# zr*zr
	l.s	$f2,36($fp)    # Cargo en f2 lo guardado en la dir 36($fp), que es zr (es float).
	l.s	$f0,36($fp)    # Cargo en f0 lo guardado en la dir 36($fp), que es zr (es float).
	mul.s	$f4,$f2,$f0    # Multiplico lo guardado en f0 con lo guardado en f2, y guardo rdo en f4.

	# zi*zi
	l.s	$f2,40($fp)    # Cargo en f2 lo guardado en la dir 40($fp), que es zi (es float).
	l.s	$f0,40($fp)    # Cargo en f0 lo guardado en la dir 40($fp), que es zi (es float).
	mul.s	$f0,$f2,$f0    # Multiplico lo guardado en f0 con lo guardado en f2, y guardo rdo en f0.

	# absz = zr*zr + zi*zi
	add.s	$f0,$f4,$f0    # Sumo lo guardado en f0 (zi*zi), con lo guardado en f4 
                               # (zr*zr), y guardo rdo en f0.
	mov.s	$f2,$f0        # Muevo el rdo de f0 a f2.
	s.s	$f2,52($fp)    # Guardo el resultado de la suma en la dir 52($fp), que representa a 
                               # la variable absz.
	l.s	$f0,fourFloat  # Cargo en f0 el valor 4.0f
	c.le.s	$f0,$f2        # Comparo absz con 4.0f. Si f0 (4.0f) <= f2 (absz), coloca el 
                               # indicador de condicion en TRUE, sino en FALSE.
	bc1t	$savePixelBrightness

	# (absz = zr*zr + zi*zi) is >= 4.0f

	# tr = parms->s_re + zr * zr - zi * zi;

	# zr * zr
	l.s	$f2,36($fp)    # Cargo en f2 lo guardado en la dir 36($fp), que es zr (es float).
	l.s	$f0,36($fp)    # Cargo en f0 lo guardado en la dir 36($fp), que es zr (es float).
	mul.s	$f2,$f2,$f0    # Multiplico lo guardado en f0 con lo guardado en f2, y guardo rdo en f2.

	# parms->s_re
	lw	v0,88($fp)    # Cargo en v0 la dir apuntada por parms (* parms), guardada en la dir 88($fp).
	l.s	$f0,24(v0)    # Cargo en f0 lo guardado en la dir *parms+24, que es s_re (es float).

	# parms->s_re + zr * zr
	add.s	$f4,$f2,$f0   # Guardo resultado de la suma en f4.
	
	# zi * zi
	l.s	$f2,40($fp)    # Cargo en f2 lo guardado en la dir 40($fp), que es zi (es float).
	l.s	$f0,40($fp)    # Cargo en f0 lo guardado en la dir 40($fp), que es zi (es float).
	mul.s	$f0,$f2,$f0    # Multiplico lo guardado en f0 con lo guardado en f2, y guardo rdo en f0.

	# tr = parms->s_re + zr * zr - zi * zi;
	sub.s	$f0,$f4,$f0    
	s.s	$f0,44($fp)    # Guardo el resultado de la resta (f0), en la dir 44($fp), representa a tr.

	# ti = parms->s_im + zr * zi * 2.0f;	

	# zr * zi
	l.s	$f2,36($fp)    # Cargo en f2 lo guardado en la dir 36($fp), que es zr (es float).
	l.s	$f0,40($fp)    # Cargo en f0 lo guardado en la dir 40($fp), que es zi (es float).
	mul.s	$f0,$f2,$f0    # Multiplico lo guardado en f0 con lo guardado en f2, y guardo rdo en f0.

	# (zr * zi * 2.0f)  lo que es igual a hacer (zr * zi + zr * zi)
	add.s	$f2,$f0,$f0

	lw	v0,88($fp)    # Cargo en v0 la dir apuntada por parms (* parms), guardada en la dir 88($fp).
	l.s	$f0,28(v0)    # Cargo en f0 lo guardado en la dir *parms+28, que es s_im (es float).

	# ti = parms->s_im + zr * zi * 2.0f;
	add.s	$f0,$f0,$f2
	s.s	$f0,48($fp)   # Guardo el resultado de la suma (f0) en 48($fp), que representa a la variable ti.

	# zr = tr;
	l.s	$f0,44($fp)
	s.s	$f0,36($fp)

	# zi = ti;
	l.s	$f0,48($fp)
	s.s	$f0,40($fp)

	# ++c
	lw	v0,64($fp)
	addu	v0,v0,1
	sw	v0,64($fp)

	b	$loopShades
$savePixelBrightness:

	# rdo = loadPixelBrightness((unsigned)c);
	lw	a0,64($fp)
	la	t9,loadPixelBrightness
	jal	ra,t9
	sw	v0,24($fp)

	# (rdo != OKEY) ?
	lw	v0,24($fp)
	beq	v0,OKEY,$putSpace

	# rdo is not equals OKEY

	# closeFile(parms->fp);
	lw	v0,88($fp)
	lw	a0,44(v0)
	la	t9,closeFile
	jal	ra,t9

	b	$returnMips32Plot
$putSpace:
	# rdo = putch(' ');
	li	a0,32		# Cargo en a0 el espacio.
	la	t9,putch
	jal	ra,t9
	sw	v0,24($fp)

	# (rdo != OKEY) ?
	lw	v0,24($fp)
	beq	v0,OKEY,$loopInXCompletion

	# rdo is not equals OKEY

	# closeFile();
	la	t9,closeFile
	jal	ra,t9

	b	$returnMips32Plot
$loopInXCompletion:
	# ++x, cr += parms->d_re

	# ++x
	lw	v0,56($fp)
	addu	v0,v0,1
	sw	v0,56($fp)

	# cr += parms->d_re
	lw	v0,88($fp)
	l.s	$f2,28($fp)
	l.s	$f0,16(v0)
	add.s	$f0,$f2,$f0
	s.s	$f0,28($fp)

	
	b	$conditionLoopInX
$putLineBreak:
	# rdo = putch('\n');
	li	a0,10		# 10 = '\n'
	la	t9,putch
	jal	ra,t9
	sw	v0,24($fp)

	# (rdo != OKEY) ?
	lw	v0,24($fp)
	beq	v0,OKEY,$closeLoopInY
	la	t9,closeFile
	jal	ra,t9
	b	$returnMips32Plot
$closeLoopInY:
	# ++y, ci -= parms->d_im

	# ++y
	lw	v0,60($fp)
	addu	v0,v0,1
	sw	v0,60($fp)

	# ci -= parms->d_im 
	lw	v0,88($fp)
	l.s	$f2,32($fp)
	l.s	$f0,20(v0)
	sub.s	$f0,$f2,$f0
	s.s	$f0,32($fp)
	b	$loopInY
$flushRestData:
	# flush();
	la	t9,flush
	jal	ra,t9

	closeFile();
	la	t9,closeFile
	jal	ra,t9
$returnMips32Plot:
	move	sp,$fp
	lw	ra,80(sp)
	lw	$fp,76(sp)

	# destruyo stack frame
	addu	sp,sp,88

	# vuelvo a funcion llamante
	j	ra

	.end	mips32_plot


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
	sw	a0,72($fp)      # Guardo en la dir 72($fp) el parametro recibido en a0, 
                                # que representa a la variable pixelBrightness.

	# character ch = convertIntToCharacter(pixelBrightness);
	addu	a0,$fp,24
	lw	a1,72($fp)
	la	t9,convertIntToCharacter # El resultado de la funcion se encuentra en v0. TODO
	jal	ra,t9


	# int rdo = OKEY;
	sw	zero,40($fp)

	#    int i;
	sw	zero,44($fp)

	# for (i = 0; i < ch.length; i++)
$loopPutchPixel:
	lw	v0,44($fp)      # Cargo en v0, lo que esta en la dir 44($fp), que es i.
	lw	v1,36($fp)      # Cargo en v1, lo que esta en la dir 36($fp), que es length.
	slt	v0,v0,v1        # Si (i < length), guardo TRUE en v0, sino FALSE.
	bne	v0,FALSE,$insideOfTheLoopPutchPixel # Si no es FALSE, o sea es TRUE, goto $insideOfTheLoopPutchPixel.

	# No cumple condicion para volver a entrar al loop
	b	$failConditionOfTheLoopPutchPixel # Salto incondicional
$insideOfTheLoopPutchPixel:

	# rdo = putch(ch.data[i]);
	lw	v1,44($fp)      # Cargo en v1 lo de esta guardado en la dir 44($fp), que es i.
	addu	v0,$fp,24       # Busco la direccion en donde esta data.
	addu	v0,v0,v1        # Determino la nueva posicion sobre la variable data: Me muevo data+i.
	lb	v0,0(v0)        # Cargo en v0 el contenido de data+i.
	move	a0,v0           # Muevo el dato guardado en v0 a a0.
	la	t9,putch        # Cargo en t9 la la direccion de la funcion putch.
	jal	ra,t9           # Ejecuto la funcion.
	sw	v0,40($fp)      # Guardo el resultado de la funcion, que esta en v0, en la dir 40($fp).

	# (rdo != OKEY)
	lw	v0,40($fp)      # Cargo en v0 lo que hay en la dir 40($fp), que es la variable rdo.
	beq	v0,OKEY,$loopPutchPixelCompletion # If (rdo == OKEY) goto $loopPutchPixelCompletion

	# rdo is nor equals OKEY

	# return rdo;
	lw	v0,40($fp)
	sw	v0,48($fp)      # Guardo el nuevo valor de rdo, que esta en el registro v0, en la dir 48($fp).
	b	$returnLoadPixelBrightness
$loopPutchPixelCompletion:
	
	# i++
	lw	v0,44($fp)
	addu	v0,v0,1
	sw	v0,44($fp)

	b	$loopPutchPixel
$failConditionOfTheLoopPutchPixel:
	# return rdo;
	lw	v0,40($fp)      # Cargo en v0 la variable rdo, que esta en la dir 40($fp).
	sw	v0,48($fp)      # Guardo el nuevo valor de rdo, que esta en el registro v0, en la dir 48($fp).
$returnLoadPixelBrightness:
	lw	v0,48($fp)      # Cargo en v0 la variable rdo, que esta en la dir 48($fp).

	move	sp,$fp
	lw	ra,64(sp)
	lw	$fp,60(sp)

	# destruyo stack frame
	addu	sp,sp,72

	# vuelvo a funcion llamante
	j	ra

	.end	loadPixelBrightness


##-----	loadDataInBuffer -----##

	.text
	.align	2
	.globl	loadDataInBuffer
	.ent	loadDataInBuffer
loadDataInBuffer:
	.frame	$fp,24,ra
	.set	noreorder
	.cpload	t9
	.set	reorder

	# Stack frame creation
	subu	sp,sp,24

	.cprestore 0
	sw	$fp,20(sp)
	sw	gp,16(sp)

	# de aqui al fin de la funcion uso $fp en lugar de sp.
	move	$fp,sp

	# Parametro
	# void loadDataInBuffer(char character)
	move	v0,a0            # Muevo el parametro character, que se encuentra en a0, a v0.
	sb	v0,8($fp)        # Guardo en la dir 8($fp), el contenido de v0, que es character.

	# buffer[quantityCharactersInBuffer] = character;
	lw	v1,quantityCharactersInBuffer # Cargo en v1 la cantidad de caracteres que me voy a 
                                              # mover sobre buffer.
	la	v0,buffer        # Cargo la direccion de inicio de buffer.
	addu	v1,v1,v0         # Guardo en v1 la nueva direccion sobre la variable buffer.
	lbu	v0,8($fp)        # Cargo en v0 el valor de character (un byte), que esta en la dir 8($fp).
	sb	v0,0(v1)         # Guardo en buffer+quantityCharactersInBuffer character

	# quantityCharactersInBuffer++;
	lw	v0,quantityCharactersInBuffer
	addu	v0,v0,1
	sw	v0,quantityCharactersInBuffer

	move	sp,$fp
	lw	$fp,20(sp)

	# destruyo stack frame
	addu	sp,sp,24

	# vuelvo a funcion llamante
	j	ra
	.end	loadDataInBuffer


##-----	writeHeader -----##

	.text
	.align	2
	.globl	writeHeader
	.ent	writeHeader
writeHeader:
	.frame	$fp,120,ra
	.set	noreorder
	.cpload	t9
	.set	reorder

	# Stack frame creation
	subu	sp,sp,120

	.cprestore 16
	sw	ra,112(sp)
	sw	$fp,108(sp)
	sw	gp,104(sp)

	# de aqui al fin de la funcion uso $fp en lugar de sp.
	move	$fp,sp

	# Parametro
	# int writeHeader(unsigned int sizeY, unsigned int sizeX, unsigned int shades)
	sw	a0,120($fp)   # Guardo en la dir 120($fp), el primer parametro que viene en a0, y es
                              # sizeY
	sw	a1,124($fp)   # Guardo en la dir 124($fp), el segundo parametro que viene en a1, y es
                              # sizeX
	sw	a2,128($fp)   # Guardo en la dir 128($fp), el tercer parametro que viene en a2, y es
                              # shades

	sw	sp,92($fp)

	# character chY = convertIntToCharacter(sizeY);
	addu	a0,$fp,24
	lw	a1,120($fp)   # Envio sizeY como parametro.
	la	t9,convertIntToCharacter
	jal	ra,t9
	
	# character chX = convertIntToCharacter(sizeX);
	addu	v0,$fp,40
	move	a0,v0
	lw	a1,124($fp)
	la	t9,convertIntToCharacter
	jal	ra,t9

	# character chShades = convertIntToCharacter(shades);
	addu	v0,$fp,56
	move	a0,v0
	lw	a1,128($fp)
	la	t9,convertIntToCharacter
	jal	ra,t9

	# int quantityCharactersInBufferToLoad = 6 + chX.length + chY.length + chShades.length;
	lw	v1,52($fp)
	lw	v0,36($fp)
	addu	v0,v1,v0
	lw	v0,68($fp)
	addu	v0,v1,v0
	addu	v0,v0,6
	sw	v0,72($fp)    # Guardo en la dir 72($fp) el resultado de la suma, que seria la 
                              # variable quantityCharactersInBufferToLoad.

	# char bufferToLoad [quantityCharactersInBufferToLoad];
	lw	v0,72($fp)
	addu	v0,v0,-1
	addu	v0,v0,1
	addu	v0,v0,7
	srl	v0,v0,3
	sll	v0,v0,3
	subu	sp,sp,v0
	addu	v0,sp,16
	sw	v0,96($fp)     # Guardo en la dir 96($fp) bufferToLoad (la direccion al primer 
                               # elemento del array).

	# bufferToLoad[0] = 'P';
	li	v0,80          # Cargo en v0 el caracter P (80 en ascii).
	lw	v1,96($fp)     # Cargo en v1 bufferToLoad (la direccion al primer 
                               # elemento del array).
	sb	v0,0(v1)       # Guardo en la primer posicion del array, el caracter P (guardado
                               # en v0).

	# bufferToLoad[1] = '2';
	li	v0,50          # Cargo en v0 el caracter 2 (50 en ascii).
	lw	a0,96($fp)
	sb	v0,1(a0)

	# bufferToLoad[2] = '\n';
	li	v0,10          # Cargo en v0 el caracter \n (10 en ascii).
	lw	v1,96($fp)
	sb	v0,2(v1)

	# int idx = 3;
	li	v0,3
	sw	v0,76($fp)     # Guardo en la dir 76($fp) la variable idx inicializada en 3.

	# int i; i = 0;
	sw	zero,80($fp)
$loopWriteHeaderChX:
	# for (i = 0; i < chX.length; i++)
	lw	v0,80($fp)    # Cargo en v0 la variable i, que esta en la dir 80($fp).
	lw	v1,52($fp)    # Cargo en v0 la variable length (de chX), que esta en la dir 52($fp).
	slt	v0,v0,v1
	bne	v0,FALSE,$insideOfTheLoopWriteHeaderChX # Si (i < chX.length) es no es FALSE, o sea 
							# es TRUE, goto $insideOfTheLoopWriteHeaderChX.
	b	$loadSpaceInWriteHeader
$insideOfTheLoopWriteHeaderChX:
	# bufferToLoad[idx] = chX.data[i];

	# bufferToLoad[idx]
	lw	v0,76($fp)
	lw	v1,96($fp)
	addu	a0,v1,v0

	# chX.data[i]
	addu	v1,$fp,40
	lw	v0,80($fp)
	addu	v0,v1,v0
	lbu	v0,0(v0)

	# Hago efectivamente bufferToLoad[idx] = chX.data[i];
	sb	v0,0(a0)
	
	# idx ++;
	lw	v0,76($fp)
	addu	v0,v0,1
	sw	v0,76($fp)

	# i++
	lw	v0,80($fp)
	addu	v0,v0,1
	sw	v0,80($fp)

	b	$loopWriteHeaderChX
$loadSpaceInWriteHeader:
	# bufferToLoad[idx] = ' ';

	# bufferToLoad[idx]
	lw	v0,76($fp)	# Cargo en v0 idx
	lw	a0,96($fp)
	addu	v1,a0,v0

	# ' ' (32 en ascii)
	li	v0,32

	# Hago efectivamente bufferToLoad[idx] = ' ';
	sb	v0,0(v1)

	# idx ++;
	lw	v0,76($fp)
	addu	v0,v0,1
	sw	v0,76($fp)

	# for (i = 0; i < chY.length; i++) 
	# i = 0
	sw	zero,80($fp)
$loopWriteHeaderChY:
	# (i < chY.length) ?
	lw	v0,80($fp)
	lw	v1,36($fp)
	slt	v0,v0,v1
	bne	v0,FALSE,$insideOfTheLoopWriteHeaderChY # Si (i < chX.length) es no es FALSE, o sea 
							# es TRUE, goto $insideOfTheLoopWriteHeaderChY.

	b	$loadLineBreakInWriteHeader
$insideOfTheLoopWriteHeaderChY:
	# bufferToLoad[idx] = chY.data[i];

	# bufferToLoad[idx]
	lw	v0,76($fp)
	lw	v1,96($fp)
	addu	a0,v1,v0

	# chY.data[i]
	lw	v1,80($fp)
	addu	v0,$fp,24
	addu	v0,v0,v1
	lbu	v0,0(v0)

	# Hago efectivamente bufferToLoad[idx] = chY.data[i];
	sb	v0,0(a0)

	# idx ++;
	lw	v0,76($fp)
	addu	v0,v0,1
	sw	v0,76($fp)

	# i++	
	lw	v0,80($fp)
	addu	v0,v0,1
	sw	v0,80($fp)
	
	b	$loopWriteHeaderChY
$loadLineBreakInWriteHeader:
	# bufferToLoad[idx] = '\n';
	lw	v0,76($fp)
	lw	a0,96($fp)
	addu	v1,a0,v0
	li	v0,10             # El salto de linea en ascii es igual a 10 ('\n').
	sb	v0,0(v1)
	
	# idx ++;
	lw	v0,76($fp)
	addu	v0,v0,1
	sw	v0,76($fp)

	# for (i = 0; i < chShades.length; i++)
	# i = 0
	sw	zero,80($fp)	
$loopWriteHeaderChShades:
	# (i < chShades.length) ?
	lw	v0,80($fp)       # Cargo i en v0
	lw	v1,68($fp)       # Cargo chShades.length en v1
	slt	v0,v0,v1
	bne	v0,FALSE,$insideOfTheLoopWriteHeaderChShades # Si (i < chShades.length) es no es FALSE, o sea 
							# es TRUE, goto $insideOfTheLoopWriteHeaderChShades.

	b	$loadLineBreakFinalInWriteHeader

$insideOfTheLoopWriteHeaderChShades:
	# bufferToLoad[idx] = chShades.data[i];

	# bufferToLoad[idx]
	lw	v0,76($fp)
	lw	v1,96($fp)
	addu	a0,v1,v0

	# chShades.data[i]
	addu	v1,$fp,56
	lw	v0,80($fp)
	addu	v0,v1,v0
	lbu	v0,0(v0)

	# Hago efectivamente bufferToLoad[idx] = chShades.data[i];
	sb	v0,0(a0)

	# idx ++;
	lw	v0,76($fp)
	addu	v0,v0,1
	sw	v0,76($fp)

	# i++
	lw	v0,80($fp)
	addu	v0,v0,1
	sw	v0,80($fp)
	b	$loopWriteHeaderChShades
$loadLineBreakFinalInWriteHeader:

	# bufferToLoad[idx] = '\n';
	lw	v0,76($fp)
	lw	a0,96($fp)
	addu	v1,a0,v0
	li	v0,10         # ascii 10 es el salto de linea
	sb	v0,0(v1)

	# int rdoWrite = writeBufferInOFile(bufferToLoad, quantityCharactersInBufferToLoad);
	lw	a0,96($fp)
	lw	a1,72($fp)
	la	t9,writeBufferInOFile
	jal	ra,t9
	sw	v0,84($fp)     # En la dir 84($fp) guardo el rdo de la funcion, que es la 
                               # variable rdoWrite.
	
	# (rdoWrite != OKEY) ?
	lw	v0,84($fp)
	beq	v0,OKEY,$returnOkeyWriteHeader

	# rdoWrite is not equals OKEY
	# closeFile();
	la	t9,closeFile
	jal	ra,t9
	lw	sp,92($fp)
	li	v0,ERROR_WRITE
	sw	v0,88($fp)
	b	$returnWriteHeader
$returnOkeyWriteHeader:
	lw	sp,92($fp)
	sw	zero,88($fp)   # OKEY = zero
$returnWriteHeader:
	lw	v0,88($fp)
	move	sp,$fp
	lw	ra,112(sp)
	lw	$fp,108(sp)

	# destruyo stack frame
	addu	sp,sp,120

	# vuelvo a funcion llamante
	j	ra
	.end	writeHeader


# ---------------------------------------------------------------------------- #

## Variables auxiliares

	.comm	fileOutput,4

	.comm	ofd,4

	.comm	buffer,100

	.data
	
	.align	2
	.type	quantityCharactersInBuffer, @object
	.size	quantityCharactersInBuffer, 4
quantityCharactersInBuffer:
	.space	4


	.rdata

	.align	2
fourFloat:
	.word	1082130432  # 4.0f

