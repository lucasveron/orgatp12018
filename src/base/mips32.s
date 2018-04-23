	.file	1 "mips32.c"
	.section .mdebug.abi32
	.previous
	.abicalls
	.globl	quantityCharactersInBuffer
	.globl	quantityCharactersInBuffer
	.section	.bss
	.align	2
	.type	quantityCharactersInBuffer, @object
	.size	quantityCharactersInBuffer, 4
quantityCharactersInBuffer:
	.space	4
	.rdata
	.align	2
$LC0:
	.ascii	"[Error] No se ha especificado archivo de salida.\n\000"
	.text
	.align	2
	.globl	loadFileDescriptor
	.ent	loadFileDescriptor
loadFileDescriptor:
	.frame	$fp,48,$ra		# vars= 8, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,48
	.cprestore 16
	sw	$ra,40($sp)
	sw	$fp,36($sp)
	sw	$gp,32($sp)
	move	$fp,$sp
	lw	$v0,fileOutput
	bne	$v0,$zero,$L18
	la	$a0,__sF+176
	la	$a1,$LC0
	la	$t9,fprintf
	jal	$ra,$t9
	li	$v0,1			# 0x1
	sw	$v0,24($fp)
	b	$L17
$L18:
	lw	$v0,fileOutput
	lh	$v0,14($v0)
	sw	$v0,ofd
	sw	$zero,24($fp)
$L17:
	lw	$v0,24($fp)
	move	$sp,$fp
	lw	$ra,40($sp)
	lw	$fp,36($sp)
	addu	$sp,$sp,48
	j	$ra
	.end	loadFileDescriptor
	.size	loadFileDescriptor, .-loadFileDescriptor
	.rdata
	.align	2
$LC1:
	.ascii	"[Warning] El archivo de output no pudo ser cerrado corre"
	.ascii	"ctamente.\n\000"
	.text
	.align	2
	.globl	closeFile
	.ent	closeFile
closeFile:
	.frame	$fp,48,$ra		# vars= 8, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,48
	.cprestore 16
	sw	$ra,40($sp)
	sw	$fp,36($sp)
	sw	$gp,32($sp)
	move	$fp,$sp
	lw	$v1,ofd
	li	$v0,1			# 0x1
	bne	$v1,$v0,$L20
	sw	$zero,fileOutput
	b	$L19
$L20:
	lw	$v0,fileOutput
	beq	$v0,$zero,$L19
	lw	$a0,fileOutput
	la	$t9,fclose
	jal	$ra,$t9
	sw	$v0,24($fp)
	lw	$v1,24($fp)
	li	$v0,-1			# 0xffffffffffffffff
	bne	$v1,$v0,$L22
	la	$a0,__sF+176
	la	$a1,$LC1
	la	$t9,fprintf
	jal	$ra,$t9
$L22:
	sw	$zero,fileOutput
$L19:
	move	$sp,$fp
	lw	$ra,40($sp)
	lw	$fp,36($sp)
	addu	$sp,$sp,48
	j	$ra
	.end	closeFile
	.size	closeFile, .-closeFile
	.rdata
	.align	3
$LC2:
	.word	0
	.word	1073741824
	.text
	.align	2
	.globl	convertIntToCharacter
	.ent	convertIntToCharacter
convertIntToCharacter:
	.frame	$fp,56,$ra		# vars= 40, regs= 2/0, args= 0, extra= 8
	.mask	0x50000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,56
	.cprestore 0
	sw	$fp,52($sp)
	sw	$gp,48($sp)
	move	$fp,$sp
	sw	$a0,56($fp)
	sw	$a1,60($fp)
	sw	$zero,20($fp)
	sw	$zero,24($fp)
	sw	$zero,28($fp)
$L24:
	lw	$v0,24($fp)
	slt	$v0,$v0,11
	beq	$v0,$zero,$L25
	lw	$v0,60($fp)
	bne	$v0,$zero,$L26
	b	$L25
