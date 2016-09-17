//============================================================================
// Name        : orga2016TP0.cpp
// Author      :
// Version     :
// Copyright   : Your copyright notice
// Description : Hello World in C++, Ansi-style
//============================================================================

#include <stdio.h>
#include <math.h>
#include <ctype.h>
#include <stdlib.h>
#include <stdbool.h>
#include <unistd.h>
#include <string.h>

char getDelimSymbol(char* cvalue);
float getReValue(char* string, char delim);
float getImValue(char* string, char delim);
bool isComplexValue(char* string);
int analyzerComplexParameter(char* cValue, float* cRe, float* cIm);
int setResolution(char* rvalue, float* width, float* height);
void drawJuliaSet(FILE* pgmFile, float resW, float resH, float recW, float recH,
		float compRe, float compIm, float centerRe, float centerIm);

int main(int argc, char *argv[]) {
	if (argc == 1) {
		printf("No options given\n");
		//return;
	}
	//global variables
	int c;
	float resW = 640;
	float resH = 480;
	float centerRe = 0;
	float centerIm = 0;
	float complexRe = 0.285;
	float complexIm = 0.01;
	FILE * pgmFile;
	float recW = 4;
	float recH = 4;

	//args values
	char *ovalue = NULL;

	//read args params
	while ((c = getopt(argc, argv, "r:c:C:w:H:o:")) != -1) {
		switch (c) {
		case 'r':
			//resolution value
			if(setResolution(optarg, &resW, &resH) != 0){
				printf("Fatal: invalid r specification.\n");
				return -1;
			}
			break;
		case 'c':
			//image center value
			if (analyzerComplexParameter(optarg, &centerRe, &centerIm) != 0) {
				printf("Fatal: invalid c specification.\n");
				return -1;
			}
			break;
		case 'C':
			//C parameter value
			if (analyzerComplexParameter(optarg, &complexRe, &complexIm) != 0) {
				printf("Fatal: invalid C specification.\n");
				return -1;
			}
			break;
		case 'w':
			//width value
			if(!isdigit(*optarg)){
				printf("Fatal: invalid w specification.\n");
				return -1;
			}
			recW = atof(optarg);
			break;
		case 'H':
			//high value
			if(!isdigit(*optarg)){
				printf("Fatal: invalid H specification.\n");
				return -1;
			}
			recH = atof(optarg);
			break;
		case 'o':
			ovalue = optarg;
			//file name value
			if (strcmp(ovalue, "-") == 0) {
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

	drawJuliaSet(pgmFile, resW, resH, recW, recH, complexRe, complexIm,
			centerRe, centerIm);

	return 0;
}

void drawJuliaSet(FILE* pgmFile, float resW, float resH, float recW, float recH,
		float compRe, float compIm, float centerRe, float centerIm) {

	// a + bi
	float a, b;

	// Start at negative half the rectangleDrawWidth and resolutionHeight
	float xmin = -recW / 2 + centerRe;
	float ymin = -recH / 2 + centerIm;

	// x goes from xmin to xmax
	float xmax = xmin + recW;
	// y goes from ymin to ymax
	float ymax = ymin + recH;

	// Calculate amount we increment x,y for each pixel
	float dx = (xmax - xmin) / (resW);
	float dy = (ymax - ymin) / (resH);

	int maxIterations = 1000;

	char header[100];
	sprintf(header, "P2\n# Julia Set image\n %f %f \n255\n", resW, resH);
	fputs(header, pgmFile);

	//loop through every pixel
	// Start y
	float y = ymin;
	int j, i;
	for (j = 0; j < resH; j++) {
		// Start x
		float x = xmin;
		for (i = 0; i < resW; i++) {
			a = x;
			b = y;
			int n;
			//start the iteration process
			for (n = 0; i < maxIterations; n++) {
				float aa = a * a;
				float bb = b * b;

				if ((aa + bb) > 4)
					break;

				float twoab = 2.0 * a * b;
				a = aa - bb + compRe;
				b = twoab + compIm;
			}
			char str[15];
			sprintf(str, "%d ", n);
			fputs(str, pgmFile);
			x += dx;
		}
		fputs("\n", pgmFile);
		y += dy;
	}
}

char getDelimSymbol(char* cvalue) {
	int len = strlen(cvalue);
	char delim;
	while (len > 0) {
		char value = cvalue[len - 1];
		if (!isdigit(value) && value != '.' && !isalpha(value)) {
			delim = value;
			break;
		}
		len = len - 1;
	}
	return delim;
}

float getReValue(char* string, char delim) {
	//10 will be the maximum number of digits
	char token[10] = "";
	int len = 0;
	while (len < strlen(string)) {
		char value = string[len];
		if (len > 0 && value == delim) {
			break;
		}else if(isdigit(value) || value == '.'){
			*(&token[len]) = value;
		}else{
			return -1;
		}
		len++;
	}
	return atof(token);
}

float getImValue(char* string, char delim) {
	//10 will be the maximum number of digits
	int len = strlen(string);
	char token[10] = "";
	while (len > 0) {
		char value = string[len - 1];
		if (value == delim) {
			break;
		}else if(isdigit(value) || value == '.'){
			token[len - 1] = value;
		}else{
			return -1;
		}
		len--;
	}
	return atof(&token[len]);
}

bool isComplexValue(char* string) {
	int len = strlen(string);
	const char * last = &string[len - 1];
	if (strcmp(last, "i") != 0) {
		return false;
	}
	return true;
}

int analyzerComplexParameter(char* cValue, float* cRe, float* cIm) {
	if (strcmp(cValue, "") == 0) {
		return -1;
	}
	if (!isComplexValue(cValue)) {
		return -1;
	}
	//extract trailing i
	strtok(cValue, "i");
	char delim = getDelimSymbol(cValue);
	*cRe = getReValue(cValue, delim);
	*cIm = getImValue(cValue, delim);
	if(*cRe == -1 || *cIm == -1){
		return -1;
	}
	return 0;
}

int setResolution(char* rvalue, float* width, float* height) {
	char *delim = "x";
	char *token = strtok(rvalue, delim);
	*width = atof(token);
	token = strtok(0, delim);
	if(!token){
		return -1;
	}
	*height = atof(token);
	return 0;
}
