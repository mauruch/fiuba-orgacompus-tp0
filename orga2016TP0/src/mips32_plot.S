#include <mips/regdef.h>
#include <asm/unistd.h>
#include <asm/asm.h>
#include <sys/syscall.h>

.text
.ent mips32_plot
.globl mips32_plot

# t0 = *parms_t

mips32_plot:
	subu	sp,sp,88
	sw	gp,72(sp)
	sw	$fp,76(sp)
	sw	ra,80(sp)
	move	$fp,sp
	sw	a0,88($fp)

	#float cpr = parms->cp_re;
	lw	t0,24(a0)
	sw	t0,60($fp)

	#float cpi = parms-> cp_im;
	lw	t0,28(a0)
	sw	t0,64($fp)

	#FILE *fp = fdopen(parms->fd, "w")	
	lw	t0,44(a0)
	move	a0,t0
	li 	a1,O_RDWR
	li 	v0,SYS_open
	syscall

	sw	v0,68($fp)

	#res = fprintf(fp, "P2\n%u\n%u\n%u\n",
	#	(unsigned)parms->x_res,
	#	(unsigned)parms->y_res,
	#	(unsigned)parms->shades);

	la	a0,first_line
	jal	my_string_length	#TODO hacer my_string_length
	lw	t4,v0
	addui	t7,t4,3			#este va a ser el tercer parametro del write

	#concateno los enteros al final del string
	lw	t0,88($fp)
	lw	t1,32(t0)
	lw	t2,36(t0)
	lw	t3,40(t0)
    
	la	t5,first_line
	addu	t5,t5,t4
	sb 	t1,0(t5)		#TODO necesito castear el valor entero que está en t0 a un char
	sb 	t2,1(t5)		#TODO necesito castear el valor entero que está en t0 a un char
	sb 	t3,2(t5)		#TODO necesito castear el valor entero que está en t0 a un char

	lw	t1,68($fp)
	move	a0,t1
	la	a1,first_line
	lw	a2,t7
	li 	v0,SYS_write
	syscall

    #if (res < 0) {
	#	fprintf(s...
	#	retu...
	#}
	sw 	v0,56($fp)
	bgez	v0, primer_for

	#TODO escribir en stderr y terminar
	#	fprintf(stderr, "io error.\n");
	#	return -1;
	b 	termina_error

pre_for:
	sw 	zero,48($fp)		# y = 0
	sw 	zero,44($fp)		# x = 0
	sw 	zero,52($fp)		# c = 0
	lw	t0,88($fp)		# t0 = *parms_t
	lw	t1,4(t0)		
	sw 	t1,20($fp)		# ci = UL_im
	lw	t2,0(t0)
	sw 	t2,16($fp)		# cr = UL_re
	lw 	t3,40(t0)
	sw 	t3,52($fp)		# c = shades

	#for (y = 0, ci = parms->UL_im;
	#y < parms->y_res;
	#++y, ci -= parms->d_im) {
primer_for:
	lw	t1,48($fp)		# t1 = y
	lw	t2,36(t0)		# t2 = y_res
	bge 	t1,t2,termina_primer_for

	#for (x = 0, cr = parms->UL_re;
	#x < parms->x_res;
	#++x, cr += parms->d_re) {
segundo_for:
	lw	t3,44($fp)		# t3 = x
	lw	t4,32(t0)		# t4 = x_res
	bge 	t3,t4,termina_segundo_for

	lw	t5,16($fp)		# t5 = cr
	sw 	t5,24($fp)
	lw	t6,20($fp)		# t6 = ci
	sw 	t6,28($fp)

	#for (c = 0; c < parms->shades; ++c) {
tercer_for:
	lw	t7,52($fp)		# t7 = c
	lw	t8,40(t0)		# t8 = shades
	bge 	t7,t8,break_tercer_for:

	lw	t1,24($fp)		# t1 = zr
	lw 	t2,28($fp)		# t2 = zi
	lw	t3,60($fp)		# t3 = cpr
	lw	t4,64($fp)		# t4 = cpi

	#if ((absz = zr*zr + zi*zi) > 4.0f)
	mulo	t7,t1,t1
	mulo	t8,t2,t2
	addu 	t7,t7,t8
	sw 	t7,40($fp)		
	li 	t8,4
	bgt	t7,t8,termina_tercer_for

	#sr = zr * zr - zi * zi + cpr;
	mulo	t7,t1,t1
	mulo	t8,t2,t2
	subu	t8,t7,t8
	addu 	t5,t8,t3		# t5 = sr
	sw 	t5,32($fp)

	#si = 2 * zr * zi + cpi;
	mulo 	t7,t1,t2
	li 	t8,1
	sll 	t7,t7,t8
	addu 	t6,t7,t4		# t6 = si
	sw 	t6,36($fp)
	
	#zr = sr;
	sw 	t5,24($fp)

	#zi = si;
	sw 	t6,28($fp)

	#++c
	lw	t7,52($fp)
	addui	t7,t7,1
	sw 	t7,52($fp)

	b 	tercer_for

termina_primer_for:
	#TODO
	#if (fflush(fp) != 0) {
	#fprintf(stderr, "cannot flush output file.\n");
	#return -1;
	#}

	b 	terminar_ok

#++y, ci -= parms->d_im
termina_segundo_for:
	lw	t1,48($fp)		# t1 = y
	addui 	t1,t1,1
	sw 	t1,48($fp)
	lw 	t2,20($fp)		# t2 = ci
	lw	t3,20(t0)		# t3 = d_im
	subu	t3,t2,t3
	sw 	t3,20($fp)
	b 	primer_for

termina_tercer_for:
	#TODO
	#if (fprintf(fp, "%u\n", (unsigned)c) < 0) {
	#fprintf(stderr, "i/o error.\n");
	#return -1;
	#}

#++x, cr += parms->d_re
break_tercer_for:
	lw	t1,44($fp)		# t1 = x
	addui	t1,t1,1
	sw 	t1,44($fp)
	lw	t2,16($fp)		# t2 = cr
	lw	t3,16(t0)		# t3 = d_re
	addu 	t3,t2,t3
	sw 	t3,16($fp)
	b 	segundo_for

termina_error:
	li 	v0,-1 		# no estoy seguro si esto anda
	b 	terminar

terminar_ok:
	li	v0,0

terminar:
	move	sp,$fp
	lw	ra,80(sp)
	lw	$fp,76(sp)
	lw	gp,72(sp)
	addu 	sp,sp,88

	jr	ra

	.end mips32_plot
	
.data
	first_line:	.asciiz "P2\n%u\n%u\n%u\n"
	error: .asciiz "io error.\n"




