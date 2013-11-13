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
	counter resb 255
	io resb 1 ;input / output

section .text
		
	call mensagem
	call ler
	mov eax, [aux]
	mov [num1], eax

	call mensagem
	call ler
	mov eax, [aux]
	mov [num2], eax

	call laco

	mov eax, 4
	mov ebx, 1
	mov ecx, blank
	mov edx, blankL
	int 0x80


	mov eax, 1
	int 0x80

mensagem:
	mov eax, 4
	mov ebx, 1
	mov ecx, msg
	mov edx, len
	int 0x80

	ret
; chamada para ler os valores
ler:
	mov eax, 0
	mov [aux], eax
	l1:
		mov eax, 3
		mov ebx, 0
		mov ecx, io
		mov edx, 1
		int 80h


		mov eax, [io]
		cmp eax, 10 ;ascII 10 = /n
		jz exit

		sub eax, '0'
		mov ebx, [aux]
		imul ebx, 10
		add ebx, eax
		mov [aux], ebx
		
		jmp l1

	exit:

	ret

;laco para realizar a impressao
laco:
	;limpando a variável aux
	mov ebx, 0
	mov [aux], ebx

	;inicializando o contador
	mov eax, 0
	mov [counter], eax
	mov eax, [counter]

	mov ebx, [num1] ; limitante do laço

	cmp eax, ebx
	jg lacoexit
	beginning:
		inc eax

		mov [counter], eax

		;rotina para imprimir o valor que esta em aux
		call imprimindo

		;guardando valores para serem somados
		mov eax, [num2]
		mov ebx, [aux]
		
		;incremetando em aux
		add ebx, eax
		mov [aux], ebx
		
		mov eax, [counter]
		mov ebx, [num1]

		;condição para virgula
		cmp eax, ebx
		je lacoexit
		
		mov eax, 4
		mov ebx, 1
		mov ecx, comma
		mov edx, commaL
		int 80h


		;realizando o check do laço
		mov eax, [counter]
		mov ebx, [num1]
		cmp eax, ebx
		jl beginning

	lacoexit:

	ret

imprimindo:
	mov eax, [aux]
	mov esi, 0

	convert:
		mov ecx, 10		;divisor
		mov edx, 0 		;resto
		idiv ecx
		push edx		;acrescenta o resto na pilha
		inc esi			;incrementa o contador
		cmp eax, 0		;verificar se o resto da div é zero
		jg convert

	impr:
		mov eax, 0 		;limpando a variável
		pop eax			;dando pop na pilha
		add eax, '0'	;convertendo o caractere

		mov [io], eax
		
		mov eax, 4		;impressão do char
		mov ebx, 1
		mov ecx, io
		mov edx, 1
		int 80h

		dec esi
		cmp esi, 0
		jne	impr

	ret	
