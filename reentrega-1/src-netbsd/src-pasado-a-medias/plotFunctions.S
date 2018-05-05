#include <mips/regdef.h>
#include <sys/syscall.h>

#include "constants.h"

# Offsets and Stack Frames

#define STACK_FRAME_LOAD_PIXEL_BRIGHTNESS 64
#define OFFSET_RA_L_P_B 56
#define OFFSET_FP_L_P_B 52
#define OFFSET_GP_L_P_B 48
#define OFFSET_PIXEL_BRIGHTNESS_L_P_B 64
#define OFFSET_CH_DATA_L_P_B 16
#define OFFSET_RDO_L_P_B 32
#define OFFSET_I_L_P_B 36
#define OFFSET_CH_LENGTH_L_P_B 28
#define OFFSET_RETURN_L_P_B 40

#define STACK_FRAME_MIPS32_PLOT 80
#define OFFSET_RA_M_32_P 72
#define OFFSET_FP_M_32_P 68
#define OFFSET_GP_M_32_P 64
#define OFFSET_PARMS_M_32_P 80
#define OFFSET_C_M_32_P 56
#define OFFSET_Y_M_32_P 52
#define OFFSET_X_M_32_P 48
#define OFFSET_ABSZ_M_32_P 44
#define OFFSET_TI_M_32_P 40
#define OFFSET_TR_M_32_P 36
#define OFFSET_ZI_M_32_P 32
#define OFFSET_ZR_M_32_P 28
#define OFFSET_CI_M_32_P 24
#define OFFSET_CR_M_32_P 20
#define OFFSET_RDO_M_32_P 16


##-----	loadPixelBrightness -----##

	.text
	.align	2
	.globl	loadPixelBrightness
	.ent	loadPixelBrightness
loadPixelBrightness:
	.frame	$fp,STACK_FRAME_LOAD_PIXEL_BRIGHTNESS,ra
	.set	noreorder
	.cpload	t9
	.set	reorder

	# Stack frame creation
	subu	sp,sp,STACK_FRAME_LOAD_PIXEL_BRIGHTNESS

	.cprestore OFFSET_GP_L_P_B
	sw	ra,OFFSET_RA_L_P_B(sp)
	sw	$fp,OFFSET_FP_L_P_B(sp)
	sw	gp,OFFSET_GP_L_P_B(sp)

	# de aqui al fin de la funcion uso $fp en lugar de sp.
	move	$fp,sp

	# Parametro
	# int loadPixelBrightness(unsigned int pixelBrightness)
	sw	a0,OFFSET_PIXEL_BRIGHTNESS_L_P_B($fp)	# Guardo en la direccion OFFSET_PIXEL_BRIGHTNESS_L_P_B($fp) el parametro, 
							# que representa a la variable pixelBrightness.

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

	
	# character ch = convertIntToCharacter(pixelBrightness);
	addu	a0,$fp,OFFSET_CH_DATA_L_P_B	# Cargo en a0 la direccion en donde espero que se guarde
						# el struct retornado por la funcion convertIntToCharacter.
						# Es el primer parametro que espera esta funcion.
	lw	a1,OFFSET_PIXEL_BRIGHTNESS_L_P_B($fp)	# Cargo en a0, la variable pixelBrightness, guardada 
							# en la direccion OFFSET_PIXEL_BRIGHTNESS_L_P_B($fp),
							# que seria el segundo parametro de la funcion.
	la	t9,convertIntToCharacter # Cargo en t9, la direccion de la funcion convertIntToCharacter.
	jal	ra,t9		# Invoco la funcion, salto a convertIntToCharacter.
				# No guardo el valor retornado por la funcion y cargado en v0, porque
				# en el primer parametro especifique la direccion en donde esperaba
				# el struct retornado.
	
	# int rdo = OKEY;
	sw	zero,OFFSET_RDO_L_P_B($fp)	# OKEY = 0

	# int i; i = 0;
	sw	zero,OFFSET_I_L_P_B($fp)
