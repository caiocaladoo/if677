section .data
	msg db "informe um valor: "
	len equ $ - msg

	comma db ", "
	commaL equ $ - comma

	blank db "", 0xA, 0xD
	blankL equ $ - blank

section .bss
	num1 resb 255
	num2 resb 255
	aux resb 255
	aux2 resb 255
	input resb 1

section .text
		
	call mensagem
	call ler1

	call mensagem
	call ler2

	call laco

	mov eax, 1
	int 0x80

mensagem:
	mov eax, 4
	mov ebx, 1
	mov ecx, msg
	mov edx, len
	int 0x80

	ret
; chamada para ler o valor 1
ler1:
	
	l1:
		mov eax, 3
		mov ebx, 0
		mov ecx, input
		mov edx, 1
		int 80h


		mov eax, [input]
		cmp eax, 10 ;ascII 10 = /n
		jz exit

		sub eax, '0'		
		mov ebx, [num1]
		imul ebx, 10
		add ebx, eax
		mov [num1], ebx
		
		jmp l1

	exit:

	ret

;chamada para ler o valor 2
ler2:
	
	l2:
		mov eax, 3
		mov ebx, 0
		mov ecx, input
		mov edx, 1
		int 80h


		mov eax, [input]
		cmp eax, 10 ;ascII 10 = /n
		jz exit

		sub eax, '0'	
		mov ebx, [num2]
		imul ebx, 10
		add ebx, eax
		mov [num2], ebx
		
		jmp l2

	exit2:

	ret

;laco para realizar a impressao
laco:
	
	mov eax, [aux2]
	add eax, '0'
	mov [aux2], eax

	mov ecx, [num1]
	mov eax, '0'
	;iterando sobre a quantidade maxima
	l3:

		
		;imprimindo o valor 
		mov eax, 4
		mov ebx, 1
		push ecx
		mov ecx, aux2
		mov edx, 255
		int 0x80

		;imprimindo a virgula
		mov eax, 4
		mov ebx, 1
		mov ecx, comma
		mov edx, commaL
		int 0x80

		mov eax, [aux]
		sub eax, '0'
		inc eax
		add eax, '0'
		pop ecx

		;realizar a soma
		mov eax, [aux2]
		mov ebx, [num2]
		add eax, ebx
		mov [aux2], eax

		loop l3

	;quebra de linha
	mov eax, 4
	mov ebx, 1
	mov ecx, blank
	mov edx, blankL
	int 0x80

	ret