$L26:
	lw	$a0,60($fp)
	li	$v0,-859045888			# 0xffffffffcccc0000
	ori	$v0,$v0,0xcccd
	multu	$a0,$v0
	mfhi	$v0
	srl	$v1,$v0,3
	move	$v0,$v1
	sll	$v0,$v0,2
	addu	$v0,$v0,$v1
	sll	$v0,$v0,1
	subu	$v0,$a0,$v0
	sw	$v0,28($fp)
	lw	$v1,24($fp)
	addu	$v0,$fp,8
	addu	$v1,$v0,$v1
	lbu	$v0,28($fp)
	addu	$v0,$v0,48
	sb	$v0,0($v1)
	lw	$v1,60($fp)
	li	$v0,-859045888			# 0xffffffffcccc0000
	ori	$v0,$v0,0xcccd
	multu	$v1,$v0
	mfhi	$v0
	srl	$v0,$v0,3
	sw	$v0,60($fp)
	lw	$v0,24($fp)
	addu	$v0,$v0,1
	sw	$v0,24($fp)
	b	$L24
$L25:
	lw	$v0,24($fp)
	sw	$v0,20($fp)
	lw	$v1,20($fp)
	li	$v0,1			# 0x1
	bne	$v1,$v0,$L28
	lw	$v0,8($fp)
	lw	$v1,56($fp)
	sw	$v0,0($v1)
	lw	$v0,12($fp)
	lw	$v1,56($fp)
	sw	$v0,4($v1)
	lw	$v0,16($fp)
	lw	$v1,56($fp)
	sw	$v0,8($v1)
	lw	$v0,20($fp)
	lw	$v1,56($fp)
	sw	$v0,12($v1)
	b	$L23
$L28:
	l.s	$f0,20($fp)
	cvt.d.w	$f2,$f0
	l.d	$f0,$LC2
	div.d	$f0,$f2,$f0
	s.d	$f0,32($fp)
	sw	$zero,24($fp)
	lw	$v0,20($fp)
	addu	$v0,$v0,-1
	sw	$v0,40($fp)
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
	lw	$v1,24($fp)
	addu	$v0,$fp,8
	addu	$v0,$v0,$v1
	lbu	$v0,0($v0)
	sb	$v0,44($fp)
	lw	$v1,40($fp)
	addu	$v0,$fp,8
	addu	$v0,$v0,$v1
	lbu	$v0,0($v0)
	sb	$v0,45($fp)
	lw	$v1,24($fp)
	addu	$v0,$fp,8
	addu	$v1,$v0,$v1
	lbu	$v0,45($fp)
	sb	$v0,0($v1)
	lw	$v1,40($fp)
	addu	$v0,$fp,8
	addu	$v1,$v0,$v1
	lbu	$v0,44($fp)
	sb	$v0,0($v1)
	lw	$v0,24($fp)
	addu	$v0,$v0,1
	sw	$v0,24($fp)
	lw	$v0,40($fp)
	addu	$v0,$v0,-1
	sw	$v0,40($fp)
	b	$L29
$L30:
	lw	$v0,8($fp)
	lw	$v1,56($fp)
	sw	$v0,0($v1)
	lw	$v0,12($fp)
	lw	$v1,56($fp)
	sw	$v0,4($v1)
	lw	$v0,16($fp)
	lw	$v1,56($fp)
	sw	$v0,8($v1)
	lw	$v0,20($fp)
	lw	$v1,56($fp)
	sw	$v0,12($v1)
$L23:
	lw	$v0,56($fp)
	move	$sp,$fp
	lw	$fp,52($sp)
	addu	$sp,$sp,56
	j	$ra
	.end	convertIntToCharacter
	.size	convertIntToCharacter, .-convertIntToCharacter
	.rdata
	.align	2