$loopPutchLoadPixelBrightness:
	# for (i = 0; i < ch.length; i++)
	lw	v0,OFFSET_I_L_P_B($fp)	# Cargo en v0 lo guardado en la direccion OFFSET_I_L_P_B($fp), que representa a
					# la variable i.
	lw	v1,OFFSET_CH_LENGTH_L_P_B($fp)	# Cargo en v1 lo guardado en la direccion OFFSET_CH_LENGTH_L_P_B($fp), 
						# que representa a la variable ch.length.

	# (i < ch.length) ?
	slt	v0,v0,v1
	bne	v0,FALSE,$insideOfTheLoopPutchLoadPixelBrightness 	# If (i < ch.length) goto 
									# $insideOfTheLoopPutchLoadPixelBrightness
	b	$loadTheResultToReturn	# Llego a la condicion de corte del loop, por lo cual se va 
					# cargar el resultado a ser retornado.

$insideOfTheLoopPutchLoadPixelBrightness:
	# rdo = putch(ch.data[i]);
	lw	v1,OFFSET_I_L_P_B($fp)	# Cargo en v1 el valor de la variable i, guardado en la direccion 
					# OFFSET_I_L_P_B($fp).
	addu	v0,$fp,OFFSET_CH_DATA_L_P_B	# Cargo en v0 la direccion donde se encuentra el primer elemento 
						# del array ch.data.
	addu	v0,v0,v1	# Me muevo i posiciones sobre ch.data.
	lb	v0,0(v0)	# Cargo el valor de ch.data en la posicion i, en v0.
	move	a0,v0		# Cargo en a0, el valor que tiene v0, que es ch.data[i]. Esto es
				# para pasarlo como parametro a la variable putch.
	la	t9,putch	# Cargo la direccion de la funcion putch.
	jal	ra,t9		# Ejecuto la funcion putch.
	sw	v0,OFFSET_RDO_L_P_B($fp)	# Guardo en la direccion OFFSET_RDO_L_P_B($fp), que representa a 
						# la variable rdo, lo retornado por la funcion putch.

	# (rdo != OKEY) ?
	lw	v0,OFFSET_RDO_L_P_B($fp)	# Cargo en v0 lo guardado en la direccion OFFSET_RDO_L_P_B($fp)
	beq	v0,OKEY,$incrementInLoopPutchLoadPixelBrightness	# If (rdo == OKEY) goto
									#  $incrementInLoopPutchLoadPixelBrightness

	# rdo is not OKEY
	lw	v0,OFFSET_RDO_L_P_B($fp)	# Cargo en v0 lo guardado en la direccion OFFSET_RDO_L_P_B($fp), que 
						# representa la variable rdo.
	sw	v0,OFFSET_RETURN_L_P_B($fp)	# Guardo en la direccion OFFSET_RETURN_L_P_B($fp), el valor de rdo, que va
						# a ser donde se guarde el resultado de la funcion.
	b	$returnLoadPixelBrightness	# Salto incondicional para hacer el return de la funcion.
$incrementInLoopPutchLoadPixelBrightness:
	# i++
	lw	v0,OFFSET_I_L_P_B($fp)
	addu	v0,v0,1
	sw	v0,OFFSET_I_L_P_B($fp)

	b	$loopPutchLoadPixelBrightness
$loadTheResultToReturn:
	lw	v0,OFFSET_RDO_L_P_B($fp)	# Cargo en v0 lo guardado en la direccion OFFSET_RDO_L_P_B($fp), 
						# que representa la variable rdo.
	sw	v0,OFFSET_RETURN_L_P_B($fp)	# Guardo en la direccion OFFSET_RETURN_L_P_B($fp), el valor de rdo, 
						# que va a ser donde se guarde el resultado de la funcion.
$returnLoadPixelBrightness:
	lw	v0,OFFSET_RETURN_L_P_B($fp)	# Cargo en v0 lo guardado en la direccion OFFSET_RETURN_L_P_B($fp), 
						# que representa el resultado de la funcion.

	# reconstruyo los registros.
	move	sp,$fp
	lw	ra,OFFSET_RA_L_P_B(sp)
	lw	$fp,OFFSET_FP_L_P_B(sp)

	# destruyo stack frame
	addu	sp,sp,STACK_FRAME_LOAD_PIXEL_BRIGHTNESS

	# vuelvo a funcion llamante
	j	ra

	.end	loadPixelBrightness


##-----	mips32_plot -----##

	.text
	.align	2
	.globl	mips32_plot
	.ent	mips32_plot
