;  Comment block below must be filled out completely for each assignment
;  ************************************************************* 
;  Student Name: Nathan Jaggers
;  COMSC-260 Fall 2019
;  Date:11/30/2019
;  Assignment 09
;  Version of Visual Studio used: 2019  
;  Did program compile? Yes
;  Did program produce correct results? Yes
;  Is code formatted correctly including indentation, spacing and vertical alignment? Yes
;  Is every line of code commented? Yes
;
;  Estimate of time in hours to complete assignment: 2.5 hours
;  In a few words describe the main challenge in writing this program:	Setting up the program for 64 bit programing was the 
;																		most difficult. I definitly spent half an hour to maybe
;																		a whole hour on this part alone.
;  
;  Short description of what program does:	This program uses arithmetic operaters as well as library functions
;										    and macros to print out the result of the stated equation. It also pauses
;											the program with a message box and a quote for you to read and ponder about.
;
;
;
;  *************************************************************
;  Reminder: each assignment should be the result of your
;  individual effort with no collaboration with other students.
;
;  Reminder: every line of code must be commented and formatted  
;  per the ProgramExpectations.pdf file on the class web site
; *************************************************************

;*************************PROTOTYPES*****************************
	ExitProcess		PROTO		;from Win64 api not Kennedy
	DspChar			PROTO       ;Display the character in rcx to the console
    DspHex			PROTO       ;Display the unsigned decimal number in rcx to the console
    DspStr			PROTO       ;Display a zero terminated string to the console. Str address in rcx 

	MessageBoxA		PROTO		;MessageBoxA takes 4 parameters: 
								;  1. window owner handle (rcx)
								;  2. message address (zero terminated string) (rdx)
								;  3. title address(zero terminated string) (r8)   
								;  4. which button(s) to display (r9)

;*************************MACROS********************************
mPrtChar  MACRO  arg1		  ;arg1 is replaced by the name of character to be displayed
         push rcx			  ;save rcx
         mov rcx, arg1		  ;character to display should be in rcx
         call DspChar		  ;display character in rcx
         pop rcx			  ;restore rcx
ENDM

mPrtStr macro   arg1          ;arg1 is replaced by the name of character to be displayed
         push rcx             ;save rcx
         mov rcx, offset arg1 ;string to display should be in rcx
         call DspStr		  ;display character in rcx
         pop rcx              ;restore rcx
ENDM

mPrtHex macro   arg1          ;arg1 is replaced by the name of character to be displayed
         push rcx             ;save rcx
         mov rcx, arg1		  ;hex number to display should be in rcx
         call DspHex		  ;display character in rcx
         pop rcx              ;restore rcx
ENDM

;************************DATA SEGMENT***************************

.data
	
	num1		qword	98A8412CBB7FB8h		;num1 =	98A8412CBB7FB8h	
	num2		qword	254h				;num2 =	254h			
	num3		qword	0FAB12534FFDD2547h	;num3 =	0FAB12534FFDD2547h	
	num4		qword	0BCD7A25A9h			;num4 =	0BCD7A25A9h		
	num5		qword	0CF2D1A293494h		;num5 =	0CF2D1A293494h	
	num6		qword	23B46Bh				;num6 =	23B46Bh		
	num7		qword	1F514ABCh			;num7 =	1F514ABCh	
		;create zero terminated strings

	authorMsg	db	"Program 9 by Nathan Jaggers", 0
	quoteMsg	db  '"',"Sometimes it is the people no one can imagine anything of who do the things no one can imagine",'"'," Alan Turing", 0

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
	sub		rsp, 28h					;align the stack on a 16 byte boundary

	mPrtHex num1						;print hex stored in num1
	
	mPrtStr hPlus						;print string stored in hPlus

	mPrtHex num1						;print hex stored in num2

	mPrtStr hStrPrn						;print string stored in hStrPrn

	mPrtHex num3						;print hex stored in num3

	mPrtStr hMod						;print string stored in hMod	

	mov		rdx, 0						;rdx = 0 
	mov		rax, num3					;rcx = num3
	div		num4						;rdx:rax / num4 => quotient in rax, remainder in rdx
										;num3 % num4
	mov		rax,num2					;rax = num2
	mul		rdx							;rax * rdx => product in rdx:rax
										;num2 * (num3 % num4)
	mov		rcx,rax						;rcx = rax

	mPrtHex num4						;print hex stored in num4

	mPrtStr hPrnMin						;print string stored in hPrnMin

	mPrtHex num5						;print hex stored in num5

	mPrtStr hDiv						;print string stored in hDiv

	mov		rdx,0						;rdx = 0
	mov		rax,num5					;rax = num5
	div		num6						;rdx:rax / num6 => quotient in rax, remainder in rdx
										;num5 / num6

	add		num1,rcx					;num1 = num1 + rcx
										;num1 + ( num2 * (num3 % num4) )

	sub		num1,rax					;num1 = num1 - rax
										;( num1 + num2 * (num3 % num4) )-( num5 / num6 )

	mPrtHex num6						;print hex stored in num6

	mPrtStr hMin						;print string stored in hMin	

	mPrtHex num7						;print hex stored in num7

	mPrtStr hEqu						;print string stored in hEqu

	mov		rcx,num1					;rcx = num1
	sub		rcx,num7					;rcx = rcx - num7
										;( num1 + num2 * (num3 % num4))- num5 / num6 ) - num7	
	call	DspHex						;print hex stored in rcx
	mPrtChar 'h'						;print h character

	mov		rcx, 0						; A handle to the owner window of the message box to be created. 
	lea		rdx, quoteMsg				; The message to be displayed in message box
	lea		r8,  authorMsg				; The message box title
	mov		r9d, 0						; 0 = display ok button

	call	MessageBoxA					;call message box function
	mov     rcx, 0                      ;exit condition = 0 (success)
    call    ExitProcess                 ;exit to os

main ENDP
END