$LC3:
	.ascii	"[Error] Hubo un error al escribir en el archivo. \n\000"
	.text
	.align	2
	.globl	writeBufferInOFile
	.ent	writeBufferInOFile
writeBufferInOFile:
	.frame	$fp,64,$ra		# vars= 24, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,64
	.cprestore 16
	sw	$ra,56($sp)
	sw	$fp,52($sp)
	sw	$gp,48($sp)
	move	$fp,$sp
	sw	$a0,64($fp)
	sw	$a1,68($fp)
	lw	$v0,fileOutput
	beq	$v0,$zero,$L36
	lw	$v0,68($fp)
	blez	$v0,$L36
	b	$L35
$L36:
	sw	$zero,40($fp)
	b	$L34
$L35:
	li	$v0,1			# 0x1
	sw	$v0,24($fp)
	sw	$zero,28($fp)
	lw	$v0,68($fp)
	sw	$v0,32($fp)
$L37:
	lw	$v1,24($fp)
	li	$v0,1			# 0x1
	beq	$v1,$v0,$L39
	b	$L38
$L39:
	lw	$v1,64($fp)
	lw	$v0,28($fp)
	addu	$v0,$v1,$v0
	lw	$a0,ofd
	move	$a1,$v0
	lw	$a2,32($fp)
	la	$t9,write
	jal	$ra,$t9
	sw	$v0,36($fp)
	lw	$v0,36($fp)
	bgez	$v0,$L40
	la	$a0,__sF+176
	la	$a1,$LC3
	la	$t9,fprintf
	jal	$ra,$t9
	li	$v0,3			# 0x3
	sw	$v0,40($fp)
	b	$L34
$L40:
	lw	$v1,28($fp)
	lw	$v0,36($fp)
	addu	$v0,$v1,$v0
	sw	$v0,28($fp)
	lw	$v1,68($fp)
	lw	$v0,28($fp)
	subu	$v0,$v1,$v0
	sw	$v0,32($fp)
	lw	$v0,32($fp)
	bgtz	$v0,$L37
	sw	$zero,24($fp)
	b	$L37
$L38:
	sw	$zero,40($fp)
$L34:
	lw	$v0,40($fp)
	move	$sp,$fp
	lw	$ra,56($sp)
	lw	$fp,52($sp)
	addu	$sp,$sp,64
	j	$ra
	.end	writeBufferInOFile
	.size	writeBufferInOFile, .-writeBufferInOFile
	.align	2
	.globl	writeHeader
	.ent	writeHeader
writeHeader:
	.frame	$fp,120,$ra		# vars= 80, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,120
	.cprestore 16
	sw	$ra,112($sp)
	sw	$fp,108($sp)
	sw	$gp,104($sp)
	move	$fp,$sp
	sw	$a0,120($fp)
	sw	$a1,124($fp)
	sw	$a2,128($fp)
	sw	$sp,92($fp)
	addu	$a0,$fp,24
	lw	$a1,120($fp)
	la	$t9,convertIntToCharacter
	jal	$ra,$t9
	addu	$v0,$fp,40
	move	$a0,$v0
	lw	$a1,124($fp)
	la	$t9,convertIntToCharacter
	jal	$ra,$t9
	addu	$v0,$fp,56
	move	$a0,$v0
	lw	$a1,128($fp)
	la	$t9,convertIntToCharacter
	jal	$ra,$t9
	lw	$v1,52($fp)
	lw	$v0,36($fp)
	addu	$v1,$v1,$v0
	lw	$v0,68($fp)
	addu	$v0,$v1,$v0
	addu	$v0,$v0,6
	sw	$v0,72($fp)
	lw	$v0,72($fp)
	addu	$v0,$v0,-1
	addu	$v0,$v0,1
	addu	$v0,$v0,7
	srl	$v0,$v0,3
	sll	$v0,$v0,3
	subu	$sp,$sp,$v0
	addu	$v0,$sp,16
	sw	$v0,96($fp)
	li	$v0,80			# 0x50
	lw	$v1,96($fp)
	sb	$v0,0($v1)
	li	$v0,50			# 0x32
	lw	$a0,96($fp)
	sb	$v0,1($a0)
	li	$v0,10			# 0xa
	lw	$v1,96($fp)
	sb	$v0,2($v1)
	li	$v0,3			# 0x3
	sw	$v0,76($fp)
	sw	$zero,80($fp)
