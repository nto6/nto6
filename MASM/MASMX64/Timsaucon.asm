option  casemap:none

extrn   GetStdHandle  : PROC
extrn   WriteFile     : PROC
extrn   ReadFile      : PROC
extrn   ExitProcess   : PROC

.data
    ChuoiS      db "S = ", 0
    ChuoiC      db "C = ", 0
    newline      db 13, 10, 0
    space        db " ", 0
    output1  db "So lan xuat hien: ", 0
    output2  db "Vi tri: ", 0

.data?
    S_buffer     db 102 dup(?)
    C_buffer     db 12 dup(?)
    Vitri        dq 100 dup(?)
    Biendem      db 20 dup(?)
    bytesRead    dq ?
    bytesWritten dq ?

.code
main PROC
    sub     rsp, 40h
    ; In "S = "
    mov     rcx,-11
    call    GetStdHandle
    mov     rcx,rax
    lea     rdx,ChuoiS
    mov     r8,4
    lea     r9,bytesWritten
    mov     qword ptr [rsp+20h],0
    call    WriteFile
    ; doc S
    mov     rcx,-10
    call    GetStdHandle
    mov     rcx,rax
    lea     rdx,S_buffer
    mov     r8,102
    lea     r9,bytesRead
    mov     qword ptr [rsp+20h],0
    call    ReadFile
    ; In "C = "
    mov     rcx,-11
    call    GetStdHandle
    mov     rcx,rax
    lea     rdx,ChuoiC
    mov     r8,4
    lea     r9,bytesWritten
    mov     qword ptr [rsp+20h],0
    call    WriteFile
    ; doc C
    mov     rcx,-10
    call    GetStdHandle
    mov     rcx,rax
    lea     rdx,C_buffer
    mov     r8,12
    lea     r9,bytesRead
    mov     qword ptr [rsp+20h],0
    call    ReadFile
    ; Xoa newline
    lea     rcx,S_buffer
    call    XoaNewline
    lea     rcx,C_buffer
    call    XoaNewline
    ; Tim sau con
    lea     rcx,S_buffer
    lea     rdx,C_buffer
    lea     r8,Vitri
    call    Timxau
    mov     r15, rax        ; Luu so lan xuat hien vao R15 
    ; In "So lan xuat hien: "
    mov     rcx,-11
    call    GetStdHandle
    mov     rcx,rax
    lea     rdx,output1
    mov     r8,18
    lea     r9,bytesWritten
    mov     qword ptr [rsp+20h],0
    call    WriteFile
    ; In so lan xh
    mov     rax, r15        ; lay gtri tu r15
    lea     rdi,Biendem
    call    Sosangchuoi
    
    lea     rcx,Biendem
    call    Len
    mov     r8,rax
    
    mov     rcx,-11
    call    GetStdHandle
    mov     rcx,rax
    lea     rdx,Biendem
    lea     r9,bytesWritten
    mov     qword ptr [rsp+20h],0
    call    WriteFile
    ; In newline
    mov     rcx,-11
    call    GetStdHandle
    mov     rcx,rax
    lea     rdx,newline
    mov     r8,2
    lea     r9,bytesWritten
    mov     qword ptr [rsp+20h],0
    call    WriteFile
    ; In "Vi tri: "
    mov     rcx,-11
    call    GetStdHandle
    mov     rcx,rax
    lea     rdx,output2
    mov     r8,8
    lea     r9,bytesWritten
    mov     qword ptr [rsp+20h],0
    call    WriteFile
    ; In cac vi tri
    lea     rcx,Vitri
    mov     rdx,r15         
    call    InVitri

    ; In newline cuoi
    mov     rcx,-11
    call    GetStdHandle
    mov     rcx,rax
    lea     rdx,newline
    mov     r8,2
    lea     r9,bytesWritten
    mov     qword ptr [rsp+20h],0
    call    WriteFile

    xor     ecx,ecx
    call    ExitProcess
main ENDP

