# Funcion para convertir una cadena de caracteres en un entero de 32 bits
# Entradas:  $a0 - Direccion de la cadena
#		       $v0 - Entero resultante
#			$v1 - Salida de errores
.text
atoi: 			add $v0, $zero, $zero
			add $v1, $zero, $zero
			add $t0, $zero, $zero
			addi $t2, $zero, 1			#bit para saber si es positivo
			addi $t7, $zero, 10
			
espacio:		lb $t0, 0($a0)
			addi $a0, $a0, 1
			beq $t0, 32, espacio			# Salta los espacios y los "+"
			beq $t0, 43, car2
			bne $t0, 45, Otro		
		    	addi $t2, $zero, -1		#si es negativo $t2->-1
		    	
car2:			lb $t0, 0($a0)
			addi $a0, $a0, 1
		    	
Otro:		    	addi $t0, $t0, -48
		    	blt $t0, $zero, caracterincorrecto		# Se comprueba si es un numero
			bge $t0, $t7,  caracterincorrecto
			addi $a0, $a0, -1 			
			
Factor:
			lb $t0, 0($a0)
			addi $a0, $a0, 1
			
			beq $t0, $t7,salir
			beq $t0, $zero,salir
			
			addi $t0, $t0, -48	
						
			bge $t0, $t7,  salir
			blt $t0, $zero, salir
			
			mul $v0, $v0, $t7
			
			add $v0,$v0,$t0
			
				
			j Factor

caracterincorrecto: 		addi $v1, $zero, 1
			

salir:			   	mul $v0, $v0, $t2
				jr $ra