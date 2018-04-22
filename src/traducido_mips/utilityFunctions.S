#include <mips/regdef.h>
#include <sys/syscall.h>



##-----	myfree -----##

	.globl	myfree
	.ent	myfree

	slt	v0,v0,65      # Guardo en v0 TRUE si word es mas chico que 65, sino guardo FALSE.


NO OLVIDAR BORRAR TODO LO ANTERIOR


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
	# character convertIntToCharacter(unsigned int number) TODO VER ESTO XQ NO ENTIENDO X Q TENGO 8 B Y NO 4 SOLAMENTE
	sw	a0,56($fp)
	sw	a1,60($fp)    # Guardo en la direccion 60($fp) el parametro number
	
	sw	zero,20($fp)  # Guardo en la direccion 20($fp) el valor 0 (oneCharacter.length = 0;).
	sw	zero,24($fp)  # Guardo en la direccion 24($fp) el valor 0 (int i = 0;).
	sw	zero,28($fp)  # Guardo en la direccion 28($fp) el valor 0 (int rest = 0;).
$whileConvert:
	lw	v0,24($fp)    # Cargo en el registro v0 lo que hay guardado en la dir 24($fp), que es i.

	# (i < MAX_LENGTH_CHARACTER) ?
	slt	v0,v0,MAX_LENGTH_CHARACTER # Guardo en v0 TRUE si i es mas chico que MAX_LENGTH_CHARACTER, sino guardo FALSE.
	beq	v0,FALSE,$loadLengthOfCharacter # If (i >= MAX_LENGTH_CHARACTER) goto $loadLengthOfCharacter

	# i is less then MAX_LENGTH_CHARACTER

	# (number != 0) ?
	lw	v0,60($fp)    # Cargo en v0, la variable number, guardada en la dir 60($fp).
	bne	v0,zero,$internalLoopConvert # If (number != 0) goto $internalLoopConvert
	b	$loadLengthOfCharacter # Sale del while porque no cumple condiciones.
$internalLoopConvert:
	# Busco el resto de la division
	# rest = number % 10;
	lw	a0,60($fp)    # Cargo en a0 number
	li	v0,-859045888 # 0xffffffffcccc0000
	ori	v0,v0,0xcccd  # OR con un inmediato
	multu	a0,v0
	mfhi	v0            # Muevo hi
	srl	v1,v0,3       # Shift logico a derecha
	move	v0,v1
	sll	v0,v0,2	      # Shift logico a izquierda
	addu	v0,v0,v1
	sll	v0,v0,1
	subu	v0,a0,v0      # En v0 queda el resto de la division.
	sw	v0,28($fp)    # Guardo el resultado de la division (rest) en la dir 28($fp).

	# oneCharacter.data[i] = rest + 48;
	lw	v1,24($fp)    # Cargo en v1, lo que hay en dir 24($fp), que es i.
	addu	v0,$fp,8      # Es para moverme 8 posiciones desde donde inicia el stack frame.
	addu	v1,v0,v1      # Me muevo i posiciones sobre el valor obtenido anteriormente.
                              # Cargo en v1 la direccion obtenida.
	lbu	v0,28($fp)    # Cargo en v0, rest, guardado en la dir 28($fp).
	addu	v0,v0,48      # A rest le sumo 48 y guardo el resultado en v0.
	sb	v0,0(v1)      # Guardo el byte, resultado de la suma anterior, esta en v0, en la dir apuntada por v1.

	# number /= 10;
	lw	v1,60($fp)    # Cargo en v1 number.
	li	v0,-859045888 # 0xffffffffcccc0000
	ori	v0,v0,0xcccd  # OR con un inmediato
	multu	v1,v0
	mfhi	v0            # Muevo hi
	srl	v0,v0,3       # Shift logico a derecha. Tengo en v0, el cociente de la division.
	sw	v0,60($fp)    # Guardo en la dir 60($fp), en number, el resultado, entero, de la division.

	# i ++;
	lw	v0,24($fp)    # Cargo en v0, el valor de i, guardado en la dir 24($fp).
	addu	v0,v0,1       # Incremento en 1 a i. Cargo resultado en v0.
	sw	v0,24($fp)    # Guardo en la dir 24($fp), el nuevo valor de i, que esta en v0.

	b	$whileConvert # Salto incondicional al comienzo del while.

