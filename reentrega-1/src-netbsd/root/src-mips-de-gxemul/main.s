	.file	1 "main.c"
	.section .mdebug.abi32
	.previous
	.abicalls
	.globl	x_res
	.data
	.align	2
	.type	x_res, @object
	.size	x_res, 4
x_res:
	.word	640
	.globl	y_res
	.align	2
	.type	y_res, @object
	.size	y_res, 4
y_res:
	.word	480
	.globl	upper_left_re
	.align	2
	.type	upper_left_re, @object
	.size	upper_left_re, 4
upper_left_re:
	.word	-1082130432
	.globl	upper_left_im
	.align	2
	.type	upper_left_im, @object
	.size	upper_left_im, 4
upper_left_im:
	.word	1065353216
	.globl	lower_right_re
	.align	2
	.type	lower_right_re, @object
	.size	lower_right_re, 4
lower_right_re:
	.word	1065353216
	.globl	lower_right_im
	.align	2
	.type	lower_right_im, @object
	.size	lower_right_im, 4
lower_right_im:
	.word	-1082130432
	.globl	seed_re
	.align	2
	.type	seed_re, @object
	.size	seed_re, 4
seed_re:
	.word	-1086712368
	.globl	seed_im
	.align	2
	.type	seed_im, @object
	.size	seed_im, 4
seed_im:
	.word	1044474785
	.globl	plot
	.globl	plot
	.section	.bss
	.align	2
	.type	plot, @object
	.size	plot, 4
plot:
	.space	4
	.globl	output
	.globl	output
	.align	2
	.type	output, @object
	.size	output, 4
output:
	.space	4
	.text
	.align	2
	.globl	main
	.ent	main
main:
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
	sw	$a0,40($fp)
	sw	$a1,44($fp)
	sw	$a2,48($fp)
	lw	$a0,40($fp)
	lw	$a1,44($fp)
	la	$t9,parse_cmdline
	jal	$ra,$t9
	la	$t9,do_plot
	jal	$ra,$t9
	move	$v0,$zero
	move	$sp,$fp
	lw	$ra,32($sp)
	lw	$fp,28($sp)
	addu	$sp,$sp,40
	j	$ra
	.end	main
	.size	main, .-main
	.rdata
	.align	2
$LC0:
	.ascii	"help\000"
	.align	2
$LC1:
	.ascii	"version\000"
	.align	2
$LC2:
	.ascii	"geometry\000"
	.align	2
$LC3:
	.ascii	"resolution\000"
	.align	2
$LC4:
	.ascii	"center\000"
	.align	2
$LC5:
	.ascii	"width\000"
	.align	2
$LC6:
	.ascii	"height\000"
	.align	2
$LC7:
	.ascii	"output\000"
	.data
	.align	2
$LC8:
	.word	$LC0
	.word	0
	.word	0
	.word	104
	.word	$LC1
	.word	0
	.word	0
	.word	86
	.word	$LC2
	.word	1
	.word	0
	.word	103
	.word	$LC3
	.word	1
	.word	0
	.word	114
	.word	$LC4
	.word	1
	.word	0
	.word	99
	.word	$LC5
	.word	1
	.word	0
	.word	119
	.word	$LC6
	.word	1
	.word	0
	.word	72
	.word	$LC7
	.word	1
	.word	0
	.word	111
	.globl	memcpy
	.rdata
	.align	2
$LC9:
	.ascii	"hc:H:m:o:r:w:g:V\000"
	.text
	.align	2
	.ent	parse_cmdline
parse_cmdline:
	.frame	$fp,192,$ra		# vars= 144, regs= 3/0, args= 24, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,192
	.cprestore 24
	sw	$ra,184($sp)
	sw	$fp,180($sp)
	sw	$gp,176($sp)
	move	$fp,$sp
	sw	$a0,192($fp)
	sw	$a1,196($fp)
	sw	$zero,36($fp)
	addu	$v0,$fp,40
	la	$v1,$LC8
	move	$a0,$v0
	move	$a1,$v1
	li	$a2,128			# 0x80
	la	$t9,memcpy
	jal	$ra,$t9
$L19:
	addu	$v1,$fp,40
	addu	$v0,$fp,36
	sw	$v0,16($sp)
	lw	$a0,192($fp)
	lw	$a1,196($fp)
	la	$a2,$LC9
	move	$a3,$v1
	la	$t9,getopt_long
	jal	$ra,$t9
	sw	$v0,32($fp)
	lw	$v1,32($fp)
	li	$v0,-1			# 0xffffffffffffffff
	bne	$v1,$v0,$L21
	b	$L20
