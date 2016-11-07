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
	lw	t0,24(a0)
	sw	t0,60($fp)

	#float cpi = parms-> cp_im;
	lw	t0,28(a0)
	sw	t0,64($fp)

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
	lw s2, 32(t0) #x_res
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
	lw s2, 36(t0) #y_res
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
	lw s2, 40(t0) #shades
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
	bgez	v0, primer_for

	#TODO escribir en stderr y terminar
	b 	termina_error

pre_for:
	sw 	zero,48($fp)		# y = 0
	sw 	zero,44($fp)		# x = 0
	sw 	zero,52($fp)		# c = 0
	lw	t0,88($fp)		# t0 = *parms_t
	lw	t1,4(t0)		
	sw 	t1,20($fp)		# ci = UL_im
	lw	t2,0(t0)
	sw 	t2,16($fp)		# cr = UL_re
	lw 	t3,40(t0)
	sw 	t3,52($fp)		# c = shades


primer_for:
	lw	t0, 88($fp)
	lw	t1,48($fp)		# t1 = y
	lw	t2,36(t0)		# t2 = y_res
	bge 	t1,t2,termina_primer_for


segundo_for:
	lw	t0, 88($fp)
	lw	t3,44($fp)		# t3 = x
	lw	t4,32(t0)		# t4 = x_res
	bge 	t3,t4,termina_segundo_for

	lw	t5,16($fp)		# t5 = cr
	sw 	t5,24($fp)
	lw	t6,20($fp)		# t6 = ci
	sw 	t6,28($fp)

	#for (c = 0; c < parms->shades; ++c) {
tercer_for:
	lw	t0, 88($fp)
	lw	t7,52($fp)		# t7 = c
	lw	t8,40(t0)		# t8 = shades
	bge t7,t8,break_tercer_for

	lw	t1,24($fp)		# t1 = zr
	lw 	t2,28($fp)		# t2 = zi
	lw	t3,60($fp)		# t3 = cpr
	lw	t4,64($fp)		# t4 = cpi

	mulo	t7,t1,t1
	mulo	t8,t2,t2
	addu 	t7,t7,t8
	sw 	t7,40($fp)		
	li 	t8,4
	bgt	t7,t8,termina_tercer_for

	#sr = zr * zr - zi * zi + cpr;
	mulo	t7,t1,t1
	mulo	t8,t2,t2
	subu	t8,t7,t8
	addu 	t5,t8,t3		# t5 = sr
	sw 	t5,32($fp)

	#si = 2 * zr * zi + cpi;
	mulo 	t7,t1,t2
	li 	t8,1
	sll 	t7,t7,t8
	addu 	t6,t7,t4		# t6 = si
	sw 	t6,36($fp)
	
	#zr = sr;
	sw 	t5,24($fp)

	#zi = si;
	sw 	t6,28($fp)

	#++c
	lw	t7,52($fp)
	addi t7,t7,1
	sw 	t7,52($fp)

	b 	tercer_for

termina_primer_for:

	b 	terminar_ok

#++y, ci -= parms->d_im
termina_segundo_for:
	lw	t1,48($fp)		# t1 = y
	addi 	t1,t1,1
	sw 	t1,48($fp)
	lw 	t2,20($fp)		# t2 = ci
	lw	t3,20(t0)		# t3 = d_im
	subu	t3,t2,t3
	sw 	t3,20($fp)
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
	li v0, SYS_write			#write syscal value

	lw	t0, 88($fp)
	lw a0, 44(t0) #params->fd

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
	li v0, SYS_write			#write syscal value

    lw	t0, 88($fp)
	lw a0, 44(t0) #params->fd

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
	lw	t1,44($fp)		# t1 = x
	addi	t1,t1,1
	sw 	t1,44($fp)
	lw	t2,16($fp)		# t2 = cr
	lw	t3,16(t0)		# t3 = d_re
	addu 	t3,t2,t3
	sw 	t3,16($fp)
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
