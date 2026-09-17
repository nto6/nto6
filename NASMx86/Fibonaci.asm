%include 'Functions.asm'
section .data
    SoN     db  "Nhap so N: ", 0
    newline db 10
section .bss
    N       resd 1          ; so phan tu N 
    input   resb 100    ; buffer tam cho input N
    so1     resb 256        ; F(n-1) 
    so2     resb 256        ; F(n-2) 
    ketqua  resb 512        ; ket qua
    len1    resd 1
    len2    resd 1
    lenKQ   resd 1
section .text
    global _start
_start:
    mov     eax, 4
    mov     ebx, 1
    mov     ecx, SoN
    mov     edx, 11
    int     0x80

    mov     eax, 3
    mov     ebx, 0
    mov     ecx, input
    mov     edx, 100
    int     0x80
    ;input -> EAX (number)
    push    input
    call    chuoisangso
    mov     [N], eax

    call    Fibonl

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
        mov     edx, 0     ; nho = 0
    addl:
        cmp     esi, ecx         ;neu i >= lenmax => ket thuc
        jge     Congsocuoi     ; ket thuc vong lap
        ; Neu lon hon len 1 => them 0
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
        ; lenKQ = edi - ketqua
        mov     eax, edi
        sub     eax, ketqua      ;EAX = So byte ghi vao ketqua(len)
        mov     [lenKQ], eax
        ; đảo ketqua
        mov     ecx, ketqua
        mov     edx, [lenKQ]
        call    Daoxau
        ;tra ve so1
        mov     ecx, so1
        mov     edx, [len1]
        call    Daoxau
        ;tra ve so 2
        mov     ecx, so2
        mov     edx, [len2]
        call    Daoxau
        pop     edx
        pop     ecx
        pop     edi
        pop     esi
        pop     ebx
        mov     esp, ebp
        pop     ebp
        ret
Fibonl:
    push    ebp
    mov     ebp, esp
    push    esi
    push    edi
    push    ebx
    mov     eax, [N]        ; N nhap vao
    cmp     eax, 0
    jl      enddFibo       ; neu N < 0 -> end
    ; Khoi tao: F(0) = 0, F(1) = 1
    mov     byte [so2], '0'
    mov     dword [len2], 1
    mov     byte [so1], '1'
    mov     dword [len1], 1
    ;luon in F(0)
    mov     eax, 4
    mov     ebx, 1
    mov     ecx, so2
    mov     edx, [len2]
    int     0x80

    mov     eax, 4
    mov     ebx, 1
    mov     ecx, newline
    mov     edx, 1
    int     0x80

    ; neu N = 0 -> end 
    mov     eax, [N]
    cmp     eax, 0
    je      enddFibo
    ; in F(1)
    mov     eax, 4
    mov     ebx, 1
    mov     ecx, so1
    mov     edx, [len1]
    int     0x80
    ; newline
    mov     eax, 4
    mov     ebx, 1
    mov     ecx, newline
    mov     edx, 1
    int     0x80
    ; neu N = 1 -> end
    mov     eax, [N]
    cmp     eax, 1
    je      enddFibo
    ; tiep tuc tu i = 2 toi i = N 
    mov     esi, 2          ; i = 2
    CheckFibo:
        mov     eax, [N]
        cmp     esi, eax
        jg      enddFibo       ; neu i > N -> end
        ; ketqua = so1 + so2
        call    Cong2so
        ; in ketqua
        mov     eax, 4
        mov     ebx, 1
        mov     ecx, ketqua
        mov     edx, [lenKQ]
        int     0x80
        ; newline
        mov     eax, 4
        mov     ebx, 1
        mov     ecx, newline
        mov     edx, 1
        int     0x80
        ;chuyen f(n-1) -> f(n-2)
        mov     edi, 0
        copyso1sangso2:
            mov     eax, [len1]
            cmp     edi, eax
            jge     endcopy1
            mov     al, [so1 + edi]
            mov     [so2 + edi], al
            inc     edi
            jmp     copyso1sangso2
        endcopy1:
            mov     eax, [len1]
            mov     [len2], eax
        ;chuyen f(n) -> f(n - 1)
        mov     edi, 0
        copykqsangso1:
            mov     eax, [lenKQ]
            cmp     edi, eax
            jge     endcopy2
            mov     al, [ketqua + edi]
            mov     [so1 + edi], al
            inc     edi
            jmp     copykqsangso1
        endcopy2:
            mov     eax, [lenKQ]
            mov     [len1], eax
            ; tang i
            inc     esi
            jmp     CheckFibo
    enddFibo:
        pop     ebx
        pop     edi
        pop     esi
        mov     esp, ebp
        pop     ebp
        ret