$L21:
	lw	$v0,32($fp)
	addu	$v0,$v0,-72
	sw	$v0,168($fp)
	lw	$v1,168($fp)
	sltu	$v0,$v1,48
	beq	$v0,$zero,$L32
	lw	$v0,168($fp)
	sll	$v1,$v0,2
	la	$v0,$L33
	addu	$v0,$v1,$v0
	lw	$v0,0($v0)
	.cpadd	$v0
	j	$v0
	.rdata
	.align	2
$L33:
	.gpword	$L29
	.gpword	$L32
	.gpword	$L32
	.gpword	$L32
	.gpword	$L32
	.gpword	$L32
	.gpword	$L32
	.gpword	$L32
	.gpword	$L32
	.gpword	$L32
	.gpword	$L32
	.gpword	$L32
	.gpword	$L32
	.gpword	$L32
	.gpword	$L24
	.gpword	$L32
	.gpword	$L32
	.gpword	$L32
	.gpword	$L32
	.gpword	$L32
	.gpword	$L32
	.gpword	$L32
	.gpword	$L32
	.gpword	$L32
	.gpword	$L32
	.gpword	$L32
	.gpword	$L32
	.gpword	$L27
	.gpword	$L32
	.gpword	$L32
	.gpword	$L32
	.gpword	$L25
	.gpword	$L23
	.gpword	$L32
	.gpword	$L32
	.gpword	$L32
	.gpword	$L32
	.gpword	$L30
	.gpword	$L32
	.gpword	$L31
	.gpword	$L32
	.gpword	$L32
	.gpword	$L26
	.gpword	$L32
	.gpword	$L32
	.gpword	$L32
	.gpword	$L32
	.gpword	$L28
	.text
$L23:
	lw	$v0,196($fp)
	lw	$a0,0($v0)
	move	$a1,$zero
	la	$t9,do_usage
	jal	$ra,$t9
	b	$L19
$L24:
	lw	$v0,196($fp)
	lw	$a0,0($v0)
	la	$t9,do_version
	jal	$ra,$t9
	b	$L19
$L25:
	lw	$v0,196($fp)
	lw	$a0,0($v0)
	lw	$a1,optarg
	la	$t9,do_geometry
	jal	$ra,$t9
	b	$L19
$L26:
	lw	$v0,196($fp)
	lw	$a0,0($v0)
	lw	$a1,optarg
	la	$t9,do_resolution
	jal	$ra,$t9
	b	$L19
$L27:
	lw	$v0,196($fp)
	lw	$a0,0($v0)
	lw	$a1,optarg
	la	$t9,do_center
	jal	$ra,$t9
	b	$L19
$L28:
	lw	$v0,196($fp)
	lw	$a0,0($v0)
	lw	$a1,optarg
	la	$t9,do_width
	jal	$ra,$t9
	b	$L19
$L29:
	lw	$v0,196($fp)
	lw	$a0,0($v0)
	lw	$a1,optarg
	la	$t9,do_height
	jal	$ra,$t9
	b	$L19
$L30:
	lw	$v0,196($fp)
	lw	$a0,0($v0)
	lw	$a1,optarg
	la	$t9,do_method
	jal	$ra,$t9
	b	$L19
$L31:
	lw	$v0,196($fp)
	lw	$a0,0($v0)
	lw	$a1,optarg
	la	$t9,do_output
	jal	$ra,$t9
	b	$L19
$L32:
	lw	$v0,196($fp)
	lw	$a0,0($v0)
	li	$a1,1			# 0x1
	la	$t9,do_usage
	jal	$ra,$t9
	b	$L19
$L20:
	lw	$v0,plot
	bne	$v0,$zero,$L34
	la	$v0,generic
	sw	$v0,plot
$L34:
	lw	$v0,output
	bne	$v0,$zero,$L18
	la	$v0,__sF+88
	sw	$v0,output
$L18:
	move	$sp,$fp
	lw	$ra,184($sp)
	lw	$fp,180($sp)
	addu	$sp,$sp,192
	j	$ra
	.end	parse_cmdline
	.size	parse_cmdline, .-parse_cmdline
	.rdata
	.align	2
$LC10:
	.ascii	"Usage:\n\000"
	.align	2
$LC11:
	.ascii	"  %s -h\n\000"
	.align	2
$LC12:
	.ascii	"  %s -V\n\000"
	.align	2
