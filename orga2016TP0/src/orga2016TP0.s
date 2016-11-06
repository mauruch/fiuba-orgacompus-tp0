	.file	1 "orga2016TP0.c"
	.section .mdebug.abi32
	.previous
	.abicalls
	.rdata
	.align	2
$LC0:
	.ascii	"No options given\n\000"
	.align	2
$LC6:
	.ascii	"r:c:C:w:H:o:\000"
	.align	2
$LC7:
	.ascii	"Fatal: invalid r specification.\n\000"
	.align	2
$LC8:
	.ascii	"Fatal: invalid c specification.\n\000"
	.align	2
$LC9:
	.ascii	"Fatal: invalid C specification.\n\000"
	.align	2
$LC10:
	.ascii	"Fatal: invalid w specification.\n\000"
	.align	2
$LC11:
	.ascii	"Fatal: invalid H specification.\n\000"
	.align	2
$LC12:
	.ascii	"-\000"
	.align	2
$LC13:
	.ascii	"wb\000"
	.align	2
$LC14:
	.ascii	"Fatal: cannot open output file.\000"
	.align	2
$LC15:
	.ascii	"Fatal: -o parameter is mandatory.\000"
	.align	2
$LC1:
	.word	1142947840
	.align	2
$LC2:
	.word	1139802112
	.align	2
$LC3:
	.word	1049750405
	.align	2
$LC4:
	.word	1008981770
	.align	2
$LC5:
	.word	1082130432
	.text
	.align	2
	.globl	main
	.ent	main
main:
	.frame	$fp,120,$31		# vars= 56, regs= 3/0, args= 40, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	.set	reorder
	subu	$sp,$sp,120
	.cprestore 40
	sw	$31,112($sp)
	sw	$fp,108($sp)
	sw	$28,104($sp)
	move	$fp,$sp
	sw	$4,120($fp)
	sw	$5,124($fp)
	lw	$3,120($fp)
	li	$2,1			# 0x1
	bne	$3,$2,$L18
	la	$4,$LC0
	la	$25,printf
	jal	$31,$25
$L18:
	l.s	$f0,$LC1
	s.s	$f0,52($fp)
	l.s	$f0,$LC2
	s.s	$f0,56($fp)
	sw	$0,60($fp)
	sw	$0,64($fp)
	l.s	$f0,$LC3
	s.s	$f0,68($fp)
	l.s	$f0,$LC4
	s.s	$f0,72($fp)
	l.s	$f0,$LC5
	s.s	$f0,80($fp)
	l.s	$f0,$LC5
	s.s	$f0,84($fp)
	sw	$0,88($fp)
$L19:
	lw	$4,120($fp)
	lw	$5,124($fp)
	la	$6,$LC6
	la	$25,getopt
	jal	$31,$25
	sw	$2,48($fp)
	lw	$3,48($fp)
	li	$2,-1			# 0xffffffffffffffff
	bne	$3,$2,$L21
	b	$L20
$L21:
	lw	$2,48($fp)
	addu	$2,$2,-67
	sw	$2,96($fp)
	lw	$3,96($fp)
	sltu	$2,$3,53
	beq	$2,$0,$L19
	lw	$2,96($fp)
	sll	$3,$2,2
	la	$2,$L37
	addu	$2,$3,$2
	lw	$2,0($2)
	.cpadd	$2
	j	$2
	.rdata
	.align	2
$L37:
	.gpword	$L27
	.gpword	$L19
	.gpword	$L19
	.gpword	$L19
	.gpword	$L19
	.gpword	$L31
	.gpword	$L19
	.gpword	$L19
	.gpword	$L19
	.gpword	$L19
	.gpword	$L19
	.gpword	$L19
	.gpword	$L19
	.gpword	$L19
	.gpword	$L19
	.gpword	$L19
	.gpword	$L19
	.gpword	$L19
	.gpword	$L19
	.gpword	$L19
	.gpword	$L19
	.gpword	$L19
	.gpword	$L19
	.gpword	$L19
	.gpword	$L19
	.gpword	$L19
	.gpword	$L19
	.gpword	$L19
	.gpword	$L19
	.gpword	$L19
	.gpword	$L19
	.gpword	$L19
	.gpword	$L25
	.gpword	$L19
	.gpword	$L19
	.gpword	$L19
	.gpword	$L19
	.gpword	$L19
	.gpword	$L19
	.gpword	$L19
	.gpword	$L19
	.gpword	$L19
	.gpword	$L19
	.gpword	$L19
	.gpword	$L33
	.gpword	$L19
	.gpword	$L19
	.gpword	$L23
	.gpword	$L19
	.gpword	$L19
	.gpword	$L19
	.gpword	$L19
	.gpword	$L29
	.text