$L43:
	lw	$v0,80($fp)
	lw	$v1,52($fp)
	slt	$v0,$v0,$v1
	bne	$v0,$zero,$L46
	b	$L44
$L46:
	lw	$v0,76($fp)
	lw	$v1,96($fp)
	addu	$a0,$v1,$v0
	addu	$v1,$fp,40
	lw	$v0,80($fp)
	addu	$v0,$v1,$v0
	lbu	$v0,0($v0)
	sb	$v0,0($a0)
	lw	$v0,76($fp)
	addu	$v0,$v0,1
	sw	$v0,76($fp)
	lw	$v0,80($fp)
	addu	$v0,$v0,1
	sw	$v0,80($fp)
	b	$L43
$L44:
	lw	$v0,76($fp)
	lw	$a0,96($fp)
	addu	$v1,$a0,$v0
	li	$v0,32			# 0x20
	sb	$v0,0($v1)
	lw	$v0,76($fp)
	addu	$v0,$v0,1
	sw	$v0,76($fp)
	sw	$zero,80($fp)
$L47:
	lw	$v0,80($fp)
	lw	$v1,36($fp)
	slt	$v0,$v0,$v1
	bne	$v0,$zero,$L50
	b	$L48
$L50:
	lw	$v0,76($fp)
	lw	$v1,96($fp)
	addu	$a0,$v1,$v0
	lw	$v1,80($fp)
	addu	$v0,$fp,24
	addu	$v0,$v0,$v1
	lbu	$v0,0($v0)
	sb	$v0,0($a0)
	lw	$v0,76($fp)
	addu	$v0,$v0,1
	sw	$v0,76($fp)
	lw	$v0,80($fp)
	addu	$v0,$v0,1
	sw	$v0,80($fp)
	b	$L47
$L48:
	lw	$v0,76($fp)
	lw	$a0,96($fp)
	addu	$v1,$a0,$v0
	li	$v0,10			# 0xa
	sb	$v0,0($v1)
	lw	$v0,76($fp)
	addu	$v0,$v0,1
	sw	$v0,76($fp)
	sw	$zero,80($fp)
$L51:
	lw	$v0,80($fp)
	lw	$v1,68($fp)
	slt	$v0,$v0,$v1
	bne	$v0,$zero,$L54
	b	$L52
$L54:
	lw	$v0,76($fp)
	lw	$v1,96($fp)
	addu	$a0,$v1,$v0
	addu	$v1,$fp,56
	lw	$v0,80($fp)
	addu	$v0,$v1,$v0
	lbu	$v0,0($v0)
	sb	$v0,0($a0)
	lw	$v0,76($fp)
	addu	$v0,$v0,1
	sw	$v0,76($fp)
	lw	$v0,80($fp)
	addu	$v0,$v0,1
	sw	$v0,80($fp)
	b	$L51
$L52:
	lw	$v0,76($fp)
	lw	$a0,96($fp)
	addu	$v1,$a0,$v0
	li	$v0,10			# 0xa
	sb	$v0,0($v1)
	lw	$a0,96($fp)
	lw	$a1,72($fp)
	la	$t9,writeBufferInOFile
	jal	$ra,$t9
	sw	$v0,84($fp)
	lw	$v0,84($fp)
	beq	$v0,$zero,$L55
	la	$t9,closeFile
	jal	$ra,$t9
	lw	$sp,92($fp)
	li	$v0,3			# 0x3
	sw	$v0,88($fp)
	b	$L42
