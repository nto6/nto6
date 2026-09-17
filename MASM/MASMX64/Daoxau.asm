option casemap:none

extrn  GetStdHandle : PROC
extrn  ReadFile     : PROC
extrn  WriteFile    : PROC
extrn  ExitProcess  : PROC

.data
    Input   db "Nhap xau: ", 0
    Output  db "Xau dao nguoc: ", 0

    inputBuf   db 256 dup(0)
    outputBuf  db 256 dup(0)

.data?
    bytesRead  dq ?
    bytesWrote dq ?

.code
main PROC
    sub     rsp, 28h
    ; "Nhap xau: "
    mov     rcx, -11
    call    GetStdHandle
    mov     rcx, rax
    mov     rdx, offset Input
    mov     r8, 10          
    mov     r9, offset bytesWrote
    mov     qword ptr [rsp+20h], 0
    call    WriteFile

    ; doc xau
    mov     rcx, -10
    call    GetStdHandle
    mov     rcx, rax
    mov     rdx, offset inputBuf
    mov     r8, 256         
    mov     r9, offset bytesRead
    mov     qword ptr [rsp+20h], 0
    call    ReadFile

    ; dao xau
    mov     rcx, offset inputBuf
    mov     rdx, offset outputBuf
    call    reverseString

    ; "Xau dao nguoc: "
    mov     rcx, -11
    call    GetStdHandle
    mov     rcx, rax
    mov     rdx, offset Output
    mov     r8, 16          
    mov     r9, offset bytesWrote
    mov     qword ptr [rsp+20h], 0
    call    WriteFile

    mov     rcx, -11
    call    GetStdHandle
    mov     rcx, rax
    mov     rdx, offset outputBuf
    mov     r8, 256         
    mov     r9, offset bytesWrote
    mov     qword ptr [rsp+20h], 0
    call    WriteFile

    mov     rcx, 0
    call    ExitProcess
main ENDP
reverseString PROC
    mov     rsi, rcx        ; RSI tro den input
    mov     rdi, rdx        ; RDI tro den output

    xor     rcx, rcx
    Timdodai:
        mov     al, [rsi + rcx]
        cmp     al, 0Ah         ; Check newline
        je      endTim
        cmp     al, 0Dh         ; Check carriage return
        je      endTim  
        cmp     al, 0           
        je      endTim
        inc     rcx
        jmp     Timdodai
    endTim:
        mov     r8, rcx         ; do dai R8
        xor     r9, r9          ; R9 = index output
    Daosau:
        cmp     rcx, 0
        je      enddao
        dec     rcx
        mov     al, [rsi + rcx] 
        mov     [rdi + r9], al  
        inc     r9
        jmp     Daosau
    
    enddao:
        ; Them newline va null terminator
        mov     byte ptr [rdi + r9], 0Ah
        mov     byte ptr [rdi + r9 + 1], 0
        ret
reverseString ENDP
END