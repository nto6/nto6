section .data
    spp db " "   ; ky tu xuong dong
section .bss
    input   resb 15
    temp    resb 50 
    outputt resb 256
section .text
    global _start
_start:
    mov     eax, 3
    mov     ebx, 0
    mov     ecx, input
    mov     edx, 256
    int     0x80

    push    input
    call    process

    mov     eax, 1
    xor     ebx, ebx
    int     0x80

process:
    push    ebp
    mov     ebp, esp
    pushad
    mov     ebx, [ebp + 0x8]
    xor     ecx, ecx
    xor     esi, esi
    xor     edi, edi 

    check:
        xor     edx, edx
        mov     dl, [ebx + ecx]
        cmp     dl, 0x0
        jz      printf
        cmp     dl, 0xa
        jz      pushdata
        cmp     dl, ' '
        jz      pushdata
        mov     [temp + esi], dl 
        inc     ecx
        inc     esi
        jmp     check
    
    pushdata:
        mov     eax, [temp]
        push    eax
        inc     edi
        inc     ecx
        xor     esi, esi
        jmp     check
    
    printf:
        cmp     edi, 0
        jz      endd
        pop     ecx
        mov     [temp], ecx
        mov     eax, 4
        mov     ebx, 1
        mov     ecx, temp
        mov     edx, 6
        int     0x80
        sub     edi, 1

        mov     eax, 4
        mov     ebx, 1
        mov     ecx, spp
        mov     edx, 1
        int     0x80

        jmp     printf

    endd:
        popad
        mov     esp, ebp
        pop     ebp
        ret     4