mips32_plot:
	.frame	$fp,STACK_FRAME_MIPS32_PLOT,ra
	.set	noreorder
	.cpload	t9
	.set	reorder

	# Stack frame creation
	subu	sp,sp,STACK_FRAME_MIPS32_PLOT

	.cprestore OFFSET_GP_M_32_P
	sw	ra,OFFSET_RA_M_32_P(sp)
	sw	$fp,OFFSET_FP_M_32_P(sp)
	sw	gp,OFFSET_GP_M_32_P(sp)

	# de aqui al fin de la funcion uso $fp en lugar de sp.
	move	$fp,sp

	# Parametro
	# void mips32_plot(param_t * parms)
	sw	a0,OFFSET_PARMS_M_32_P($fp)	# Guardo en la dir OFFSET_PARMS_M_32_P($fp), la direccion de parms (param_t * parms).

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
	lw	v0,OFFSET_PARMS_M_32_P($fp)	# Cargo en v0, la dir a la que apunta parms.
	lw	a0,44(v0)	# Cargo en a0, la dir a la que apunta parms + 44 (que es FILE *),
				# que seria el parametro de la funcion.
	la	t9,initFile	# Cargo en t9 la direccion de la funcion initFile.
	jal	ra,t9		# Ejecuto la funcion initFile.

	# int rdo = loadFileDescriptor();
	la	t9,loadFileDescriptor	# Cargo en t9 la direccion de la funcion loadFileDescriptor.
	jal	ra,t9			# Ejecuto la funcion loadFileDescriptor.
	sw	v0,OFFSET_RDO_M_32_P($fp)	# Guardo en la direccion OFFSET_RDO_M_32_P($fp) el resultado
						# de la funcion loadFileDescriptor que representa la variable rdo.

	# (rdo != OKEY) ?
	lw	v0,OFFSET_RDO_M_32_P($fp)	# Cargo en v0 lo guardado en la direccion OFFSET_RDO_M_32_P($fp), 
						# que representa la variable rdo.
	beq	v0,OKEY,$writeHeader		# If (rdo == OKEY) goto $writeHeader

	# rdo is not OKEY
	b	$returnMips32Plot	# Salto incondicional a $returnMips32Plot.
$writeHeader:
	# rdo = writeHeader((unsigned)parms->y_res, (unsigned)parms->x_res, (unsigned)(parms->shades - 1));
	lw	v1,OFFSET_PARMS_M_32_P($fp)	# Cargo en v1, la dir a la que apunta parms. Me preparo para cargar parms->y_res
	lw	a1,OFFSET_PARMS_M_32_P($fp)	# Cargo en a1, la dir a la que apunta parms.
	lw	v0,OFFSET_PARMS_M_32_P($fp)	# Cargo en v0, la dir a la que apunta parms. Me preparo para cargar parms->shades.

	# (parms->shades - 1)
	lw	v0,40(v0)	# Cargo en v0, el contenido apuntado por *parms + 40, que seria shades (parms->shades).
	addu	v0,v0,-1	# A shades le resto 1. Guardo en v0 el resultado de parms->shades - 1.
	move	a2,v0		# Muevo a a2, el contenido de v0, que es el resultado de parms->shades - 1. Lo cargo 
				# en a2 porque es el tercer parametro pasado a la funcion writeHeader.

	# (parms->y_res)
	lw	a0,36(v1)	# Cargo en a0, lo apuntado por *parms + 36, que seria y_res (parms->y_res). Lo cargo 
				# en a0 porque es el primer parametro pasado a la funcion writeHeader.

	# (parms->x_res)
	lw	a1,32(a1)	# Cargo en a1, lo apuntado por *parms + 32, que seria y_res (parms->x_res). Lo cargo 
				# en a1 porque es el segundo parametro pasado a la funcion writeHeader.


	la	t9,writeHeader	# Cargo en t9, la direccion de la funcion writeHeader.
	jal	ra,t9		# Ejecuto la funcion writeHeader.
	sw	v0,OFFSET_RDO_M_32_P($fp)	# Guardo el resultado de la funcion writeHeader, que es la variable
						# rdo, en la direccion OFFSET_RDO_M_32_P($fp).

	# (rdo != OKEY) ?
	lw	v0,OFFSET_RDO_M_32_P($fp)	# Cargo en v0, rdo, guardado en la direccion OFFSET_RDO_M_32_P($fp).
	beq	v0,OKEY,$loopPixelInMips32Plot 	# If (rdo == OKEY) goto $loopPixelInMips32Plot.

	# rdo is not equal to OKEY
	b	$returnMips32Plot	# Salto incondicional a $returnMips32Plot.
