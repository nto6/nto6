%include 'Functions.asm'
section .data
    So1    db "Nhap so thu 1: ", 0
    So2    db "Nhap so thu 2: ", 0
    KQ   db "Tong: ",0
    newline     db 10, 0

section .bss
    so1     resb 25
    so2     resb 25
    ketqua  resb 40
    len1    resd 1
    len2    resd 1
    lenKQ   resd 1

section .text
    global _start
_start:
    mov     eax, 4
    mov     ebx, 1
    mov     ecx, So1
    mov     edx, 15
    int     0x80
    
    mov     eax, 3
    mov     ebx, 0
    mov     ecx, so1
    mov     edx, 20
    int     0x80
    dec     eax
    mov     byte [so1 + eax], 0     ; thay \n bang null

    mov     eax, 4
    mov     ebx, 1
    mov     ecx, So2
    mov     edx, 15
    int     0x80
    
    mov     eax, 3
    mov     ebx, 0
    mov     ecx, so2
    mov     edx, 20
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

    mov     eax, 4
    mov     ebx, 1
    mov     ecx, KQ
    mov     edx, 6
    int     0x80

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

    mov     eax,1
    xor     ebx,ebx
    int     0x80
Cong2so:
    push    ebp
    mov     ebp, esp
    push    ebx
    push    esi
    push    edi
    push    ecx
    push    edx
    ; dao so1
    mov     ecx, so1         ;s1
    mov     edx, [len1]
    call    Daoxau

    ; dao so2
    mov     ecx, so2         ;s2
    mov     edx, [len2]
    call    Daoxau

    ; lay max(len1,len2)
    mov     eax, [len1]
    mov     ebx, [len2]
    cmp     eax, ebx
    jge     Cong1       ;len1 >= len2 -> cong binh thuong
    mov     eax, ebx     ;len1 < len2 -> len2 bang eax, lay do dai max
    Cong1:
        mov     ecx, eax     ; ecx = maxlen so chu can cong
        ; cong tung ky tu
        mov     esi, 0     ; chi so (i)
        mov     edi, ketqua          ;len ketqua
        mov     dl, 0     ; nho = 0
    addl:
        cmp     esi, ecx         ;neu i > lenmax => ket thuc
        jge     Congsocuoi     ; ket thuc vong lap
        ; Neu vuot len 1 => them 0
        cmp     esi, [len1]
        jge     Cong0vao1     ; neu i >= len1 -> so1 = 0
        mov     al, [so1 + esi]     ; al = so1[i]
        sub     al, '0'              ; chuyen sang so
        jmp     tieptuc
    Cong0vao1:
        mov     al, 0        ; so1 = 0
    tieptuc:
        mov     bl, al       ; bl = so1
        ;tiep tuc voi so2
        cmp     esi, [len2]
        jge     Cong0vao2
        mov     al, [so2 + esi]  ;al = so2[i]
        sub     al, '0'      ; chuyen sang so
        jmp     tieptuc2
    Cong0vao2:
        mov     al, 0
    tieptuc2:
        ; sum = so1 + so2 + nho
        add     al, bl      ;al = so1 + so2
        add     al, dl      ; cong so nho
        mov     dl, 0        ; nho ve 0
        cmp     al, 10
        jl      Khongnho
        sub     al, 10
        mov     dl, 1
    Khongnho:
        add     al,'0'      ; chuyen ve chuoi
        mov     [edi], al    ;luu vao ketqua[i]
        inc     edi         ; tang len ketqua
        inc     esi         ; i++
        jmp     addl
    Congsocuoi:
        cmp     dl,0        ;neu nho bang 0 thi thoi con bang 1 thi tiep tuc
        je      Ketthuc
        mov     byte [edi],'1'  ;cong them 1 o dau
        inc     edi
    Ketthuc:
        mov     eax, edi
        sub     eax, ketqua      ;EAX = So byte ghi vao ketqua(len)
        mov     [lenKQ], eax
        ; đảo ketqua
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