$L23:
	addu	$2,$fp,52
	addu	$3,$fp,56
	lw	$4,optarg
	move	$5,$2
	move	$6,$3
	la	$25,setResolution
	jal	$31,$25
	beq	$2,$0,$L19
	la	$4,$LC7
	la	$25,printf
	jal	$31,$25
	li	$2,-1			# 0xffffffffffffffff
	sw	$2,92($fp)
	b	$L17
$L25:
	addu	$2,$fp,60
	addu	$3,$fp,64
	lw	$4,optarg
	move	$5,$2
	move	$6,$3
	la	$25,analyzerComplexParameter
	jal	$31,$25
	beq	$2,$0,$L19
	la	$4,$LC8
	la	$25,printf
	jal	$31,$25
	li	$3,-1			# 0xffffffffffffffff
	sw	$3,92($fp)
	b	$L17
$L27:
	addu	$2,$fp,68
	addu	$3,$fp,72
	lw	$4,optarg
	move	$5,$2
	move	$6,$3
	la	$25,analyzerComplexParameter
	jal	$31,$25
	beq	$2,$0,$L19
	la	$4,$LC9
	la	$25,printf
	jal	$31,$25
	li	$2,-1			# 0xffffffffffffffff
	sw	$2,92($fp)
	b	$L17
$L29:
	lw	$2,optarg
	lb	$3,0($2)
	lw	$2,_ctype_
	addu	$2,$3,$2
	addu	$2,$2,1
	lbu	$2,0($2)
	srl	$2,$2,2
	andi	$2,$2,0x1
	bne	$2,$0,$L30
	la	$4,$LC10
	la	$25,printf
	jal	$31,$25
	li	$3,-1			# 0xffffffffffffffff
	sw	$3,92($fp)
	b	$L17
$L30:
	lw	$4,optarg
	la	$25,atof
	jal	$31,$25
	cvt.s.d	$f0,$f0
	s.s	$f0,80($fp)
	b	$L19
$L31:
	lw	$2,optarg
	lb	$3,0($2)
	lw	$2,_ctype_
	addu	$2,$3,$2
	addu	$2,$2,1
	lbu	$2,0($2)
	srl	$2,$2,2
	andi	$2,$2,0x1
	bne	$2,$0,$L32
	la	$4,$LC11
	la	$25,printf
	jal	$31,$25
	li	$2,-1			# 0xffffffffffffffff
	sw	$2,92($fp)
	b	$L17
$L32:
	lw	$4,optarg
	la	$25,atof
	jal	$31,$25
	cvt.s.d	$f0,$f0
	s.s	$f0,84($fp)
	b	$L19
$L33:
	lw	$2,optarg
	sw	$2,88($fp)
	lw	$4,88($fp)
	la	$5,$LC12
	la	$25,strcmp
	jal	$31,$25
	bne	$2,$0,$L34
	la	$2,__sF+88
	sw	$2,76($fp)
	b	$L19
$L34:
	lw	$4,88($fp)
	la	$5,$LC13
	la	$25,fopen
	jal	$31,$25
	sw	$2,76($fp)
	lw	$2,76($fp)
	bne	$2,$0,$L19
	la	$4,$LC14
	la	$25,printf
	jal	$31,$25
	li	$3,-1			# 0xffffffffffffffff
	sw	$3,92($fp)
	b	$L17
$L20:
	lw	$2,88($fp)
	bne	$2,$0,$L39
	la	$4,$LC15
	la	$25,printf
	jal	$31,$25
	li	$2,-1			# 0xffffffffffffffff
	sw	$2,92($fp)
	b	$L17