$loadLengthOfCharacter:
	# oneCharacter.length = i;
	lw	v0,24($fp)    # Cargo en v0, el valor de i, guardado en la dir 24($fp).
	sw	v0,20($fp)    # Guardo en la dir 20($fp), que es length, lo que tiene v0, que es i.

	# (oneCharacter.length == 1) ?
	lw	v1,20($fp)    # Cargo en v1 lo que hay en la dir 20($fp), que es length.
	li	v0,1	      # Cargo en v0 el inmediato 1, para hacer la comparacion.
	bne	v1,v0,$investNumber # If (oneCharacter.length != 1) goto $investNumber.

	# oneCharacter.length is equal to 1.

	# Preparo los datos para hacer el return.
	lw	v0,8($fp)    # Cargo en v0, oneCharacter.data
	lw	v1,56($fp)   #
	sw	v0,0(v1)
	lw	v0,12($fp)
	lw	v1,56($fp)
	sw	v0,4(v1)
	lw	v0,16($fp)
	lw	v1,56($fp)
	sw	v0,8(v1)
	lw	v0,20($fp)
	lw	v1,56($fp)
	sw	v0,12(v1)
	b	$L23
$investNumber:
	l.s	$f0,20($fp)
	cvt.d.w	$f2,$f0
	l.d	$f0,$LC2
	div.d	$f0,$f2,$f0
	s.d	$f0,32($fp)
	sw	zero,24($fp)
	lw	v0,20($fp)
	addu	v0,v0,-1
	sw	v0,40($fp)
$L29:
	l.s	$f0,24($fp)
	cvt.d.w	$f2,$f0
	l.d	$f0,32($fp)
	c.lt.d	$f2,$f0
	bc1t	$L33
	b	$L30
$L33:
	l.s	$f0,40($fp)
	cvt.d.w	$f2,$f0
	l.d	$f0,32($fp)
	c.le.d	$f0,$f2
	bc1t	$L31
	b	$L30
$L31:
	lw	v1,24($fp)
	addu	v0,$fp,8
	addu	v0,v0,v1
	lbu	v0,0(v0)
	sb	v0,44($fp)
	lw	v1,40($fp)
	addu	v0,$fp,8
	addu	v0,v0,v1
	lbu	v0,0(v0)
	sb	v0,45($fp)
	lw	v1,24($fp)
	addu	v0,$fp,8
	addu	v1,v0,v1
	lbu	v0,45($fp)
	sb	v0,0(v1)
	lw	v1,40($fp)
	addu	v0,$fp,8
	addu	v1,v0,v1
	lbu	v0,44($fp)
	sb	v0,0(v1)
	lw	v0,24($fp)
	addu	v0,v0,1
	sw	v0,24($fp)
	lw	v0,40($fp)
	addu	v0,v0,-1
	sw	v0,40($fp)
	b	$L29
$L30:
	lw	v0,8($fp)
	lw	v1,56($fp)
	sw	v0,0(v1)
	lw	v0,12($fp)
	lw	v1,56($fp)
	sw	v0,4(v1)
	lw	v0,16($fp)
	lw	v1,56($fp)
	sw	v0,8(v1)
	lw	v0,20($fp)
	lw	v1,56($fp)
	sw	v0,12(v1)
$L23:
	lw	v0,56($fp)
	move	sp,$fp
	lw	$fp,52(sp)
	addu	sp,sp,56
	j	ra
	.end	convertIntToCharacter
	.size	convertIntToCharacter, .-convertIntToCharacter


