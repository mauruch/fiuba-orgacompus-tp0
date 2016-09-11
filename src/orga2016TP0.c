//============================================================================
// Name        : orga2016TP0.cpp
// Author      :
// Version     :
// Copyright   : Your copyright notice
// Description : Hello World in C++, Ansi-style
//============================================================================

//# Specify image width and height
//w, h = 200, 200s
//
//# Specify real and imaginary range of image
//re_min, re_max = -2.0, 2.0
//im_min, im_max = -2.0, 2.0
//
//# Pick a value for c
//c = complex(0.0,0.65)
//
//# Generate evenly spaced values over real and imaginary ranges
//real_range = numpy.arange(re_min, re_max, (re_max - re_min) / w)
//imag_range = numpy.arange(im_max, im_min, (im_min - im_max) / h)
//
//# Open output file and write PGM header info
//fout = open('julia.pgm', 'w')
//fout.write('P2\n# Julia Set image\n' + str(w) + ' ' + str(h) + '\n255\n')
//
//# Generate pixel values and write to file
//for im in imag_range:
//    for re in real_range:
//        z = complex(re, im)
//        n = 255
//        while abs(z) < 10 and n >= 5:
//            z = z*z + c
//            n -= 5
//        # Write pixel to file
//        fout.write(str(n) + ' ')
//    # End of row
//    fout.write('\n')
//
//# Close file
//fout.close()

#include <stdio.h>

#define DEFAULT_WIDTH = 640;
#define DEFAULT_HEIGHT = 480;


int main(int argc, char *argv[]) {
	float width = 640; //TODO: take value from argv
	float height = 480; //TODO: take value from argv

	float cRe = 0.285; //TODO: take value from argv
	float cIm = 0.01; //TODO: take value from argv
	float a, b; // a + bi

	float w = 4; //TODO: take value from argv
	float h = 4; //TODO: take value from argv

	// Start at negative half the width and height
	float xmin = -w/2;
	float ymin = -h/2;

	// x goes from xmin to xmax
	float xmax = xmin + w;
	// y goes from ymin to ymax
	float ymax = ymin + h;

	// Calculate amount we increment x,y for each pixel
	float dx = (xmax - xmin) / (width);
	float dy = (ymax - ymin) / (height);

	int maxIterations = 1000;

	char header[100];
	FILE * pgmFile = fopen("JuliaSet.pgm", "wb");

	sprintf(header, "P2\n# Julia Set image\n %f %f \n255\n", width, height);
	fputs(header, pgmFile);

	//loop through every pixel
	// Start y
	float y = ymin;
	for(int j = 0; j < height; j++) {
		// Start x
		float x = xmin;
		for(int i = 0; i < width; i++) {
			a = x;
			b = y;
			int n;
			//start the iteration process
			for(n = 0; i < maxIterations; n++) {
				float aa = a * a;
				float bb = b * b;

				if((aa + bb) > 4) break;

				float twoab = 2.0 * a * b;
				a = aa - bb + cRe;
				b = twoab + cIm;
			}
			char str[15];
			sprintf(str, "%d ", n);
			fputs(str, pgmFile);
			x+=dx;
		}
		fputs("\n", pgmFile);
		y+=dy;
	}
	printf("Termino bien");
	return 0;
}
