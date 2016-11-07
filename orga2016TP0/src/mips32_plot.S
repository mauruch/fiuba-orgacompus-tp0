#include <mips/regdef.h>
#include <sys/syscall.h>

BUFFSIZE = 8192

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

	#contador de bytes a escribir
	move s1, zero

	#Cargo el header en el buffer
    la t0, header
    la t1, buffer

	lb t2, 0(t0)
    sb t2, 0(t1)
    lb t2, 1(t0)
    sb t2, 1(t1)
    lb t2, 2(t0)
    sb t2, 2(t1)

    addiu s1, s1, 3

 	#levanto params->x_res y lo appendeo al buffer
	lw	t0, 88($fp)
	lw s2, 32(t0)		#x_res
	la t9, append_y_res
    b append_to_buffer


append_y_res:

	#Appendeo una "\n" TODO: extraer en un metodo para no repetir
	la t1, buffer
	la t3, endline
	lb t3, 0(t3)
	addu t7,t1,s1
	sb t3, 0(t7)
	addiu s1, s1, 1

	lw	t0, 88($fp)
	lw s2, 36(t0)		#y_res
    la t9, append_shades
    b append_to_buffer

append_shades:

	#Appendeo una "\n"
	la t1, buffer
	la t3, endline
	lb t3, 0(t3)
	addu t7,t1,s1
	sb t3, 0(t7)
	addiu s1, s1, 1

	lw	t0, 88($fp)
	lw s2, 40(t0)		#shades
	la t9, calculate_fractal
	b append_to_buffer

calculate_fractal:

	#Appendeo una "\n"
	la t1, buffer
	la t3, endline
	lb t3, 0(t3)
	addu t7,t1,s1
	sb t3, 0(t7)
	addiu s1, s1, 1

	sw 	v0,56($fp)
	bgez	v0, pre_for

	#TODO escribir en stderr y terminar
	b 	termina_error

pre_for:
	lw	t0,88($fp)
	sw 	zero,48($fp)		# y = 0
	sw 	zero,44($fp)		# x = 0
	sw 	zero,52($fp)		# c = 0
	lw	t0,88($fp)		# t0 = &parms_t
	l.s 	$f2,4(t0)		
	s.s 	$f2,20($fp)		# ci = UL_im
	l.s 	$f4,0(t0)
	s.s 	$f4,16($fp)		# cr = UL_re

primer_for:
	lw	t0,88($fp)
	lw	t1,48($fp)		# t1 = y
	lw	t2,36(t0)		# t2 = y_res
	bge 	t1,t2,termina_primer_for

segundo_for:
	lw	t0,88($fp)
	lw	t3,44($fp)		# t3 = x
	lw	t4,32(t0)		# t4 = x_res
	bge 	t3,t4,termina_segundo_for

	l.s 	$f6,16($fp)		# $f6 = cr
	s.s 	$f6,24($fp)		# zr = cr
	l.s 	$f8,20($fp)		# $f8 = ci
	s.s 	$f8,28($fp)		# zi = ci

	#for (c = 0; c < parms->shades; ++c) {
tercer_for:
	lw	t0,88($fp)
	lw	t7,52($fp)		# t7 = c
	lw	t8,40(t0)		# t8 = shades
	bge t7,t8,break_tercer_for

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
	bc1t 	termina_tercer_for
	
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
	addi t7,t7,1
	sw 	t7,52($fp)

	b 	tercer_for

termina_primer_for:

	b 	terminar_ok

	#++y, ci -= parms->d_im
termina_segundo_for:
	lw	t0,88($fp)
	lw	t1,48($fp)		# t1 = y
	addi 	t1,t1,1
	sw 	t1,48($fp)
	l.s 	$f2,20($fp)		# $f2 = ci
	l.s 	$f4,20(t0)		# $f4 = d_im
	sub.s	$f4,$f2,$f4
	s.s 	$f4,20($fp)
	b 	primer_for

