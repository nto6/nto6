section .data
    So1        db "Nhap so thu 1: ", 0
    So2        db "Nhap so thu 2: ", 0
    KQ         db "Tong: ",0
    newline    db 10, 0
section .bss
    so1     resb 30
    so2     resb 30
    ketqua  resb 40
    len1    resd 1
    len2    resd 1
    lenKQ   resd 1
section .text
    global _start
_start:
    ; In "Nhap so thu 1:"
    mov     eax, 4
    mov     ebx, 1
    mov     ecx, So1
    mov     edx, 15
    int     0x80
    ; Nhap so1
    mov     eax, 3
    mov     ebx, 0
    mov     ecx, so1
    mov     edx, 30
    int     0x80
    dec     eax
    mov     byte [so1 + eax], 0     ; thay \n bang null
    ; In "Nhap so thu 2:"
    mov     eax, 4
    mov     ebx, 1
    mov     ecx, So2
    mov     edx, 15
    int     0x80
    ; Nhap so2
    mov     eax, 3
    mov     ebx, 0
    mov     ecx, so2
    mov     edx, 30
    int     0x80
    dec     eax
    mov     byte [so2 + eax], 0     ; thay \n bang null

    push    so1
    call    len
    mov     [len1], edi

    push    so2
    call    len
    mov     [len2], edi

    call    Cong2so
    ; In "Tong:"
    mov     eax, 4
    mov     ebx, 1
    mov     ecx, KQ
    mov     edx, 6
    int     0x80
    ; In ketqua
    mov     eax, 4
    mov     ebx, 1
    mov     ecx, ketqua
    mov     edx, [lenKQ]
    int     0x80

    mov     eax, 4
    mov     ebx, 1
    mov     ecx, newline
    mov     edx, 1
    int     0x80

    mov     eax, 1
    xor     ebx, ebx
    int     0x80
Cong2so:
    push    ebp
    mov     ebp, esp
    push    ebx
    push    esi
    push    edi
    push    ecx
    push    edx
    ; dao chuoi
    mov     ecx, so1
    mov     edx, [len1]
    call    Daoxau

    mov     ecx, so2
    mov     edx, [len2]
    call    Daoxau
    ; lay max(len1, len2)
    mov     eax, [len1]
    mov     ebx, [len2]
    cmp     eax, ebx
    jge     tieptuc1
    mov     eax, ebx
tieptuc1:
    mov     ecx, eax        ; maxlen
    mov     esi, 0          ; chi so i
    mov     edi, ketqua
    mov     dl, 0           ; nho
Cong_loop:
    cmp     esi, ecx
    jge     Congsocuoi
    ; lay so1
    cmp     esi, [len1]
    jge     so1zero
    mov     al, [so1 + esi]
    sub     al, '0'
    jmp     next1
so1zero:
    mov     al, 0
next1:
    mov     bl, al
    ; lay so2
    cmp     esi, [len2]
    jge     so2zero
    mov     al, [so2 + esi]
    sub     al, '0'
    jmp     next2
so2zero:
    mov     al, 0
next2:
    add     al, bl
    add     al, dl
    mov     dl, 0
    cmp     al, 10
    jl      No_carry
    sub     al, 10
    mov     dl, 1
No_carry:
    add     al, '0'
    mov     [edi], al
    inc     edi
    inc     esi
    jmp     Cong_loop
Congsocuoi:
    cmp     dl, 0
    je      Done
    mov     byte [edi], '1'
    inc     edi
Done:
    mov     eax, edi
    sub     eax, ketqua
    mov     [lenKQ], eax
    ; dao ketqua
    mov     ecx, ketqua
    mov     edx, [lenKQ]
    call    Daoxau
    pop     edx
    pop     ecx
    pop     edi
    pop     esi
    pop     ebx
    mov     esp, ebp
    pop     ebp
    ret
