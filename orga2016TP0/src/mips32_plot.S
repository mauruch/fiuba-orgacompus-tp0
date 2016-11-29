#STACK FRAME

#88		Params
#-----------------------#
#84		Padding	S
#80		ra	R
#76		$fp	A
#72		gp	#
#----------------------	#
#68	File	*fp	#
#64	float cpi	#
#60	float cpr	#
#56	int res		#
#52	int c		#
#48	int y		L
#44	int x		T
#40	float absz	A
#36	float si	#
#32	float sr	#
#28	float zi	#
#24	float zr	#
#20	float ci	#
#16	float cr	#
#---------------------- #
#12	a3		A
#8 	a2		B
#4 	a1		A
#0 	a0		#
#-----------------------#

#include <mips/regdef.h>
#include <sys/syscall.h>

BUFFSIZE = 4096

#Offsets
A0_OFF = 0
A1_OFF = 4
A2_OFF = 8
A3_OFF = 12

CR_OFF = 16
CI_OFF = 20
ZR_OFF = 24
ZI_OFF = 28
SR_OFF = 32
SI_OFF = 36
ABSZ_OFF = 40

X_OFF = 44
Y_OFF = 48
C_OFF = 52

RES_OFF = 56
CPR_OFF = 60
CPI_OFF = 64
FP_OFF = 68

GP_OFF = 72
FP_OFF = 76
GP_OFF = 80

.text
.ent mips32_plot
.globl mips32_plot

mips32_plot:
	subu	sp,sp,88
	sw	gp, GP_OFF(sp)
	sw	$fp, FP_OFF(sp)
	sw	ra, GP_OFF(sp)
	move	$fp,sp
	sw	a0,88($fp)

	#float cpr = parms->cp_re;
	l.s	$f0,24(a0)
	s.s	$f0, CPR_OFF($fp)

	#float cpi = parms-> cp_im;
	l.s	$f0, 28(a0)
	s.s	$f0, CPI_OFF($fp)

	#contador de bytes a escribir.
	move	s1, zero

	#hago append del header en el buffer.
	la	t0, header
	la	t1, buffer

	lb	t2,0(t0)
	sb	t2,0(t1)
	lb	t2,1(t0)
	sb	t2,1(t1)
	lb	t2,2(t0)
	sb	t2,2(t1)

	#s1 va a tener el numero de bytes que agregue al buffer.
	addiu 	s1, s1, 3

	#levanto params->x_res y le hago append al buffer.
append_x_res:
	lw	t0, 88($fp)
	lw 	s2, 32(t0) # x
	la 	t9, append_to_buffer
	jal	ra, t9

	la 	t9, append_y_res
	b 	append_new_line

append_y_res:
	lw	t0, 88($fp)
	lw	s2, 36(t0) #y_res
	la 	t9, append_to_buffer
	jal	ra, t9

	la 	t9, append_shades
	b 	append_new_line

append_shades:
	lw	t0, 88($fp)
	lw	s2, 40(t0)		#shades
	la 	t9, append_to_buffer
	jal	ra, t9

	la 	t9, calculate_fractal
	b 	append_new_line

append_new_line:
	la	t1, buffer
	la	t3, endline
	lb	t3, 0(t3)
	addu	t2,t1,s1
	sb	t3,0(t2)
	addiu 	s1,s1,1
	jr t9

calculate_fractal:
	sw 	v0, RES_OFF($fp)
	bgez	v0, pre_for

pre_for:
	lw	t0,88($fp)
	sw	zero, Y_OFF($fp)	# y = 0
	sw	zero, X_OFF($fp)	# x = 0
	sw	zero, C_OFF($fp)	# c = 0
	lw	t0, 88($fp)		# t0 = &parms_t
	l.s 	$f2, 4(t0)
	s.s 	$f2, CI_OFF($fp)	# ci = UL_im
	l.s 	$f4, 0(t0)
	s.s 	$f4, CR_OFF($fp)	# cr = UL_re

