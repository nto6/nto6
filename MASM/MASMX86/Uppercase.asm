.386									
.model flat, stdcall
option casemap: none

include D:\masm32\include\masm32.inc
include D:\masm32\include\kernel32.inc
includelib D:\masm32\lib\masm32.lib
includelib D:\masm32\lib\kernel32.lib

.data
	Nhapchuoi	db "Nhap chuoi: ", 0
.data?
	chuoi		db 32 dup(?)
.code	
main PROC
	push	offset Nhapchuoi
	call	StdOut

	push	32
	push	offset chuoi
	call	StdIn				;nhap chuoi

	push	offset chuoi		
	call	len

	push	edi					;len
	push	offset chuoi
	call	Inhoa

	push	offset chuoi
	call	StdOut
	push 0                                      
    call ExitProcess                            
main ENDP    
len PROC
	push    ebp
    mov     ebp, esp
    push    ecx
    mov     ecx, [ebp + 8]
    mov     edi, 0
    check:
        mov     eax, [ecx + edi]
        cmp     eax, 0
        je      enddd
        inc     edi 
        jmp     check
    enddd:
        pop     ecx
        mov     esp, ebp
        pop     ebp
        ret     4
len ENDP
Inhoa PROC
	push	ebp
	mov		ebp, esp
	push    eax
    push    ecx
    push    edx

	mov		ecx, [ebp + 8]			;chuoi
	mov		edx, [ebp + 12]			;len
	mov		eax, 0
	Kiemtra:
		cmp		eax, edx			;check len
		jge		endd

		mov		bl, [ecx + eax]
		cmp     bl, 'a'
        jl      nhay
        cmp     bl, 'z'
        jg      nhay

		sub		bl, 32
		mov		[ecx + eax], bl
	nhay:	
		inc		eax			;i++
		jmp		Kiemtra
	endd:
		pop     edx
        pop     ecx
        pop     eax
		mov     esp, ebp
        pop     ebp
        ret     8
Inhoa ENDP
END main         