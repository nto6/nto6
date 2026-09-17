.386
.model flat, stdcall
option casemap:none

include \masm32\include\kernel32.inc
include \masm32\include\masm32.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib

.data
    XauS        db "S = ", 0
    XauC        db "C = ", 0
    newline     db 13,10,0
    space       db ' ', 0
.data?
    ChuoiS      db 100 dup(?)
    ChuoiC      db 10 dup(?)
    lenS        dd ?
    lenC        dd ?
    Vitri       dd 100 dup(?)   
    inso        db 10 dup(?)
    Biendem     dd ?            

.code
main PROC
 
    push    offset XauS
    call    StdOut
 
    push    100
    push    offset ChuoiS
    call    StdIn
 
    push    offset XauC
    call    StdOut
 
    push    10
    push    offset ChuoiC
    call    StdIn
 
    push    offset ChuoiS
    call    len
    mov     [lenS], eax
 
    push    offset ChuoiC
    call    len
    mov     [lenC], eax
 
    push    offset Vitri
    push    offset ChuoiC
    push    offset ChuoiS
    call    Timchuoi
    mov     [Biendem], eax          ;so lan xuat hien
    ;in so lan
    mov     eax, [Biendem]
    mov     edi, offset inso
    call    sosangchuoi
    push    offset inso
    call    StdOut
 
    push    offset newline
    call    StdOut
 
    call    Invitri
 
    push    0
    call    ExitProcess

main ENDP

len PROC
    push    ebp
    mov     ebp, esp
    mov     esi, [ebp+8]   
    xor     ecx, ecx       
    check:
        mov     al, [esi+ecx]
        cmp     al, 0
        je      endlen
        cmp     al, 10          
        je      endlen
        cmp     al, 13          
        je      endlen
        inc     ecx
        jmp     check
    endlen:
        mov     eax, ecx
        pop     ebp
        ret     4
len ENDP
Timchuoi PROC
    push    ebp
    mov     ebp, esp
    push    esi
    push    edi
    push    ebx
    push    ecx
    push    edx

    mov     esi, [ebp+8]      ; ChuoiS
    mov     edi, [ebp+12]     ; ChuoiC
    mov     edx, [ebp+16]    ;mang vitri

    xor     eax, eax          ;dem
    xor     ebx, ebx          ;chi so trong S
    ;gioi han = lenS - lenC
    mov     ecx, [lenS]
    sub     ecx, [lenC]
    js      endl                ;nhay neu lenS < lenC
    checkl:
        push    esi
        push    edi
        push    ecx 
        ;ss S+i va C
        mov     esi, [ebp+8]      
        add     esi, ebx            ; bat dau so sanh = S + ebx
        mov     edi, [ebp+12]      
        mov     ecx, [lenC]     
        cld                  
        repe    cmpsb           ;so sanh 1 byte tai dia chi tro cua esi va edi

        pop     ecx
        pop     edi
        pop     esi

        jne     Nhay         
 
        mov     [edx], ebx       ;luu vi tri trong mang
        add     edx, 4           ;dich sang o ke tiep
        inc     eax              

    Nhay:
        inc     ebx             
        cmp     ebx, ecx          
        jle     checkl           
    endl:
        pop     edx
        pop     ecx
        pop     ebx
        pop     edi
        pop     esi
        mov     esp, ebp
        pop     ebp
        ret     12
Timchuoi ENDP

Invitri PROC
    mov     ecx, 0           ; ecx la chi so vong lap 
    invitri:
        cmp     ecx, [Biendem]      
        jge     enddd               ; neu ecx >= Biendem thi end
         ; lay Vitri[ecx]
        mov     eax, [Vitri + ecx*4]        ; doc  vitri[ecx] vao eax (nhan ecx voi 4 vi moi phan tu la 4 byte)
        push    ecx
        mov     edi, offset inso
        call    sosangchuoi
        pop     ecx
        ;in so
        push    ecx
        push    offset inso
        call    StdOut
        pop     ecx
        ; in space neu chua phai phan tu cuoi
        inc     ecx
        cmp     ecx, [Biendem]
        jge     Dongmoi
        push    ecx
        push    offset space
        call    StdOut
        pop     ecx
        jmp     invitri
    Dongmoi:
        ; in xuong dong sau khi in het
        push    offset newline
        call    StdOut
    enddd:
        ret
Invitri ENDP

sosangchuoi PROC
    push    ebp
    mov     ebp, esp
    push    ebx
    push    ecx
    push    edx
    push    esi
    push    edi

    mov     esi, edi      ;buffer
    xor     ecx, ecx       
    mov     ebx, 10

    test    eax, eax
    jnz     kiemtra
    ; Neu so la 0, ghi '0' vao buffer và ket thuc chuoi
    mov     byte ptr [esi], '0'
    mov     byte ptr [esi+1], 0
    jmp     endd
    kiemtra:
        xor     edx, edx        ;don so du
        div     ebx            ; eax / 10 , du trong edx
        add     dl, '0'         ; chuyen sang ky tu
        push    dx           ; day ky tu vao stack
        inc     ecx            
        test    eax, eax
        jnz     kiemtra
        ; ghi ket qua
        mov     edi, 0
    ketqua:
        pop     dx
        mov     [esi+edi], dl
        inc     edi
        loop    ketqua 
        mov     byte ptr [esi+edi], 0   ;end chuoi
   endd:
        pop     edi
        pop     esi
        pop     edx
        pop     ecx
        pop     ebx
        mov     esp, ebp
        pop     ebp
        ret
sosangchuoi ENDP

END main