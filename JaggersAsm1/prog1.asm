;  Comment block below must be filled out completely for each assignment
;  ************************************************************* 
;  Student Name: Nathan Jaggers
;  COMSC-260 Fall 2019
;  Date:8/28/2019
;  Assignment 1
;  Version of Visual Studio used: 2019  
;  Did program compile? Yes
;  Did program produce correct results? Yes
;  Is code formatted correctly including indentation, spacing and vertical alignment? Yes
;  Is every line of code commented? Yes
;
;  Estimate of time in hours to complete assignment:  3.5 hours
;
;  In a few words describe the main challenge in writing this program:	Getting add.asm to compile so I could
;																		use it as a skeleton 
;  
;  Short description of what program does:	Assigns hex, binary and decimal values to variables and registrars, 
;											then performs arithmatic with them 
;
;
;  *************************************************************
;  Reminder: each assignment should be the result of your
;  individual effort with no collaboration with other students.
;
;  Reminder: every line of code must be commented and formatted  
;  per the ProgramExpectations.pdf file on the class web site
; *************************************************************


.386								;identifies minimum CPU for this program

.MODEL flat,stdcall					;flat - protected mode program
									;stdcall - enables calling of MS_windows programs

;allocate memory for stack

.STACK 4096							;allocate 4096 bytes (1000h) for stack

;*************************PROTOTYPES*****************************

ExitProcess PROTO,dwExitCode:DWORD  ;from Win32 api not Irvine

ReadChar PROTO						;Irvine code for getting a single char from keyboard
									;Character is stored in the al register.
									;Can be used to pause program execution until key is hit.


WriteHex PROTO                      ;Irvine function to write a hex number in EAX to the console


;************************DATA SEGMENT***************************

.data

    num1    word   0feedh			;num1 = 0feedh
    num2    word   0badeh			;num2 = 0badeh

;************************CODE SEGMENT****************************

.code

main PROC

    mov     ebx, 0ddddffffh			;ebx = 0ddddffffh
    mov     eax, 0ddddffffh			;eax = 0ddddffffh
	mov		ecx, 0ddddffffh			;ecx = 0ddddffffh
    mov     edx, 0e2b5fadeh			;edx = 0e2b5fadehh
	mov		bh,	 11110101b			;bh  = 11110101b
    mov     bl,  251				;bl  = 251 
	mov		cx,	 0ffa5h				;cx  = 0ffa5h

	movzx	eax, cx					;eax = cx 
	
	movzx	esi, num1				;esi = num1
	add		eax, esi				;eax = eax + esi
	
	movzx	esi, num2				;esi = num2
	sub		eax, esi				;eax = eax - esi

	add		eax, edx				;eax = eax + edx

	movzx	esi, bl					;esi = bl
	add		eax, esi				;eax = eax + esi

	movzx	esi, bh					;esi = bh 
	sub		eax, esi				;eax = eax + esi

	call	WriteHex				;print hex stored in eax

    call    ReadChar				;Pause program execution while user inputs a non-displayed char
	INVOKE	ExitProcess,0			;exit to dos: like C++ exit(0)

main ENDP
END main