$LC13:
	.ascii	"  %s [options]\n\000"
	.align	2
$LC14:
	.ascii	"Options:\n\000"
	.align	2
$LC15:
	.ascii	"  -r, --resolution  Set bitmap resolution to WxH pixels."
	.ascii	"\n\000"
	.align	2
$LC16:
	.ascii	"  -c, --center      Set coordinates for the center of th"
	.ascii	"e image.\n\000"
	.align	2
$LC17:
	.ascii	"  -w, --width       Change the width of the spanned regi"
	.ascii	"on.\n\000"
	.align	2
$LC18:
	.ascii	"  -H, --height      Change the height of the spanned reg"
	.ascii	"ion.\n\000"
	.align	2
$LC19:
	.ascii	"  -o, --output      Path to output file.\n\000"
	.align	2
$LC20:
	.ascii	"Examples:\n\000"
	.align	2
$LC21:
	.ascii	"  %s -o output.pgm\n\000"
	.align	2
$LC22:
	.ascii	"  %s -r 1600x1200 -o output.pgm\n\000"
	.align	2
$LC23:
	.ascii	"  %s -c +0.282+0.01i -o output.pgm\n\000"
	.text
	.align	2
	.ent	do_usage
do_usage:
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
	sw	$a0,40($fp)
	sw	$a1,44($fp)
	la	$a0,__sF+176
	la	$a1,$LC10
	la	$t9,fprintf
	jal	$ra,$t9
	la	$a0,__sF+176
	la	$a1,$LC11
	lw	$a2,40($fp)
	la	$t9,fprintf
	jal	$ra,$t9
	la	$a0,__sF+176
	la	$a1,$LC12
	lw	$a2,40($fp)
	la	$t9,fprintf
	jal	$ra,$t9
	la	$a0,__sF+176
	la	$a1,$LC13
	lw	$a2,40($fp)
	la	$t9,fprintf
	jal	$ra,$t9
	la	$a0,__sF+176
	la	$a1,$LC14
	la	$t9,fprintf
	jal	$ra,$t9
	la	$a0,__sF+176
	la	$a1,$LC15
	la	$t9,fprintf
	jal	$ra,$t9
	la	$a0,__sF+176
	la	$a1,$LC16
	la	$t9,fprintf
	jal	$ra,$t9
	la	$a0,__sF+176
	la	$a1,$LC17
	la	$t9,fprintf
	jal	$ra,$t9
	la	$a0,__sF+176
	la	$a1,$LC18
	la	$t9,fprintf
	jal	$ra,$t9
	la	$a0,__sF+176
	la	$a1,$LC19
	la	$t9,fprintf
	jal	$ra,$t9
	la	$a0,__sF+176
	la	$a1,$LC20
	la	$t9,fprintf
	jal	$ra,$t9
	la	$a0,__sF+176
	la	$a1,$LC21
	lw	$a2,40($fp)
	la	$t9,fprintf
	jal	$ra,$t9
	la	$a0,__sF+176
	la	$a1,$LC22
	lw	$a2,40($fp)
	la	$t9,fprintf
	jal	$ra,$t9
	la	$a0,__sF+176
	la	$a1,$LC23
	lw	$a2,40($fp)
	la	$t9,fprintf
	jal	$ra,$t9
	lw	$a0,44($fp)
	la	$t9,exit
	jal	$ra,$t9
	.end	do_usage
	.size	do_usage, .-do_usage
	.rdata
	.align	2
$LC24:
	.ascii	"%s\n\000"
	.align	2
$LC25:
	.ascii	"0.0.1-cvs\000"
	.text
	.align	2
	.ent	do_version
do_version:
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
	sw	$a0,40($fp)
	la	$a0,__sF+176
	la	$a1,$LC24
	la	$a2,$LC25
	la	$t9,fprintf
	jal	$ra,$t9
	move	$a0,$zero
	la	$t9,exit
	jal	$ra,$t9
	.end	do_version
	.size	do_version, .-do_version
	.rdata
	.align	2
$LC26:
	.ascii	"%d%c%d %c\000"
	.text
	.align	2
	.ent	do_resolution