$L39:
	l.s	$f0,84($fp)
	s.s	$f0,16($sp)
	l.s	$f0,68($fp)
	s.s	$f0,20($sp)
	l.s	$f0,72($fp)
	s.s	$f0,24($sp)
	l.s	$f0,60($fp)
	s.s	$f0,28($sp)
	l.s	$f0,64($fp)
	s.s	$f0,32($sp)
	lw	$4,76($fp)
	lw	$5,52($fp)
	lw	$6,56($fp)
	lw	$7,80($fp)
	la	$25,drawJuliaSet
	jal	$31,$25
	sw	$0,92($fp)
$L17:
	lw	$2,92($fp)
	move	$sp,$fp
	lw	$31,112($sp)
	lw	$fp,108($sp)
	addu	$sp,$sp,120
	j	$31
	.end	main
	.size	main, .-main
	.rdata
	.align	2
$LC17:
	.ascii	"P2\n"
	.ascii	"# Julia Set image\n"
	.ascii	" %f %f \n"
	.ascii	"255\n\000"
	.align	2
$LC19:
	.ascii	"%d \000"
	.align	2
$LC20:
	.ascii	"\n\000"
	.align	2
$LC16:
	.word	1073741824
	.align	2
$LC18:
	.word	1082130432
	.text
	.align	2
	.globl	drawJuliaSet
	.ent	drawJuliaSet
drawJuliaSet:
	.frame	$fp,240,$31		# vars= 192, regs= 3/0, args= 24, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	.set	reorder
	subu	$sp,$sp,240
	.cprestore 24
	sw	$31,232($sp)
	sw	$fp,228($sp)
	sw	$28,224($sp)
	move	$fp,$sp
	sw	$4,240($fp)
	sw	$5,244($fp)
	sw	$6,248($fp)
	sw	$7,252($fp)
	l.s	$f0,252($fp)
	neg.s	$f2,$f0
	l.s	$f0,$LC16
	div.s	$f2,$f2,$f0
	l.s	$f0,268($fp)
	add.s	$f0,$f2,$f0
	s.s	$f0,40($fp)
	l.s	$f0,256($fp)
	neg.s	$f2,$f0
	l.s	$f0,$LC16
	div.s	$f2,$f2,$f0
	l.s	$f0,272($fp)
	add.s	$f0,$f2,$f0
	s.s	$f0,44($fp)
	l.s	$f2,40($fp)
	l.s	$f0,252($fp)
	add.s	$f0,$f2,$f0
	s.s	$f0,48($fp)
	l.s	$f2,44($fp)
	l.s	$f0,256($fp)
	add.s	$f0,$f2,$f0
	s.s	$f0,52($fp)
	l.s	$f2,48($fp)
	l.s	$f0,40($fp)
	sub.s	$f2,$f2,$f0
	l.s	$f0,244($fp)
	div.s	$f0,$f2,$f0
	s.s	$f0,56($fp)
	l.s	$f2,52($fp)
	l.s	$f0,44($fp)
	sub.s	$f2,$f2,$f0
	l.s	$f0,248($fp)
	div.s	$f0,$f2,$f0
	s.s	$f0,60($fp)
	li	$2,1000			# 0x3e8
	sw	$2,64($fp)
	addu	$2,$fp,72
	l.s	$f0,244($fp)
	cvt.d.s	$f2,$f0
	l.s	$f0,248($fp)
	cvt.d.s	$f0,$f0
	s.d	$f0,16($sp)
	move	$4,$2
	la	$5,$LC17
	mfc1	$6,$f2
	mfc1	$7,$f3
	la	$25,sprintf
	jal	$31,$25
	addu	$2,$fp,72
	move	$4,$2
	lw	$5,240($fp)
	la	$25,fputs
	jal	$31,$25
	l.s	$f0,44($fp)
	s.s	$f0,176($fp)
	sw	$0,180($fp)
$L41:
	l.s	$f0,180($fp)
	cvt.s.w	$f2,$f0
	l.s	$f0,248($fp)
	c.lt.s	$f2,$f0
	bc1t	$L44
	b	$L40
$L44:
	l.s	$f0,40($fp)
	s.s	$f0,188($fp)
	sw	$0,184($fp)
$L45:
	l.s	$f0,184($fp)
	cvt.s.w	$f2,$f0
	l.s	$f0,244($fp)
	c.lt.s	$f2,$f0
	bc1t	$L48
	b	$L46
