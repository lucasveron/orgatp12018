#include <mips/regdef.h>
#include <sys/syscall.h>


#include "constants.h"


##-----	convertIntToCharacter -----##

	.text
	.align	2
	.globl	convertIntToCharacter
	.ent	convertIntToCharacter
convertIntToCharacter:
	.frame	$fp,56,ra
	.set	noreorder
	.cpload	t9
	.set	reorder

	# Stack frame creation
	subu	sp,sp,56

	.cprestore 0
	sw	$fp,52(sp)
	sw	gp,48(sp)

	# de aqui al fin de la funcion uso $fp en lugar de sp.
	move	$fp,sp

	# Parametro
	# character convertIntToCharacter(unsigned int number)
	sw	a0,56($fp)	# Guardo en la direccion 56($fp) el primer parametro, que 
				# representa la direccion en la cual la funcion llamante espera
				# el valor retornado.
	sw	a1,60($fp)	# Guardo en la direccion 60(fp) el numero a ser convertido a 
				# caracter, representado por la variable number.

	# oneCharacter.length = 0;
	sw	zero,20($fp)	# Guardo cero en la direccion 20($fp), que representa a la variable
				# oneCharacter.length.

	# int i = 0;
	sw	zero,24($fp)	# Guardo cero en la direccion 24($fp), que representa a la variable i.

	# (number == 0) ?
	lw	v0,60($fp)	# Cargo en v0 lo guardado en la direccion 60($fp), que seria la variable
				# number (parametro, valor a transformar en caracter).
	bne	v0,zero,$numberIsNotZeroInConvertIntToCh  # If (number != 0) goto $numberIsNotZeroInConvertIntToCh.

	# number is equals to zero

	#################
	# Ascii = Nro   #
	#  48   = 0     #
	#################

	# oneCharacter.data[i] = 48;
	lw	v1,24($fp)	# Cargo en v1 lo guardado en la direccion 24($fp), que seria la variable i.
	addu	v0,$fp,8	# Me muevo 8 posiciones sobre el stack frama (desde la posicion inicial). Cargo
				# nueva posicion en v0. Esto es para obtener la direccion guardada en la posicion inicial
				# de oneCharacter.data.
	addu	v1,v0,v1	# A la direccion guardada en la posicion inicial de oneCharacter.data, le sumo lo que
				# tiene v1 (que es i); y guardo el resultado en v1. Esto seria:
				# oneCharacter.data[i] = oneCharacter.data + i
	li	v0,48		# Cargo en v0 el valor 48, que representa el numero 0 en ascii (caracter).
	sb	v0,0(v1)	# Guardo en la posicion determinada anteriormente de oneCharacter.data el valor 48.
				# O sea, hago efectivamente: oneCharacter.data[i] = 48

	# i ++;
	lw	v0,24($fp)	# Cargo en v0 lo guardado en la direccion 24($fp), que seria la variable i.
	addu	v0,v0,1		# Incremento en 1 a i, y guardo resultado en v0.
	sw	v0,24($fp)	# Actualizo el nuevo valor de i.

	b	$setLengthInConvertIntToCh	# Salto incondicional a $setLengthInConvertIntToCh.
$numberIsNotZeroInConvertIntToCh:
	# int rest = 0;
	sw	zero,28($fp)	# Guardo cero en la direccion 28($fp). Representaria la inicializacion de la
				# variable rest.
$whileConvertIntToCh:
	# while (i < MAX_LENGTH_CHARACTER && number != 0)

	# Divido por 10, porque esta en base 10
	# Me deja el numero invertido

	# (i < MAX_LENGTH_CHARACTER) ?
	lw	v0,24($fp)	# Cargo en v0 lo guardado en la direccion 24($fp), que representa a la variable i.
	slt	v0,v0,MAX_LENGTH_CHARACTER	# Guardo en v0 TRUE si (i < MAX_LENGTH_CHARACTER), sino guardo FALSE.
	beq	v0,FALSE,$setLengthInConvertIntToCh # If (i >= MAX_LENGTH_CHARACTER) goto $setLengthInConvertIntToCh.

	# i is less than MAX_LENGTH_CHARACTER

	# (number != 0) ?
	lw	v0,60($fp)	# Cargo en v0 lo guardado en la direccion 60($fp), que seria la variable number.
	bne	v0,zero,$insideOfTheWhileConvertIntToCh	# If (number != 0) goto $insideOfTheWhileConvertIntToCh.

	# number is equals to 0.
	b	$setLengthInConvertIntToCh	# Salto incondicional a $setLengthInConvertIntToCh.
