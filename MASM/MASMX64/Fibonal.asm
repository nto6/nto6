option casemap:none

extrn GetStdHandle : PROC
extrn ReadFile     : PROC
extrn WriteFile    : PROC
extrn ExitProcess  : PROC

.data
    msgN    db "Nhap so N: ",0
    space   db " ",0
    nl      db 13,10,0

.data?
    bytesRead  dq ?
    bytesWrite dq ?

    bufN   db 32 dup(?)
    N      dq ?

    so1    db 256 dup(?)
    so2    db 256 dup(?)
    kq     db 512 dup(?)

    len1   dq ?
    len2   dq ?
    lenKQ  dq ?
.code
main PROC
    sub     rsp, 28h
    ; In "Nhap so N"
    mov     rcx, -11
    call    GetStdHandle
    mov     rcx, rax
    mov     rdx, offset msgN
    mov     r8, 12
    mov     r9, offset bytesWrite
    mov     qword ptr [rsp+20h], 0
    call    WriteFile
    ; Read N
    mov     rcx, -10
    call    GetStdHandle
    mov     rcx, rax
    mov     rdx, offset bufN
    mov     r8, 32
    mov     r9, offset bytesRead
    mov     qword ptr [rsp+20h], 0
    call    ReadFile

    lea     rcx, bufN
    call    Chuoisangso
    mov     N, rax

    ; Fibonacci
    call    Fibonacci

    mov     rcx, 0
    call    ExitProcess
main ENDP
Chuoisangso PROC
    push    rbx           
    xor     rax, rax
    xor     rbx, rbx
    mov     rsi, rcx
    Tiep:
        mov     bl, [rsi]
        cmp     bl, '0'
        jb      EndChuoi
        cmp     bl, '9'
        ja      EndChuoi
        imul    rax, 10
        sub     bl, '0'
        add     rax, rbx
        inc     rsi
        jmp     Tiep
    EndChuoi:
        pop     rbx            
        ret
Chuoisangso ENDP
strlen PROC
    push    rbx          
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
        pop     rbx           
        ret
strlen ENDP

DaoChuoi PROC
    push    rbx        
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
        pop     rbx        
        ret
DaoChuoi ENDP
Cong2So PROC
    push    rbx             
    sub     rsp, 20h

    lea     rcx, so1
    mov     rdx, len1
    call    DaoChuoi

    lea     rcx, so2
    mov     rdx, len2
    call    DaoChuoi

    mov     rax, len1
    mov     rbx, len2
    cmp     rax, rbx
    cmovb   rax, rbx
    mov     rcx, rax

    xor     rsi, rsi
    xor     r8b, r8b
    lea     rdi, kq
    lea     r9, so1
    lea     r10, so2
    AddL:
        cmp     rsi, rcx
        jge     EndAdd

        mov     al, 0
        cmp     rsi, len1
        jae     Nhay1
        mov     al, [r9+rsi]
        sub     al, '0'
        Nhay1:
            mov     bl, al

            mov     al, 0
            cmp     rsi, len2
            jae     Nhay2
            mov     al, [r10+rsi]
            sub     al, '0'
        Nhay2:
            add     al, bl
            add     al, r8b
            xor     r8b, r8b
            cmp     al, 10
            jb      Khongnho
            sub     al, 10
            mov     r8b, 1
        Khongnho:
            add     al, '0'
            mov     [rdi], al

            inc     rdi
            inc     rsi
            jmp     AddL
        EndAdd:
            cmp     r8b, 0
            je  EndCong
            mov     byte ptr [rdi], '1'
            inc     rdi
    EndCong:
        mov     rax, rdi
        lea     rbx, kq
        sub     rax, rbx
        mov     lenKQ, rax

        lea     rcx, kq
        mov     rdx, lenKQ
        call    DaoChuoi

        add     rsp, 20h
        pop     rbx              
        ret
Cong2So ENDP
Fibonacci PROC
    push    rbx            
    push    r12 
    sub     rsp, 20h                 ; shadow space
    ; lay stdout 
    mov     rcx, -11
    call    GetStdHandle
    mov     r12, rax                 ; hOut
    ; Neu N < 0 return 
    mov     rax, N
    test    rax, rax
    js      EndFibo
    ; so2 = "0" 
    mov     byte ptr so2, '0'
    mov     qword ptr len2, 1
    ; so1 = "1" 
    mov byte ptr so1, '1'
    mov qword ptr len1, 1
    ; print F0
    mov     rcx, r12
    mov     rdx, offset so2
    mov     r8, len2
    mov     r9, offset bytesWrite
    mov     qword ptr [rsp+20h], 0
    call    WriteFile

    mov     rcx, r12
    mov     rdx, offset nl
    mov     r8, 2
    mov     r9, offset bytesWrite
    mov     qword ptr [rsp+20h], 0
    call    WriteFile

    cmp     N, 0
    je      EndFibo
    ; print F1 
    mov     rcx, r12
    mov     rdx, offset so1
    mov     r8, len1
    mov     r9, offset bytesWrite
    mov     qword ptr [rsp+20h], 0
    call    WriteFile

    mov     rcx, r12
    mov     rdx, offset nl
    mov     r8, 2
    mov     r9, offset bytesWrite
    mov     qword ptr [rsp+20h], 0
    call    WriteFile

    cmp     N, 1
    je      EndFibo
    ; i = 2 
    mov     rbx, 2
    FibL:
        mov     rax, N
        cmp     rbx, rax
        jg      EndFibo
        ;  kq = so1 + so2 
        call    Cong2So
        lea     rcx, so1
        mov     rdx, len1
        call    DaoChuoi

        lea     rcx, so2
        mov     rdx, len2
        call    DaoChuoi
        ; kq
        mov     rcx, r12
        mov     rdx, offset kq
        mov     r8, lenKQ
        mov     r9, offset bytesWrite
        mov     qword ptr [rsp+20h], 0
        call    WriteFile

        mov     rcx, r12
        mov     rdx, offset nl
        mov     r8, 2
        mov     r9, offset bytesWrite
        mov     qword ptr [rsp+20h], 0
        call    WriteFile
        ; so2 = so1
        lea     rsi, so1
        lea     rdi, so2
        mov     rcx, len1
        rep     movsb
        mov     rax, len1
        mov     len2, rax
        ; so1 = kq 
        lea     rsi, kq
        lea     rdi, so1
        mov     rcx, lenKQ
        rep     movsb
        mov     rax, lenKQ
        mov     len1, rax

        inc     rbx
        jmp     FibL

    EndFibo:
        add     rsp, 20h
        pop     r12            
        pop     rbx 
        ret
Fibonacci ENDP
END
