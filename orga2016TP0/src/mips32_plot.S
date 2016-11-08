#include <mips/regdef.h>
#include <sys/syscall.h>

BUFFSIZE = 4096

.text
.ent mips32_plot
.globl mips32_plot

mips32_plot:
	subu	sp,sp,88
	sw	gp,72(sp)
	sw	$fp,76(sp)
	sw	ra,80(sp)
	move	$fp,sp
	sw	a0,88($fp)

	#float cpr = parms->cp_re;
	l.s	$f0,24(a0)
	s.s	$f0,60($fp)

	#float cpi = parms-> cp_im;
	l.s	$f0,28(a0)
	s.s	$f0,64($fp)

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
	addiu s1, s1, 3

	#levanto params->x_res y le hago append al buffer.
	lw	t0,88($fp)
	lw s2,32(t0)
	la t9,append_y_res
	b append_to_buffer


append_y_res:
	#Appendeo una "\n" TODO: extraer en un metodo para no repetir.
	la	t1,buffer
	la	t3,endline
	lb	t3,0(t3)
	addu	t2,t1,s1
	sb	t3,0(t2)
	addiu 	s1,s1,1

	lw	t0,88($fp)
	lw	s2,36(t0)		#y_res
	la	t9,append_shades
	b	append_to_buffer

append_shades:

	#Appendeo una "\n"
	la	t1,buffer
	la	t3,endline
	lb	t3,0(t3)
	addu 	t2,t1,s1
	sb	t3,0(t2)
	addiu 	s1,s1,1

	lw	t0,88($fp)
	lw	s2,40(t0)		#shades
	la	t9,calculate_fractal
	b	append_to_buffer

calculate_fractal:

	#Appendeo una "\n"
	la	t1,buffer
	la	t3,endline
	lb	t3,0(t3)
	addu 	t2,t1,s1
	sb 	t3,0(t2)
	addiu 	s1,s1,1

	sw 	v0,56($fp)
	bgez	v0, pre_for

pre_for:
	lw	t0,88($fp)
	sw	zero,48($fp)		# y = 0
	sw	zero,44($fp)		# x = 0
	sw	zero,52($fp)		# c = 0
	lw	t0,88($fp)		# t0 = &parms_t
	l.s 	$f2,4(t0)		
	s.s 	$f2,20($fp)		# ci = UL_im
	l.s 	$f4,0(t0)
	s.s 	$f4,16($fp)		# cr = UL_re

first_for:
	lw	t0,88($fp)
	lw	t1,48($fp)		# t1 = y
	lw	t2,36(t0)		# t2 = y_res
	bge 	t1,t2,end_first_for

second_for:
	lw	t0,88($fp)
	lw	t3,44($fp)		# t3 = x
	lw	t4,32(t0)		# t4 = x_res
	bge 	t3,t4,end_second_for

	l.s 	$f6,16($fp)		# $f6 = cr
	s.s 	$f6,24($fp)		# zr = cr
	l.s 	$f8,20($fp)		# $f8 = ci
	s.s 	$f8,28($fp)		# zi = ci

	#for (c = 0; c < parms->shades; ++c) {
third_for:
	lw	t0,88($fp)
	lw	t7,52($fp)		# t7 = c
	lw	t8,40(t0)		# t8 = shades
	bge	t7,t8,end_third_for

	l.s 	$f2,24($fp)		# $f2 = zr
	l.s 	$f4,28($fp)		# $f4 = zi
	l.s 	$f6,60($fp)		# $f6 = cpr
	l.s 	$f8,64($fp)		# $f8 = cpi

	# ( (absz = zr*zr + zi*zi) > 4.0f) ? break:continue
	mul.s 	$f10,$f2,$f2
	mul.s	$f12,$f4,$f4
	add.s 	$f10,$f10,$f12
	s.s 	$f10,40($fp)		# absz = zr * zr + zi * zi	
	li.s 	$f12,4.0
	c.le.s 	$f12,$f10
	bc1t 	end_third_for
	
	#sr = zr * zr - zi * zi + cpr;
	mul.s	$f10,$f2,$f2
	mul.s	$f12,$f4,$f4
	sub.s	$f12,$f10,$f12
	add.s 	$f12,$f12,$f6		# $f12 = sr
	s.s 	$f12,32($fp)

	#si = 2 * zr * zi + cpi;
	mul.s 	$f10,$f2,$f4
	li.s 	$f14,2.0
	mul.s 	$f10,$f10,$f14
	add.s 	$f10,$f10,$f8		# $f10 = si
	s.s 	$f10,36($fp)
	
	#zr = sr;
	s.s 	$f12,24($fp)

	#zi = si;
	s.s 	$f10,28($fp)

	#++c
	lw	t7,52($fp)
	addi	t7,t7,1
	sw 	t7,52($fp)
	b 	third_for

end_first_for:
	sw 	zero,48($fp)		# y = 0
	lw	t0,88($fp)
	l.s 	$f2,4(t0)		
	s.s 	$f2,20($fp)		# ci = UL_im

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
	sw 	zero,44($fp)		# x = 0
	lw	t0,88($fp)
	l.s 	$f4,0(t0)
	s.s 	$f4,16($fp)		# cr = UL_re
	lw	t1,48($fp)		# t1 = y
	addi 	t1,t1,1
	sw 	t1,48($fp)
	l.s 	$f2,20($fp)		# $f2 = ci
	l.s 	$f4,20(t0)		# $f4 = d_im
	sub.s	$f4,$f2,$f4
	s.s 	$f4,20($fp)
	b 	first_for

end_third_for:
	
	li	t0,BUFFSIZE

	#Si la cantidad de bytes acumulados supero el buffer, hago un flush del mismo.
	bge	s1,t0,writeToFile

   	#cargo en s2 el valor de C
   	lw	t1,52($fp)
	move 	s2,t1
	la	t9,writeEndline
	b	append_to_buffer


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
	la	t0,buffer
	la	t4,endline
	lb	t4,0(t4)
	addu 	t0,t0,s1
	sb	t4,0(t0)
	addiu 	s1,s1,1
	b	increment_second_for

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
	sw 	zero,52($fp)		# c = 0
	lw	t0,88($fp)
	lw	t1,44($fp)		# t1 = x
	addi	t1,t1,1
	sw 	t1,44($fp)
	l.s 	$f2,16($fp)		# $f2 = cr
	l.s 	$f4,16(t0)		# $f4 = d_re
	add.s 	$f4,$f2,$f4
	s.s 	$f4,16($fp)
	b 	second_for


append_to_buffer:
	li 	t0,10
	li 	t7,10
	li 	t6,1

getOrder:
	divu 	t1,s2,t7
	blt 	t1,t6,endGetOrder
	mul 	t7,t7,10
	b 	getOrder

endGetOrder:
	divu 	t7,t7,10

digitToChar:
	blt 	t7,t6,end
	divu 	t1,s2,t7
	la 	t2,digits
	addu 	t2,t2,t1		#offset del array digit
	lb	t1,0(t2)		#digit as char

    	la	t3,buffer
	addu 	t3,t3,s1
	sb	t1,0(t3)
	addiu 	s1,s1,1

	remu 	s2,s2,t7
	divu 	t7,t7,10

	b 	digitToChar

end: 
	jr t9

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
	lw	gp,72(sp)
	addu 	sp,sp,88

	jr	ra

	.end 	mips32_plot

.data
.align 2
digits: .ascii "0123456789"
buffer: .space BUFFSIZE
header: .ascii "P2\n"
endline: .ascii "\n"
error: .asciiz "io error.\n"
