section .data
    inp     db "Input: ", 0
    outp    db "Output: ", 0  
    newline db 10   ; ky tu xuong dong
section .bss
    input   resb  256
section .text
    global _start
_start:
    
    mov     eax, 4
    mov     ebx, 1
    mov     ecx, inp
    mov     edx, 8
    int     0x80

    mov     eax, 3
    mov     ebx, 0
    mov     ecx, input
    mov     edx, 256
    int     0x80

    push    input
    call    len
    mov     esi, eax

    push    esi 
    push    input
    call    Daoxau
    ;hien thi output
    mov     eax, 4
    mov     ebx, 1
    mov     ecx, outp
    mov     edx, 9
    int     0x80
    ;in ket qua
    mov     eax, 4
    mov     ebx, 1
    mov     ecx, input
    mov     edx, esi
    int     0x80
    ;ky tu xuong dong
    mov     eax, 4
    mov     ebx, 1
    mov     ecx, newline
    mov     edx, 1
    int     0x80

    mov     eax, 1
    xor     ebx, ebx
    int     0x80

len: 
    push    ebp
    mov     ebp, esp
    push    ecx
    push    edx
    mov     ecx, [ebp + 8]
    mov     edi, 0
    check:
        mov     al, [ecx + edi]
        cmp     al, 10
        je      enddd
        inc     edi 
        jmp     check
    enddd:
        mov     eax, edi
        pop     edx
        pop     ecx
        mov     esp, ebp
        pop     ebp
        ret     4
Daoxau:
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



    