do_resolution:
	.frame	$fp,64,$ra		# vars= 16, regs= 3/0, args= 24, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,64
	.cprestore 24
	sw	$ra,56($sp)
	sw	$fp,52($sp)
	sw	$gp,48($sp)
	move	$fp,$sp
	sw	$a0,64($fp)
	sw	$a1,68($fp)
	addu	$v1,$fp,40
	addu	$v0,$fp,36
	sw	$v0,16($sp)
	addu	$v0,$fp,41
	sw	$v0,20($sp)
	lw	$a0,68($fp)
	la	$a1,$LC26
	addu	$a2,$fp,32
	move	$a3,$v1
	la	$t9,sscanf
	jal	$ra,$t9
	move	$v1,$v0
	li	$v0,3			# 0x3
	bne	$v1,$v0,$L40
	lw	$v0,32($fp)
	blez	$v0,$L40
	lb	$v1,40($fp)
	li	$v0,120			# 0x78
	bne	$v1,$v0,$L40
	lw	$v0,36($fp)
	blez	$v0,$L40
	b	$L39
$L40:
	lw	$a0,64($fp)
	li	$a1,1			# 0x1
	la	$t9,do_usage
	jal	$ra,$t9
$L39:
	lw	$v0,32($fp)
	sw	$v0,x_res
	lw	$v0,36($fp)
	sw	$v0,y_res
	move	$sp,$fp
	lw	$ra,56($sp)
	lw	$fp,52($sp)
	addu	$sp,$sp,64
	j	$ra
	.end	do_resolution
	.size	do_resolution, .-do_resolution
	.rdata
	.align	2
$LC27:
	.ascii	"%lf %c %lf %c %c %lf %c %lf %c %c\000"
	.align	2
$LC28:
	.ascii	"invalid geometry specification.\n\000"
	.text
	.align	2
	.ent	do_geometry
do_geometry:
	.frame	$fp,160,$ra		# vars= 88, regs= 3/0, args= 48, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,160
	.cprestore 48
	sw	$ra,152($sp)
	sw	$fp,148($sp)
	sw	$gp,144($sp)
	move	$fp,$sp
	sw	$a0,160($fp)
	sw	$a1,164($fp)
	addu	$v1,$fp,89
	addu	$v0,$fp,64
	sw	$v0,16($sp)
	addu	$v0,$fp,91
	sw	$v0,20($sp)
	addu	$v0,$fp,88
	sw	$v0,24($sp)
	addu	$v0,$fp,72
	sw	$v0,28($sp)
	addu	$v0,$fp,90
	sw	$v0,32($sp)
	addu	$v0,$fp,80
	sw	$v0,36($sp)
	addu	$v0,$fp,92
	sw	$v0,40($sp)
	addu	$v0,$fp,93
	sw	$v0,44($sp)
	lw	$a0,164($fp)
	la	$a1,$LC27
	addu	$a2,$fp,56
	move	$a3,$v1
	la	$t9,sscanf
	jal	$ra,$t9
	move	$v1,$v0
	li	$v0,9			# 0x9
	bne	$v1,$v0,$L43
	lb	$v1,89($fp)
	li	$v0,43			# 0x2b
	beq	$v1,$v0,$L44
	lb	$v1,89($fp)
	li	$v0,45			# 0x2d
	bne	$v1,$v0,$L43
$L44:
	lb	$v1,90($fp)
	li	$v0,43			# 0x2b
	beq	$v1,$v0,$L45
	lb	$v1,90($fp)
	li	$v0,45			# 0x2d
	bne	$v1,$v0,$L43
$L45:
	lb	$v1,91($fp)
	li	$v0,105			# 0x69
	beq	$v1,$v0,$L46
	lb	$v1,91($fp)
	li	$v0,106			# 0x6a
	bne	$v1,$v0,$L43
$L46:
	lb	$v1,92($fp)
	li	$v0,105			# 0x69
	beq	$v1,$v0,$L47
	lb	$v1,92($fp)
	li	$v0,106			# 0x6a
	bne	$v1,$v0,$L43
$L47:
	lb	$v1,88($fp)
	li	$v0,44			# 0x2c
	bne	$v1,$v0,$L43
	b	$L42
$L43:
	la	$a0,__sF+176
	la	$a1,$LC28
	la	$t9,fprintf
	jal	$ra,$t9
	li	$a0,1			# 0x1
	la	$t9,exit
	jal	$ra,$t9
$L42:
	l.d	$f0,64($fp)
	s.d	$f0,96($fp)
	lb	$v1,89($fp)
	li	$v0,45			# 0x2d
	bne	$v1,$v0,$L48
	l.d	$f2,96($fp)
	neg.d	$f2,$f2
	s.d	$f2,96($fp)
