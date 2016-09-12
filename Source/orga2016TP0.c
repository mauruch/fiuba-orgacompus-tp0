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
#include <math.h>
#include <ctype.h>
#include <stdlib.h>
#include <stdbool.h>
#include <unistd.h>
#include <string.h>

#define DEFAULT_WIDTH = 640;
#define DEFAULT_HEIGHT = 480;

int main(int argc, char *argv[]) {
	if(argc == 1){
		printf("No options given\n");
		//return;
	}
	//variables
	int c;
	float width;
	float height;
	float cRe;
	float cIm;
	FILE * pgmFile;
	float w;
	float h;

	//args flags
	bool rflag = false;
	bool cflag = false;
	bool Cflag = false;
	bool wflag = false;
	bool Hflag = false;
	bool oflag = false;

	//args values
	char *rvalue = NULL;
	char *cvalue = NULL;
	char *Cvalue = NULL;
	char *wvalue = NULL;
	char *Hvalue = NULL;
	char *ovalue = NULL;

	while ((c = getopt(argc, argv, "r:c:C:w:H:o:")) != -1) {
		switch (c){
			case 'r':
				rflag = true;
				rvalue = optarg;
				break;
			case 'c':
				cflag = true;
				cvalue = optarg;
				break;
			case 'C':
				Cflag = true;
				Cvalue = optarg;
				break;
			case 'w':
				wflag = true;
				wvalue = optarg;
				break;
			case 'H':
				Hflag = true;
				Hvalue = optarg;
				break;
			case 'o':
				oflag = true;
				ovalue = optarg;
				break;
		}
	}

	//resolution value
	if(rflag){
		char *delim = "x";
		char *token = strtok(rvalue, delim);
		width = atof(token);
		token  = strtok(0, delim);
		height = atof(token);
	}else{
		//default values
		width = 640;
		height = 480;
	}
	//image center value
	if (cflag){
		if(strcmp(cvalue, "") == 0){
			//cvalue is empty
			printf ("Fatal: invalid center specification.\n");
			return -1;
		}

		//check if cvalue is complex
		int len = strlen(cvalue);
		const char * last = &cvalue[len-1];
		if(strcmp(last, "i") != 0){
			printf ("Fatal: invalid center specification.\n");
			return -1;
		}
		//extract trailing i
		strtok(cvalue, "i");
		// need to split cvalue in + and i
		char* delim = "+";
		char* token = strtok(cvalue, delim);
		cRe = atof(token);
		token = strtok(0, delim);
		cIm = atof(token);

	} else {
		//default values
		cRe = 0;
		cIm = 0;
	}
	//file name value
	if (oflag) {
		if(strcmp(ovalue, "-") == 0){
			pgmFile = stdout;
		} else {
			pgmFile = fopen(ovalue, "wb");
			if (pgmFile == NULL) {
				printf("Fatal: cannot open output file.");
				return -1;
			}
		}
	}
	//width value
	if(wflag){
		w = atof(wvalue);
	}else{
		w = 4;
	}
	//high value
	if(Hflag){
		h = atof(Hvalue);
	}else{
		h = 4;
	}





	float a, b; // a + bi
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
	sprintf(header, "P2\n# Julia Set image\n %f %f \n255\n", width, height);
	fputs(header, pgmFile);

	//TODO: put this code into c function
	//loop through every pixel
	// Start y
	float y = ymin;
	int j,i;
	for(j = 0; j < height; j++) {
		// Start x
		float x = xmin;
		for(i = 0; i < width; i++) {
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
