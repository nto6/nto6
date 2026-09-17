.386									
.model flat, stdcall
option casemap: none

include D:\masm32\include\masm32.inc
include D:\masm32\include\kernel32.inc
includelib D:\masm32\lib\masm32.lib
includelib D:\masm32\lib\kernel32.lib

.data
    NhapN     db "Nhap n: ", 0
    NhapMang  db "Nhap mang: ", 0
    MAX       db "Max: ", 0
    MIN       db "Min: ", 0
    newline      db 13, 10, 0
    space        db " ", 0

.data?
    n            dd ?                   ; so phan tu (32-bit)
    arr          dd 100 dup(?)          ; mang arr luu cac so (32-bit)
    buffer       db 256 dup(?)          ; doc input
    MaxBuf    db 12 dup(0)           ; buffer chuyen so -> chuoi (Max)
    MinBuf    db 12 dup(0)           ; buffer chuyen so -> chuoi (Min)
    Max       dd ?                   ; luu gia tri Max (32-bit)
    Min       dd ?                   ; luu gia tri Min (32-bit)
.code
main PROC
    ; In "Nhap n: "
    push    offset NhapN
    call    StdOut
    push    10
    push    offset buffer
    call    StdIn
    ; Chuyen ky tu dau tien trong buffer -> so (chi dung so 0..9 doi voi n)
    mov     eax, 0
    mov     al, [buffer]
    sub     eax, '0'
    mov     [n], eax
    ; In "Nhap mang: "
    push    offset NhapMang
    call    StdOut
    ; Bat dau doc tung lan cho den khi du n
    xor     edi, edi         ; edi = so phan tu da doc (index)
Docso:
    cmp     edi, [n]         ; neu edi >= n -> end
    jge     endDocso

    ; nhap 1 dong vao buffer
    push    10
    push    offset buffer
    call    StdIn

    ; eax = so byte thuc su doc (StdIn tra ve so byte in EAX)
    mov     byte ptr [buffer + eax], 0   ; them ky tu ket thuc chuoi

    mov     esi, offset buffer          ; dat esi = buffer
    xor     ebx, ebx                    ; ebx luu gia tri dang build (so hien tai)
    mov     edx, 0                      ; edx = flag: co ky tu so hay khong

Kiemtraso:
    mov     al, [esi]
    cmp     al, 0
    je      endKiemtra
    cmp     al, 13      ; CR
    je      Socuoi
    cmp     al, 10
    je      Socuoi
    cmp     al, ' '
    je      Socuoi

    ; kiem tra co phai so khong
    cmp     al, '0'
    jb      Nhay
    cmp     al, '9'
    ja      Nhay

    sub     al, '0'      ; chuyen sang so (0..9)
    mov     ecx, 0
    mov     cl, al       ; ecx = digit
    imul    ebx, 10      ; ebx = ebx * 10
    add     ebx, ecx     ; ebx += digit
    mov     edx, 1       ; danh dau la co so
    jmp     Tiep
Socuoi:
    cmp     edx, 0
    je      Vietlaiso    ; neu khong co so dang build thi bo qua
    mov     [arr + edi*4], ebx     ; luu ebx vao arr[edi]
    inc     edi
Vietlaiso:
    xor     ebx, ebx
    mov     edx, 0
    cmp     edi, [n]
    jge     endKiemtra
    jmp     Tiep

Nhay:
Tiep:
    inc     esi
    jmp     Kiemtraso

endKiemtra:
    cmp     edx, 0
    je      Tieptuc
    mov     [arr + edi*4], ebx
    inc     edi
    mov     edx, 0

Tieptuc:
    cmp     edi, [n]
    jl      Docso
endDocso:
    ; Goi ham tinh max, min: tham so (arr, n)
    push    dword ptr [n]
    push    offset arr
    call    maxmin

    ; In "Max: "
    push    offset MAX
    call    StdOut

    ; Chuyen Max -> chuoi, hien thi
    mov     eax, [Max]         ; so can chuyen
    push    eax
    push    offset MaxBuf
    call    sosangchuoi

    push    offset MaxBuf
    call    StdOut

    push    offset newline
    call    StdOut

    ; In "Min: "
    push    offset MIN
    call    StdOut

    mov     eax, [Min]
    push    eax
    push    offset MinBuf
    call    sosangchuoi

    push    offset MinBuf
    call    StdOut

    push    offset newline
    call    StdOut

    push    0
    call    ExitProcess
main ENDP
sosangchuoi PROC
    push    ebp
    mov     ebp, esp
    mov     edi, [ebp + 8]      ; buffer
    mov     eax, [ebp + 12]     ; So can chuyen
    mov     ecx, 0
    mov     ebx, 10
    
    cmp     eax, 0
    jne     nhay
    ; Neu so la 0, ghi '0' vao buffer và ket thuc chuoi
    mov     byte ptr [edi], '0' ;thao tac 1 byt tai edi+1
    mov     byte ptr [edi + 1], 0
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
sosangchuoi ENDP
maxmin PROC
    push    ebp
    mov     ebp, esp
    mov     esi, [ebp + 8]    ; dia chi mang arr
    mov     ecx, [ebp + 12]   ; so phan tu
    ; neu n <= 0 thi thiet lap 0
    cmp     ecx, 1
    jl      KhongN

    mov     eax, [esi]        ; arr[0]
    mov     ebx, eax          ; max
    mov     edx, eax          ; min

    mov     edi, 1
Timmaxmin:
    cmp     edi, ecx
    jge     endTim
    mov     eax, [esi + edi*4] ; lay arr[edi]
    cmp     eax, ebx
    jle     checkmin
    mov     ebx, eax
checkmin:
    cmp     eax, edx
    jge     tiepl
    mov     edx, eax
tiepl:
    inc     edi
    jmp     Timmaxmin

endTim:
    mov     [Max], ebx
    mov     [Min], edx
    jmp     enddl

KhongN:
    ; neu mang rong, dat Max = 0, Min = 0 (hoac khac tu y)
    mov     dword ptr [Max], 0
    mov     dword ptr [Min], 0

enddl:
    mov     esp, ebp
    pop     ebp
    ret     8
maxmin ENDP

END main
