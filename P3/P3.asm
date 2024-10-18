.data
DireccionNumero: .space 500

.text
	# Recibimos el número a convertir y preparamos los parametros
	li $v0, 5
	syscall
	add $a0, $v0, $zero
	la $a1, DireccionNumero

	jal itoa
	
	# Imprimir el resultado
	li $v0, 4
	la $a0, DireccionNumero	
	syscall

	

	li $v0, 10
	syscall

# Funcion para convertir un numero en complemento a dos a una cadena ASCII en decimal
# Entradas: $a0 - Numero a convertir
#	    $a1: - Direccion donde guardar la cadena resultante
itoa: 		andi $a0, $a0, -2147483648			# Negativo --> 1

		li $v0, 4
		syscall
		
		jr $ra