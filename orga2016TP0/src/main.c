#include <math.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#include <defs.h>
#include <debug.h>
#include <param.h>

#ifndef VERSION
#define VERSION "0.0.1-cvs"
#endif

#ifndef no_argument
#define no_argument 0
#endif

#ifndef required_argument
#define required_argument 1
#endif

#ifndef optional_argument
#define optional_argument 2
#endif

static void plot(void);
extern int mips32_plot(param_t *);

/*
 * Parámetros globales.
 */

int x_res = 640;		/* Ancho de imagen por defecto. */
int y_res = 480;		/* Alto de imagen, por defecto. */
float upper_left_re = -1;	/* Extremo superior izquierzo (re). */
float upper_left_im = +1;	/* Extremo superior izquierzo (im). */
float lower_right_re = 1;	/* Extremo inferior derecho (re). */
float lower_right_im = -1;	/* Extremo inferior derecho (im). */
float c_param_re = 0.285;	/* Parámetro C (re). */
float c_param_im = -0.01;	/* Parámetro C (im). */
/* XXX Para qué está?? */
//void (*draw)(FILE *) = NULL;	/* Método para generar el fractal. */
FILE *output;

static void parse_cmdline(int, char * const []);
static void do_usage(const char *, int);
static void do_version(const char *);
static void do_resolution(const char *, const char *);
static void do_geometry(const char *, const char *);
static void do_center(const char *, const char *);
static void do_cparam(const char *, const char *);
static void do_width(const char *, const char *);
static void do_height(const char *, const char *);
static void do_output(const char *, const char *);

int
main(int argc, char * const argv[], char * const envp[])
{
	parse_cmdline(argc, argv);
	plot();

	return 0;
}

static void
parse_cmdline(int argc, char * const argv[])
{
	int ch;
	int index = 0;

	struct option options[] = {
		{"help", no_argument, NULL, 'h'},
		{"version", no_argument, NULL, 'V'},
		{"geometry", required_argument, NULL, 'g'},
		{"resolution", required_argument, NULL, 'r'},
		{"center", required_argument, NULL, 'c'},
		{"cparam", required_argument, NULL, 'C'},
		{"width", required_argument, NULL, 'w'},
		{"height", required_argument, NULL, 'H'},
		{"output", required_argument, NULL, 'o'},
	};

	while ((ch = getopt_long(argc, argv, 
	                         "hC:c:H:m:o:r:w:g:V", options, &index)) != -1) {
		switch (ch) {
		case 'h':
			do_usage(argv[0], 0);
			break;
		case 'V':
			do_version(argv[0]);
			break;
		case 'g':
			do_geometry(argv[0], optarg);
			break;
		case 'r':
			do_resolution(argv[0], optarg);
			break;
		case 'c':
			do_center(argv[0], optarg);
			break;
		case 'C':
			do_cparam(argv[0], optarg);
			break;
		case 'w':
			do_width(argv[0], optarg);
			break;
		case 'H':
			do_height(argv[0], optarg);
			break;
		case 'o':
			do_output(argv[0], optarg);
			break;
		default:
			do_usage(argv[0], 1);
		}
	}

	if (!output) {
		fprintf(stderr, "no output file.\n");
		exit(1);
	}
}

static void
do_usage(const char *name, int status)
{
	fprintf(stderr, "Usage:\n");
	fprintf(stderr, "  %s -h\n", name);
	fprintf(stderr, "  %s -V\n", name);
	fprintf(stderr, "  %s [options]\n", name);
	fprintf(stderr, "Options:\n");
	fprintf(stderr, "  -r, --resolution "
	                " Set bitmap resolution to WxH pixels.\n");
	fprintf(stderr, "  -c, --center     "
	                " Set coordinates for the center of the image.\n");
	fprintf(stderr, "  -w, --width      "
	                " Change the width of the spanned region.\n");
	fprintf(stderr, "  -H, --height     "
	                " Change the height of the spanned region.\n");
	fprintf(stderr, "  -C, --cparam     "
	                " Set c parameter.\n");
	fprintf(stderr, "  -o, --output     "
	                " Path to output file.\n");
	fprintf(stderr, "Examples:\n");
	fprintf(stderr, "  %s -o output.pgm\n", name);
	fprintf(stderr, "  %s -r 1600x1200 -o output.pgm\n", name);
	fprintf(stderr, "  %s -c +0.282+0.01i -o output.pgm\n", name);
	exit(status);
}

static void
do_version(const char *name)
{
	fprintf(stderr, "%s\n", VERSION);
	exit(0);
}

static void
do_resolution(const char *name, const char *spec)
{
	int x;
	int y;
	char c;
	char d;

	if (sscanf(spec, "%d%c%d %c", &x, &c, &y, &d) != 3
	    || x <= 0
	    || c != 'x'
	    || y <= 0)
		do_usage(name, 1);

	/* Set new resolution. */
	x_res = x;
	y_res = y;
}

