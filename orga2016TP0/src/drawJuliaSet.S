#			STACK
#
#104 |		param_t* params		|
#    | ---------------------------------|
#100 |		PADDING			|
# 96 |			ra		|
# 92 |			fp		|
# 88 |			gp		|
#    | ---------------------------------|
# 84 |		char[15] str		|
# 80 |		float twoab		|
# 76 |		float bb			|
# 72 |		flaot aa		|
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
	subu	sp,sp,104
	sw	ra,96(sp)
	sw	$fp,92
	sw	gp,88

	move 	$fp,sp

	#save 1st argument
	sw 	a0,104($fp)

pre_for:
	# t0 = xmin (-params->recW / 2 + params->centerRe)
	lw 	t0,8(a0)
	neg 	t0,t0
	srl 	t0,t0,1
	lw 	t1,24(a0)
	add 	t0,t0,t1
	sw 	t0,24($fp)

	# t0 = ymin (-params->recH / 2 + params->centerIm)
	lw	t0,12(a0)
	neg 	t0,t0
	srl 	t0,t0,1
	lw 	t1,28(a0)
	add 	t0,t0,t1
	sw 	t0,28($fp)

	# t0 = xmax (xmin + params->recW)
	lw 	t0,24($fp)
	lw 	t1,8(a0)
	add 	t0,t0,t1
	sw 	t0,32($fp)

	# t0 = ymax (ymin + params->recH)
	lw	t0,28($fp)
	lw 	t1,12(a0)
	add 	t0,t1,t0
	sw 	t0,36($fp)

	# t0 = dx ((xmax - xmin) / (params->resW))
	lw 	t0,32($fp)
	lw 	t1,24($fp)
	sub 	t0,t0,t1
	lw 	t2,0(a0)
	srl 	t0,t0,0(t2)
	sw 	t0,40($fp)

	# t0 = dy ((ymax - ymin) / (params->resH))
	lw 	t0,36($fp)
	lw 	t1,28($fp)
	sub 	t0,t0,t1
	lw 	t2,4($fp)
	srl 	t0,t0,0(t2)
	sw 	t0,44($fp)

	# t0 = maxIterations (1000)
	li 	t0,1000
	sw 	t0,48,($fp)

	# fputs(header, params->pgmFile); ????

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

	# i < params->resW
	lw 	t0,60($fp)
	lw 	t1,0($fp)
	bge 	t0,t1,fin_first_for

second_for:
	#so something

fin_first_for:
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

end_juliaSet:
	move 	sp,$fp

	lw 	ra,96(sp)
	lw 	$fp,92(sp)
	lw 	gp,88(sp)
	addu 	sp,sp,104
	
	jr 	ra
	.end 	drawJuliaSet
