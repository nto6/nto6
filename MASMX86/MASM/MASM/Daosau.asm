.386									
.model flat, stdcall
option casemap: none

include D:\masm32\include\masm32.inc
include D:\masm32\include\kernel32.inc
includelib D:\masm32\lib\masm32.lib
includelib D:\masm32\lib\kernel32.lib

.data
	inp     db "Input: ", 0
    outp    db "Output: ", 0
.data?
	input		db 256 dup(?)
.code	
main PROC
	push	offset inp
	call	StdOut
    push    256
	push	offset input
	call	StdIn

    push    offset input
    call    len
    mov     esi, eax

    push    esi
    push    offset input
    call    Daoxau


    push	offset outp
	call	StdOut
    push    offset input
    call    StdOut

    push 0                                      
    call ExitProcess
main ENDP
len PROC
	push    ebp
    mov     ebp, esp
    mov     ecx, [ebp + 8]
    mov     eax, 0
    check:
        mov     dl, [ecx + eax]
        cmp     dl, 0
        je      enddd
        inc     eax
        jmp     check
    enddd:
        mov     esp, ebp
        pop     ebp
        ret     4
len ENDP
Daoxau PROC
    push    ebp
    mov     ebp, esp
    push    edi 
    push    esi
    mov     ecx, [ebp + 8]  ;input
    mov     edx, [ebp + 12]  ;do dai
    mov     esi, 0      ;tro tu dau
    dec     edx         ;dodai - 1
    mov     edi, edx

    checkl:
        cmp     esi, edi 
        jge     endd 
        
        mov     al, [ecx + esi]     ;ki tu dau
        mov     bl, [ecx + edi]     ;ky tu cuoi
        mov     [ecx + esi], bl     ;doi cho
        mov     [ecx + edi], al 

        inc     esi
        dec     edi 
        jmp     checkl
    endd:
        pop     esi
        pop     edi
        mov     esp, ebp
        pop     ebp
        ret     8
Daoxau ENDP
END main