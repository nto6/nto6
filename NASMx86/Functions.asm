len: 
    push    ebp
    mov     ebp, esp
    push    ecx
    mov     ecx, [ebp + 8]
    mov     edi, 0
    check:
        mov     eax, [ecx + edi]
        cmp     eax, 0
        je      enddd
        inc     edi 
        jmp      check
    enddd:
        pop     ecx
        mov     esp, ebp
        pop     ebp
        ret     4
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
        mov     esp, ebp
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
        mov     eax, ecx    ; tra lai len
    endd:
        mov     esp, ebp
        pop     ebp
        ret     8
Daoxau:
    push     eax
    push     ebx
    push     ecx
    push     edx
    mov     esi, ecx
    mov     edi, ecx
    add     edi, edx
    dec     edi
    Dao:
        cmp     esi, edi
        jge     endDao
        mov     al, [esi]
        mov     bl, [edi]
        mov     [esi], bl
        mov     [edi], al
        inc     esi
        dec     edi
        jmp     Dao
    endDao:
        pop     edx
        pop     ecx
        pop     ebx
        pop     eax
        ret
