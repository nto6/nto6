.386									
.model flat, stdcall
option casemap: none

include D:\masm32\include\masm32.inc
include D:\masm32\include\kernel32.inc
includelib D:\masm32\lib\masm32.lib
includelib D:\masm32\lib\kernel32.lib

.data
	So1     db "Nhap so 1: ", 0
	So2	    db "Nhap so 2: ", 0
    Tong    db "Tong: ", 0
.data?
	S1		db 32 dup(?)
	S2		db 32 dup(?)
    tong    db 32 dup(?)
.code	
main PROC
	push	offset So1
	call	StdOut
    push    11
	push	offset S1
	call	StdIn

	push	offset So2
	call	StdOut
    push    11
	push	offset S2
	call	StdIn

    push    offset S1
    call    chuoisangso
    mov     edi, eax

    push    offset S2
    call    chuoisangso
    add     eax, edi

    push    eax
    push    offset tong
    call    sosangchuoi

    push    offset Tong 
    call    StdOut
    push    offset tong
    call    StdOut
    push    0                                      
    call    ExitProcess
main ENDP
chuoisangso PROC
    push    ebp
    mov     ebp, esp
    mov     esi, [ebp + 8]
    mov     eax, 0  ;Tong
    kiemtra:
        mov     ebx, 0
        mov     bl, [esi]
        cmp     bl, 10      ; neu gap '\n' thi ket thuc
        je      endl
        cmp     bl, 0       ;neu la null => ket thuc
        je      endl

        cmp     bl, '0'
        jb      endl
        cmp     bl, '9'
        ja      endl

        sub     bl, '0'     ;chuyen chuoi ve so
        imul    eax, 10
        add     eax, ebx
        
        inc     esi
        jmp     kiemtra

    endl:
        pop     ebp
        ret     4
chuoisangso ENDP
sosangchuoi PROC
    push    ebp
    mov     ebp, esp
    mov     edi, [ebp + 8]      ; buffer
    mov     eax, [ebp + 12]     ; So can chuyen
    mov     ecx, 0
    mov     ebx, 10
    
    cmp     eax, 0
    jne     nhay
    ; Neu so la 0, ghi '0' vao buffer và ket thuc chuoi
    mov     byte ptr [edi], '0' ;thao tac 1 byt tai edi+1
    mov     byte ptr [edi + 1], 0
    jmp     endd

    nhay: 
    Kiemtra:
        mov     edx, 0           ;don so du 
        div     ebx              ; eax / 10 , du trong edx
        add     dl, '0'          ; chuyen sang ky tu
        push    dx               ; day ky tu vao stack
        inc     ecx
        test    eax, eax
        jnz     Kiemtra

    ; ghi ket qua
    Ketqua:
        pop     dx  
        mov     [edi], dl
        inc     edi
        loop    Ketqua
    endd:
        mov     esp, ebp
        pop     ebp
        ret     8
sosangchuoi ENDP
END main