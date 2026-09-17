option casemap:none

extrn  GetStdHandle : PROC
extrn  ReadFile     : PROC
extrn  WriteFile    : PROC
extrn  ExitProcess  : PROC

.data
    input       db "Nhap so thu 1: ", 0
    output       db "Nhap so thu 2: ", 0
    Sum     db "Tong = ", 0

    buf1       db 32 dup(0)
    buf2       db 32 dup(0)
    outBuf     db 64 dup(0)

.data?
    bytesRead  dq ?
    bytesWrote dq ?

.code
main PROC
    sub     rsp, 28h

    mov     rcx, -11
    call    GetStdHandle
    mov     rcx, rax
    mov     rdx, offset input
    mov     r8, 16
    mov     r9, offset bytesWrote
    mov     qword ptr [rsp+20h], 0
    call    WriteFile

    mov     rcx, -10
    call    GetStdHandle
    mov     rcx, rax
    mov     rdx, offset buf1
    mov     r8, 32
    mov     r9, offset bytesRead
    mov     qword ptr [rsp+20h], 0
    call    ReadFile

    mov     rcx, -11
    call    GetStdHandle
    mov     rcx, rax
    mov     rdx, offset output
    mov     r8, 16
    mov     r9, offset bytesWrote
    mov     qword ptr [rsp+20h], 0
    call    WriteFile

    mov     rcx, -10
    call    GetStdHandle
    mov     rcx, rax
    mov     rdx, offset buf2
    mov     r8, 32
    mov     r9, offset bytesRead
    mov     qword ptr [rsp+20h], 0
    call    ReadFile

    mov     rcx, offset buf1
    call    Chuoisangso
    mov     r14, rax

    mov     rcx, offset buf2
    call    Chuoisangso
    add     r14, rax

    mov     rcx, -11
    call    GetStdHandle
    mov     rcx, rax
    mov     rdx, offset Sum
    mov     r8, 7
    mov     r9, offset bytesWrote
    mov     qword ptr [rsp+20h], 0
    call    WriteFile

    mov     rcx, r14
    mov     rdx, offset outBuf
    call    Sosangchuoi

    mov     rcx, -11
    call    GetStdHandle
    mov     rcx, rax
    mov     rdx, offset outBuf
    mov     r8, 32
    mov     r9, offset bytesWrote
    mov     qword ptr [rsp+20h], 0
    call    WriteFile

    mov     rcx, 0
    call    ExitProcess

main ENDP
Chuoisangso PROC
    mov     rsi, rcx        
    xor     rax, rax
    xor     rbx, rbx
    Check:
        mov     bl, [rsi]
        cmp     bl, 0Dh     
        je      endc
        cmp     bl, 0Ah
        je      endc  
        cmp     bl, 0
        je      endc
        cmp     bl, '0'
        jb      endc
        cmp     bl, '9'
        ja      endc
        imul    rax, 10
        sub     bl, '0'
        movzx   rbx, bl
        add     rax, rbx
        inc     rsi
        jmp     Check
    endc:
        ret
Chuoisangso ENDP

Sosangchuoi PROC
    mov     rdi, rdx        ; buffer trong RDX
    mov     rax, rcx        ; value trong RCX
    xor     rcx, rcx

    cmp     rax, 0
    jne     Check1
    mov     byte ptr [rdi], '0'
    mov     byte ptr [rdi+1], 0Ah
    mov     byte ptr [rdi+2], 0
    ret

    Check1:
        xor     rdx, rdx
        mov     rbx, 10
        div     rbx
        add     dl, '0'
        push    rdx
        inc     rcx
        test    rax, rax
        jnz     Check1

    Endl:
        pop     rdx
        mov     [rdi], dl
        inc     rdi
        loop    Endl

        mov     byte ptr [rdi], 0Ah
        mov     byte ptr [rdi+1], 0
        ret
Sosangchuoi ENDP
END