$L48:
	l.d	$f0,96($fp)
	s.d	$f0,64($fp)
	l.d	$f2,80($fp)
	s.d	$f2,104($fp)
	lb	$v1,90($fp)
	li	$v0,45			# 0x2d
	bne	$v1,$v0,$L49
	l.d	$f0,104($fp)
	neg.d	$f0,$f0
	s.d	$f0,104($fp)
$L49:
	l.d	$f2,104($fp)
	s.d	$f2,80($fp)
	l.d	$f2,56($fp)
	l.d	$f0,72($fp)
	c.le.d	$f2,$f0
	bc1t	$L52
	b	$L50
$L52:
	l.d	$f0,56($fp)
	s.d	$f0,112($fp)
	b	$L51
$L50:
	l.d	$f2,72($fp)
	s.d	$f2,112($fp)
$L51:
	l.d	$f2,112($fp)
	cvt.s.d	$f0,$f2
	s.s	$f0,upper_left_re
	l.d	$f2,64($fp)
	l.d	$f0,80($fp)
	c.le.d	$f0,$f2
	bc1t	$L55
	b	$L53
$L55:
	l.d	$f0,64($fp)
	s.d	$f0,120($fp)
	b	$L54
$L53:
	l.d	$f2,80($fp)
	s.d	$f2,120($fp)
$L54:
	l.d	$f2,120($fp)
	cvt.s.d	$f0,$f2
	s.s	$f0,upper_left_im
	l.d	$f2,56($fp)
	l.d	$f0,72($fp)
	c.le.d	$f0,$f2
	bc1t	$L58
	b	$L56
$L58:
	l.d	$f0,56($fp)
	s.d	$f0,128($fp)
	b	$L57
$L56:
	l.d	$f2,72($fp)
	s.d	$f2,128($fp)
$L57:
	l.d	$f2,128($fp)
	cvt.s.d	$f0,$f2
	s.s	$f0,lower_right_re
	l.d	$f2,64($fp)
	l.d	$f0,80($fp)
	c.le.d	$f2,$f0
	bc1t	$L61
	b	$L59
$L61:
	l.d	$f0,64($fp)
	s.d	$f0,136($fp)
	b	$L60
$L59:
	l.d	$f2,80($fp)
	s.d	$f2,136($fp)
$L60:
	l.d	$f2,136($fp)
	cvt.s.d	$f0,$f2
	s.s	$f0,lower_right_im
	move	$sp,$fp
	lw	$ra,152($sp)
	lw	$fp,148($sp)
	addu	$sp,$sp,160
	j	$ra
	.end	do_geometry
	.size	do_geometry, .-do_geometry
	.rdata
	.align	2
$LC29:
	.ascii	"%lf %c %lf %c %c\000"
	.align	2
$LC30:
	.ascii	"invalid center specification.\n\000"
	.align	3
$LC31:
	.word	0
	.word	1073741824
	.text
	.align	2
	.ent	do_center
do_center:
	.frame	$fp,104,$ra		# vars= 48, regs= 3/0, args= 32, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,104
	.cprestore 32
	sw	$ra,96($sp)
	sw	$fp,92($sp)
	sw	$gp,88($sp)
	move	$fp,$sp
	sw	$a0,104($fp)
	sw	$a1,108($fp)
	addu	$v1,$fp,56
	addu	$a3,$fp,73
	addu	$v0,$fp,64
	sw	$v0,16($sp)
	addu	$v0,$fp,72
	sw	$v0,20($sp)
	addu	$v0,$fp,74
	sw	$v0,24($sp)
	lw	$a0,108($fp)
	la	$a1,$LC29
	move	$a2,$v1
	la	$t9,sscanf
	jal	$ra,$t9
	move	$v1,$v0
	li	$v0,4			# 0x4
	bne	$v1,$v0,$L64
	lb	$v1,73($fp)
	li	$v0,43			# 0x2b
	beq	$v1,$v0,$L65
	lb	$v1,73($fp)
	li	$v0,45			# 0x2d
	bne	$v1,$v0,$L64
$L65:
	lb	$v1,72($fp)
	li	$v0,105			# 0x69
	beq	$v1,$v0,$L63
	lb	$v1,72($fp)
	li	$v0,106			# 0x6a
	bne	$v1,$v0,$L64
	b	$L63
$L64:
	la	$a0,__sF+176
	la	$a1,$LC30
	la	$t9,fprintf
	jal	$ra,$t9
	li	$a0,1			# 0x1
	la	$t9,exit
	jal	$ra,$t9