$L48:
	l.s	$f0,188($fp)
	s.s	$f0,32($fp)
	l.s	$f0,176($fp)
	s.s	$f0,36($fp)
	sw	$0,192($fp)
$L49:
	lw	$2,184($fp)
	lw	$3,64($fp)
	slt	$2,$2,$3
	bne	$2,$0,$L52
	b	$L50
$L52:
	l.s	$f2,32($fp)
	l.s	$f0,32($fp)
	mul.s	$f0,$f2,$f0
	s.s	$f0,196($fp)
	l.s	$f2,36($fp)
	l.s	$f0,36($fp)
	mul.s	$f0,$f2,$f0
	s.s	$f0,200($fp)
	l.s	$f2,196($fp)
	l.s	$f0,200($fp)
	add.s	$f2,$f2,$f0
	l.s	$f0,$LC18
	c.lt.s	$f0,$f2
	bc1t	$L50
	l.s	$f0,32($fp)
	cvt.d.s	$f0,$f0
	add.d	$f2,$f0,$f0
	l.s	$f0,36($fp)
	cvt.d.s	$f0,$f0
	mul.d	$f0,$f2,$f0
	cvt.s.d	$f0,$f0
	s.s	$f0,204($fp)
	l.s	$f2,196($fp)
	l.s	$f0,200($fp)
	sub.s	$f2,$f2,$f0
	l.s	$f0,260($fp)
	add.s	$f0,$f2,$f0
	s.s	$f0,32($fp)
	l.s	$f2,204($fp)
	l.s	$f0,264($fp)
	add.s	$f0,$f2,$f0
	s.s	$f0,36($fp)
	lw	$2,192($fp)
	addu	$2,$2,1
	sw	$2,192($fp)
	b	$L49
$L50:
	addu	$2,$fp,208
	move	$4,$2
	la	$5,$LC19
	lw	$6,192($fp)
	la	$25,sprintf
	jal	$31,$25
	addu	$2,$fp,208
	move	$4,$2
	lw	$5,240($fp)
	la	$25,fputs
	jal	$31,$25
	l.s	$f2,188($fp)
	l.s	$f0,56($fp)
	add.s	$f0,$f2,$f0
	s.s	$f0,188($fp)
	lw	$2,184($fp)
	addu	$2,$2,1
	sw	$2,184($fp)
	b	$L45
$L46:
	la	$4,$LC20
	lw	$5,240($fp)
	la	$25,fputs
	jal	$31,$25
	l.s	$f2,176($fp)
	l.s	$f0,60($fp)
	add.s	$f0,$f2,$f0
	s.s	$f0,176($fp)
	lw	$2,180($fp)
	addu	$2,$2,1
	sw	$2,180($fp)
	b	$L41
$L40:
	move	$sp,$fp
	lw	$31,232($sp)
	lw	$fp,228($sp)
	addu	$sp,$sp,240
	j	$31
	.end	drawJuliaSet
	.size	drawJuliaSet, .-drawJuliaSet
	.align	2
	.globl	getDelimSymbol
	.ent	getDelimSymbol
getDelimSymbol:
	.frame	$fp,48,$31		# vars= 8, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	.set	reorder
	subu	$sp,$sp,48
	.cprestore 16
	sw	$31,40($sp)
	sw	$fp,36($sp)
	sw	$28,32($sp)
	move	$fp,$sp
	sw	$4,48($fp)
	lw	$4,48($fp)
	la	$25,strlen
	jal	$31,$25
	sw	$2,24($fp)
$L56:
	lw	$2,24($fp)
	bgtz	$2,$L58
	b	$L57
$L58:
	lw	$3,48($fp)
	lw	$2,24($fp)
	addu	$2,$3,$2
	addu	$2,$2,-1
	lbu	$2,0($2)
	sb	$2,29($fp)
	lb	$3,29($fp)
	lw	$2,_ctype_
	addu	$2,$3,$2
	addu	$2,$2,1
	lbu	$2,0($2)
	srl	$2,$2,2
	andi	$2,$2,0x1
	bne	$2,$0,$L59
	lb	$3,29($fp)
	li	$2,46			# 0x2e
	beq	$3,$2,$L59
	lb	$3,29($fp)
	lw	$2,_ctype_
	addu	$2,$3,$2
	addu	$2,$2,1
	lbu	$2,0($2)
	andi	$2,$2,0x3
	bne	$2,$0,$L59
	lbu	$2,29($fp)
	sb	$2,28($fp)
	b	$L57