$loopPixelInMips32Plot:
	# for (y = 0, ci = parms->UL_im; y < parms->y_res; ++y, ci -= parms->d_im)

	# y = 0
	sw	zero,OFFSET_Y_M_32_P($fp)	# Guardo en la direccion OFFSET_Y_M_32_P($fp) el valor 0, 
						# que seria y = 0.

	# ci = parms->UL_im
	lw	v0,OFFSET_PARMS_M_32_P($fp)	# Cargo en v0 la dir apuntada por parms (* parms), guardada 
						# en la dir OFFSET_PARMS_M_32_P($fp).
	l.s	$f0,4(v0)			# Cargo en f0 lo apuntado por *parms + 4, que es UL_im (es float).
	s.s	$f0,OFFSET_CI_M_32_P($fp)	# Guardo en la dir OFFSET_CI_M_32_P($fp) el valor guardado 
						# en f0, que es UL_im (float), que seria ci.
$loopInYInMips32Plot:
	# (y < parms->y_res) ?
	lw	v0,OFFSET_PARMS_M_32_P($fp)	# Cargo en v0 la direccion apuntada por parms (* parms), guardada 
						# en la direccion OFFSET_PARMS_M_32_P($fp).
	lw	v1,OFFSET_Y_M_32_P($fp)		# Cargo en v1 y, guardado en la dir OFFSET_Y_M_32_P($fp).
	lw	v0,36(v0)			# Cargo en v0, lo apuntado por *parms + 36, que seria y_res (parms->y_res).
	sltu	v0,v1,v0			# Guardo en v0 TRUE si (y < parms->y_res), sino guardo FALSE.
	bne	v0,FALSE,$loopInXInMips32Plot	# Si no es FALSE, es TRUE, continuo el for, salto a $loopInXInMips32Plot.

	b	$flushRestDataInMips32Plot	# Salto incondicional a $flushRestDataInMips32Plot.
$loopInXInMips32Plot:
	# for (x = 0, cr = parms->UL_re; x < parms->x_res; ++x, cr += parms->d_re)
	
	# x = 0
	sw	zero,OFFSET_X_M_32_P($fp)	# Guardo en la direccion OFFSET_X_M_32_P($fp) el valor 0, que seria x = 0.

	# cr = parms->UL_re
	lw	v0,OFFSET_PARMS_M_32_P($fp)	# Cargo en v0 la dir apuntada por parms (* parms), 
						# guardada en la dir OFFSET_PARMS_M_32_P($fp).
	l.s	$f0,0(v0)	# Cargo en f0 lo apuntado por *parms, que es UL_re (es float).
	s.s	$f0,OFFSET_CR_M_32_P($fp)	# Guardo en la direccion OFFSET_CR_M_32_P($fp) el valor guardado 
						# en f0, que es UL_re (float), que seria cr.
$conditionLoopInXInMips32Plot:
	# (x < parms->x_res) ?
	lw	v0,OFFSET_PARMS_M_32_P($fp)	# Cargo en v0 la direccion apuntada por parms (* parms), guardada 
						# en la direccion OFFSET_PARMS_M_32_P($fp).
	lw	v1,OFFSET_X_M_32_P($fp)		# Cargo en v1 lo guardado en la direccion OFFSET_X_M_32_P($fp), que seria x.
	lw	v0,32(v0)		# Cargo en v0 lo guardado en la direccion *parms+32, que es x_res.
	sltu	v0,v1,v0		# Guardo en v0 TRUE si (x < parms->x_res), sino guardo FALSE.
	bne	v0,zero,$insideOfTheLoopInXInMips32Plot # Si no es FALSE, es TRUE, continuo dentro del for, 
							# salto a $insideOfTheLoopInXInMips32Plot.

	# x is not less than parms->x_res
	b	$putLineBreakInMips32Plot	# Salto incondicional a $putLineBreakInMips32Plot.
$insideOfTheLoopInXInMips32Plot:
	# zr = cr;
	l.s	$f0,OFFSET_CR_M_32_P($fp)	# Cargo en f0 lo guardado en la direccion OFFSET_CR_M_32_P($fp), 
						# que es cr (es float).
	s.s	$f0,OFFSET_ZR_M_32_P($fp)	# Guardo en la direccion OFFSET_ZR_M_32_P($fp), que representa 
						# a zr, lo que tiene f0.

	# zi = ci;
	l.s	$f0,OFFSET_CI_M_32_P($fp)	# Cargo en f0 lo guardado en la direccion OFFSET_CI_M_32_P($fp), 
						# que es ci (es float).
	s.s	$f0,OFFSET_ZI_M_32_P($fp)	# Guardo en la dir OFFSET_ZI_M_32_P($fp), que representa a zi, 
						# lo que tiene f0.

	# for (c = 0; c < parms->shades; ++c)

	# c = 0
	sw	zero,OFFSET_C_M_32_P($fp)	# Guardo en la direccion OFFSET_C_M_32_P($fp) el valor 0, que 
						# representa a la variable c.
