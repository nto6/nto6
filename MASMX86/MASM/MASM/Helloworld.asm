.386											; dung tap lenh 32-bit
.model flat, stdcall							; mo hinh bo nho , quy uoc goi ham win
option casemap:none                             ;phan biet chu hoa thuong(khong doi)

include D:\masm32\include\masm32.inc            ; cac ham tien ich nhu StdOut
include D:\masm32\include\kernel32.inc          ; dinh nghia ham tu kernel32.dll
includelib D:\masm32\lib\masm32.lib             ; Lien ket thu vien nhi phan masm32.lib (StdOut,...)
includelib D:\masm32\lib\kernel32.lib           ; Lien ket thu vien kernel32.lib (ExitProcess,...)

.data
    chuoi   db "Hello, World!" , 0

.code
main PROC
    push    offset chuoi                        ;day dia chi chuoi vao stack
    call    StdOut                              ;goi ham stdout de in (masm32.lib)

    push 0                                      ;ma thoat = 0
    call ExitProcess                            ;end chuong trinh(winAPI)
main ENDP                                       ;end main

END main                                        ;end label, diem vao chuong chinh la nhan main(entry point)