$insideOfTheWhileConvertIntToCh:
	# rest = number % 10;
	lw	v0,60($fp)	# Cargo en v0 lo guardado en la direccion 60($fp), que seria la variable number.
	li	v1,10		# Cargo en v1 el inmediato 10.

	# divu   s,t  	
	# siendo s y t registros      
	#  lo <— s div t
        #  hi <— s mod t
        #  operands are unsigned

	divu	v0,v1		# Hago la division entre number y 10. En el registro v0 quedo el cociente.
				# Mientras que en v1 quedo el resto.
	sw	v1,28($fp)	# Guardo el resto de la division (cargado en v1) en la direccion 28($fp),
				# que representa a la variable rest.

	#################
	# Ascii = Nro	#
	#   48  = 0	#
	#   57  = 9	#
	#################

	# Voy a hacer: oneCharacter.data[i] = rest + 48;

	# oneCharacter.data[i]
	lw	v1,24($fp)	# Cargo en v1 lo guardado en la direccion 24($fp), que representa
				# a la variable i.
	addu	v0,$fp,8	# Me muevo 8 posiciones sobre el stack frama (desde la posicion inicial). Cargo
				# nueva posicion en v0. Esto es para obtener la direccion guardada en la posicion inicial
				# de oneCharacter.data.
	addu	v1,v0,v1	# A la direccion guardada en la posicion inicial de oneCharacter.data, le sumo lo que
				# tiene v1 (que es i); y guardo el resultado en v1. Esto seria:
				# oneCharacter.data[i] = oneCharacter.data + i

	# rest + 48;
	lbu	v0,28($fp)	# Cargo en v0 lo guardado en la direccion 28($fp), que seria la variable rest.
	addu	v0,v0,48	# A la variable rest le sumo 48. Guardo resultado en v0. Esto es para convertir el
				# numero en base 10 en caracter ascii.

	# Hago efectivamente: oneCharacter.data[i] = rest + 48;
	sb	v0,0(v1)	# Guardo el resultado de la conversion en el array data.

	# number /= 10;
	lw	v1,60($fp)	# Cargo en v0 lo guardado en la direccion 60($fp), que seria la variable number.
	li	v1,10		# Cargo en v1 el inmediato 10.

	# divu   s,t  	
	# siendo s y t registros      
	#  lo <— s div t
        #  hi <— s mod t
        #  operands are unsigned

	divu	v0,v1		# Hago la division entre number y 10. En el registro v0 quedo el cociente.
				# Mientras que en v1 quedo el resto.
	sw	v0,60($fp)	# Actualizo el valor de la variable number. Guardo en la direccion 60($fp),
				# donde esta number, el cociente de la division por 10.
	
	# i ++;
	lw	v0,24($fp)	# Cargo en v0 lo guardado en la direccion 24($fp), que seria la variable i.
	addu	v0,v0,1		# Incremento en 1 la variable i. El resultado del incremento esta en v0.
	sw	v0,24($fp)	# Guardo en la direccion 24($fp) el resultado del incremento. O sea, se 
				# actualiza el valor de i en la memoria.

	b	$whileConvertIntToCh	# Salto incondicional a $whileConvertIntToCh
