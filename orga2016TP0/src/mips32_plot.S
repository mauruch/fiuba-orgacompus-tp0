


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

	#FILE *fp = fdopen(parms->fd, "w");	
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

	#TODO hacer my_string_length
    la	a0,first_line
    jal	my_string_length
    lw	t3,v0
    addui	t7,t7,3	#este va a ser el tercer parametro del write

    #concateno los enteros al final del string
    lw	t0,32($fp)
	lw	t1,36($fp)
	lw	t2,40($fp)
    
	la	t4,first_line
    addu	t4,t4,t3
    sb 	t0,0(t4)	#TODO necesito castear el valor entero que está en t0 a un char
    sb 	t1,1(t4)	#TODO necesito castear el valor entero que está en t0 a un char
    sb 	t2,2(t4)	#TODO necesito castear el valor entero que está en t0 a un char

    lw	t0,68($fp)
    move	a0,t0
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

	#for (y = 0, ci = parms->UL_im; 
    #y < parms->y_res; 
    #++y, ci -= parms->d_im) {
	sw 	zero,48($fp)
	lw	t0,88($fp)
	lw	t0,4($fp)
	sw 	t0,20($fp)
primer_for:
    lw	t0,48($fp)
    lw	t1,88($fp)
    lw	t1,36($fp)
    bge 	t0,t1,termina_primer_for

segundo_for:

termina_primer_for:


termina_error:

.data
	first_line:	.asciiz "P2\n%u\n%u\n%u\n"
	error: .asciiz "io error.\n"




