	.file	1 "mips32_plot_assemble.c"
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
	.align	2
$LC2:
	.ascii	"%d\000"
	.text
	.align	2
	.globl	convertIntToCharacter
	.ent	convertIntToCharacter
convertIntToCharacter:
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
	sw	$zero,36($fp)
	sw	$zero,40($fp)
$L24:
	lw	$v0,40($fp)
	slt	$v0,$v0,11
	bne	$v0,$zero,$L27
	b	$L25
$L27:
	lw	$v1,40($fp)
	addu	$v0,$fp,24
	addu	$v0,$v0,$v1
	sb	$zero,0($v0)
	lw	$v0,40($fp)
	addu	$v0,$v0,1
	sw	$v0,40($fp)
	b	$L24
$L25:
	addu	$a0,$fp,24
	la	$a1,$LC2
	lw	$a2,68($fp)
	la	$t9,sprintf
	jal	$ra,$t9
	li	$v0,1			# 0x1
	sw	$v0,44($fp)
	sw	$zero,40($fp)
$L28:
	lw	$v0,40($fp)
	slt	$v0,$v0,20
	beq	$v0,$zero,$L29
	lw	$v1,44($fp)
	li	$v0,1			# 0x1
	beq	$v1,$v0,$L30
	b	$L29
$L30:
	lw	$v1,40($fp)
	addu	$v0,$fp,24
	addu	$v0,$v0,$v1
	lb	$v0,0($v0)
	bne	$v0,$zero,$L32
	sw	$zero,44($fp)
	b	$L33
$L32:
	lw	$v0,36($fp)
	addu	$v0,$v0,1
	sw	$v0,36($fp)
$L33:
	lw	$v0,40($fp)
	addu	$v0,$v0,1
	sw	$v0,40($fp)
	b	$L28
$L29:
	lw	$v0,24($fp)
	lw	$v1,64($fp)
	sw	$v0,0($v1)
	lw	$v0,28($fp)
	lw	$v1,64($fp)
	sw	$v0,4($v1)
	lw	$v0,32($fp)
	lw	$v1,64($fp)
	sw	$v0,8($v1)
	lw	$v0,36($fp)
	lw	$v1,64($fp)
	sw	$v0,12($v1)
	lw	$v0,64($fp)
	move	$sp,$fp
	lw	$ra,56($sp)
	lw	$fp,52($sp)
	addu	$sp,$sp,64
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
	.rdata
	.align	2
$LC4:
	.ascii	"[Error] Hubo un error de asignacion de memoria (bufferTo"
	.ascii	"Load). \n\000"
	.text
	.align	2
	.globl	writeHeader
	.ent	writeHeader
writeHeader:
	.frame	$fp,96,$ra		# vars= 56, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,96
	.cprestore 16
	sw	$ra,88($sp)
	sw	$fp,84($sp)
	sw	$gp,80($sp)
	move	$fp,$sp
	sw	$a0,96($fp)
	sw	$a1,100($fp)
	sw	$a2,104($fp)
	addu	$a0,$fp,24
	lw	$a1,96($fp)
	la	$t9,convertIntToCharacter
	jal	$ra,$t9
	addu	$v0,$fp,40
	move	$a0,$v0
	lw	$a1,100($fp)
	la	$t9,convertIntToCharacter
	jal	$ra,$t9
	lw	$v1,52($fp)
	lw	$v0,36($fp)
	addu	$v0,$v1,$v0
	addu	$v0,$v0,9
	sw	$v0,56($fp)
	lw	$a0,56($fp)
	la	$t9,malloc
	jal	$ra,$t9
	sw	$v0,60($fp)
	lw	$v0,60($fp)
	bne	$v0,$zero,$L43
	la	$a0,__sF+176
	la	$a1,$LC4
	la	$t9,fprintf
	jal	$ra,$t9
	li	$v0,2			# 0x2
	sw	$v0,76($fp)
	b	$L42
$L43:
	lw	$v1,60($fp)
	li	$v0,80			# 0x50
	sb	$v0,0($v1)
	lw	$v0,60($fp)
	addu	$v1,$v0,1
	li	$v0,50			# 0x32
	sb	$v0,0($v1)
	lw	$v0,60($fp)
	addu	$v1,$v0,2
	li	$v0,10			# 0xa
	sb	$v0,0($v1)
	li	$v0,3			# 0x3
	sw	$v0,64($fp)
	sw	$zero,68($fp)