$setLengthInConvertIntToCh:
	# oneCharacter.length = i;
	lw	v0,24($fp)	# Cargo en v0 el valor guardado en la direccion 24($fp), que representa a 
				# la variable i.
	sw	v0,20($fp)	# Guardo lo que tiene v0 (i) en la direccion 20($fp), que representa a
				# oneCharacter.length.

	# (oneCharacter.length == 1) ?
	lw	v1,20($fp)	# Cargo en v1 lo guardado en la direccion 20($fp), que representa a
				# oneCharacter.length.
	li	v0,1		# Cargo en v0 el literal 1, para poder hacer la comparacion.
	bne	v1,v0,$investNumberInConvertIntToCh	# If (oneCharacter.length != 1) goto 
							# $investNumberInConvertIntToCh.

	# oneCharacter.length is equals to 1

	# return oneCharacter;

	# Voy a guardar oneCharacter.data que debe de ser retornado.
	lw	v0,8($fp)	# Cargo en v0 lo guardado en la direccion 8($fp), que representa a la
				# variable oneCharacter.data.
	lw	v1,56($fp)	# Cargo en v1 lo guardado en la direccion 56($fp), que representa la
				# direccion en la cual la funcion invocante espera el resultado de la
				# ejecucion de esta funcion.
	sw	v0,0(v1)	# Guardo en la direccion que la funcion espera el resultado (v1) lo cargado
				# en v0, que es oneCharacter.data. Pero solo se guardan 4 bytes de los 11 que
				# se reservo para ese array (en realidad son 3 bloques de 4 bytes cada uno,
				# que dan 12 bytes en total).
	lw	v0,12($fp)	# Cargo en v0 lo guardado en la direccion 12($fp), que son los siguientes 4
				# bytes del array oneCharacter.data.
	lw	v1,56($fp)	# Cargo en v1 lo guardado en la direccion 56($fp), que representa la
				# direccion en la cual la funcion invocante espera el resultado de la
				# ejecucion de esta funcion.
	sw	v0,4(v1)	# Guardo el segundo bloque de 4 bytes de oneCharacter.data en la direccion
				# especificada en v1+4 (se mueve 4 bytes sobre la direccion en v1).
	lw	v0,16($fp)	# Cargo en v0 lo guardado en la direccion 16($fp), que son los siguientes 4
				# bytes del array oneCharacter.data, o sea, el ultimo bloque de 4 bytes.
	lw	v1,56($fp)	# Cargo en v1 lo guardado en la direccion 56($fp), que representa la
				# direccion en la cual la funcion invocante espera el resultado de la
				# ejecucion de esta funcion.	
	sw	v0,8(v1)	# Guardo el tercer bloque de 4 bytes de oneCharacter.data en la direccion
				# especificada en v1+8 (se mueve 8 bytes sobre la direccion en v1).

	# Voy a guardar oneCharacter.length que debe de ser retornado.
	lw	v0,20($fp)	# Cargo en v0 lo guardado en la direccion 20($fp), que representa a 
				# oneCharacter.length.
	lw	v1,56($fp)	# Cargo en v1 lo guardado en la direccion 56($fp), que representa la
				# direccion en la cual la funcion invocante espera el resultado de la
				# ejecucion de esta funcion.
	sw	v0,12(v1)	# Guardo oneCharacter.length (v0) en la direccion especificada en 
				# v1+12 (se mueve 12 bytes sobre la direccion en v1).
	b	$returnInConvertIntToCh	# Salto incondicional a $returnInConvertIntToCh.
$investNumberInConvertIntToCh:
	# double middle = (double)oneCharacter.length / 2;
	l.s	$f0,20($fp)	# Cargo en $f0 lo guardado en la direccion 20($fp), que representa
				# la variable oneCharacter.length.
	cvt.d.w	$f2,$f0		# Convierto el integer oneCharacter.length a double. Guardo resultado
				# en $f2.
	l.d	$f0,twoDouble	# Cargo en $f0 el valor 2 en formato double.
	div.d	$f0,$f2,$f0	# Division con Double (double)oneCharacter.length / 2; 
                                # Sintaxis: div.d FRdest, FRsrc1, FRsrc2
	s.d	$f0,32($fp)	# Guarda el resultado de la division en 32($fp). O sea, 
                                # middle (double middle = (double)oneCharacter.length / 2;)

	# i = 0;
	sw	zero,24($fp)	# Guardo 0 en la direccion 24($fp), que representa a la variable i.

	# int last = oneCharacter.length - 1;
	lw	v0,20($fp)	# Cargo en v0 lo guardado en la direccion 20($fp), que representa
				# la variable oneCharacter.length.
	addu	v0,v0,-1	# Le resto 1 a la variable oneCharacter.length. El resultado esta en v0.
	sw	v0,28($fp)	# Guardo el resultado de la resta en la direccion 28($fp), que representa 
				# a la variable last.
$whileInvestNumberInConvertIntToCh:
	# while(i < middle && last >= middle)

	# (i < middle) ?
	l.s	$f0,24($fp)	# Cargo en $f0 lo guardado en la direccion 24($fp), que representa
				# la variable i.
	cvt.d.w	$f2,$f0		# Convierto el integer i a double. Guardo resultado en $f2.
	l.d	$f0,32($fp)	# Cargo en $f0 lo guardado en la direccion 32($fp), que representa
				# la variable middle.
	c.lt.d	$f2,$f0		# Compara la variable i con la variable middle, y setea el condition flag en true 
				# si el primero (i) es mas chico que el segundo (middle).
	bc1t	$verifyConditionLastWithMiddleInConvertIntToCh	# Si el condition flag es true, continua  
                                              			# haciendo las comparaciones. Salta a 
								# $verifyConditionLastWithMiddleInConvertIntToCh.

	# i is >= middle.
	b	$whileInvestNumberInConvertIntToChFinalized	# Salta incondicionalmente a 
								# $whileInvestNumberInConvertIntToChFinalized.
