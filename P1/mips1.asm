.data
error: .ascii "Son del mismo signo"

.text
# Comienzo intervalo
	li $v0 6
	syscall
	mov.s $f12, $f0
	mov.s $f1, $f12

# Fin intervalo
	li $v0 6
	syscall
	mov.s $f13, $f0
	mov.s $f2, $f13

# Tolerancia
	li $v0 6
	syscall
	mov.s $f14, $f0
	
	jal Bisec
	
	beq $v0,$zero,raiz
	la $a0,error
	li $v0 4
	syscall
	li $v0 10
	syscall	
raiz:	
	mov.s $f12, $f0
	li $v0 2
	syscall
	li $v0 10
	syscall
	
.data
Cero: .float 0.0
Uno: .float 1.0
Dos: .float 2.0
Tres: .float 3.0
.text	
#recibe f12=a f13=b f14=error
#devuelve v0- 0 solucion correcta 1 solucion incorrecta
#devuelve f0 x tal que f(x)=0
Bisec:
	addi $sp $sp -4
	sw $ra 0($sp)
	
	#obtenemos valores de la función en extremos y si es igual a 0 ya sabemos solución
	#a
Bucle:	mov.s $f16, $f12
	jal Funcion
	mov.s $f20, $f0
	la $t0, Cero
	lwc1 $f30, 0($t0)	
	c.eq.s 1 $f20, $f30
	mov.s $f0, $f12
	bc1t 1, Acabarbien
	#b
	mov.s $f16, $f13
	jal Funcion
	mov.s $f21, $f0
	la $t0, Cero
	lwc1 $f30, 0($t0)
	c.eq.s 1 $f21, $f30
	mov.s $f0, $f13
	bc1t 1, Acabarbien
	#comparamos si a y b son del mismo signo
	mov.s $f3, $f20
	mov.s $f4, $f21
	jal Comparador
	beq $t0,$zero,Acabaerror
	#si no son del mismo signo calculamos punto medio
	mov.s $f6, $f12
	mov.s $f7, $f13
	jal Puntomedio
	#calculamos f(c)
	mov.s $f16, $f15
	jal Funcion
	mov.s $f22, $f0
	#comparamos si a y c son del mismo signo
	mov.s $f3, $f20
	mov.s $f4, $f22
	jal Comparador
	beq $t0,$zero,B
	mov.s $f13,$f15
	j Bucle
B:	mov.s $f12,$f15
	j Bucle
	
	
	mov.s $f0,$f15
	j Acabarbien
Acabaerror:
	addi $v0,$zero,1
	j Fin
Acabarbien:
	addi $v0,$zero,0

Fin:	lw $ra 0($sp)
	addi $sp $sp 4
	jr $ra
	
#Recibe una valor x $f16 
# devuelve en $f0 el valor de la función en ese punto
# FUNCION = 2X + 1
Funcion:
	la $t0, Dos 
	lwc1 $f28, 0($t0)
        mul.s $f0, $f16, $f28
        la $t0, Uno 
	lwc1 $f29, 0($t0)
        add.s $f0, $f0, $f29
	jr $ra
	
#Recibe un número en $f3 y otro $f4 
# devuelve $t0=0 si son del mismo signo
Comparador:	
	la $t0, Cero 
	lwc1 $f30, 0($t0)
	
	c.lt.s 1 $f3, $f30
	c.lt.s 2 $f4, $f30
	
	bc1t 1 N1
	
	bc1t 2 N3
	add $t0, $zero, $zero
	j FinC
	
N1: 	bc1t 2 N2
	addi $t0, $zero, 1
	j FinC

N2: 	add $t0, $zero, $zero
	j FinC

N3:	addi $t0, $zero, 1

FinC:	jr $ra

#Recibe dos puntos en $f6, $f7 
#devuelve el punto medio en $f15
Puntomedio:
	la $t0, Dos
	lwc1 $f28, 0($t0)
	add.s $f15, $f6,$f7
	div.s $f15, $f15,$f28
	jr $ra