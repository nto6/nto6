section .data
    So1     db "Nhap so dau: ", 0
    So2     db "Nhap so cuoi: ", 0
    Tong    db "Tong: ", 0
    newline db 10   ; ky tu xuong dong
section .bss
    Sot1    resb 8
    Sot2    resb 8
    Tong2so     resb 9
section .text
    global _start

_start:
    ;in Nhap so dau
    mov     eax, 4
    mov     ebx, 1
    mov     ecx, So1
    mov     edx, 14
    int     0x80

    mov     eax, 3
    mov     ebx, 0
    mov     ecx, Sot1
    mov     edx, 8
    int     0x80

    mov     eax, 4
    mov     ebx, 1
    mov     ecx, So2
    mov     edx, 15
    int     0x80

    mov     eax, 3
    mov     ebx, 0
    mov     ecx, Sot2
    mov     edx, 8
    int     0x80

    push    Sot1
    call    chuoisangso
    mov     edi, eax

    push    Sot2
    call    chuoisangso
    add     eax, edi

    push    eax
    push    Tong2so
    call    sosangchuoi

    ; in "Tong: "
    mov     eax, 4
    mov     ebx, 1
    mov     ecx, Tong
    mov     edx, 6
    int     0x80

    ; in kết quả
    mov     eax, 4
    mov     ebx, 1
    mov     ecx, Tong2so
    mov     edx, 16
    int     0x80

    ;ky tu xuong dong
    mov     eax, 4
    mov     ebx, 1
    mov     ecx, newline
    mov     edx, 1
    int     0x80
    ; thoat
    mov     eax, 1
    xor     ebx, ebx
    int     0x80


chuoisangso:
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
sosangchuoi:
    push    ebp
    mov     ebp, esp
    mov     edi, [ebp + 8]      ; buffer
    mov     eax, [ebp + 12]     ; So can chuyen
    mov     ecx, 0
    mov     ebx, 10
    
    cmp     eax, 0
    jne     nhay
    ; Neu so la 0, ghi '0' vao buffer và ket thuc chuoi
    mov     byte [edi], '0'
    mov     byte [edi + 1], 0
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