first_for:
	lw	t0, 88($fp)
	lw	t1, Y_OFF($fp)		# t1 = y
	lw	t2,	36(t0)		# t2 = y_res
	bge 	t1, t2, end_first_for

second_for:
	lw	t0, 88($fp)
	lw	t3, X_OFF($fp)		# t3 = x
	lw	t4, 32(t0)		# t4 = x_res
	bge 	t3, t4, end_second_for

	l.s 	$f6,CR_OFF($fp)		# $f6 = cr
	s.s 	$f6,ZR_OFF($fp)		# zr = cr
	l.s 	$f8,CI_OFF($fp)		# $f8 = ci
	s.s 	$f8,ZI_OFF($fp)		# zi = ci

	#for (c = 0; c < parms->shades; ++c) {
third_for:
	lw	t0,88($fp)
	lw	t7,C_OFF($fp)		# t7 = c
	lw	t8,40(t0)		# t8 = shades
	bge	t7,t8,end_third_for

	l.s 	$f2,ZR_OFF($fp)		# $f2 = zr
	l.s 	$f4,ZI_OFF($fp)		# $f4 = zi
	l.s 	$f6,60($fp)		# $f6 = cpr
	l.s 	$f8,64($fp)		# $f8 = cpi

	# ( (absz = zr*zr + zi*zi) > 4.0f) ? break:continue
	mul.s 	$f10,$f2,$f2
	mul.s	$f12,$f4,$f4
	add.s 	$f10,$f10,$f12
	s.s 	$f10,ABSZ_OFF($fp)	# absz = zr * zr + zi * zi
	li.s 	$f12,4.0
	c.le.s 	$f12,$f10
	bc1t 	end_third_for
	
	#sr = zr * zr - zi * zi + cpr;
	mul.s	$f10,$f2,$f2
	mul.s	$f12,$f4,$f4
	sub.s	$f12,$f10,$f12
	add.s 	$f12,$f12,$f6		# $f12 = sr
	s.s 	$f12,SR_OFF($fp)

	#si = 2 * zr * zi + cpi;
	mul.s 	$f10,$f2,$f4
	li.s 	$f14,2.0
	mul.s 	$f10,$f10,$f14
	add.s 	$f10,$f10,$f8		# $f10 = si
	s.s 	$f10,SI_OFF($fp)
	
	#zr = sr;
	s.s 	$f12,ZR_OFF($fp)

	#zi = si;
	s.s 	$f10,ZI_OFF($fp)

	#++c
	lw	t7,C_OFF($fp)
	addi	t7,t7,1
	sw 	t7,C_OFF($fp)
	b 	third_for

end_first_for:
	sw 	zero,Y_OFF($fp)		# y = 0
	lw	t0,88($fp)
	l.s 	$f2,4(t0)		
	s.s 	$f2,CI_OFF($fp)		# ci = UL_im

	#Si no tengo bytes acumulados -> finish_ok
	beqz 	s1,finish_ok

	#Flush de los bytes acumulados
	li 	v0,SYS_write
	lw	t0,88($fp)
	lw 	a0,44(t0)		#params->fd

	la 	a1,buffer
	move 	a2,s1
	syscall

	blt 	v0,zero,showError
	li 	v0,0
	b 	finish_ok

	#++y, ci -= parms->d_im
end_second_for:
	sw 	zero,X_OFF($fp)		# x = 0
	lw	t0,88($fp)
	l.s 	$f4,0(t0)
	s.s 	$f4,CR_OFF($fp)		# cr = UL_re
	lw	t1,Y_OFF($fp)		# t1 = y
	addi 	t1,t1,1
	sw 	t1,48($fp)
	l.s 	$f2,CI_OFF($fp)		# $f2 = ci
	l.s 	$f4,20(t0)		# $f4 = d_im
	sub.s	$f4,$f2,$f4
	s.s 	$f4,CI_OFF($fp)
	b 	first_for