$loopShadesInMips32Plot:
	# (c < parms->shades) ?
	lw	v0,OFFSET_PARMS_M_32_P($fp)	# Cargo en v0 la direccion apuntada por parms (* parms), guardada 
						# en la direccion OFFSET_PARMS_M_32_P($fp).
	lw	v1,OFFSET_C_M_32_P($fp)		# Cargo en v1 lo guardado en la direccion OFFSET_C_M_32_P($fp), 
						# que seria c.
	lw	v0,40(v0)	# Cargo en v0 lo guardado en la dir *parms+40, que es shades.
	sltu	v0,v1,v0	# Guardo en v0 TRUE si (c < parms->shades), sino guardo FALSE.
	bne	v0,FALSE,$insideOfTheLoopShadesInMips32Plot # Si no es FALSE, es TRUE, continuo dentro 
							    # del for, salto a $insideOfTheLoopShadesInMips32Plot.

	# c is not less than parms->shades
	b	$savePixelBrightnessInMips32Plot	# Salto incondicional a $savePixelBrightnessInMips32Plot.
$insideOfTheLoopShadesInMips32Plot:
	# ((absz = zr*zr + zi*zi) >= 4.0f) ?

	# (absz = zr*zr + zi*zi)

	# zr*zr
	l.s	$f2,OFFSET_ZR_M_32_P($fp)	# Cargo en f2 lo guardado en la direccion OFFSET_ZR_M_32_P($fp), 
						# que es zr (es float).
	l.s	$f0,OFFSET_ZR_M_32_P($fp)	# Cargo en f0 lo guardado en la direccion OFFSET_ZR_M_32_P($fp), 
						# que es zr (es float).
	mul.s	$f4,$f2,$f0	# Multiplico lo guardado en f0 con lo guardado en f2, y guardo rdo en f4.

	# zi*zi
	l.s	$f2,OFFSET_ZI_M_32_P($fp)	# Cargo en f2 lo guardado en la direccion OFFSET_ZI_M_32_P($fp), 
						# que es zi (es float).
	l.s	$f0,OFFSET_ZI_M_32_P($fp)	# Cargo en f0 lo guardado en la dir OFFSET_ZI_M_32_P($fp), 
						# que es zi (es float).
	mul.s	$f0,$f2,$f0	# Multiplico lo guardado en f0 con lo guardado en f2, y guardo rdo en f0.

	# absz = zr*zr + zi*zi
	add.s	$f0,$f4,$f0	# Sumo lo guardado en f0 (zi*zi), con lo guardado en f4 (zr*zr), y guardo rdo en f0.
	mov.s	$f2,$f0		# Muevo el rdo de f0 a f2.
	s.s	$f2,OFFSET_ABSZ_M_32_P($fp)	# Guardo el resultado de la suma en la dir OFFSET_ABSZ_M_32_P($fp), 
						# que representa a la variable absz.

	l.s	$f0,fourFloat	# Cargo en f0 el valor 4.0f (cargado en la variable fourFloat).
	c.le.s	$f0,$f2		# Comparo absz con 4.0f. Si [f0 (4.0f) <= f2 (absz)], coloca el indicador de condicion 
				# en TRUE, sino en FALSE.
	bc1t	$savePixelBrightnessInMips32Plot

	# (absz = zr*zr + zi*zi) is >= 4.0f

	# A continuacion se va a hacer: tr = parms->s_re + zr * zr - zi * zi;

	# zr * zr
	l.s	$f2,OFFSET_ZR_M_32_P($fp)	# Cargo en f2 lo guardado en la direccion OFFSET_ZR_M_32_P($fp), 
						# que es zr (es float).
	l.s	$f0,OFFSET_ZR_M_32_P($fp)	# Cargo en f0 lo guardado en la dir OFFSET_ZR_M_32_P($fp), 
						# que es zr (es float).
	mul.s	$f2,$f2,$f0	# Multiplico lo guardado en f0 con lo guardado en f2, y guardo rdo en f2.

	# parms->s_re
	lw	v0,OFFSET_PARMS_M_32_P($fp)	# Cargo en v0 la direccion apuntada por parms (* parms), guardada 
						# en la dir OFFSET_PARMS_M_32_P($fp).
	l.s	$f0,24(v0)	# Cargo en f0 lo guardado en la direccion *parms+24, que es s_re (es float).

	# parms->s_re + zr * zr
	add.s	$f4,$f2,$f0	# Guardo resultado de la suma en f4. Guardo el resultado parcial de la suma.

	# zi * zi
	l.s	$f2,OFFSET_ZI_M_32_P($fp)	# Cargo en f2 lo guardado en la direccion OFFSET_ZI_M_32_P($fp), 
						# que es zi (es float).
	l.s	$f0,OFFSET_ZI_M_32_P($fp)	# Cargo en f0 lo guardado en la direccion OFFSET_ZI_M_32_P($fp), 
						# que es zi (es float).
	mul.s	$f0,$f2,$f0	# Multiplico lo guardado en f0 con lo guardado en f2, y guardo rdo en f0.

	# Hago efectivamente tr = parms->s_re + zr * zr - zi * zi;
	sub.s	$f0,$f4,$f0	# Sumo lo que tiene f0 (resultado de zi * zi) y f4 (resultado de 
				# parms->s_re + zr * zr); guardo resultado de la suma en f0.
	s.s	$f0,OFFSET_TR_M_32_P($fp)	# Guardo el resultado de la resta (f0), en la direccion 
						# OFFSET_TR_M_32_P($fp), representa a tr.

	# A continuacion hago: ti = parms->s_im + zr * zi * 2.0f;

	# zr * zi
	l.s	$f2,OFFSET_ZR_M_32_P($fp)	# Cargo en f2 lo guardado en la direccion OFFSET_ZR_M_32_P($fp), 
						# que es zr (es float).
	l.s	$f0,OFFSET_ZI_M_32_P($fp)	# Cargo en f0 lo guardado en la direccion OFFSET_ZI_M_32_P($fp), 
						# que es zi (es float).
	mul.s	$f0,$f2,$f0	# Multiplico lo guardado en f0 (zi) con lo guardado en f2 (zr), y guardo rdo en f0.

	# Hago (zr * zi * 2.0f)  lo que es igual a hacer (zr * zi + zr * zi)
	add.s	$f2,$f0,$f0

	# parms->s_im
	lw	v0,OFFSET_PARMS_M_32_P($fp)	# Cargo en v0 la direccion apuntada por parms (* parms), 
						# guardada en la dir OFFSET_PARMS_M_32_P($fp).
	l.s	$f0,28(v0)			# Cargo en f0 lo guardado en la dir *parms+28, que es s_im (es float).

	# Hago efectivamente: ti = parms->s_im + zr * zi * 2.0f;
	add.s	$f0,$f0,$f2			# Sumo lo que tiene f0 (parms->s_im) con lo que tiene f2 (zr * zi * 2.0f); 
						# y guardo el resultado en f0.
	s.s	$f0,OFFSET_TI_M_32_P($fp)	# Guardo el resultado de la suma (f0) en la direccion 
						# OFFSET_TI_M_32_P($fp), que representa a la variable ti.

	# zr = tr;
	l.s	$f0,OFFSET_TR_M_32_P($fp)	# Cargo en f0 lo guardado en la direccion OFFSET_TR_M_32_P($fp), 
						# que representa a la variable tr.
	s.s	$f0,OFFSET_ZR_M_32_P($fp)	# Guardo en la direccion OFFSET_ZR_M_32_P($fp), que representa a 
						# la variable zr, lo que tiene f0 (valor de tr).

	# zi = ti;
	l.s	$f0,OFFSET_TI_M_32_P($fp)	# Cargo en f0 lo guardado en la direccion OFFSET_TI_M_32_P($fp), 
						# que representa a la variable ti.
	s.s	$f0,OFFSET_ZI_M_32_P($fp)	# Guardo en la direccion OFFSET_ZI_M_32_P($fp), que representa a 
						# la variable zi, lo que tiene f0 (valor de ti).

	# ++c
	lw	v0,OFFSET_C_M_32_P($fp)		# Cargo en v0 lo guardado en la direccion OFFSET_C_M_32_P($fp), 
						# que es la variable c.
	addu	v0,v0,1				# Incremento en 1 a la variable c, cargada en v0. Guardo el resultado en v0.
	sw	v0,OFFSET_C_M_32_P($fp)		# Guardo en la direccion OFFSET_C_M_32_P($fp), el nuevo valor de c, 
						# cargado en v0.

	b	$loopShadesInMips32Plot	# Salto incondicional a $loopShadesInMips32Plot.