$verifyConditionLastWithMiddleInConvertIntToCh:
	# (last >= middle) ?
	l.s	$f0,28($fp)	# Cargo la variable last en $f0, que se encuentra guardada en la direccion 28($fp).
	cvt.d.w	$f2,$f0		# Convierto el integer last a double y lo guardo en $f2 para poder hacer la comparacion.
	l.d	$f0,32($fp)	# Cargo en $f0 el contenido de la variable middle, guardado en la direccion 32($fp).
	c.le.d	$f0,$f2		# Compara el contenido de la variable last con la variable middle, y setea el 
				# condition flag en true si middle es menor o igual a last, sino false
	bc1t	$insideOfTheWhileInvestNumberInConvertIntToCh	# Si el condition flag es true, continua dentro del while.
								# goto $insideOfTheWhileInvestNumberInConvertIntToCh.

	# last is < middle.
	b	$whileInvestNumberInConvertIntToChFinalized	# Salta incondicionalmente a 
								# $whileInvestNumberInConvertIntToChFinalized.
$insideOfTheWhileInvestNumberInConvertIntToCh:
	# char firstCharacter = oneCharacter.data[i];
	lw	v1,24($fp)	# Cargo en v1 lo guardado en la direccion 24($fp), que representa a la 
				# variable i.
	addu	v0,$fp,8	# Me muevo 8 posiciones sobre el stack frama (desde la posicion inicial). Cargo
				# nueva posicion en v0. Esto es para obtener la direccion guardada en la posicion inicial
				# de oneCharacter.data.
	addu	v0,v0,v1	# A la direccion guardada en la posicion inicial de oneCharacter.data, le sumo lo que
				# tiene v1 (que es i); y guardo el resultado en v0. Esto seria:
				# oneCharacter.data[i] = oneCharacter.data + i
	lbu	v0,0(v0)	# Cargo en v0 el valor guardado en oneCharacter.data[i].
	sb	v0,40($fp)	# Guardo en la direccion 40($fp) un byte de lo que tiene v0. O sea, hago efectivamente
				# char firstCharacter = oneCharacter.data[i];
				# Por lo que la variable firstCharacter estaria guardada en la direccion 40($fp).

	# char lastCharacter = oneCharacter.data[last];
	lw	v1,28($fp)	# Cargo en v1 lo guardado en la direccion 28($fp), que representa a la 
				# variable last.
	addu	v0,$fp,8	# Me muevo 8 posiciones sobre el stack frama (desde la posicion inicial). Cargo
				# nueva posicion en v0. Esto es para obtener la direccion guardada en la posicion inicial
				# de oneCharacter.data.
	addu	v0,v0,v1	# A la direccion guardada en la posicion inicial de oneCharacter.data, le sumo lo que
				# tiene v1 (que es last); y guardo el resultado en v0. Esto seria:
				# oneCharacter.data[last] = oneCharacter.data + last
	lbu	v0,0(v0)	# Cargo en v0 el valor guardado en oneCharacter.data[last].
	sb	v0,41($fp)	# Guardo en la direccion 41($fp) un byte de lo que tiene v0. O sea, hago efectivamente
				# char lastCharacter = oneCharacter.data[last];
				# Por lo que la variable lastCharacter estaria guardada en la direccion 41($fp).

	# oneCharacter.data[i] = lastCharacter;
	lw	v1,24($fp)	# Cargo en v1 lo guardado en la direccion 24($fp), que representa a la 
				# variable i.
	addu	v0,$fp,8	# Me muevo 8 posiciones sobre el stack frama (desde la posicion inicial). Cargo
				# nueva posicion en v0. Esto es para obtener la direccion guardada en la posicion inicial
				# de oneCharacter.data.
	addu	v1,v0,v1	# A la direccion guardada en la posicion inicial de oneCharacter.data, le sumo lo que
				# tiene v1 (que es i); y guardo el resultado en v1. Esto seria:
				# oneCharacter.data[i] = oneCharacter.data + i
	lbu	v0,41($fp)	# Cargo en v0 un byte lo guardado en la direccion 41($fp), que seria lastCharacter.
	sb	v0,0(v1)	# Guardo un byte en la direccion apuntada por v1. O sea, hago efectivamente:
				# oneCharacter.data[i] = lastCharacter;

	# oneCharacter.data[last] = firstCharacter;
	lw	v1,28($fp)	# Cargo en v1 lo guardado en la direccion 28($fp), que representa a la 
				# variable last.
	addu	v0,$fp,8	# Me muevo 8 posiciones sobre el stack frama (desde la posicion inicial). Cargo
				# nueva posicion en v0. Esto es para obtener la direccion guardada en la posicion inicial
				# de oneCharacter.data.
	addu	v1,v0,v1	# A la direccion guardada en la posicion inicial de oneCharacter.data, le sumo lo que
				# tiene v1 (que es last); y guardo el resultado en v1. Esto seria:
				# oneCharacter.data[last] = oneCharacter.data + last
	lbu	v0,40($fp)	# Cargo en v0 un byte lo guardado en la direccion 40($fp), que seria firstCharacter.
	sb	v0,0(v1)	# Guardo un byte en la direccion apuntada por v1. O sea, hago efectivamente:
				# oneCharacter.data[last] = firstCharacter;

	# i ++;
	lw	v0,24($fp)	# Cargo en v0 lo guardado en la direccion 24($fp), que representa a la 
				# variable i.
	addu	v0,v0,1		# Incremento en 1 el valor de i.
	sw	v0,24($fp)	# Guardo el nuevo valor de i, que se encuentra en la direccion 24($fp).

	# last --;
	lw	v0,28($fp)	# Cargo en v0 lo guardado en la direccion 28($fp), que representa a la 
				# variable last.
	addu	v0,v0,-1	# Decremento en 1 el valor de last.
	sw	v0,28($fp)	# Guardo el nuevo valor de last, que se encuentra en la direccion 28($fp).

	b	$whileInvestNumberInConvertIntToCh	# Salto incondicionalmente a 
							# $whileInvestNumberInConvertIntToCh.