end_third_for:
	
	li	t0,BUFFSIZE

	#Si la cantidad de bytes acumulados supero el buffer, hago un flush del mismo.
	bge	s1,t0,writeToFile

   	#cargo en s2 el valor de C
   	lw	t1,C_OFF($fp)
	move 	s2,t1
	la 	t9, append_to_buffer
	jal	ra, t9
	b writeEndline

writeToFile:
	li	v0,SYS_write		#write syscal value
	lw	t0,88($fp)
	lw	a0,44(t0)		#params->fd
	la	a1,buffer
	move 	a2,s1
	syscall

	blt 	v0,zero,showError
	move 	s1,zero
	la	t1,buffer
	b	end_third_for

writeEndline:
	li	t0,BUFFSIZE
	bge 	s1,t0,writeToFileAndFallbackWriteEndline

	la 	t9, increment_second_for
	b 	append_new_line

writeToFileAndFallbackWriteEndline:
	li	v0,SYS_write		#write syscal value
	lw	t0,88($fp)
	lw	a0,44(t0)		#params->fd
	la	a1,buffer
	move	a2,s1
	syscall

	blt 	v0,zero,showError
	la	t1,buffer
	move 	s1,zero

	b	writeEndline

	#++x, cr += parms->d_re
increment_second_for:
	sw 	zero,C_OFF($fp)		# c = 0
	lw	t0,88($fp)
	lw	t1,X_OFF($fp)		# t1 = x
	addi	t1,t1,1
	sw 	t1,X_OFF($fp)
	l.s 	$f2,CR_OFF($fp)		# $f2 = cr
	l.s 	$f4,16(t0)		# $f4 = d_re
	add.s 	$f4,$f2,$f4
	s.s 	$f4,CR_OFF($fp)
	b 	second_for

showError:
	li	v0,SYS_write
    	li	a0,2
    	la	a1,error
	li	a2,10
	syscall
	b 	finish_error

finish_error:
	li 	v0,-1
	b 	finish

finish_ok:
	li	v0,0

finish:
	move	sp,$fp
	lw	ra,80(sp)
	lw	$fp,76(sp)
	lw	gp, GP_OFF(sp)
	addu 	sp,sp,88

	jr	ra

	.end 	mips32_plot


# Function append_to_buffer

.ent append_to_buffer
append_to_buffer:

	.set noreorder
	.cpload t9
	.set reorder

	subu 	sp, sp, 8
	sw	gp, 0(sp)
	sw	$fp, 4(sp)

#Bloque de código para convertir un entero a char.
#Dado un entero, por ej 640, va diviendo por 10 para reducir a orden 1 (0 a 9) y asi utilizarlo como
#offset del arreglo digits

	li 	t0, 10
	li 	t7, 10
	li 	t6, 1

getOrder:
	divu 	t1, s2, t7
	blt 	t1, t6, endGetOrder
	mul 	t7, t7, 10
	b 	getOrder

endGetOrder:
	divu 	t7,t7,10

digitToChar:
	blt 	t7, t6, end
	divu 	t1, s2, t7
	la 	t2, digits
	addu 	t2, t2, t1		#offset del array digit
	lb	t1, 0(t2)		#digit as char

    la		t3, buffer
	addu 	t3, t3, s1
	sb	t1, 0(t3)
	addiu 	s1, s1, 1

	remu 	s2, s2, t7
	divu 	t7, t7, 10

	b 	digitToChar

end:
	move v0, s1
	lw	gp, 0(sp)
	lw	$fp, 4(sp)
	addu sp, sp, 8
	jr ra

.end 	append_to_buffer

.data

digits: .ascii "0123456789"
buffer: .space BUFFSIZE
header: .ascii "P2\n"
endline: .ascii "\n"
error: .asciiz "io error.\n"
