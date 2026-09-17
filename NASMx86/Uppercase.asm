%include "Functions.asm"

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
    ; Goi ham inhoa
    push    edi         ; do dai
    push    input
    call    inhoa

    ; In "Output: "
    mov     eax, 4
    mov     ebx, 1
    mov     ecx, outp
    mov     edx, 8
    int     0x80

    ; In chuoi in hoa
    mov     eax, 4
    mov     ebx, 1
    mov     ecx, input
    mov     edx, edi
    int     0x80

    ; Ket thuc
    mov     eax, 1
    xor     ebx, ebx
    int     0x80
inhoa:
    push    ebp
    mov     ebp, esp
    push    eax
    push    ecx
    push    edx

    mov     ecx, [ebp + 8]    ; ecx = buffer
    mov     edx, [ebp + 12]   ; edx = length
    mov     eax, 0    

    kiemtra:
        cmp     eax, edx
        jge     endd

        mov     bl, [ecx + eax]
        cmp     bl, 'a'
        jl      nhay
        cmp     bl, 'z'
        jg      nhay

        sub     bl, 32
        mov     [ecx + eax], bl

    nhay:
        inc     eax
        jmp     kiemtra

    endd:
        pop     edx
        pop     ecx
        pop     eax
        mov     esp, ebp
        pop     ebp
        ret     8
