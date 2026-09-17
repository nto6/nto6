.386									
.model flat, stdcall
option casemap: none

include D:\masm32\include\masm32.inc
include D:\masm32\include\kernel32.inc
includelib D:\masm32\lib\masm32.lib
includelib D:\masm32\lib\kernel32.lib

.data
	Nhapchuoi	db "Nhap chuoi: ", 0
.data?						;vung nho chua khoi tao(same .bss)
	chuoi		db 32 dup(?)
.code	
main PROC
	push	offset Nhapchuoi
	call	StdOut

	push	32
	push	offset chuoi
	call	StdIn				;nhap chuoi

	push	offset chuoi
	call	StdOut

	push 0                                      
    call ExitProcess                            
main ENDP                                      

END main             