$L55:
	lw	$sp,92($fp)
	sw	$zero,88($fp)
$L42:
	lw	$v0,88($fp)
	move	$sp,$fp
	lw	$ra,112($sp)
	lw	$fp,108($sp)
	addu	$sp,$sp,120
	j	$ra
	.end	writeHeader
	.size	writeHeader, .-writeHeader
	.align	2
	.globl	loadDataInBuffer
	.ent	loadDataInBuffer
loadDataInBuffer:
	.frame	$fp,24,$ra		# vars= 8, regs= 2/0, args= 0, extra= 8
	.mask	0x50000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,24
	.cprestore 0
	sw	$fp,20($sp)
	sw	$gp,16($sp)
	move	$fp,$sp
	move	$v0,$a0
	sb	$v0,8($fp)
	lw	$v1,quantityCharactersInBuffer
	la	$v0,buffer
	addu	$v1,$v1,$v0
	lbu	$v0,8($fp)
	sb	$v0,0($v1)
	lw	$v0,quantityCharactersInBuffer
	addu	$v0,$v0,1
	sw	$v0,quantityCharactersInBuffer
	move	$sp,$fp
	lw	$fp,20($sp)
	addu	$sp,$sp,24
	j	$ra
	.end	loadDataInBuffer
	.size	loadDataInBuffer, .-loadDataInBuffer
	.align	2
	.globl	putch
	.ent	putch
putch:
	.frame	$fp,56,$ra		# vars= 16, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,56
	.cprestore 16
	sw	$ra,48($sp)
	sw	$fp,44($sp)
	sw	$gp,40($sp)
	move	$fp,$sp
	move	$v0,$a0
	sb	$v0,24($fp)
	lw	$v0,quantityCharactersInBuffer
	slt	$v0,$v0,100
	beq	$v0,$zero,$L58
	lb	$v0,24($fp)
	move	$a0,$v0
	la	$t9,loadDataInBuffer
	jal	$ra,$t9
	sw	$zero,32($fp)
	b	$L57
$L58:
	la	$a0,buffer
	lw	$a1,quantityCharactersInBuffer
	la	$t9,writeBufferInOFile
	jal	$ra,$t9
	sw	$v0,28($fp)
	lw	$v0,28($fp)
	beq	$v0,$zero,$L59
	lw	$v0,28($fp)
	sw	$v0,32($fp)
	b	$L57
$L59:
	sw	$zero,quantityCharactersInBuffer
	lb	$v0,24($fp)
	move	$a0,$v0
	la	$t9,loadDataInBuffer
	jal	$ra,$t9
	sw	$zero,32($fp)
$L57:
	lw	$v0,32($fp)
	move	$sp,$fp
	lw	$ra,48($sp)
	lw	$fp,44($sp)
	addu	$sp,$sp,56
	j	$ra
	.end	putch
	.size	putch, .-putch
	.align	2
	.globl	flush
	.ent	flush
flush:
	.frame	$fp,48,$ra		# vars= 8, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,48
	.cprestore 16
	sw	$ra,40($sp)
	sw	$fp,36($sp)
	sw	$gp,32($sp)
	move	$fp,$sp
	lw	$v0,quantityCharactersInBuffer
	blez	$v0,$L61
	la	$a0,buffer
	lw	$a1,quantityCharactersInBuffer
	la	$t9,writeBufferInOFile
	jal	$ra,$t9
	sw	$v0,24($fp)
	b	$L60
$L61:
	sw	$zero,24($fp)
$L60:
	lw	$v0,24($fp)
	move	$sp,$fp
	lw	$ra,40($sp)
	lw	$fp,36($sp)
	addu	$sp,$sp,48
	j	$ra
	.end	flush
	.size	flush, .-flush
	.align	2
	.globl	loadPixelBrightness
	.ent	loadPixelBrightness