$L59:
	lw	$2,24($fp)
	addu	$2,$2,-1
	sw	$2,24($fp)
	b	$L56
$L57:
	lb	$2,28($fp)
	move	$sp,$fp
	lw	$31,40($sp)
	lw	$fp,36($sp)
	addu	$sp,$sp,48
	j	$31
	.end	getDelimSymbol
	.size	getDelimSymbol, .-getDelimSymbol
	.rdata
	.align	2
$LC21:
	.ascii	"\000"
	.space	9
	.align	2
$LC22:
	.word	-1082130432
	.text
	.align	2
	.globl	getReValue
	.ent	getReValue
getReValue:
	.frame	$fp,80,$31		# vars= 40, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	.set	reorder
	subu	$sp,$sp,80
	.cprestore 16
	sw	$31,72($sp)
	sw	$fp,68($sp)
	sw	$28,64($sp)
	move	$fp,$sp
	sw	$4,80($fp)
	move	$2,$5
	sb	$2,24($fp)
	lbu	$2,$LC21
	sb	$2,32($fp)
	sb	$0,33($fp)
	sb	$0,34($fp)
	sb	$0,35($fp)
	sb	$0,36($fp)
	sb	$0,37($fp)
	sb	$0,38($fp)
	sb	$0,39($fp)
	sb	$0,40($fp)
	sb	$0,41($fp)
	sw	$0,48($fp)
$L61:
	lw	$4,80($fp)
	la	$25,strlen
	jal	$31,$25
	lw	$3,48($fp)
	sltu	$2,$3,$2
	bne	$2,$0,$L63
	b	$L62
$L63:
	lw	$3,80($fp)
	lw	$2,48($fp)
	addu	$2,$3,$2
	lbu	$2,0($2)
	sb	$2,52($fp)
	lw	$2,48($fp)
	blez	$2,$L64
	lb	$3,52($fp)
	lb	$2,24($fp)
	bne	$3,$2,$L64
	b	$L62
$L64:
	lb	$3,52($fp)
	lw	$2,_ctype_
	addu	$2,$3,$2
	addu	$2,$2,1
	lbu	$2,0($2)
	srl	$2,$2,2
	andi	$2,$2,0x1
	bne	$2,$0,$L67
	lb	$3,52($fp)
	li	$2,46			# 0x2e
	beq	$3,$2,$L67
	b	$L66
$L67:
	addu	$3,$fp,32
	lw	$2,48($fp)
	addu	$3,$3,$2
	lbu	$2,52($fp)
	sb	$2,0($3)
	b	$L65
$L66:
	l.s	$f0,$LC22
	s.s	$f0,56($fp)
	b	$L60
$L65:
	lw	$2,48($fp)
	addu	$2,$2,1
	sw	$2,48($fp)
	b	$L61
$L62:
	addu	$2,$fp,32
	move	$4,$2
	la	$25,atof
	jal	$31,$25
	cvt.s.d	$f0,$f0
	s.s	$f0,56($fp)
$L60:
	l.s	$f0,56($fp)
	move	$sp,$fp
	lw	$31,72($sp)
	lw	$fp,68($sp)
	addu	$sp,$sp,80
	j	$31
	.end	getReValue
	.size	getReValue, .-getReValue
	.rdata
	.align	2
$LC23:
	.word	-1082130432
	.text
	.align	2
	.globl	getImValue
	.ent	getImValue
getImValue:
	.frame	$fp,72,$31		# vars= 32, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	.set	reorder
	subu	$sp,$sp,72
	.cprestore 16
	sw	$31,64($sp)
	sw	$fp,60($sp)
	sw	$28,56($sp)
	move	$fp,$sp
	sw	$4,72($fp)
	move	$2,$5
	sb	$2,24($fp)
	lw	$4,72($fp)
	la	$25,strlen
	jal	$31,$25
	sw	$2,28($fp)
	lbu	$2,$LC21
	sb	$2,32($fp)
	sb	$0,33($fp)
	sb	$0,34($fp)
	sb	$0,35($fp)
	sb	$0,36($fp)
	sb	$0,37($fp)
	sb	$0,38($fp)
	sb	$0,39($fp)
	sb	$0,40($fp)
	sb	$0,41($fp)
