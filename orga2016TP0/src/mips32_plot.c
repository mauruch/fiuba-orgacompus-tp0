#include <debug.h>
#include <stdio.h>
#include <defs.h>
#include <param.h>

int
mips32_plot(param_t *parms)
{
	float cr, ci;
	float zr, zi;
	float sr, si;
	float absz;
	int x, y;
	int c;
	int res;

	float cpr = parms->cp_re;
	float cpi = parms-> cp_im;
	
	// Notar que esta implementación hace uso de un file pointer. Es no es
	// lo que debe hacerse en MIPS32. Debe hacerse uso del syscall write
	// con el file descriptor provisto en la estructura param_t
	FILE *fp = fdopen(parms->fd, "w");	

	/* Header PGM. */
	res = fprintf(fp, "P2\n%u\n%u\n%u\n",
		(unsigned)parms->x_res,
		(unsigned)parms->y_res,
		(unsigned)parms->shades);
	if (res < 0) {
		fprintf(stderr, "io error.\n");
		return -1;
	}

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
}
