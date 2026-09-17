option casemap:none

extrn GetStdHandle	:PROC		;Lay handle chuan cho input/output
extrn WriteFile		:PROC		;Ghi du lieu ra file/console
extrn ExitProcess	:PROC		

;BOOL WriteFile(
;  HANDLE hFile,         // RCX
;  LPCVOID lpBuffer,     // RDX
;  DWORD nNumberOfBytesToWrite, // R8
;  LPDWORD lpNumberOfBytesWritten, // R9
;  LPOVERLAPPED lpOverlapped // stack (optional, NULL)
;)
;BOOL ReadFile(
;  HANDLE hFile,         // RCX
;  LPVOID lpBuffer,      // RDX
;  DWORD nNumberOfBytesToRead, // R8
;  LPDWORD lpNumberOfBytesRead, // R9
;  LPOVERLAPPED lpOverlapped // stack (optional)
;)
.data
	Hi		db "Hello world", 0Ah, 0h

.data?
	HiHi	dd ?

.code 
main PROC
	mov		rbp, rsp			; rsp can chinh theo 16 byte trc khi call(alignment)
	sub		rsp, 28h			; giam RSP, chuan bi stack + local + shadow space(32 bytes shadow space luon duoc cap trc khi call ham win)

	mov		rcx, -11			;handle tu GetStdHandle
	call	GetStdHandle		;return handle rax
	xor		rbx, rbx
	mov		rcx, rax			;Std_Output_Handle
	mov		rdx, offset Hi		;dia chi bufer
	mov     r8, 11		;so byte doc toi da 
	mov		r9, offset HiHi		;pointer so byte doc thuc te
	mov		[rsp + 20h], rbx	;Null ,cho shadow space + tham so stack thu 5 (Overlapped), [rsp+offset]
	call	WriteFile

	mov		rcx, 0
	call	ExitProcess

main ENDP
END