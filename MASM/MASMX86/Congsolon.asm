.386         
.model flat, stdcall
option casemap: none

include D:\masm32\include\masm32.inc
include D:\masm32\include\kernel32.inc
includelib D:\masm32\lib\masm32.lib
includelib D:\masm32\lib\kernel32.lib

.data
     So1     db "Nhap so 1: ", 0
     So2     db "Nhap so 2: ", 0
     Tong    db "Tong: ", 0
     newline db 13,10,0
.data?
     so1     db 32 dup(?)
     so2     db 32 dup(?)
     ketqua  db 32 dup(?)
     len1    dd ?
     len2    dd ?
     lenKQ   dd ?

.code 
len PROC
    push    ebp
    mov     ebp, esp
    mov     ecx, [ebp + 8]  
    mov     edi, 0          
    
    check:
        mov     al, [ecx + edi]  
        cmp     al, 0
        je      enddd
        cmp     al, 13    
        je      enddd
        cmp     al, 10   
        je      enddd
        inc     edi
        jmp     check
    
    enddd:
        mov     eax, edi     
        mov     esp, ebp
        pop     ebp
        ret     4
len ENDP

Daoxau PROC
    push    eax
    push    ebx
    push    ecx
    push    edx
    push    esi
    push    edi
    
    mov     esi, ecx     
    mov     edi, ecx
    add     edi, edx
    dec     edi          
    Dao:
        cmp     esi, edi
        jge     endDao
        mov     al, [esi]
        mov     bl, [edi]
        mov     [esi], bl
        mov     [edi], al
        inc     esi
        dec     edi
        jmp     Dao
    endDao:
        pop     edi
        pop     esi
        pop     edx
        pop     ecx
        pop     ebx
        pop     eax
        ret
Daoxau ENDP


Cong2so PROC
    push    ebp
    mov     ebp, esp
    push    ebx
    push    esi
    push    edi
    push    ecx
    push    edx
    ; dao so1
    mov     ecx, offset so1         ;s1
    mov     edx, [len1]
    call    Daoxau

    ; dao so2
    mov     ecx, offset so2         ;s2
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
        mov     edi, offset ketqua          ;len ketqua
        mov     dl, 0     ; nho = 0
    addl:
        cmp     esi, ecx         ;neu i > lenmax => ket thuc
        jge     Congsocuoi     ; ket thuc vong lap
        ; Neu vuot len 1 => them 0
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
        mov     byte ptr [edi],'1'  ;cong them 1 o dau
        inc     edi
    Ketthuc:
        mov     eax, edi
        sub     eax, offset ketqua      ;EAX = So byte ghi vao ketqua(len)
        mov     [lenKQ], eax
        ; dao ketqua
        mov     ecx, offset ketqua
        mov     edx, [lenKQ]
        call    Daoxau
        pop     edx
        pop     ecx
        pop     edi
        pop     esi
        pop     ebx
        mov     esp, ebp
        pop     ebp
        ret
Cong2so ENDP
main PROC
    push    offset So1
    call    StdOut

    push    32
    push    offset so1
    call    StdIn

    mov     esi, offset so1
checkkytu1:                 ;kiem tra ki tu xuong dong
    mov     al, [esi]
    cmp     al, 0
    je      end1
    cmp     al, 13    ; \r
    je      tiep1
    cmp     al, 10    ; \n
    je      tiep1
    inc     esi
    jmp     checkkytu1
tiep1:
    mov     byte ptr [esi], 0       ; thay \n bang null
    inc     esi
    jmp     checkkytu1
end1:

    push    offset So2
    call    StdOut

    push    32
    push    offset so2
    call    StdIn

    mov     esi, offset so2
checkkytu2:
    mov     al, [esi]
    cmp     al, 0
    je      end2
    cmp     al, 13    
    je      tiep2
    cmp     al, 10    
    je      tiep2
    inc     esi
    jmp     checkkytu2
tiep2:
    mov     byte ptr [esi], 0
    inc     esi
    jmp     checkkytu2
end2:

    push    offset so1
    call    len
    mov     [len1], eax

    push    offset so2
    call    len
    mov     [len2], eax

    call    Cong2so

    push    offset Tong
    call    StdOut

    push    offset ketqua
    call    StdOut

    push    offset newline
    call    StdOut

    push    0
    call    ExitProcess
main ENDP

END main