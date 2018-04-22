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


# ---------------------------------------------------------------------------- #

## Variables auxiliares

	.comm	fileOutput,4

	.comm	ofd,4

	.comm	buffer,100

	.rdata

	.align	2
fourFloat:
	.word	1082130432  # 4.0f

