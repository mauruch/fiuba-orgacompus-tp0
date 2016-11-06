#include <stdio.h>
#include <stdlib.h>

typedef struct {
/*0*/	float UL_re;
/*4*/	float UL_im;
/*8*/	float LR_re;
/*12*/	float LR_im;
/*16*/	float d_re;
/*20*/	float d_im;
/*24*/	float cp_re;
/*28*/	float cp_im;

/*32*/	size_t x_res;
/*36*/	size_t y_res;
/*40*/	size_t shades;

/*44*/	int fd;
} param_t;