; Xoa newline
XoaNewline PROC
    push    rsi
    mov     rsi,rcx
    endTim:
        mov     al,[rsi]
        cmp     al,0
        je      checknewline
        inc     rsi
        jmp     endTim
    checknewline:
        dec     rsi
        cmp     byte ptr [rsi],10
        je      Xoa_n
        cmp     byte ptr [rsi],13
        je      Xoa_r
        jmp     done
    Xoa_n:
        mov     byte ptr [rsi],0
        dec     rsi
        cmp     byte ptr [rsi],13
        jne     done
    Xoa_r:
        mov     byte ptr [rsi],0
    done:
        pop     rsi
        ret
XoaNewline ENDP

Len PROC
    xor     rax,rax
    checkl:
        cmp     byte ptr [rcx+rax],0
        je      endl
        inc     rax
        jmp     checkl
    endl:
        ret
Len ENDP
Sosangchuoi PROC
    push    rbx
    push    rcx
    push    rdx
    push    rsi
    mov     rsi,rdi
    test    rax,rax
    jnz     Chuyenso
    mov     byte ptr [rsi],'0'
    mov     byte ptr [rsi+1],0
    jmp     endChuyen
    Chuyenso:
        xor     rcx,rcx
        mov     rbx,10
    Chuyenso2:
        xor     rdx,rdx
        div     rbx
        add     dl,'0'
        push    rdx
        inc     rcx
        test    rax,rax
        jnz     Chuyenso2
        xor     rdi,rdi
    Chuyenso3:
        pop     rdx
        mov     [rsi+rdi],dl
        inc     rdi
        loop    Chuyenso3
        mov     byte ptr [rsi+rdi],0
    endChuyen:
        pop     rsi
        pop     rdx
        pop     rcx
        pop     rbx
        ret
Sosangchuoi ENDP

; Tim xau con
Timxau PROC
    push    rbp
    mov     rbp,rsp
    sub     rsp,40h

    push    rbx
    push    rsi
    push    rdi
    push    r12
    push    r13
    push    r14
    push    r15

    mov     rsi,rcx
    mov     rdi,rdx
    mov     r12,r8

    mov     rcx,rsi
    call    Len
    mov     r13,rax
    mov     rcx,rdi
    call    Len
    mov     r14,rax

    xor     rax,rax
    xor     rbx,rbx

    cmp     r14,0
    je      endcheck
    cmp     r13,r14
    jl      endcheck

    mov     r8,r13
    sub     r8,r14

    TimChuoi:
        xor     r9, r9
    CheckT:
        mov     r10,rsi
        add     r10,rbx
        add     r10,r9
        mov     r15b,[r10]

        mov     r11,rdi
        add     r11,r9
        mov     r11b,[r11]

        cmp     r15b,r11b
        jne     Khonggiong
        inc     r9
        cmp     r9,r14
        jl      CheckT

        ; match found
        mov     r10,rax
        shl     r10,3
        add     r10,r12
        mov     [r10],rbx
        inc     rax

    Khonggiong:
        inc     rbx
        cmp     rbx,r8
        jle     TimChuoi

    endcheck:
        pop     r15
        pop     r14
        pop     r13
        pop     r12
        pop     rdi
        pop     rsi
        pop     rbx
        mov     rsp,rbp
        pop     rbp
        ret
Timxau ENDP
; In cac vi tri
InVitri PROC
    push    rbp
    mov     rbp,rsp
    sub     rsp,40h

    push    rbx
    push    rsi
    push    r14

    mov     rsi,rcx
    mov     rbx,rdx
    xor     r14,r14

    Invitri:
        cmp     r14,rbx
        jge     EndInvitri

        mov     rax,[rsi+r14*8]
        lea     rdi,Biendem
        call    Sosangchuoi

        lea     rcx,Biendem
        call    Len
        mov     r8,rax

        mov     rcx,-11
        call    GetStdHandle
        mov     rcx,rax
        lea     rdx,Biendem
        lea     r9,bytesWritten
        mov     qword ptr [rsp+20h],0
        call    WriteFile

        inc     r14
        cmp     r14,rbx
        jge     EndIn

        mov     rcx,-11
        call    GetStdHandle
        mov     rcx,rax
        lea     rdx,space
        mov     r8,1
        lea     r9,bytesWritten
        mov     qword ptr [rsp+20h],0
        call    WriteFile

        jmp     Invitri

    EndIn:
    EndInvitri:
        pop     r14
        pop     rsi
        pop     rbx
        mov     rsp,rbp
        pop     rbp
        ret
InVitri ENDP

END 