$L70:
	lw	$2,28($fp)
	bgtz	$2,$L72
	b	$L71
$L72:
	lw	$3,72($fp)
	lw	$2,28($fp)
	addu	$2,$3,$2
	addu	$2,$2,-1
	lbu	$2,0($2)
	sb	$2,48($fp)
	lb	$3,48($fp)
	lb	$2,24($fp)
	bne	$3,$2,$L73
	b	$L71
$L73:
	lb	$3,48($fp)
	lw	$2,_ctype_
	addu	$2,$3,$2
	addu	$2,$2,1
	lbu	$2,0($2)
	srl	$2,$2,2
	andi	$2,$2,0x1
	bne	$2,$0,$L76
	lb	$3,48($fp)
	li	$2,46			# 0x2e
	beq	$3,$2,$L76
	b	$L75
$L76:
	addu	$3,$fp,31
	lw	$2,28($fp)
	addu	$3,$3,$2
	lbu	$2,48($fp)
	sb	$2,0($3)
	b	$L74
$L75:
	l.s	$f0,$LC23
	s.s	$f0,52($fp)
	b	$L69
$L74:
	lw	$2,28($fp)
	addu	$2,$2,-1
	sw	$2,28($fp)
	b	$L70
$L71:
	addu	$3,$fp,32
	lw	$2,28($fp)
	addu	$2,$3,$2
	move	$4,$2
	la	$25,atof
	jal	$31,$25
	cvt.s.d	$f0,$f0
	s.s	$f0,52($fp)
$L69:
	l.s	$f0,52($fp)
	move	$sp,$fp
	lw	$31,64($sp)
	lw	$fp,60($sp)
	addu	$sp,$sp,72
	j	$31
	.end	getImValue
	.size	getImValue, .-getImValue
	.rdata
	.align	2
$LC24:
	.ascii	"i\000"
	.text
	.align	2
	.globl	isComplexValue
	.ent	isComplexValue
isComplexValue:
	.frame	$fp,56,$31		# vars= 16, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	.set	reorder
	subu	$sp,$sp,56
	.cprestore 16
	sw	$31,48($sp)
	sw	$fp,44($sp)
	sw	$28,40($sp)
	move	$fp,$sp
	sw	$4,56($fp)
	lw	$4,56($fp)
	la	$25,strlen
	jal	$31,$25
	sw	$2,24($fp)
	lw	$3,56($fp)
	lw	$2,24($fp)
	addu	$2,$3,$2
	addu	$2,$2,-1
	sw	$2,28($fp)
	lw	$4,28($fp)
	la	$5,$LC24
	la	$25,strcmp
	jal	$31,$25
	beq	$2,$0,$L79
	sw	$0,32($fp)
	b	$L78
$L79:
	li	$2,1			# 0x1
	sw	$2,32($fp)
$L78:
	lw	$2,32($fp)
	move	$sp,$fp
	lw	$31,48($sp)
	lw	$fp,44($sp)
	addu	$sp,$sp,56
	j	$31
	.end	isComplexValue
	.size	isComplexValue, .-isComplexValue
	.rdata
	.align	2
$LC25:
	.ascii	"\000"
	.align	2
$LC26:
	.word	-1082130432
	.text
	.align	2
	.globl	analyzerComplexParameter
	.ent	analyzerComplexParameter
analyzerComplexParameter:
	.frame	$fp,48,$31		# vars= 8, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	.set	reorder
	subu	$sp,$sp,48
	.cprestore 16
	sw	$31,40($sp)
	sw	$fp,36($sp)
	sw	$28,32($sp)
	move	$fp,$sp
	sw	$4,48($fp)
	sw	$5,52($fp)
	sw	$6,56($fp)
	lw	$4,48($fp)
	la	$5,$LC25
	la	$25,strcmp
	jal	$31,$25
	bne	$2,$0,$L81
	li	$2,-1			# 0xffffffffffffffff
	sw	$2,28($fp)
	b	$L80
