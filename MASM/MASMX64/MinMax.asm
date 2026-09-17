option casemap:none

extrn GetStdHandle : proc
extrn ReadFile     : proc
extrn WriteFile    : proc
extrn ExitProcess  : proc

; ================= DATA =================
.data
    NhapN       db "Nhap n: ", 0
    NhapMang    db "Nhap mang: ", 0
    MAXstr      db "Max: ", 0
    MINstr      db "Min: ", 0
    newline     db 13, 10, 0

    MaxBuf      db 32 dup(0)
    MinBuf      db 32 dup(0)

.data?
    n           dq ?
    arr         dq 100 dup(?)
    buffer      db 256 dup(?)
    Max         dq ?
    Min         dq ?
    bytesRead   dq ?
    bytesWritten dq ?

; ================= CODE =================
.code
main PROC
    sub     rsp, 28h                 ; shadow space + align

; ---------- In "Nhap n" ----------
    mov     rcx, -11
    call    GetStdHandle
    lea     rdx, NhapN
    mov     r8, 8
    lea     r9, bytesWritten
    mov     qword ptr [rsp+20h], 0
    call    WriteFile

; ---------- Read n ----------
    mov     rcx, -10
    call    GetStdHandle
    lea     rdx, buffer
    mov     r8, 32
    lea     r9, bytesRead
    mov     qword ptr [rsp+20h], 0
    call    ReadFile

    lea     rbx, buffer
    movzx   rax, byte ptr [rbx]
    sub     rax, '0'
    mov     [n], rax

; ---------- In "Nhap mang" ----------
    mov     rcx, -11
    call    GetStdHandle
    lea     rdx, NhapMang
    mov     r8, 12
    lea     r9, bytesWritten
    mov     qword ptr [rsp+20h], 0
    call    WriteFile

; ---------- Base pointer cho arr ----------
    lea     r12, arr                ; r12 = base arr (callee-saved)

; ---------- Doc mang ----------
    xor     rdi, rdi                ; index

DocSo:
    cmp     rdi, [n]
    jge     EndDoc

    mov     rcx, -10
    call    GetStdHandle
    lea     rdx, buffer
    mov     r8, 32
    lea     r9, bytesRead
    mov     qword ptr [rsp+20h], 0
    call    ReadFile

    lea     rbx, bytesRead
    mov     rax, [rbx]
    lea     rcx, buffer
    mov     byte ptr [rcx+rax], 0

    lea     rsi, buffer
    xor     rbx, rbx                ; current value
    xor     r8d, r8d                ; flag

Parse:
    mov     al, [rsi]
    test    al, al
    je      StoreLast
    cmp     al, ' '
    je      Store
    cmp     al, 13
    je      Store
    cmp     al, 10
    je      Store
    cmp     al, '0'
    jb      Next
    cmp     al, '9'
    ja      Next

    sub     al, '0'
    movzx   rcx, al
    imul    rbx, rbx, 10
    add     rbx, rcx
    mov     r8d, 1
    jmp     Next

Store:
    cmp     r8d, 0
    je      Next
    mov     [r12+rdi*8], rbx
    inc     rdi
    xor     rbx, rbx
    xor     r8d, r8d
    cmp     rdi, [n]
    jge     EndParse

Next:
    inc     rsi
    jmp     Parse

StoreLast:
    cmp     r8d, 0
    je      EndParse
    mov     [r12+rdi*8], rbx
    inc     rdi

EndParse:
    jmp     DocSo

EndDoc:

; ---------- Tim max / min ----------
    lea     rcx, arr
    mov     rdx, [n]
    call    maxmin

; ---------- In Max ----------
    mov     rcx, -11
    call    GetStdHandle
    lea     rdx, MAXstr
    mov     r8, 5
    lea     r9, bytesWritten
    mov     qword ptr [rsp+20h], 0
    call    WriteFile

    mov     rax, [Max]
    lea     rcx, MaxBuf
    call    sosangchuoi

    mov     rcx, -11
    call    GetStdHandle
    lea     rdx, MaxBuf
    mov     r8, 16
    lea     r9, bytesWritten
    mov     qword ptr [rsp+20h], 0
    call    WriteFile

; ---------- Newline ----------
    mov     rcx, -11
    call    GetStdHandle
    lea     rdx, newline
    mov     r8, 2
    lea     r9, bytesWritten
    mov     qword ptr [rsp+20h], 0
    call    WriteFile

; ---------- In Min ----------
    mov     rcx, -11
    call    GetStdHandle
    lea     rdx, MINstr
    mov     r8, 5
    lea     r9, bytesWritten
    mov     qword ptr [rsp+20h], 0
    call    WriteFile

    mov     rax, [Min]
    lea     rcx, MinBuf
    call    sosangchuoi

    mov     rcx, -11
    call    GetStdHandle
    lea     rdx, MinBuf
    mov     r8, 16
    lea     r9, bytesWritten
    mov     qword ptr [rsp+20h], 0
    call    WriteFile

; ---------- Exit ----------
    add     rsp, 28h
    xor     ecx, ecx
    call    ExitProcess
main ENDP

; ================= So -> Chuoi =================
sosangchuoi PROC
    push    rbp
    mov     rbp, rsp
    mov     rdi, rcx
    xor     rcx, rcx
    mov     rbx, 10

    test    rax, rax
    jnz     conv
    mov     byte ptr [rdi], '0'
    mov     byte ptr [rdi+1], 0
    jmp     done

conv:
    xor     rdx, rdx
    div     rbx
    add     dl, '0'
    push    rdx
    inc     rcx
    test    rax, rax
    jnz     conv

outt:
    pop     rdx
    mov     [rdi], dl
    inc     rdi
    loop    outt
    mov     byte ptr [rdi], 0

done:
    mov     rsp, rbp
    pop     rbp
    ret
sosangchuoi ENDP

; ================= Max / Min =================
maxmin PROC
    push    rbp
    mov     rbp, rsp
    mov     rsi, rcx
    mov     rcx, rdx

    cmp     rcx, 1
    jl      none

    mov     rax, [rsi]
    mov     rbx, rax
    mov     rdx, rax
    mov     rdi, 1

loop_mm:
    cmp     rdi, rcx
    jge     endmm
    mov     rax, [rsi+rdi*8]
    cmp     rax, rbx
    jle     chkmin
    mov     rbx, rax
chkmin:
    cmp     rax, rdx
    jge     cont
    mov     rdx, rax
cont:
    inc     rdi
    jmp     loop_mm

endmm:
    mov     [Max], rbx
    mov     [Min], rdx
    jmp     done

none:
    mov     qword ptr [Max], 0
    mov     qword ptr [Min], 0

done:
    mov     rsp, rbp
    pop     rbp
    ret
maxmin ENDP

END