$L63:
	l.d	$f0,64($fp)
	s.d	$f0,80($fp)
	lb	$v1,73($fp)
	li	$v0,45			# 0x2d
	bne	$v1,$v0,$L66
	l.d	$f0,80($fp)
	neg.d	$f0,$f0
	s.d	$f0,80($fp)
$L66:
	l.d	$f0,80($fp)
	s.d	$f0,64($fp)
	l.s	$f2,upper_left_re
	l.s	$f0,lower_right_re
	sub.s	$f0,$f2,$f0
	cvt.d.s	$f0,$f0
	abs.d	$f0,$f0
	s.d	$f0,40($fp)
	l.s	$f2,upper_left_im
	l.s	$f0,lower_right_im
	sub.s	$f0,$f2,$f0
	cvt.d.s	$f0,$f0
	abs.d	$f0,$f0
	s.d	$f0,48($fp)
	l.d	$f2,40($fp)
	l.d	$f0,$LC31
	div.d	$f2,$f2,$f0
	l.d	$f0,56($fp)
	sub.d	$f0,$f0,$f2
	cvt.s.d	$f0,$f0
	s.s	$f0,upper_left_re
	l.d	$f2,48($fp)
	l.d	$f0,$LC31
	div.d	$f2,$f2,$f0
	l.d	$f0,64($fp)
	add.d	$f0,$f2,$f0
	cvt.s.d	$f0,$f0
	s.s	$f0,upper_left_im
	l.d	$f2,40($fp)
	l.d	$f0,$LC31
	div.d	$f2,$f2,$f0
	l.d	$f0,56($fp)
	add.d	$f0,$f2,$f0
	cvt.s.d	$f0,$f0
	s.s	$f0,lower_right_re
	l.d	$f2,48($fp)
	l.d	$f0,$LC31
	div.d	$f2,$f2,$f0
	l.d	$f0,64($fp)
	sub.d	$f0,$f0,$f2
	cvt.s.d	$f0,$f0
	s.s	$f0,lower_right_im
	move	$sp,$fp
	lw	$ra,96($sp)
	lw	$fp,92($sp)
	addu	$sp,$sp,104
	j	$ra
	.end	do_center
	.size	do_center, .-do_center
	.rdata
	.align	2
$LC32:
	.ascii	"%lf %c\000"
	.align	2
$LC33:
	.ascii	"invalid height specification.\n\000"
	.align	2
$LC34:
	.word	1073741824
	.align	3
$LC35:
	.word	0
	.word	1073741824
	.text
	.align	2
	.ent	do_height
do_height:
	.frame	$fp,80,$ra		# vars= 40, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,80
	.cprestore 16
	sw	$ra,72($sp)
	sw	$fp,68($sp)
	sw	$gp,64($sp)
	move	$fp,$sp
	sw	$a0,80($fp)
	sw	$a1,84($fp)
	addu	$v0,$fp,32
	addu	$v1,$fp,56
	lw	$a0,84($fp)
	la	$a1,$LC32
	move	$a2,$v0
	move	$a3,$v1
	la	$t9,sscanf
	jal	$ra,$t9
	move	$v1,$v0
	li	$v0,1			# 0x1
	bne	$v1,$v0,$L69
	l.d	$f2,32($fp)
	mtc1	$zero,$f0
	mtc1	$zero,$f1
	c.le.d	$f2,$f0
	bc1t	$L69
	b	$L68
$L69:
	la	$a0,__sF+176
	la	$a1,$LC33
	la	$t9,fprintf
	jal	$ra,$t9
	li	$a0,1			# 0x1
	la	$t9,exit
	jal	$ra,$t9