$whileInvestNumberInConvertIntToChFinalized:
	# return oneCharacter;

	# Voy a guardar oneCharacter.data que debe de ser retornado.
	lw	v0,8($fp)	# Cargo en v0 lo guardado en la direccion 8($fp), que representa a la
				# variable oneCharacter.data.
	lw	v1,56($fp)	# Cargo en v1 lo guardado en la direccion 56($fp), que representa la
				# direccion en la cual la funcion invocante espera el resultado de la
				# ejecucion de esta funcion.
	sw	v0,0(v1)	# Guardo en la direccion que la funcion espera el resultado (v1) lo cargado
				# en v0, que es oneCharacter.data. Pero solo se guardan 4 bytes de los 11 que
				# se reservo para ese array (en realidad son 3 bloques de 4 bytes cada uno,
				# que dan 12 bytes en total).
	lw	v0,12($fp)	# Cargo en v0 lo guardado en la direccion 12($fp), que son los siguientes 4
				# bytes del array oneCharacter.data.
	lw	v1,56($fp)	# Cargo en v1 lo guardado en la direccion 56($fp), que representa la
				# direccion en la cual la funcion invocante espera el resultado de la
				# ejecucion de esta funcion.
	sw	v0,4(v1)	# Guardo el segundo bloque de 4 bytes de oneCharacter.data en la direccion
				# especificada en v1+4 (se mueve 4 bytes sobre la direccion en v1).
	lw	v0,16($fp)	# Cargo en v0 lo guardado en la direccion 16($fp), que son los siguientes 4
				# bytes del array oneCharacter.data, o sea, el ultimo bloque de 4 bytes.
	lw	v1,56($fp)	# Cargo en v1 lo guardado en la direccion 56($fp), que representa la
				# direccion en la cual la funcion invocante espera el resultado de la
				# ejecucion de esta funcion.
	sw	v0,8(v1)	# Guardo el tercer bloque de 4 bytes de oneCharacter.data en la direccion
				# especificada en v1+8 (se mueve 8 bytes sobre la direccion en v1).

	# Voy a guardar oneCharacter.length que debe de ser retornado.
	lw	v0,20($fp)	# Cargo en v0 lo guardado en la direccion 20($fp), que representa a 
				# oneCharacter.length.
	lw	v1,56($fp)	# Cargo en v1 lo guardado en la direccion 56($fp), que representa la
				# direccion en la cual la funcion invocante espera el resultado de la
				# ejecucion de esta funcion.
	sw	v0,12(v1)	# Guardo oneCharacter.length (v0) en la direccion especificada en 
				# v1+12 (se mueve 12 bytes sobre la direccion en v1).
$returnInConvertIntToCh:
	lw	v0,56($fp)	# Cargo en v0 la direccion en la cual se va a retornar el struct, que
				# se encuentra guardada en la direccion 56($fp).

	# reconstruyo los registros.
	move	sp,$fp
	lw	$fp,52(sp)

	# destruyo stack frame
	addu	sp,sp,56

	# vuelvo a funcion llamante
	j	ra

	.end	convertIntToCharacter


# ---------------------------------------------------------------------------- #

## Variables auxiliares

	.data

twoDouble:
	.double	2


