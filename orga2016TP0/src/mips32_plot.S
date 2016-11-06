


	/* 
	 * Barremos la región rectangular del plano complejo comprendida 
	 * entre (parms->UL_re, parms->UL_im) y (parms->LR_re, parms->LR_im).
	 * El parámetro de iteración es el punto (cr, ci).
	 */

	for (y = 0, ci = parms->UL_im; 
	     y < parms->y_res; 
	     ++y, ci -= parms->d_im) {
		for (x = 0, cr = parms->UL_re; 
		     x < parms->x_res; 
		     ++x, cr += parms->d_re) {
			zr = cr;
			zi = ci;

			/*
			 * Determinamos el nivel de brillo asociado al punto
			 * (cr, ci), usando la fórmula compleja recurrente 
			 * f = f^3 + c.
			 */
			for (c = 0; c < parms->shades; ++c) {
				if ((absz = zr*zr + zi*zi) > 4.0f)
					break;
				sr = zr * zr - zi * zi + cpr;
				si = 2 * zr * zi + cpi;
				zr = sr;
				zi = si;
			}

			if (fprintf(fp, "%u\n", (unsigned)c) < 0) {
				fprintf(stderr, "i/o error.\n");
				return -1;
			}
		}
	}

	/* Flush any buffered information before quit. */
	if (fflush(fp) != 0) {
		fprintf(stderr, "cannot flush output file.\n");
		return -1;
	}
	return 0;

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
	sb 	t1,0(t5)	#TODO necesito castear el valor entero que está en t0 a un char
	sb 	t2,1(t5)	#TODO necesito castear el valor entero que está en t0 a un char
	sb 	t3,2(t5)	#TODO necesito castear el valor entero que está en t0 a un char

	lw	t1,68($fp)
	move	a0,t1
	la	a1,first_line
	lw	a2,t7
	li 	v0,SYS_write
	syscall

    #if (res < 0) {
	#	fprintf(stderr, "io error.\n");
	#	return -1;
	#}
	sw 	v0,56($fp)
	bgez	v0, primer_for

	#TODO escribir en stderr y terminar
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
	lw	t1,48($fp)
	lw	t2,36(t0)
	bge 	t1,t2,termina_primer_for

	#for (x = 0, cr = parms->UL_re;
	#x < parms->x_res;
	#++x, cr += parms->d_re) {
segundo_for:
	lw	t3,44($fp)
	lw	t4,32(t0)
	bge 	t3,t4,termina_segundo_for

	lw	t5,16($fp)
	sw 	t5,24($fp)
	lw	t6,20($fp)
	sw 	t6,28($fp)

	#for (c = 0; c < parms->shades; ++c) {
tercer_for:
	lw	t7,	
	mulo	t5,t5,t5
	mulo	t6,t6,t6
	addu 	t7,t5,t6
	sw 	t7,40($fp)
	li 	t8,4
	bgt	t7,t8,termina_tercer_for


termina_primer_for:

termina_segundo_for:

termina_tercer_for:


termina_error:

.data
	first_line:	.asciiz "P2\n%u\n%u\n%u\n"
	error: .asciiz "io error.\n"