$L68:
	l.s	$f2,upper_left_re
	l.s	$f0,lower_right_re
	add.s	$f2,$f2,$f0
	l.s	$f0,$LC34
	div.s	$f0,$f2,$f0
	cvt.d.s	$f0,$f0
	s.d	$f0,40($fp)
	l.s	$f2,upper_left_im
	l.s	$f0,lower_right_im
	add.s	$f2,$f2,$f0
	l.s	$f0,$LC34
	div.s	$f0,$f2,$f0
	cvt.d.s	$f0,$f0
	s.d	$f0,48($fp)
	l.s	$f2,upper_left_re
	l.s	$f0,lower_right_re
	sub.s	$f0,$f2,$f0
	cvt.d.s	$f0,$f0
	abs.d	$f0,$f0
	s.d	$f0,24($fp)
	l.d	$f2,24($fp)
	l.d	$f0,$LC35
	div.d	$f2,$f2,$f0
	l.d	$f0,40($fp)
	sub.d	$f0,$f0,$f2
	cvt.s.d	$f0,$f0
	s.s	$f0,upper_left_re
	l.d	$f2,32($fp)
	l.d	$f0,$LC35
	div.d	$f2,$f2,$f0
	l.d	$f0,48($fp)
	add.d	$f0,$f2,$f0
	cvt.s.d	$f0,$f0
	s.s	$f0,upper_left_im
	l.d	$f2,24($fp)
	l.d	$f0,$LC35
	div.d	$f2,$f2,$f0
	l.d	$f0,40($fp)
	add.d	$f0,$f2,$f0
	cvt.s.d	$f0,$f0
	s.s	$f0,lower_right_re
	l.d	$f2,32($fp)
	l.d	$f0,$LC35
	div.d	$f2,$f2,$f0
	l.d	$f0,48($fp)
	sub.d	$f0,$f0,$f2
	cvt.s.d	$f0,$f0
	s.s	$f0,lower_right_im
	move	$sp,$fp
	lw	$ra,72($sp)
	lw	$fp,68($sp)
	addu	$sp,$sp,80
	j	$ra
	.end	do_height
	.size	do_height, .-do_height
	.rdata
	.align	2
$LC36:
	.ascii	"invalid width specification.\n\000"
	.align	2
$LC37:
	.word	1073741824
	.align	3
$LC38:
	.word	0
	.word	1073741824
	.text
	.align	2
	.ent	do_width
do_width:
	.frame	$fp,80,$ra		# vars= 40, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,80
	.cprestore 16
	sw	$ra,72($sp)
	sw	$fp,68($sp)
	sw	$gp,64($sp)
	move	$fp,$sp
	sw	$a0,80($fp)
	sw	$a1,84($fp)
	addu	$v0,$fp,56
	lw	$a0,84($fp)
	la	$a1,$LC32
	addu	$a2,$fp,24
	move	$a3,$v0
	la	$t9,sscanf
	jal	$ra,$t9
	move	$v1,$v0
	li	$v0,1			# 0x1
	bne	$v1,$v0,$L72
	l.d	$f2,24($fp)
	mtc1	$zero,$f0
	mtc1	$zero,$f1
	c.le.d	$f2,$f0
	bc1t	$L72
	b	$L71
$L72:
	la	$a0,__sF+176
	la	$a1,$LC36
	la	$t9,fprintf
	jal	$ra,$t9
	li	$a0,1			# 0x1
	la	$t9,exit
	jal	$ra,$t9
$L71:
	l.s	$f2,upper_left_re
	l.s	$f0,lower_right_re
	add.s	$f2,$f2,$f0
	l.s	$f0,$LC37
	div.s	$f0,$f2,$f0
	cvt.d.s	$f0,$f0
	s.d	$f0,40($fp)
	l.s	$f2,upper_left_im
	l.s	$f0,lower_right_im
	add.s	$f2,$f2,$f0
	l.s	$f0,$LC37
	div.s	$f0,$f2,$f0
	cvt.d.s	$f0,$f0
	s.d	$f0,48($fp)
	l.s	$f2,upper_left_im
	l.s	$f0,lower_right_im
	sub.s	$f0,$f2,$f0
	cvt.d.s	$f0,$f0
	abs.d	$f0,$f0
	s.d	$f0,32($fp)
	l.d	$f2,24($fp)
	l.d	$f0,$LC38
	div.d	$f2,$f2,$f0
	l.d	$f0,40($fp)
	sub.d	$f0,$f0,$f2
	cvt.s.d	$f0,$f0
	s.s	$f0,upper_left_re
	l.d	$f2,32($fp)
	l.d	$f0,$LC38
	div.d	$f2,$f2,$f0
	l.d	$f0,48($fp)
	add.d	$f0,$f2,$f0
	cvt.s.d	$f0,$f0
	s.s	$f0,upper_left_im
	l.d	$f2,24($fp)
	l.d	$f0,$LC38
	div.d	$f2,$f2,$f0
	l.d	$f0,40($fp)
	add.d	$f0,$f2,$f0
	cvt.s.d	$f0,$f0
	s.s	$f0,lower_right_re
	l.d	$f2,32($fp)
	l.d	$f0,$LC38
	div.d	$f2,$f2,$f0
	l.d	$f0,48($fp)
	sub.d	$f0,$f0,$f2
	cvt.s.d	$f0,$f0
	s.s	$f0,lower_right_im
	move	$sp,$fp
	lw	$ra,72($sp)
	lw	$fp,68($sp)
	addu	$sp,$sp,80
	j	$ra
	.end	do_width
	.size	do_width, .-do_width
	.rdata
	.align	2