$L44:
	lw	$v0,68($fp)
	lw	$v1,36($fp)
	slt	$v0,$v0,$v1
	bne	$v0,$zero,$L47
	b	$L45
$L47:
	lw	$v1,60($fp)
	lw	$v0,64($fp)
	addu	$a0,$v1,$v0
	lw	$v1,68($fp)
	addu	$v0,$fp,24
	addu	$v0,$v0,$v1
	lbu	$v0,0($v0)
	sb	$v0,0($a0)
	lw	$v0,64($fp)
	addu	$v0,$v0,1
	sw	$v0,64($fp)
	lw	$v0,68($fp)
	addu	$v0,$v0,1
	sw	$v0,68($fp)
	b	$L44
$L45:
	lw	$v1,60($fp)
	lw	$v0,64($fp)
	addu	$v1,$v1,$v0
	li	$v0,32			# 0x20
	sb	$v0,0($v1)
	lw	$v0,64($fp)
	addu	$v0,$v0,1
	sw	$v0,64($fp)
	sw	$zero,68($fp)
$L48:
	lw	$v0,68($fp)
	lw	$v1,52($fp)
	slt	$v0,$v0,$v1
	bne	$v0,$zero,$L51
	b	$L49
$L51:
	lw	$v1,60($fp)
	lw	$v0,64($fp)
	addu	$a0,$v1,$v0
	addu	$v1,$fp,40
	lw	$v0,68($fp)
	addu	$v0,$v1,$v0
	lbu	$v0,0($v0)
	sb	$v0,0($a0)
	lw	$v0,64($fp)
	addu	$v0,$v0,1
	sw	$v0,64($fp)
	lw	$v0,68($fp)
	addu	$v0,$v0,1
	sw	$v0,68($fp)
	b	$L48
$L49:
	lw	$v1,60($fp)
	lw	$v0,64($fp)
	addu	$v1,$v1,$v0
	li	$v0,10			# 0xa
	sb	$v0,0($v1)
	lw	$v0,64($fp)
	addu	$v0,$v0,1
	sw	$v0,64($fp)
	lw	$v1,60($fp)
	lw	$v0,64($fp)
	addu	$v1,$v1,$v0
	li	$v0,50			# 0x32
	sb	$v0,0($v1)
	lw	$v0,64($fp)
	addu	$v0,$v0,1
	sw	$v0,64($fp)
	lw	$v1,60($fp)
	lw	$v0,64($fp)
	addu	$v1,$v1,$v0
	li	$v0,53			# 0x35
	sb	$v0,0($v1)
	lw	$v0,64($fp)
	addu	$v0,$v0,1
	sw	$v0,64($fp)
	lw	$v1,60($fp)
	lw	$v0,64($fp)
	addu	$v1,$v1,$v0
	li	$v0,53			# 0x35
	sb	$v0,0($v1)
	lw	$v0,64($fp)
	addu	$v0,$v0,1
	sw	$v0,64($fp)
	lw	$v1,60($fp)
	lw	$v0,64($fp)
	addu	$v1,$v1,$v0
	li	$v0,10			# 0xa
	sb	$v0,0($v1)
	lw	$a0,60($fp)
	lw	$a1,56($fp)
	la	$t9,writeBufferInOFile
	jal	$ra,$t9
	sw	$v0,72($fp)
	lw	$a0,60($fp)
	la	$t9,free
	jal	$ra,$t9
	lw	$v0,72($fp)
	beq	$v0,$zero,$L52
	la	$t9,closeFile
	jal	$ra,$t9
	li	$v0,3			# 0x3
	sw	$v0,76($fp)
	b	$L42
$L52:
	sw	$zero,76($fp)
$L42:
	lw	$v0,76($fp)
	move	$sp,$fp
	lw	$ra,88($sp)
	lw	$fp,84($sp)
	addu	$sp,$sp,96
	j	$ra
	.end	writeHeader
	.size	writeHeader, .-writeHeader
	.rdata
	.align	2
$LC5:
	.ascii	"[Error] Hubo un error de asignacion de memoria (buffer)."
	.ascii	" \n\000"
	.text
	.align	2
	.globl	loadDataInBuffer
	.ent	loadDataInBuffer
