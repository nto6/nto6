option casemap:none

extrn GetStdHandle : PROC
extrn ReadFile     : PROC
extrn WriteFile    : PROC
extrn ExitProcess  : PROC

.data
    S1 db "Nhap so 1: ",0
    S2 db "Nhap so 2: ",0
    Tong db "Tong: ",0
    nl   db 13,10,0

    so1  db 32 dup(0)
    so2  db 32 dup(0)
    kq   db 40 dup(0)

.data?
    bytesRead  dq ?
    bytesWrite dq ?
    len1 dq ?
    len2 dq ?
    lenKQ dq ?

.code
main PROC
    sub     rsp, 28h

    ; Nhap so 1 
    mov     rcx, -11
    call    GetStdHandle
    mov     rcx, rax
    mov     rdx, offset S1
    mov     r8,  11
    mov     r9,  offset bytesWrite
    mov     qword ptr [rsp+20h], 0
    call    WriteFile

    mov     rcx, -10
    call    GetStdHandle
    mov     rcx, rax
    mov     rdx, offset so1
    mov     r8,  32
    mov     r9,  offset bytesRead
    mov     qword ptr [rsp+20h], 0
    call    ReadFile
    ;  Nhap so 2 
    mov     rcx, -11
    call    GetStdHandle
    mov     rcx, rax
    mov     rdx, offset S2
    mov     r8,  11
    mov     r9,  offset bytesWrite
    mov     qword ptr [rsp+20h], 0
    call    WriteFile

    mov     rcx, -10
    call    GetStdHandle
    mov     rcx, rax
    mov     rdx, offset so2
    mov     r8,  32
    mov     r9,  offset bytesRead
    mov     qword ptr [rsp+20h], 0
    call    ReadFile
    ;  Do dai 
    mov     rcx, offset so1
    call    strlen
    mov     len1, rax

    mov     rcx, offset so2
    call    strlen
    mov     len2, rax

    call    Cong2So

    ; ket qua
    mov     rcx, -11
    call    GetStdHandle
    mov     rcx, rax
    mov     rdx, offset Tong
    mov     r8, 6
    mov     r9, offset bytesWrite
    mov     qword ptr [rsp+20h], 0
    call    WriteFile

    mov     rcx, -11
    call    GetStdHandle
    mov     rcx, rax
    mov     rdx, offset kq
    mov     r8, 40
    mov     r9, offset bytesWrite
    mov     qword ptr [rsp+20h], 0
    call    WriteFile

    mov     rcx, 0
    call    ExitProcess
main ENDP
strlen PROC
    mov     rax, rcx
    xor     rdx, rdx
    L1:
        mov     bl, [rax+rdx]
        cmp     bl, 0
        je      EndL
        cmp     bl, 13
        je      EndL
        cmp     bl, 10
        je      EndL
        inc     rdx
        jmp     L1
    EndL:
        mov     rax, rdx
        ret
strlen ENDP
DaoChuoi PROC
    push    rsi
    push    rdi

    mov     rsi, rcx
    lea     rdi, [rcx+rdx-1]
    Lap:
        cmp     rsi, rdi
        jge     EndDao
        mov     al, [rsi]
        mov     bl, [rdi]
        mov     [rsi], bl
        mov     [rdi], al
        inc     rsi
        dec     rdi
        jmp     Lap
    EndDao:
        pop     rdi
        pop     rsi
        ret
DaoChuoi ENDP
Cong2So PROC
    sub     rsp, 20h            ; shadow space
    ; Dao so1 
    lea     rcx, so1            ; RCX = &so1
    mov     rdx, len1           ; RDX = len1
    call    DaoChuoi
    ; Dao so2 
    lea     rcx, so2
    mov     rdx, len2
    call    DaoChuoi
    ; max(len1, len2) 
    mov     rax, len1
    mov     rbx, len2
    cmp     rax, rbx
    cmovb   rax, rbx
    mov     rcx, rax            ; RCX = maxlen
    ;  Khoi tao 
    xor     rsi, rsi            ; i = 0
    xor     r8b, r8b            ; nho = 0
    lea     rdi, kq             ; buffer ket qua
    ; base address cho mang
    lea     r9,  so1            ; base so1
    lea     r10, so2            ; base so2
    AddLoop:
        cmp     rsi, rcx
        jge     EndAdd
        ; Lay so1[i] 
        mov     al, 0
        cmp     rsi, len1
        jae     Skip1
        mov     al, [r9+rsi]
        sub     al, '0'
    Skip1:
        mov     bl, al              ; bl = so1[i]
        ; Lay so2[i] 
        mov     al, 0
        cmp     rsi, len2
        jae     Skip2
        mov     al, [r10+rsi]
        sub     al, '0'
    Skip2:
        ;  Cong + nho 
        add     al, bl
        add     al, r8b
        xor     r8b, r8b
        cmp     al, 10
        jb      Konho
        sub     al, 10
        mov     r8b, 1
    Konho:
        add     al, '0'
        mov     [rdi], al

        inc     rdi
        inc     rsi
        jmp     AddLoop
    EndAdd:
        ; Neu con nho 
        cmp     r8b, 0
        je      EndCong
        mov     byte ptr [rdi], '1'
        inc     rdi
    EndCong:
        ; lenKQ = rdi - kq 
        mov     rax, rdi
        lea     rbx, kq
        sub     rax, rbx
        mov     lenKQ, rax
        ;  Dao ket qua
        lea     rcx, kq
        mov     rdx, lenKQ
        call    DaoChuoi
        add     rsp, 20h
        ret
Cong2So ENDP
END