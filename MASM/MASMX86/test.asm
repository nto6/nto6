.386									
.model flat, stdcall
option casemap: none

include D:\masm32\include\masm32.inc
include D:\masm32\include\kernel32.inc
includelib D:\masm32\lib\masm32.lib
includelib D:\masm32\lib\kernel32.lib

.data
	msg	db	"hello", 0Ah

.code
main PROC
	push	offset msg
	call	StdOut

	push	0
	call	ExitProcess

main ENDP
END main