termina_tercer_for:

	#tengo que escribir el valor de C, pero tal vez el buffer esta lleno
	li t0, BUFFSIZE
	bge s1, t0, escribirEnArchivo1

    la t0, buffer #estas 2 lineas se pueden borrar me parece.
    addu t0, t0, s1

   	#cargo en s2 el valor de C
   	lw t1, 52($fp)
	move s2, t1
    la t9, escribirEndLine
	b append_to_buffer


escribirEnArchivo1:
	li v0, SYS_write		#write syscal value

	lw	t0, 88($fp)
	lw a0, 44(t0)		#params->fd

    la a1, buffer
    move a2, s1

    la t0, terminator
    lb t0, 0(t0)
    addu t1, a1, s1
    sb t0, 0(t1)

    syscall

    blt v0, zero, mostrarError
	move s1, zero
	la t1, buffer

    la t0, terminator
    lb t0, 0(t0)
    addu t1, t1, s1
    sb t0, 0(t1)

    b termina_tercer_for

escribirEndLine:
	li t0, BUFFSIZE
	bge s1, t0, escribirEnArchivo2
	la t0, buffer
	la t4, endline
	lb t4, 0(t4)
    addu t0, t0, s1
    sb t4, 0(t0)
    addiu s1, s1, 1
	b break_tercer_for

escribirEnArchivo2:
	li v0, SYS_write		#write syscal value

    lw	t0, 88($fp)
	lw a0, 44(t0)		#params->fd

    la a1, buffer

    la t0, terminator
    lb t0, 0(t0)
    addu t1, a1, s1
    sb t0, 0(t1)
    move a2, s1


    syscall

    blt v0, zero, mostrarError

    la t1, buffer

    la t0, terminator
    lb t0, 0(t0)
    addu t1, t1, s3
    sb t0, 0(t1)

	move s3, zero

    b escribirEndLine


	#++x, cr += parms->d_re
break_tercer_for:
	lw	t0,88($fp)
	lw	t1,44($fp)		# t1 = x
	addi	t1,t1,1
	sw 	t1,44($fp)
	l.s 	$f2,16($fp)		# $f2 = cr
	l.s 	$f4,16(t0)		# $f4 = d_re
	add.s 	$f4,$f2,$f4
	s.s 	$f4,16($fp)
	b 	segundo_for


append_to_buffer:
	li t0, 10
	li t7, 10

	li t6, 1

calculoOrden:
	divu t1,s2,t7
	blt t1,t6, finCalculo
	mul t7,t7,10
	b calculoOrden

finCalculo:
	divu t7,t7,10

loopImpresion:
	blt t7, t6, fin
	divu t1, s2, t7
	la t2, digits
	addu t2,t2,t1 #offset del array digit
	lb	t1, 0(t2) #digit as char

    la t3, buffer
	addu t3,t3,s1
	sb 	t1, 0(t3)
	addiu s1,s1,1

	remu s2,s2,t7

	divu t7,t7,10

	b loopImpresion

fin: jr t9

mostrarError:
	li v0, SYS_write   #write syscal
    li a0, 2			#stderrr file descriptor
    la a1, error
    li a2, 10				#cantidad de bytes a ecribir. largo de cadena de texto
    syscall
    b termina_error

termina_error:
	li 	v0,-1 		# no estoy seguro si esto anda
	b 	terminar

terminar_ok:
	li	v0,0

terminar:
	move	sp,$fp
	lw	ra,80(sp)
	lw	$fp,76(sp)
	lw	gp,72(sp)
	addu 	sp,sp,88

	jr	ra

	.end mips32_plot

.data
.align 2
terminator:   .asciiz ""
digits: .ascii "0123456789"
buffer: .space BUFFSIZE + 3
header: .ascii "P2\n"
endline: .ascii "\n"
error: .asciiz "io error.\n"
