option casemap:none

extrn GetStdHandle : PROC
extrn WriteFile    : PROC
extrn ReadFile     : PROC
extrn ExitProcess  : PROC

.data
    Ip      db "Ip: ", 0Ah, 0h

.data?
    HiHi    dd ?
    Op      db 50 dup(?)     

.code
main PROC
    mov     rbp, rsp
    sub     rsp, 28h

    mov     rcx, -11
    call    GetStdHandle
    xor     rbx, rbx
    mov     rcx, rax
    mov     rdx, offset Ip
    mov     r8, 4
    mov     r9, offset HiHi
    mov     [rsp+20h], rbx
    call    WriteFile

    mov     rcx, -10
    call    GetStdHandle
    xor     rbx, rbx
    mov     rcx, rax
    mov     rdx, offset Op
    mov     r8, 50
    mov     r9, offset HiHi
    mov     [rsp+20h], rbx
    call    ReadFile

    mov     rcx, offset Op    ; buffer
    mov     edx, HiHi         
    call    Inhoa

    mov     rcx, -11
    call    GetStdHandle
    xor     rbx, rbx
    mov     rcx, rax
    mov     rdx, offset Op
    mov     r8d, HiHi         
    mov     r9, offset HiHi
    mov     [rsp+20h], rbx
    call    WriteFile

    mov     rcx, 0
    call    ExitProcess
main ENDP

Inhoa PROC                   
    push    rbx
    push    rdi

    mov     rdi, rcx   ; ptr
    mov     rcx, rdx   ; dem

    CheckInhoa:
        cmp     rcx, 0
        je      EndCheck

        mov     al, [rdi]

        cmp     al, 'a'
        jb      Nhay
        cmp     al, 'z'
        ja      Nhay
        sub     al, 20h

    Nhay:
        mov     [rdi], al
        inc     rdi
        dec     rcx
        jmp     CheckInhoa

    EndCheck:
        pop     rdi
        pop     rbx
        ret
Inhoa ENDP

END