$savePixelBrightnessInMips32Plot:
	# rdo = loadPixelBrightness((unsigned)c);
	lw	a0,OFFSET_C_M_32_P($fp)		# Cargo en a0 lo guardado en la direccion OFFSET_C_M_32_P($fp), variable c, 
						# que va a ser el parametro de la funcion loadPixelBrightness.
	la	t9,loadPixelBrightness		# Cargo en t9 la direccion de la funcion loadPixelBrightness.
	jal	ra,t9				# Ejecuto la funcion loadPixelBrightness.
	sw	v0,OFFSET_RDO_M_32_P($fp)	# Guardo en la direccion OFFSET_RDO_M_32_P($fp) el resultado de 
						# ejecutar la funcion loadPixelBrightness, valor que se encuentra en v0.

	# (rdo != OKEY) ?
	lw	v0,OFFSET_RDO_M_32_P($fp)	# Cargo en v0 lo guardado en la direccion OFFSET_RDO_M_32_P($fp), 
						# que representa la variable rdo.
	beq	v0,OKEY,$putSpaceInMips32Plot

	# rdo is not equals OKEY

	# closeFile(parms->fp);
	lw	v0,OFFSET_PARMS_M_32_P($fp)	# Cargo en v0 la direccion apuntada por parms, que esta guardada 
						# en la direccion OFFSET_PARMS_M_32_P($fp).
	lw	a0,44(v0)	# Cargo en a0 la direccion apuntada por parms+44, que es parms->fp. Es el parametro de 
				# la funcion closeFile.
	la	t9,closeFile	# Cargo en t9 la direccion de la funcion closeFile.
	jal	ra,t9		# Ejecuto la funcion closeFile.

	b	$returnMips32Plot	# Salto incondicional a $returnMips32Plot.