$L81:
	lw	$4,48($fp)
	la	$25,isComplexValue
	jal	$31,$25
	bne	$2,$0,$L82
	li	$2,-1			# 0xffffffffffffffff
	sw	$2,28($fp)
	b	$L80
$L82:
	lw	$4,48($fp)
	la	$5,$LC24
	la	$25,strtok
	jal	$31,$25
	lw	$4,48($fp)
	la	$25,getDelimSymbol
	jal	$31,$25
	sb	$2,24($fp)
	lb	$2,24($fp)
	lw	$4,48($fp)
	move	$5,$2
	la	$25,getReValue
	jal	$31,$25
	lw	$2,52($fp)
	s.s	$f0,0($2)
	lb	$2,24($fp)
	lw	$4,48($fp)
	move	$5,$2
	la	$25,getImValue
	jal	$31,$25
	lw	$2,56($fp)
	s.s	$f0,0($2)
	lw	$2,52($fp)
	l.s	$f2,0($2)
	l.s	$f0,$LC26
	c.eq.s	$f2,$f0
	bc1t	$L84
	lw	$2,56($fp)
	l.s	$f2,0($2)
	l.s	$f0,$LC26
	c.eq.s	$f2,$f0
	bc1t	$L84
	b	$L83
$L84:
	li	$2,-1			# 0xffffffffffffffff
	sw	$2,28($fp)
	b	$L80
$L83:
	sw	$0,28($fp)
$L80:
	lw	$2,28($fp)
	move	$sp,$fp
	lw	$31,40($sp)
	lw	$fp,36($sp)
	addu	$sp,$sp,48
	j	$31
	.end	analyzerComplexParameter
	.size	analyzerComplexParameter, .-analyzerComplexParameter
	.rdata
	.align	2
$LC27:
	.ascii	"x\000"
	.text
	.align	2
	.globl	setResolution
	.ent	setResolution
setResolution:
	.frame	$fp,56,$31		# vars= 16, regs= 4/0, args= 16, extra= 8
	.mask	0xd0010000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	.set	reorder
	subu	$sp,$sp,56
	.cprestore 16
	sw	$31,52($sp)
	sw	$fp,48($sp)
	sw	$28,44($sp)
	sw	$16,40($sp)
	move	$fp,$sp
	sw	$4,56($fp)
	sw	$5,60($fp)
	sw	$6,64($fp)
	la	$2,$LC27
	sw	$2,24($fp)
	lw	$4,56($fp)
	lw	$5,24($fp)
	la	$25,strtok
	jal	$31,$25
	sw	$2,28($fp)
	lw	$16,60($fp)
	lw	$4,28($fp)
	la	$25,atof
	jal	$31,$25
	cvt.s.d	$f0,$f0
	s.s	$f0,0($16)
	move	$4,$0
	lw	$5,24($fp)
	la	$25,strtok
	jal	$31,$25
	sw	$2,28($fp)
	lw	$2,28($fp)
	bne	$2,$0,$L86
	li	$2,-1			# 0xffffffffffffffff
	sw	$2,32($fp)
	b	$L85
$L86:
	lw	$16,64($fp)
	lw	$4,28($fp)
	la	$25,atof
	jal	$31,$25
	cvt.s.d	$f0,$f0
	s.s	$f0,0($16)
	lw	$2,60($fp)
	l.s	$f2,0($2)
	mtc1	$0,$f0
	c.lt.s	$f0,$f2
	bc1t	$L89
	b	$L88
$L89:
	lw	$2,64($fp)
	l.s	$f2,0($2)
	mtc1	$0,$f0
	c.lt.s	$f0,$f2
	bc1t	$L87
$L88:
	li	$2,-1			# 0xffffffffffffffff
	sw	$2,32($fp)
	b	$L85
$L87:
	sw	$0,32($fp)
$L85:
	lw	$2,32($fp)
	move	$sp,$fp
	lw	$31,52($sp)
	lw	$fp,48($sp)
	lw	$16,40($sp)
	addu	$sp,$sp,56
	j	$31
	.end	setResolution
	.size	setResolution, .-setResolution
	.ident	"GCC: (GNU) 3.3.3 (NetBSD nb3 20040520)"