loadPixelBrightness:
	.frame	$fp,72,$ra		# vars= 32, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,72
	.cprestore 16
	sw	$ra,64($sp)
	sw	$fp,60($sp)
	sw	$gp,56($sp)
	move	$fp,$sp
	sw	$a0,72($fp)
	addu	$a0,$fp,24
	lw	$a1,72($fp)
	la	$t9,convertIntToCharacter
	jal	$ra,$t9
	sw	$zero,40($fp)
	sw	$zero,44($fp)
$L63:
	lw	$v0,44($fp)
	lw	$v1,36($fp)
	slt	$v0,$v0,$v1
	bne	$v0,$zero,$L66
	b	$L64
$L66:
	lw	$v1,44($fp)
	addu	$v0,$fp,24
	addu	$v0,$v0,$v1
	lb	$v0,0($v0)
	move	$a0,$v0
	la	$t9,putch
	jal	$ra,$t9
	sw	$v0,40($fp)
	lw	$v0,40($fp)
	beq	$v0,$zero,$L65
	lw	$v0,40($fp)
	sw	$v0,48($fp)
	b	$L62
$L65:
	lw	$v0,44($fp)
	addu	$v0,$v0,1
	sw	$v0,44($fp)
	b	$L63
$L64:
	lw	$v0,40($fp)
	sw	$v0,48($fp)
$L62:
	lw	$v0,48($fp)
	move	$sp,$fp
	lw	$ra,64($sp)
	lw	$fp,60($sp)
	addu	$sp,$sp,72
	j	$ra
	.end	loadPixelBrightness
	.size	loadPixelBrightness, .-loadPixelBrightness
	.rdata
	.align	2
$LC4:
	.word	1082130432
	.text
	.align	2
	.globl	mips32_plot
	.ent	mips32_plot
mips32_plot:
	.frame	$fp,88,$ra		# vars= 48, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,88
	.cprestore 16
	sw	$ra,80($sp)
	sw	$fp,76($sp)
	sw	$gp,72($sp)
	move	$fp,$sp
	sw	$a0,88($fp)
	lw	$v0,88($fp)
	lw	$v0,44($v0)
	sw	$v0,fileOutput
	la	$t9,loadFileDescriptor
	jal	$ra,$t9
	sw	$v0,24($fp)
	lw	$v0,24($fp)
	beq	$v0,$zero,$L69
	b	$L68
$L69:
	lw	$v1,88($fp)
	lw	$a1,88($fp)
	lw	$v0,88($fp)
	lw	$v0,40($v0)
	addu	$v0,$v0,-1
	lw	$a0,36($v1)
	lw	$a1,32($a1)
	move	$a2,$v0
	la	$t9,writeHeader
	jal	$ra,$t9
	sw	$v0,24($fp)
	lw	$v0,24($fp)
	beq	$v0,$zero,$L70
	b	$L68
$L70:
	sw	$zero,60($fp)
	lw	$v0,88($fp)
	l.s	$f0,4($v0)
	s.s	$f0,32($fp)
$L71:
	lw	$v0,88($fp)
	lw	$v1,60($fp)
	lw	$v0,36($v0)
	sltu	$v0,$v1,$v0
	bne	$v0,$zero,$L74
	b	$L72
$L74:
	sw	$zero,56($fp)
	lw	$v0,88($fp)
	l.s	$f0,0($v0)
	s.s	$f0,28($fp)
$L75:
	lw	$v0,88($fp)
	lw	$v1,56($fp)
	lw	$v0,32($v0)
	sltu	$v0,$v1,$v0
	bne	$v0,$zero,$L78
	b	$L76
$L78:
	l.s	$f0,28($fp)
	s.s	$f0,36($fp)
	l.s	$f0,32($fp)
	s.s	$f0,40($fp)
	sw	$zero,64($fp)
