;  Comment block below must be filled out completely for each assignment
;  ************************************************************* 
;  Student Name: Nathan Jaggers
;  COMSC-260 Fall 2019
;  Date:9/9/2019
;  Assignment 2
;  Version of Visual Studio used: 2019  
;  Did program compile? Yes
;  Did program produce correct results? Yes
;  Is code formatted correctly including indentation, spacing and vertical alignment? Yes
;  Is every line of code commented? Yes
;
;  Estimate of time in hours to complete assignment: 9/11 200min so far,  time: 5:10	
;  In a few words describe the main challenge in writing this program: Planning the code to be most efficient and 
;																	   integrating the Write commands with the 
;																	   evaluation of the equation at different steps.
;  
;  Short description of what program does: This program uses arithmetic	operaters as well as
;										   library functions to print out an equation and its result.
;
;
;  *************************************************************
;  Reminder: each assignment should be the result of your
;  individual effort with no collaboration with other students.
;
;  Reminder: every line of code must be commented and formatted  
;  per the ProgramExpectations.pdf file on the class web site
; *************************************************************


.386									;identifies minimum CPU for this program

.MODEL flat,stdcall						;flat - protected mode program
										;stdcall - enables calling of MS_windows programs

										;allocate memory for stack

.STACK 4096								;allocate 4096 bytes (1000h) for stack

;*************************PROTOTYPES*****************************

WriteHex		PROTO					;write the number stored in eax to the console as a hex number
										;before calling WriteHex put the number to write into eax

WriteString		PROTO					; write null-terminated string to console
										; edx contains the address of the string to write
										; before calling WriteString put the address of the string to write into edx
										; e.g. mov edx, offset message 
										;address of message is copied to edx

ExitProcess		PROTO,dwExitCode:DWORD	; exit to the operating system

ReadChar		PROTO					;Irvine code for getting a single char from keyboard
										;Can be used to pause program execution until key is hit.
										;Character is stored in the al register.

WriteChar		PROTO					;Irvine code for printing a single char to the console.
										;Character to be printed must be in the al register.

;************************ Constants ***************************

	LF			equ		0Ah				;ASCII Line Feed

;************************DATA SEGMENT***************************

.data
	
	num1		dword	0CB7FB84h		;num1 =	0CB7FB84	
	num2		dword	547h			;num2 =	547			
	num3		dword	0F56A2C57h		;num3 =	0F56A2C57	
	num4		dword	0B46Bh			;num4 =	0B46B		
	num5		dword	0CB7A25A9h		;num5 =	0CB7A25A9	
	num6		dword	0D3494h			;num6 =	0D3494		
	num7		dword	1514ABCh		;num7 =	1514ABC		

		;create strings with embedded line feeds

	authorMsg	byte	"Program 2 by Nathan Jaggers", LF, LF, 0
	endingMsg	byte	'h',LF, LF, "Hit any key to exit!" , 0

	hPlus		byte	"h+",	0		;hPlus = "h+"
	hStrPrn		byte	"h*(",	0		;hStrPrn = "h*("
	hPrnMin		byte	"h)-",	0		;hPrnMin = "h)-"
	hMod		byte	"h%",	0		;hMod = "h%"
	hDiv		byte	"h/",	0		;hDiv = "h/"
	hMin		byte	"h-",	0		;hMin = "h-"
	hEqu		byte	"h=",	0		;hEqu = "h="

;************************CODE SEGMENT****************************

.code

main PROC

	mov		edx,offset authorMsg		;edx = address of zero termined string
	call	WriteString					;print string stored in edx

	mov		eax,num1					;eax = num1
	call	WriteHex					;print hex stored in eax
	
	mov		edx,offset hPlus			;edx = address of zero termined string
	call	WriteString					;print string stored in edx

	mov		eax,num2					;eax = num2
	call	WriteHex					;print hex stored in eax

	mov		edx,offset hStrPrn			;edx = address of zero termined string
	call	WriteString					;print string stored in edx

	mov		eax,num3					;eax = num3
	call	WriteHex					;print hex stored in eax

	mov		edx,offset hMod				;edx = address of zero termined string
	call	WriteString					;print string stored in edx

	mov		edx,0						;edx = 0 
	div		num4						;edx:eax / num4 => quotient in eax, remainder in edx
										;num3 % num4
	mov		eax,num2					;eax = num2
	mul		edx							;eax * edx => product in edx:eax
										;num2 * (num3 % num4)
	mov		ecx,eax						;ecx = eax

	mov		eax,num4					;eax = num4
	call	WriteHex					;print hex stored in eax

	mov		edx,offset hPrnMin			;edx = address of zero termined string
	call	WriteString					;print string stored in edx

	mov		eax,num5					;eax = num5
	call	WriteHex					;print hex stored in eax

	mov		edx,offset hDiv				;edx = address of zero termined string
	call	WriteString					;print string stored in edx

	mov		edx,0						;edx = 0
	div		num6						;edx:eax / num6 => quotient in eax, remainder in edx
										;num5 / num6

	mov		esi,num1					;esi = num1
	add		esi,ecx						;esi = esi + ecx
										;num1 + ( num2 * (num3 % num4) )

	sub		esi,eax						;esi = esi - eax
										;( num1 + num2 * (num3 % num4) )-( num5 / num6 )

	mov		eax,num6					;eax = num6
	call	WriteHex					;print hex stored in eax

	mov		edx,offset hMin				;edx = address of zero termined string
	call	WriteString					;print string stored in edx

	mov		eax,num7					;eax = num7
	call	WriteHex					;print hex stored in eax

	mov		edx,offset hEqu				;edx = address of zero termined string
	call	WriteString					;print string stored in edx

	mov		eax,esi						;eax = esi
	sub		eax,num7					;eax = eax - num7
										;( num1 + num2 * (num3 % num4))- num5 / num6 ) - num7	
	call	WriteHex					;print hex stored in eax

	mov		edx,offset endingMsg		;edx = address of zero termined string
	call	WriteString					;print string stored in edx

    call    ReadChar					;Pause program execution while user inputs a non-displayed char
	INVOKE	ExitProcess,0				;exit to dos: like C++ exit(0)

main ENDP
END main