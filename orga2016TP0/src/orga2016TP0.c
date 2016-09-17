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

char getDelimSymbol(char* cvalue){
	int len = strlen(cvalue);
	char delim;
	while(len > 0){
		char value = cvalue[len-1];
		if( !isdigit(value) && value != '.' ){
			delim = value;
			break;
		}
		len=len-1;
	}
	return delim;
}

float getReValue(char* string,char delim){
	//10 will be the maximum number of digits
	char token[10] = "";
	int len = 0;
	while( len < strlen(string) ){
		char value = string[len];
		if( len > 0 && value == delim){
			break;
		}else{
			*(&token[len]) = value;
		}
		len++;
	}
	return atof(token);
}

float getImValue(char* string,char delim){
	//10 will be the maximum number of digits
	int len = strlen(string);
	char token[10] = "";
	while( len > 0){
		char value = string[len-1];
		if( value == delim){
			break;
		}else{
			token[len-1] = value;
		}
		len--;
	}
	return atof(&token[len]);
}

bool isComplexValue(char* string){
	int len = strlen(string);
	const char * last = &string[len-1];
	if(strcmp(last, "i") != 0){
		return false;
	}
	return true;
}

int analyzerComplexParameter(char* cValue,float* cRe,float* cIm){
	if(strcmp(cValue, "") == 0){
		return -1;
	}
	if(!isComplexValue(cValue)){
		return -1;
	}
	//extract trailing i
	strtok(cValue, "i");
	char delim = getDelimSymbol(cValue);
	*cRe = getReValue(cValue,delim);
	*cIm = getImValue(cValue,delim);
	return 0;
}

void setResolution(char* rvalue,float* width,float* height){
	char *delim = "x";
	char *token = strtok(rvalue, delim);
	*width = atof(token);
	token  = strtok(0, delim);
	*height = atof(token);
}

int main(int argc, char *argv[]) {
	if(argc == 1){
		printf("No options given\n");
		//return;
	}
	//variables
	int c;
	float width = 640;
	float height = 480;
	float cRe = 0;
	float cIm = 0;
	float CRe = 0.285;
	float CIm = -0.01;
	FILE * pgmFile;
	float w = 4;
	float h = 4;

	//args values
	char *rvalue = NULL;
	char *cvalue = NULL;
	char *Cvalue = NULL;
	char *wvalue = NULL;
	char *Hvalue = NULL;
	char *ovalue = NULL;

	//read args params
	while ((c = getopt(argc, argv, "r:c:C:w:H:o:")) != -1) {
		switch (c){
			case 'r':
				rvalue = optarg;
				//resolution value
				setResolution(rvalue,&width,&height);
				break;
			case 'c':
				cvalue = optarg;
				//image center value
				if(analyzerComplexParameter(cvalue,&cRe,&cIm)!=0){
					printf ("Fatal: invalid specification.\n");
					return -1;
				}
				break;
			case 'C':
				Cvalue = optarg;
				//C parameter value
				if(analyzerComplexParameter(Cvalue,&CRe,&CIm)!=0){
					printf ("Fatal: invalid specification.\n");
					return -1;
				}
				break;
			case 'w':
				wvalue = optarg;
				//width value
				w = atof(wvalue);
				break;
			case 'H':
				Hvalue = optarg;
				//high value
				h = atof(Hvalue);
				break;
			case 'o':
				ovalue = optarg;
				//file name value
				if(strcmp(ovalue, "-") == 0){
					pgmFile = stdout;
				} else {
					pgmFile = fopen(ovalue, "wb");
					if (pgmFile == NULL) {
						printf("Fatal: cannot open output file.");
						return -1;
					}
				}
				break;
		}
	}

	if (!ovalue) {
		printf("Fatal: -o parameter is mandatory.");
		return -1;
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