$L79:
	lw	$v0,88($fp)
	lw	$v1,64($fp)
	lw	$v0,40($v0)
	sltu	$v0,$v1,$v0
	bne	$v0,$zero,$L82
	b	$L80
$L82:
	l.s	$f2,36($fp)
	l.s	$f0,36($fp)
	mul.s	$f4,$f2,$f0
	l.s	$f2,40($fp)
	l.s	$f0,40($fp)
	mul.s	$f0,$f2,$f0
	add.s	$f0,$f4,$f0
	mov.s	$f2,$f0
	s.s	$f2,52($fp)
	l.s	$f0,$LC4
	c.le.s	$f0,$f2
	bc1t	$L80
	lw	$v0,88($fp)
	l.s	$f2,36($fp)
	l.s	$f0,36($fp)
	mul.s	$f2,$f2,$f0
	l.s	$f0,24($v0)
	add.s	$f4,$f2,$f0
	l.s	$f2,40($fp)
	l.s	$f0,40($fp)
	mul.s	$f0,$f2,$f0
	sub.s	$f0,$f4,$f0
	s.s	$f0,44($fp)
	lw	$v0,88($fp)
	l.s	$f2,36($fp)
	l.s	$f0,40($fp)
	mul.s	$f0,$f2,$f0
	add.s	$f2,$f0,$f0
	l.s	$f0,28($v0)
	add.s	$f0,$f0,$f2
	s.s	$f0,48($fp)
	l.s	$f0,44($fp)
	s.s	$f0,36($fp)
	l.s	$f0,48($fp)
	s.s	$f0,40($fp)
	lw	$v0,64($fp)
	addu	$v0,$v0,1
	sw	$v0,64($fp)
	b	$L79
$L80:
	lw	$a0,64($fp)
	la	$t9,loadPixelBrightness
	jal	$ra,$t9
	sw	$v0,24($fp)
	lw	$v0,24($fp)
	beq	$v0,$zero,$L85
	lw	$v0,88($fp)
	lw	$a0,44($v0)
	la	$t9,closeFile
	jal	$ra,$t9
	b	$L68
$L85:
	li	$a0,32			# 0x20
	la	$t9,putch
	jal	$ra,$t9
	sw	$v0,24($fp)
	lw	$v0,24($fp)
	beq	$v0,$zero,$L77
	la	$t9,closeFile
	jal	$ra,$t9
	b	$L68
$L77:
	lw	$v0,56($fp)
	addu	$v0,$v0,1
	sw	$v0,56($fp)
	lw	$v0,88($fp)
	l.s	$f2,28($fp)
	l.s	$f0,16($v0)
	add.s	$f0,$f2,$f0
	s.s	$f0,28($fp)
	b	$L75
$L76:
	li	$a0,10			# 0xa
	la	$t9,putch
	jal	$ra,$t9
	sw	$v0,24($fp)
	lw	$v0,24($fp)
	beq	$v0,$zero,$L73
	la	$t9,closeFile
	jal	$ra,$t9
	b	$L68
$L73:
	lw	$v0,60($fp)
	addu	$v0,$v0,1
	sw	$v0,60($fp)
	lw	$v0,88($fp)
	l.s	$f2,32($fp)
	l.s	$f0,20($v0)
	sub.s	$f0,$f2,$f0
	s.s	$f0,32($fp)
	b	$L71
$L72:
	la	$t9,flush
	jal	$ra,$t9
	la	$t9,closeFile
	jal	$ra,$t9
$L68:
	move	$sp,$fp
	lw	$ra,80($sp)
	lw	$fp,76($sp)
	addu	$sp,$sp,88
	j	$ra
	.end	mips32_plot
	.size	mips32_plot, .-mips32_plot

	.comm	fileOutput,4

	.comm	ofd,4

	.comm	buffer,100
	.ident	"GCC: (GNU) 3.3.3 (NetBSD nb3 20040520)"