static void
do_geometry(const char *name, const char *spec)
{
	double re_1, im_1;
	double re_2, im_2;
	char comma;
	char sg_1;
	char sg_2;
	char ii_1;
	char ii_2;
	char ch;

#define PLUS_OR_MINUS(c)  ((c) == '+' || (c) == '-')
#define IMAGINARY_UNIT(x) ((x) == 'i' || (x) == 'j')

	if (sscanf(spec, 
	           "%lf %c %lf %c %c %lf %c %lf %c %c", 
	           &re_1,
	           &sg_1,
	           &im_1,
	           &ii_1,
	           &comma,
	           &re_2,
	           &sg_2,
	           &im_2,
	           &ii_2,
	           &ch) != 9
	    || !PLUS_OR_MINUS(sg_1)
	    || !PLUS_OR_MINUS(sg_2)
	    || !IMAGINARY_UNIT(ii_1)
	    || !IMAGINARY_UNIT(ii_2)
	    || comma != ',') {
		fprintf(stderr, "invalid geometry specification.\n");
		exit(1);
	}

#define MINIMUM(x, y) ((x) <= (y) ? (x) : (y))
#define MAXIMUM(x, y) ((x) >= (y) ? (x) : (y))
#define SIGN(c) ((c) == '-' ? -1.0 : +1.0)

	/* Sign-adjust. */
	im_1 *= SIGN(sg_1);
	im_2 *= SIGN(sg_2);

	/*
	 * We have two edges of the rectangle. Now, find the upper-left 
	 * (i.e. the one with minimum real part and maximum imaginary
	 * part) and lower-right (maximum real part, minimum imaginary)
	 * corners of the rectangle.
	 */
	upper_left_re = MINIMUM(re_1, re_2);
	upper_left_im = MAXIMUM(im_1, im_2);
	lower_right_re = MAXIMUM(re_1, re_2);
	lower_right_im = MINIMUM(im_1, im_2);
}

static void
do_center(const char *name, const char *spec)
{
	double width;
	double height;
	double re, im;
	char ii;
	char sg;
	char ch;

	if (sscanf(spec, 
	           "%lf %c %lf %c %c", 
	           &re,
	           &sg,
	           &im,
	           &ii,
	           &ch) != 4
	    || !PLUS_OR_MINUS(sg)
	    || !IMAGINARY_UNIT(ii)) {
		fprintf(stderr, "invalid center specification.\n");
		exit(1);
	}

	im *= SIGN(sg);
	width = fabs(upper_left_re - lower_right_re);
	height = fabs(upper_left_im - lower_right_im);

	upper_left_re = re - width / 2;
	upper_left_im = im + height / 2;
	lower_right_re = re + width / 2;
	lower_right_im = im - height / 2;
}

static void
do_cparam(const char *name, const char *spec)
{
	double re, im;
	char ii;
	char sg;
	char ch;

	if (sscanf(spec, 
	           "%lf %c %lf %c %c", 
	           &re,
	           &sg,
	           &im,
	           &ii,
	           &ch) != 4
	    || !PLUS_OR_MINUS(sg)
	    || !IMAGINARY_UNIT(ii)) {
		fprintf(stderr, "invalid cparam specification.\n");
		exit(1);
	}

	im *= SIGN(sg);

	c_param_re = re;
	c_param_im = im;
}
static void
do_height(const char *name, const char *spec)
{
	double width;
	double height;
	double re, im;
	char ch;

	if (sscanf(spec, 
	           "%lf %c", 
	           &height,
	           &ch) != 1
	    || height <= 0.0) {
		fprintf(stderr, "invalid height specification.\n");
		exit(1);
	}

	re = (upper_left_re + lower_right_re) / 2;
	im = (upper_left_im + lower_right_im) / 2;
	width = fabs(upper_left_re - lower_right_re);

	upper_left_re = re - width / 2;
	upper_left_im = im + height / 2;
	lower_right_re = re + width / 2;
	lower_right_im = im - height / 2;
}

static void
do_width(const char *name, const char *spec)
{
	double width;
	double height;
	double re, im;
	char ch;

	if (sscanf(spec, 
	           "%lf %c", 
	           &width,
	           &ch) != 1
	    || width <= 0.0) {
		fprintf(stderr, "invalid width specification.\n");
		exit(1);
	}

	re = (upper_left_re + lower_right_re) / 2;
	im = (upper_left_im + lower_right_im) / 2;
	height = fabs(upper_left_im - lower_right_im);

	upper_left_re = re - width / 2;
	upper_left_im = im + height / 2;
	lower_right_re = re + width / 2;
	lower_right_im = im - height / 2;
}

static void
do_output(const char *name, const char *spec)
{
	if (output != NULL) {
		fprintf(stderr, "multiple do output files.");
		exit(1);
	}

	if (strcmp(spec, "-") == 0) {
		output = stdout;
	} else {
		if (!(output = fopen(spec, "w"))) {
			fprintf(stderr, "cannot open output file.\n");
			exit(1);
		}
	}
}

static void
plot(void)
{
	param_t parms;

	memset(&parms, 0, sizeof(parms));
	parms.UL_re = upper_left_re;
	parms.UL_im = upper_left_im;
	parms.LR_re = lower_right_re;
	parms.LR_im = lower_right_im;
        parms.d_re = (lower_right_re - upper_left_re) / x_res;
        parms.d_im = (upper_left_im - lower_right_im) / y_res;
        parms.x_res = x_res;
        parms.y_res = y_res;
        parms.shades = 255;
	parms.cp_re = c_param_re;
	parms.cp_im = c_param_im;
        parms.fd = fileno(output);

	if (mips32_plot(&parms) < 0) exit(1);
}
