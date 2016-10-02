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

typedef struct{
	size_t resW;
	size_t resH;
	size_t recW;
	size_t recH;
	float complexRe;
	float complexIm;
	float centerRe;
	float centerIm;
	FILE* pgmFile;
}param_t;

char getDelimSymbol(char* cvalue);
float getReValue(char* string, char delim);
float getImValue(char* string, char delim);
bool isComplexValue(char* string);
int analyzerComplexParameter(char* cValue, float* cRe, float* cIm);
int setResolution(char* rvalue,param_t* param);
void drawJuliaSet(param_t* params);

int main(int argc, char *argv[]) {
	if (argc == 1) {
		fprintf(stderr,"No options given\n");
		return EXIT_FAILURE;
	}
	//default params values
	param_t params;
	params.resW = 640;
	params.resH = 480;
	params.centerIm = 0;
	params.centerRe = 0;
	params.complexIm = 0.01;
	params.complexRe = 0.285;
	params.recW = 4;
	params.recH = 4;

	int c;

	//args values
	char *ovalue = NULL;

	//read args params
	while ((c = getopt(argc, argv, "r:c:C:w:H:o:")) != -1) {
		switch (c) {
		case 'r':
			//resolution value
			if(setResolution(optarg,&params) != 0){
				fprintf(stderr,"Fatal: invalid r specification.\n");
				return EXIT_FAILURE;
			}
			break;
		case 'c':
			//image center value
			if (analyzerComplexParameter(optarg, &(params.centerRe), &(params.centerIm)) != 0) {
				fprintf(stderr,"Fatal: invalid c specification.\n");
				return EXIT_FAILURE;
			}
			break;
		case 'C':
			//C parameter value
			if (analyzerComplexParameter(optarg, &(params.complexRe), &(params.complexIm)) != 0) {
				fprintf(stderr,"Fatal: invalid C specification.\n");
				return EXIT_FAILURE;
			}
			break;
		case 'w':
			//width value
			if(!isdigit(*optarg)){
				fprintf(stderr,"Fatal: invalid w specification.\n");
				return EXIT_FAILURE;
			}
			params.recW = atof(optarg);
			break;
		case 'H':
			//high value
			if(!isdigit(*optarg)){
				fprintf(stderr,"Fatal: invalid H specification.\n");
				return EXIT_FAILURE;
			}
			params.recH = atof(optarg);
			break;
		case 'o':
			ovalue = optarg;
			//file name value
			if (strcmp(ovalue, "-") == 0) {
				params.pgmFile = stdout;
			} else {
				params.pgmFile = fopen(ovalue, "wb");
				if (params.pgmFile == NULL) {
					fprintf(stderr,"Fatal: cannot open output file.");
					return EXIT_FAILURE;
				}
			}
			break;
		}
	}

	if (!ovalue) {
		fprintf(stderr,"Fatal: -o parameter is mandatory.");
		return EXIT_FAILURE;
	}

	drawJuliaSet(&params);

	return 0;
}

void drawJuliaSet(param_t* params) {

	// a + bi
	float a, b;

	// Start at negative half the rectangleDrawWidth and resolutionHeight
	float xmin = -params->recW / 2 + params->centerRe;
	float ymin = -params->recH / 2 + params->centerIm;

	// x goes from xmin to xmax
	float xmax = xmin + params->recW;
	// y goes from ymin to ymax
	float ymax = ymin + params->recH;

	// Calculate amount we increment x,y for each pixel
	float dx = (xmax - xmin) / (params->resW);
	float dy = (ymax - ymin) / (params->resH);

	int maxIterations = 1000;

	char header[100];
	sprintf(header, "P2\n# Julia Set image\n %d %d \n255\n", params->resW, params->resH);
	fputs(header, params->pgmFile);

	//loop through every pixel
	// Start y
	float y = ymin;
	int j, i;
	for (j = 0; j < params->resH; j++) {
		// Start x
		float x = xmin;
		for (i = 0; i < params->resW; i++) {
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
				a = aa - bb + params->complexRe;
				b = twoab + params->complexIm;
			}
			char str[15];
			sprintf(str, "%d ", n);
			fputs(str, params->pgmFile);
			x += dx;
		}
		fputs("\n", params->pgmFile);
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

int setResolution(char* rvalue,param_t* params) {
	char *delim = "x";
	char *token = strtok(rvalue, delim);
	params->resW = atof(token);
	token = strtok(0, delim);
	if(!token){
		return -1;
	}
	params->resH = atof(token);
	if( (params->resH <= 0) || (params->resW <= 0)){
		return EXIT_FAILURE;
	}
	return 0;
}