$LC39:
	.ascii	"mips32\000"
	.text
	.align	2
	.ent	do_method
do_method:
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
	sw	$a0,40($fp)
	sw	$a1,44($fp)
	lw	$a0,44($fp)
	la	$a1,$LC39
	la	$t9,strcmp
	jal	$ra,$t9
	bne	$v0,$zero,$L74
	la	$v0,mips32_plot
	sw	$v0,plot
	b	$L73
$L74:
	la	$v0,generic
	sw	$v0,plot
$L73:
	move	$sp,$fp
	lw	$ra,32($sp)
	lw	$fp,28($sp)
	addu	$sp,$sp,40
	j	$ra
	.end	do_method
	.size	do_method, .-do_method
	.rdata
	.align	2
$LC40:
	.ascii	"multiple do output files.\000"
	.align	2
$LC41:
	.ascii	"-\000"
	.align	2
$LC42:
	.ascii	"w\000"
	.align	2
$LC43:
	.ascii	"cannot open output file.\n\000"
	.text
	.align	2
	.ent	do_output
do_output:
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
	sw	$a0,40($fp)
	sw	$a1,44($fp)
	lw	$v0,output
	beq	$v0,$zero,$L76
	la	$a0,__sF+176
	la	$a1,$LC40
	la	$t9,fprintf
	jal	$ra,$t9
	li	$a0,1			# 0x1
	la	$t9,exit
	jal	$ra,$t9
$L76:
	lw	$a0,44($fp)
	la	$a1,$LC41
	la	$t9,strcmp
	jal	$ra,$t9
	bne	$v0,$zero,$L77
	la	$v0,__sF+88
	sw	$v0,output
	b	$L75
$L77:
	lw	$a0,44($fp)
	la	$a1,$LC42
	la	$t9,fopen
	jal	$ra,$t9
	sw	$v0,output
	lw	$v0,output
	bne	$v0,$zero,$L75
	la	$a0,__sF+176
	la	$a1,$LC43
	la	$t9,fprintf
	jal	$ra,$t9
	li	$a0,1			# 0x1
	la	$t9,exit
	jal	$ra,$t9
$L75:
	move	$sp,$fp
	lw	$ra,32($sp)
	lw	$fp,28($sp)
	addu	$sp,$sp,40
	j	$ra
	.end	do_output
	.size	do_output, .-do_output
	.align	2
	.ent	do_plot
do_plot:
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
	addu	$a0,$fp,24
	move	$a1,$zero
	li	$a2,48			# 0x30
	la	$t9,memset
	jal	$ra,$t9
	l.s	$f0,upper_left_re
	s.s	$f0,24($fp)
	l.s	$f0,upper_left_im
	s.s	$f0,28($fp)
	l.s	$f0,lower_right_re
	s.s	$f0,32($fp)
	l.s	$f0,lower_right_im
	s.s	$f0,36($fp)
	l.s	$f2,lower_right_re
	l.s	$f0,upper_left_re
	sub.s	$f2,$f2,$f0
	l.s	$f0,x_res
	cvt.s.w	$f0,$f0
	div.s	$f0,$f2,$f0
	s.s	$f0,40($fp)
	l.s	$f2,upper_left_im
	l.s	$f0,lower_right_im
	sub.s	$f2,$f2,$f0
	l.s	$f0,y_res
	cvt.s.w	$f0,$f0
	div.s	$f0,$f2,$f0
	s.s	$f0,44($fp)
	l.s	$f0,seed_re
	s.s	$f0,48($fp)
	l.s	$f0,seed_im
	s.s	$f0,52($fp)
	lw	$v0,x_res
	sw	$v0,56($fp)
	lw	$v0,y_res
	sw	$v0,60($fp)
	li	$v0,256			# 0x100
	sw	$v0,64($fp)
	lw	$v0,output
	sw	$v0,68($fp)
	lw	$v0,plot
	addu	$a0,$fp,24
	move	$t9,$v0
	jal	$ra,$t9
	move	$sp,$fp
	lw	$ra,80($sp)
	lw	$fp,76($sp)
	addu	$sp,$sp,88
	j	$ra
	.end	do_plot
	.size	do_plot, .-do_plot
	.ident	"GCC: (GNU) 3.3.3 (NetBSD nb3 20040520)"
