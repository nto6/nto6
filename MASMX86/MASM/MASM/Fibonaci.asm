.386         
.model flat, stdcall
option casemap: none

include \masm32\include\masm32.inc
include \masm32\include\kernel32.inc
includelib \masm32\lib\masm32.lib
includelib \masm32\lib\kernel32.lib

.data
    SoN     db "Nhap so N: ", 0
    newline db 13, 10, 0
.data?
    N       dd ?            ; so phan tu N 
    input   db 100 dup(?)   ; buffer cho input N
    so1     db 256 dup(?)   ; F(n-1)
    so2     db 256 dup(?)   ; F(n-2)
    ketqua  db 512 dup(?)   ; ket qua
    len1    dd ?
    len2    dd ?
    lenKQ   dd ?

.code 
main PROC
    push    offset SoN
    call    StdOut

    push    100
    push    offset input
    call    StdIn

    ; Chuyen input thanh so
    push    offset input
    call    chuoisangso
    mov     [N], eax

    call    Fibonl

    push    0
    call    ExitProcess
main ENDP
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

chuoisangso PROC
    push    ebp
    mov     ebp, esp
    mov     esi, [ebp + 8]
    mov     eax, 0  ; Tong

    kiemtra:
        mov     ebx, 0
        mov     bl, [esi]
        cmp     bl, 10      ; neu gap '\n' thi ket thuc
        je      endl
        cmp     bl, 0       ; neu la null => ket thuc
        je      endl

        cmp     bl, '0'
        jb      endl
        cmp     bl, '9'
        ja      endl

        sub     bl, '0'     ; chuyen chuoi ve so
        imul    eax, 10
        add     eax, ebx
    
        inc     esi
        jmp     kiemtra

    endl:
        mov     esp, ebp
        pop     ebp
        ret     4
chuoisangso ENDP
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
	    ; Them ky tu ket thuc chuoi
	    mov 	esi, [lenKQ]
        mov 	byte ptr [ketqua + esi], 0

	    ; Dao nguoc lai so1 va so2 ve trang thai ban dau
	    mov 	ecx, offset so1
	    mov 	edx, [len1]
	    call 	Daoxau

	    mov 	ecx, offset so2
	    mov 	edx, [len2]
	    call 	Daoxau
        pop     edx
        pop     ecx
        pop     edi
        pop     esi
        pop     ebx
        mov     esp, ebp
        pop     ebp
        ret
Cong2so ENDP
Fibonl PROC
    push ebp
    mov ebp, esp
    push esi
    push edi
    push ebx
    
    mov eax, [N]
    cmp eax, 0
    jl enddFibo            ; neu N < 0 -> ket thuc
    
    ; Khoi tao: F(0) = "0", F(1) = "1"
    mov byte ptr [so2], '0'
    mov byte ptr [so2 + 1], 0    ; null 
    mov dword ptr [len2], 1
    
    mov byte ptr [so1], '1'
    mov byte ptr [so1 + 1], 0    ; null 
    mov dword ptr [len1], 1
    
    ; In F(0)
    push offset so2
    call StdOut
    push offset newline
    call StdOut
    
    ; Neu N = 0 -> ket thuc
    mov eax, [N]
    cmp eax, 0
    je enddFibo
    
    ; In F(1)
    push offset so1
    call StdOut
    push offset newline
    call StdOut
    
    ; Neu N = 1 -> ket thuc
    mov eax, [N]
    cmp eax, 1
    je enddFibo
    
    ; Bat dau tinh tu i = 2 den N
    mov esi, 2
    
    CheckFibo:
        mov eax, [N]
        cmp esi, eax
        jg enddFibo            ; neu i > N -> ket thuc
    
        ; Tinh F(i) = F(i-1) + F(i-2)
        call Cong2so
    
        ; In ket qua F(i)
        push offset ketqua
        call StdOut
        push offset newline
        call StdOut
    
        ; Cap nhat: F(i-2) = F(i-1)
        mov edi, 0
    copyso1sangso2:
        mov eax, [len1]
        cmp edi, eax
        jge endcopy1
        mov al, [so1 + edi]
        mov [so2 + edi], al
        inc edi
        jmp copyso1sangso2
    
    endcopy1:
        mov eax, [len1]
        mov [len2], eax
        mov byte ptr [so2 + edi], 0    ; null 
        ; Cap nhat: F(i-1) = F(i)
        mov edi, 0
    copykqsangso1:
        mov eax, [lenKQ]
        cmp edi, eax
        jge endcopy2
        mov al, [ketqua + edi]
        mov [so1 + edi], al
        inc edi
        jmp copykqsangso1
    
    endcopy2:
        mov eax, [lenKQ]
        mov [len1], eax
        mov byte ptr [so1 + edi], 0    ; null
    
        ; Tang i va lap lai
        inc esi
        jmp CheckFibo
    
    enddFibo:
        pop ebx
        pop edi
        pop esi
        mov esp, ebp
        pop ebp
        ret
Fibonl ENDP

END main