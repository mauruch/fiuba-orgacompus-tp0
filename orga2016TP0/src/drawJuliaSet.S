#			STACK
#
#112 |		param_t* params		|
#    | ---------------------------------|
#108 |		PADDING			|
#104 |			ra		|
#100 |			fp		|
# 96 |			gp		|
#    | ---------------------------------|
# 92 |		PADDING			|
# 88 |		char[15] str		|
# 84 |		float twoab		|
# 80 |		float bb			|
# 76 |		flaot aa		|
# 72 |		float n 		|
# 68 | 		float x			|
# 64 | 		float j			|
# 60 | 		float i			|
# 56 |		float y			|
# 52 |		char[100] header		|
# 48 |		int maxIterations	|
# 44 |		float dy			|
# 40 |		float dx			|
# 36 |		float ymax		|
# 32 |		float xmax		|
# 28 |		float ymin		|
# 24 |		float xmin		|
# 20 |		float b			|
# 16 |		float a 			|
#    |----------------------------------|
# 12 |			a3		|
# 8  |			a2	 	|
# 4  |			a1	 	|
# 0  |			a0	 	|
#     ----------------------------------

	# 0 parms.UL_re = upper_left_re;
	# 4 parms.UL_im = upper_left_im;
	# 8 parms.LR_re = lower_right_re;
	# 12 parms.LR_im = lower_right_im;
 #    16 parms.d_re = (lower_right_re - upper_left_re) / x_res;
 #    20 parms.d_im = (upper_left_im - lower_right_im) / y_res;
 #    24 parms.x_res = x_res;
 #    28 parms.y_res = y_res;
 #    32 parms.shades = 255;
	# 36 parms.cp_re = c_param_re;
	# 40 parms.cp_im = c_param_im;
 #    44 parms.fd = fileno(output);

# typedef struct {
# 0	size_t resW;
# 4	size_t resH;
# 8	size_t recW;
# 12	size_t recH;
# 16	float complexRe;
# 20	float complexIm;
# 24	float centerRe;
# 28	float centerIm;
# 32	FILE* pgmFile;
# }param_t

.text
.globl drawJuliaSet

drawJuliaSet:
	#create stack frame
	subu	sp,sp,112
	sw	ra,104(sp)
	sw	$fp,100(sp)
	sw	gp,96(sp)

	move 	$fp,sp

	#save 1st argument
	sw 	a0,112($fp)

pre_for:
	# t0 = xmin = UL_re
	lw 	t0, 0(a0)
	sw 	t0,24($fp)

	# t0 = ymin = LR_im
	lw	t0,12(a0)
	sw 	t0,28($fp)

	# t0 = xmax = LR_re
	lw 	t0, 8(a0)
	sw 	t0,32($fp)

	# t0 = ymax = UL_im
	lw 	t0, 4(a0)
	sw 	t0,36($fp)

	# t0 = dx = d_Re
	lw 	t0, 16(a0)
	sw 	t0,40($fp)

	# t0 = dy = d_Im
	lw 	t0, 20(a0)
	sw 	t0,44($fp)

	# t0 = maxIterations (1000)
	li 	t0,1000
	sw 	t0,48,($fp)

	#char header[100];
	#sprintf(header, "P2\n%d %d \n255\n", params->resW, params->resH);
	#fputs(header, params->pgmFile);

	# t0 = y (ymin)
	lw 	t0,28($fp)
	sw	t0,56($fp)

	# t0 = i,j (0)
	li 	t0,0
	sw	t0,60($fp)
	sw	t0,64($fp)

first_for:
	# j < params->resH
	lw	t0,64($fp)
	lw 	t1,4(a0)
	bge 	t0,t1,end_juliaSet
	
	# t0 = x (xmin)
	lw 	t0,24($fp)
	sw 	t0,68($fp)

second_for:
	# i < params->resW
	lw 	t0,60($fp)
	lw 	t1,0($fp)
	bge t0,t1,end_second_for

	# t0 = a (x)
	lw 	t0,68($fp)
	sw	t0,16($fp)

	# t0 = b (y)
	lw 	t0,56($fp)
	sw 	t0,20($fp)

	# t0 = n (0)
	li 	t0,0
	sw 	t0,72($fp)

third_for:
	# n < maxIterations
	lw 	t0,72($fp)
	lw	t1,48($fp)
	bge t0,t1,end_third_for

	lw t5, 16($fp)
	lw t6, 20($fp)

	mul t5, t5, t5 #aa
	mul t6, t6, t6 #bb

	li t9, 4
	add t7, t5, t6 #aa+bb
	bgt t7, t9, breakFor

	#float twoab = 2 * a * b;
	lw t7, 16($fp) #a
	lw t8, 20($fp) #b
	mul t7, t7, t8 #a*b
	li t9, 2
	mul t7, t7, t9 #twoab = a*b*2

	sub t9, t5, t6 #aa-bb

	#a = aa - bb + params->complexRe;
	add t9, t9, 36(a0)
	sw t9, 16($fp)

	#b = twoab + params->complexIm;
	add t7, t7, 40($fp)
	sw t7, 20($fp)

	#n++
	lw t4, 72($fp)
	addi t4, t4, 1
	sw 	t0,72($fp)

	b third_for

end_second_for:
	#fputs("\n", params->pgmFile); ????
	
	# y += dy
	lw t0,56($fp)
	lw t1,44($fp)
	addu 	t0,t0,t1
	sw	t0,56($fp)

	# j++
	lw 	t0,64($fp)
	addiu 	t0,t0,1
	sw	t0,64($fp)
	b 	first_for

end_third_for:
	#char str[15];
	#sprintf(str, "%d ", n);
	#fputs(str, params->pgmFile);


	# x += dx
	lw 	t0,68($fp)
	lw 	t1,40($fp)
	addu 	t0,t0,t1
	sw 	t0,68($fp)

	# i++
	lw 	t0,60($fp)
	addiu 	t0,t0,1
	sw 	t0,60($fp)
	b 	second_for

end_juliaSet:
	move 	sp,$fp

	lw 	ra,104(sp)
	lw 	$fp,100(sp)
	lw 	gp,96(sp)
	addu 	sp,sp,112
	
	jr 	ra
	.end 	drawJuliaSet