loadDataInBuffer:
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
	move	$v0,$a0
	sb	$v0,24($fp)
	lw	$v0,buffer
	bne	$v0,$zero,$L54
	li	$a0,100			# 0x64
	la	$t9,malloc
	jal	$ra,$t9
	sw	$v0,buffer
	lw	$v0,buffer
	bne	$v0,$zero,$L55
	la	$a0,__sF+176
	la	$a1,$LC5
	la	$t9,fprintf
	jal	$ra,$t9
	li	$v0,2			# 0x2
	sw	$v0,28($fp)
	b	$L53
$L55:
	sw	$zero,quantityCharactersInBuffer
$L54:
	lw	$v1,buffer
	lw	$v0,quantityCharactersInBuffer
	addu	$v1,$v1,$v0
	lbu	$v0,24($fp)
	sb	$v0,0($v1)
	lw	$v0,quantityCharactersInBuffer
	addu	$v0,$v0,1
	sw	$v0,quantityCharactersInBuffer
	sw	$zero,28($fp)
$L53:
	lw	$v0,28($fp)
	move	$sp,$fp
	lw	$ra,40($sp)
	lw	$fp,36($sp)
	addu	$sp,$sp,48
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
	beq	$v0,$zero,$L57
	lb	$v0,24($fp)
	move	$a0,$v0
	la	$t9,loadDataInBuffer
	jal	$ra,$t9
	sw	$v0,32($fp)
	b	$L56
$L57:
	lw	$a0,buffer
	lw	$a1,quantityCharactersInBuffer
	la	$t9,writeBufferInOFile
	jal	$ra,$t9
	sw	$v0,28($fp)
	lw	$v0,28($fp)
	beq	$v0,$zero,$L58
	lw	$v0,28($fp)
	sw	$v0,32($fp)
	b	$L56
$L58:
	sw	$zero,quantityCharactersInBuffer
	lb	$v0,24($fp)
	move	$a0,$v0
	la	$t9,loadDataInBuffer
	jal	$ra,$t9
	sw	$v0,32($fp)
$L56:
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
	blez	$v0,$L60
	lw	$a0,buffer
	lw	$a1,quantityCharactersInBuffer
	la	$t9,writeBufferInOFile
	jal	$ra,$t9
	sw	$v0,24($fp)
	b	$L59
$L60:
	sw	$zero,24($fp)
$L59:
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
$L62:
	lw	$v0,44($fp)
	lw	$v1,36($fp)
	slt	$v0,$v0,$v1
	bne	$v0,$zero,$L65
	b	$L63
$L65:
	lw	$v1,44($fp)
	addu	$v0,$fp,24
	addu	$v0,$v0,$v1
	lb	$v0,0($v0)
	move	$a0,$v0
	la	$t9,putch
	jal	$ra,$t9
	sw	$v0,40($fp)
	lw	$v0,40($fp)
	beq	$v0,$zero,$L64
	lw	$v0,40($fp)
	sw	$v0,48($fp)
	b	$L61
$L64:
	lw	$v0,44($fp)
	addu	$v0,$v0,1
	sw	$v0,44($fp)
	b	$L62
$L63:
	lw	$v0,40($fp)
	sw	$v0,48($fp)
$L61:
	lw	$v0,48($fp)
	move	$sp,$fp
	lw	$ra,64($sp)
	lw	$fp,60($sp)
	addu	$sp,$sp,72
	j	$ra
	.end	loadPixelBrightness
	.size	loadPixelBrightness, .-loadPixelBrightness
	.align	2
	.globl	freeBuffer
	.ent	freeBuffer
freeBuffer:
	.frame	$fp,40,$ra		# vars= 0, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,40
	.cprestore 16
	sw	$ra,32($sp)
	sw	$fp,28($sp)
	sw	$gp,24($sp)
	move	$fp,$sp
	lw	$v0,buffer
	beq	$v0,$zero,$L67
	lw	$a0,buffer
	la	$t9,free
	jal	$ra,$t9
	sw	$zero,buffer
$L67:
	move	$sp,$fp
	lw	$ra,32($sp)
	lw	$fp,28($sp)
	addu	$sp,$sp,40
	j	$ra
	.end	freeBuffer
	.size	freeBuffer, .-freeBuffer

	.comm	fileOutput,4

	.comm	ofd,4

	.comm	buffer,4
	.ident	"GCC: (GNU) 3.3.3 (NetBSD nb3 20040520)"