$putSpaceInMips32Plot:
	# rdo = putch(' ');
	li	a0,32		# Cargo en a0 el espacio, que en ascii es el codigo 32. Es el parametro de la funcion putch.
	la	t9,putch	# Cargo en t9 la direccion de la funcion putch.
	jal	ra,t9		# Ejecuto la funcion putch.
	sw	v0,OFFSET_RDO_M_32_P($fp)	# Guardo en la direccion OFFSET_RDO_M_32_P($fp) lo que tiene v0, 
						# que es el resultado de la funcion putch (rdo).

	# (rdo != OKEY) ?
	lw	v0,OFFSET_RDO_M_32_P($fp)	# Cargo en v0 lo que hay en la direccion OFFSET_RDO_M_32_P($fp), que es la variable rdo.
	beq	v0,OKEY,$loopInXCompletionInMips32Plot # If (rdo == OKEY) goto $loopInXCompletionInMips32Plot.

	# rdo is not equals OKEY

	# closeFile();
	la	t9,closeFile	# Cargo en t9 la direccion de la funcion closeFile.
	jal	ra,t9		# Ejecuto la funcion closeFile.

	b	$returnMips32Plot	# Salto incondicional a $returnMips32Plot.
$loopInXCompletionInMips32Plot:
	# ++x, cr += parms->d_re

	# ++x
	lw	v0,OFFSET_X_M_32_P($fp)	# Cargo en v0 lo guardado en la direccion OFFSET_X_M_32_P($fp), que es la variable x.
	addu	v0,v0,1			# Incremento la variable x en 1, y guardo el resultado en el registro v0.
	sw	v0,OFFSET_X_M_32_P($fp)	# Guardo el valor actualizado de x, en al direccion OFFSET_X_M_32_P($fp).

	# cr += parms->d_re
	l.s	$f2,OFFSET_CR_M_32_P($fp)	# Cargo en f2 lo guardado en la direccion OFFSET_CR_M_32_P($fp), 
						# que es la variable cr.
	lw	v0,OFFSET_PARMS_M_32_P($fp)	# Cargo en v0 la direccion guardada en la direccion OFFSET_PARMS_M_32_P($fp), 
						# que es *parms.
	l.s	$f0,16(v0)			# Cargo en f0 lo guardado en la direccion *parms+16, que es parms->d_re.
	add.s	$f0,$f2,$f0			# Hago la suma entre lo que tiene f2 (cr) y lo que tiene f0 (parms->d_re). 
						# Se guarda resultado en f0.
	s.s	$f0,OFFSET_CR_M_32_P($fp)	# Guardo en la direccion OFFSET_CR_M_32_P($fp) lo que tiene f0, que es 
						# el resultado de la suma, y que representa a la variable cr.

	b	$conditionLoopInXInMips32Plot	# Salto incondicional a $conditionLoopInXInMips32Plot.
