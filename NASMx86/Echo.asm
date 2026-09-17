section .data
    inp     db "Input: ", 0
    outp    db "Output: ", 0
section .bss
    input   resb 33       ; buffer 33 byte

section .text
    global _start

_start:
    ; In "Input: "
    mov     eax, 4
    mov     ebx, 1
    mov     ecx, inp
    mov     edx, 7
    int     0x80

    ; Nhap tu ban phim
    mov     eax, 3
    mov     ebx, 0
    mov     ecx, input
    mov     edx, 33
    int     0x80

    ; Goi ham len
    push    input
    call    len

    ; In "Output: "
    mov     eax, 4
    mov     ebx, 1
    mov     ecx, outp
    mov     edx, 8
    int     0x80

    mov     eax, 4
    mov     ebx, 1
    mov     ecx, input
    mov     edx, edi
    int     0x80

    ; Ket thuc
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
        mov     eax, [ecx + edi]
        cmp     eax, 0
        je      endd
        inc     edi 
        jmp      check
    endd:
        pop     edx
        pop     ecx
        mov     esp, ebp
        pop     ebp
        ret     4


