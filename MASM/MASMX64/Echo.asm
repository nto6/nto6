option casemap:none

extrn GetStdHandle	:PROC		;Lay handle chuan cho input/output
extrn WriteFile		:PROC		;ghi du lieu ra file/console
extrn ReadFile		:PROC		;Doc du lieu ra file/console
extrn ExitProcess	:PROC

.data
	Ip		db "Ip: ", 0Ah, 0h

.data?
	HiHi	dd ?
	Op		dd 50 dup(?)
.code 
main PROC
	mov		rbp, rsp
	sub		rsp, 28h

	mov		rcx, -11			
	call	GetStdHandle		
	xor		rbx, rbx
	mov		rcx, rax			
	mov		rdx, offset Ip		
	mov     r8, 4		
	mov		r9, offset HiHi	
	mov		[rsp + 20h], rbx	
	call	WriteFile

	mov		rcx, -10			;handle tu GetStdHandle
	call	GetStdHandle		;return handle rax
	xor		rbx, rbx
	mov		rcx, rax			;Std_Input_Handle
	mov		rdx, offset Op		;dia chi bufer
	mov     r8, 50				;so byte doc toi da  
	mov		r9, offset HiHi		;pointer so byte doc thuc te
	mov		[rsp + 20h], rbx	;Null ,cho shadow space + tham so stack thu 5 (Overlapped)
	call	ReadFile

	mov		rcx, -11			
	call	GetStdHandle	
	xor		rbx, rbx
	mov		rcx, rax			
	mov		rdx, offset Op		
	mov     r8, sizeof Op		
	mov		r9, offset HiHi	
	mov		[rsp + 20h], rbx	
	call	WriteFile

	mov		rcx, 0
	call	ExitProcess

main ENDP
END