$putLineBreakInMips32Plot:
	# rdo = putch('\n');
	li	a0,10		# Cargo en a0 el caracter \n, que en ascii es el codigo 10. Es el parametro de la funcion putch.
	la	t9,putch	# Cargo en t9 la direccion de la funcion putch.
	jal	ra,t9		# Ejecuto la funcion putch.
	sw	v0,OFFSET_RDO_M_32_P($fp)	# Guardo en la direccion OFFSET_RDO_M_32_P($fp) lo que tiene v0, resultado 
						# de la funcion putch, que representa la variable rdo.

	# (rdo != OKEY) ?
	lw	v0,OFFSET_RDO_M_32_P($fp)	# Cargo en v0 lo que hay guardado en la direccion OFFSET_RDO_M_32_P($fp), que 
						# representa la variable rdo, para validar el resultado de ejecutar la funcion putch.
	beq	v0,OKEY,$closeLoopInYInMips32Plot # If (rdo == OKEY) goto $closeLoopInYInMips32Plot.

	# rdo is not OKEY

	# closeFile();
	la	t9,closeFile	# Cargo en t9 la direccion de la funcion closeFile.
	jal	ra,t9		# Ejecuto la funcion closeFile.

	b	$returnMips32Plot	# Salto incondicional a $returnMips32Plot.
$closeLoopInYInMips32Plot:
	# ++y, ci -= parms->d_im
	
	# ++y
	lw	v0,OFFSET_Y_M_32_P($fp)		# Cargo en v0 lo guardado en la direccion OFFSET_Y_M_32_P($fp), 
						# que representa la variable y.
	addu	v0,v0,1				# Incremento en 1 a la variable y (guardada en el registro v0).
	sw	v0,OFFSET_Y_M_32_P($fp)		# Guardo el valor de y actualizado en la direccion OFFSET_Y_M_32_P($fp).

	# ci -= parms->d_im 
	l.s	$f2,OFFSET_CI_M_32_P($fp)	# Cargo en f2 lo guardado en la direccion OFFSET_CI_M_32_P($fp), que 
						# representa a la variable ci.
	lw	v0,OFFSET_PARMS_M_32_P($fp)	# Cargo en v0 lo guardado en la direccion OFFSET_PARMS_M_32_P($fp), que representa a *parms.
	l.s	$f0,20(v0)			# Cargo en f0 lo guardado en la direccion *parms+20, que es parms->d_im.
	sub.s	$f0,$f2,$f0			# Resto lo que tiene el registro f2 (ci) con lo que tiene el registro 
						# f0 (parms->d_im). Guardo resultado en el registro f0.
	s.s	$f0,OFFSET_CI_M_32_P($fp)	# Guardo en la direccion OFFSET_CI_M_32_P($fp) lo que tiene el registro f0, que es 
						# resultado de la resta. Se actualiza el valor de la variable ci.

	b	$loopInYInMips32Plot	# Salto incondicional a $loopInYInMips32Plot.
$flushRestDataInMips32Plot:
	# flush();
	la	t9,flush	# Cargo en t9 la direccion de la funcion flush.
	jal	ra,t9		# Ejecuto la funcion flush.

	# closeFile();
	la	t9,closeFile	# Cargo en t9 la direccion de la funcion closeFile.
	jal	ra,t9		# Ejecuto la funcion closeFile.
$returnMips32Plot:
	# reconstruyo los registros.
	move	sp,$fp
	lw	ra,OFFSET_RA_M_32_P(sp)
	lw	$fp,OFFSET_FP_M_32_P(sp)

	# destruyo stack frame
	addu	sp,sp,STACK_FRAME_MIPS32_PLOT

	# vuelvo a funcion llamante
	j	ra

	.end	mips32_plot


# ---------------------------------------------------------------------------- #

## Variables auxiliares


	.rdata
	.align	2
fourFloat:
	.float 4





