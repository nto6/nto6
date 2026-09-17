section .data
    XauS   db "S = ", 0
    XauC   db "C = ", 0
    newline     db 10   ; ky tu xuong dong  
    space      db ' ', 0
section .bss
    ChuoiS  resb 100
    ChuoiC  resb 10
    lenS    resb 100
    lenC    resb 10
    Vitri    resb 100
    inso    resb 10         
    Biendem     resb 20     ;so phan tu
section .text
    global _start
_start:

    mov     eax, 4
    mov     ebx, 1
    mov     ecx, XauS
    mov     edx, 4
    int     0x80

    mov     eax, 3
    mov     ebx, 0
    mov     ecx, ChuoiS
    mov     edx, 100
    int     0x80

    mov     eax, 4
    mov     ebx, 1
    mov     ecx, XauC
    mov     edx, 4
    int     0x80

    mov     eax, 3
    mov     ebx, 0
    mov     ecx, ChuoiC
    mov     edx, 10
    int     0x80

    push    ChuoiS
    call    len
    mov     [lenS], eax

    push    ChuoiC
    call    len
    mov     [lenC], eax
    
    push    Vitri
    push    ChuoiC
    push    ChuoiS
    call    Timchuoi
    mov     [Biendem], eax        ;so lan xuat hien
    ;in so lan
    mov     eax, [Biendem]
    mov     edi, inso
    call    sosangchuoi

    mov     eax, 4
    mov     ebx, 1
    mov     ecx, inso
    mov     edx, 10
    int     0x80
    ;in xuong dong
    mov     eax, 4
    mov     ebx, 1
    mov     ecx, newline
    mov     edx, 1
    int     0x80

    call    Invitri

    mov     eax, 4
    mov     ebx, 1
    mov     ecx, newline
    mov     edx, 1
    int     0x80

    mov eax, 1
    xor ebx, ebx
    int 0x80
len: 
    push    ebp
    mov     ebp, esp
    mov     esi, [ebp + 8]
    mov     ecx, 0
    check:
        mov     al, [esi + ecx]
        cmp     al, 0
        je      endlen
        cmp     al, 10
        je      endlen
        inc     ecx 
        jmp     check
    endlen:
        mov     eax, ecx
        mov     esp, ebp
        pop     ebp
        ret     4

Timchuoi:
    push    ebp
    mov     ebp, esp
    push    esi
    push    edi
    push    edx
    push    ecx
    push    ebx
    mov     esi, [ebp + 8]          ; S
    mov     edi, [ebp + 12]         ; C
    mov     edx, [ebp + 16]         ; buffer mang vi tri 

    mov     eax, 0          ;dem
    mov     ebx, 0          ;chi so trong S
    ;gioi han = lenS - lenC
    mov     ecx, [lenS]
    sub     ecx, [lenC]
    js      endl          ;nhay neu lenS < lenC

    checkl:
        push    ecx
        push    esi
        push    edi
        ;so sanh S+i va C
        mov     esi, [ebp + 8]
        add     esi, ebx        ; bat dau so sanh = S + ebx
        mov     edi, [ebp + 12]
        mov     ecx, [lenC]
        repe    cmpsb      ;so sanh 1 byte tai dia chi tro cua esi va edi

        pop     edi
        pop     esi
        pop     ecx

        jne     Nhay
        mov     [edx], ebx  ;luu vi tri xh trong mang
        add     edx, 4      ;dich sang o ke tiep (1 o 4 byte)
        inc     eax

    Nhay:
        inc     ebx
        mov     ecx, [lenS]
        sub     ecx, [lenC]
        cmp     ebx, ecx   
        jle     checkl

    endl:
        pop     ebx
        pop     ecx
        pop     edx
        pop     edi
        pop     esi
        mov     esp, ebp
        pop     ebp
        ret     12
Invitri:
    mov     ecx, 0         ; ecx la chi so vong lap 
    invitri:
        cmp     ecx, [Biendem]
        jge     enddd             ; neu ecx >= Biendem thi end

        ; lay Vitri[ecx]
        mov     eax, [Vitri + ecx*4]    ; doc  vitri[ecx] vao eax (nhan ecx voi 4 vi moi phan tu la 4 byte)
        push    ecx
        mov     edi, inso
        call    sosangchuoi
        pop     ecx

        ; in so
        push    ecx
        mov     eax, 4
        mov     ebx, 1
        mov     ecx, inso
        mov     edx, 10           
        int     0x80
        pop     ecx

        ; in space neu chua phai phan tu cuoi
        inc     ecx
        cmp     ecx, [Biendem]
        jge     Dongmoi
        push    ecx
        mov     eax, 4
        mov     ebx, 1
        mov     ecx, space        ; space db ' ',0
        mov     edx, 1
        int     0x80
        pop     ecx
        jmp     invitri

    Dongmoi:
        ; in xuong dong sau khi in het
        mov     eax, 4
        mov     ebx, 1
        mov     ecx, newline
        mov     edx, 1
        int     0x80
    enddd:
        ret
sosangchuoi:
    push    ebp
    mov     ebp, esp
    mov     esi, edi      ; buffer
    mov     ecx, 0
    mov     ebx, 10
    cmp     eax, 0
    jne     kiemtra
    ; Neu so la 0, ghi '0' vao buffer và ket thuc chuoi
    mov     byte [esi], '0'
    mov     byte [esi + 1], 0
    jmp     endd

    kiemtra:
        mov     edx, 0           ;don so du 
        div     ebx              ; eax / 10 , du trong edx
        add     dl, '0'          ; chuyen sang ky tu
        push    dx               ; day ky tu vao stack
        inc     ecx
        test    eax, eax
        jnz     kiemtra
        mov     edi, 0
    ; ghi ket qua
    Ketqua:
        pop     dx              
        mov     [esi + edi], dl
        inc     edi
        loop    Ketqua
        mov     byte [esi + edi], 0   ;ket thuc chuoi
    endd:
        mov     esp, ebp
        pop     ebp
        ret     



