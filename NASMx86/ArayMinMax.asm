%include 'Functions.asm'
section .data
    Sophantu    db "Nhap n: ",0
    Nhapmang    db "Nhap mang: ",0
    MAX     db "Max: ", 0
    MIN     db "Min: ", 0
    newline     db 10, 0

section .bss
    n       resd 1                ;so phan tu
    arr     resd 100            ;mang arr luu cac so
    buffer  resb 256         ;doc input
    Max     resb 100
    Min     resb 100
section .text
    global _start
_start:
    ; In "Nhap n: "
    mov     eax, 4
    mov     ebx, 1
    mov     ecx, Sophantu
    mov     edx, 8
    int     0x80
    ; Nhap n
    mov     eax, 3
    mov     ebx, 0
    mov     ecx, buffer
    mov     edx, 10
    int     0x80
    mov     eax, 0              ;don eax
    mov     al, [buffer]       ;lay ky tu dau tien tu buffet vao eax
    sub     eax, '0'                 ;chuyen ve so
    mov     [n], eax

    mov     eax, 4
    mov     ebx, 1
    mov     ecx, Nhapmang
    mov     edx, 11
    int     0x80
    ; Bat dau doc tung lan cho den khi du n
    xor edi, edi         ; edi = so phan tu da doc, (i)
Docso:
    cmp     edi, [n]     ;neu edi >= sophantu -> end
    jge     endDocso
    ; nhap so vao buffer
    mov     eax, 3
    mov     ebx, 0
    mov     ecx, buffer
    mov     edx, 256
    int     0x80
    ; eax = so byte thuc su doc
    mov     byte [buffer + eax], 0   ; them ky tu ket thuc chuoi
    mov     esi, buffer            ; đặt esi = buffer
    ; kiem tra buffer -> cac so
    xor     ebx, ebx        
    mov     edx, 0          ;check so hop le
    Kiemtraso:
        mov     al, [esi]        ;ki tu hien tai
        cmp     al, 0
        je      endKiemtra
        cmp     al, 10
        je      Socuoi      ;neu newlile -> ket thu 1 so
        cmp     al, ' '
        je      Socuoi     ;neu space -> ket thuc 1 so
        ; kiem tra co phai so khong
        cmp     al, '0'
        jb      Nhay
        cmp     al, '9'
        ja      Nhay
        sub     al, '0'      ; chuyen sang so
        mov     ecx, 0       ; don ecx
        mov     cl, al      ; ecx la so dau tien
        imul    ebx, 10  
        add     ebx, ecx     ;cong ecx vao ebx
        mov     edx, 1       ;so hop le
        jmp     Tiep  
    Socuoi:
        cmp     edx, 0            ;xem co phai so khong ,neu ko thi khong luu
        je      Vietlaiso        ;neu nhap nhieu space -> so moi chua cap nhap
        mov     [arr + edi*4], ebx     ; luu ebx vao mang arr[edi]
        inc     edi                  ; tang so phan tu
    Vietlaiso:
        xor     ebx, ebx         ; reset bat dau so moi
        mov     edx, 0           ; chua co so moi
        cmp     edi, [n]
        jge     endKiemtra     ;neu du n phan tu -> end
    Nhay:
    Tiep:
        inc     esi             ;sang ky tu tiep theo trong buffer
        jmp     Kiemtraso
    endKiemtra:
        cmp     edx, 0
        je      Tieptuc    ;kiem tra xem con so khong
        mov     [arr + edi*4], ebx     ;neu buffer ket thuc maf van dang xay dung so -> luu so cuoi cung
        inc     edi
        mov     edx, 0
    Tieptuc:
        cmp     edi, [n]
        jl      Docso     ;neu van chua du n phan tu -> tiep tuc
endDocso:
    push    dword [n]       ;so phan tu
    push    arr         ; mang
    call    maxmin 

    ; In "Max: "
    mov     eax, 4
    mov     ebx, 1
    mov     ecx, MAX
    mov     edx, 5
    int     0x80

    mov     eax, [Max]    ;so can chuyen 
    push    eax   
    push    Max     ;buffer 
    call    sosangchuoi 

    ;in max
    mov     eax, 4
    mov     ebx, 1
    mov     ecx, Max
    mov     edx, 100
    int     0x80

    mov     eax, 4  
    mov     ebx, 1
    mov     ecx, newline
    mov     edx, 1
    int     0x80
    ; In "Min: "
    mov     eax, 4
    mov     ebx, 1
    mov     ecx, MIN
    mov     edx, 5
    int     0x80

    mov     eax, [Min] 
    push    eax  ;so can chuyen 
    push    Min     ;buffer 
    call    sosangchuoi
 
    ;in min
    mov     eax, 4
    mov     ebx, 1
    mov     ecx, Min
    mov     edx, 100
    int     0x80

    mov     eax, 4  
    mov     ebx, 1
    mov     ecx, newline
    mov     edx, 1
    int     0x80
    ; Thoat
    mov     eax, 1
    xor     ebx, ebx
    int     0x80
maxmin:
    push    ebp
    mov     ebp,esp

    mov     esi, [ebp+8]    ;  mang arr
    mov     ecx, [ebp+12]   ; so phan tu

    mov     eax, [esi]      ; lay arr[0]
    mov     ebx, eax        ; ebx = max
    mov     edx, eax        ; edx = min

    mov     edi, 1          ; bat dau tu arr[1]
    Timmaxmin:
        cmp     edi, ecx   
        jge     endTim           ; neu edi >= n thi ket thuc
        mov     eax, [esi + edi*4] ; lay arr[i]
        cmp     eax, ebx
        jle     checkmin      ;neu nho hon -> thay min
        mov     ebx, eax        ;neu lon hon -> thay max

    checkmin:
        cmp     eax, edx        ;neu lon hon thi giu nguyen min 
        jge     tiep
        mov     edx, eax        ; cap nhap min

    tiep:
        inc     edi
        jmp     Timmaxmin

    endTim:
        mov     [Max], ebx
        mov     [Min], edx

        mov     esp, ebp
        pop     ebp
        ret     8