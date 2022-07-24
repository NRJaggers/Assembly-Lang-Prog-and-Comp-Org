;  Comment block below must be filled out completely for each assignment
;  ************************************************************* 
;  Student Name: Nathan Jaggers
;  COMSC-260 Fall 2019
;  Date:10/14/2019
;  Assignment 5
;  Version of Visual Studio used: 2019  
;  Did program compile? Yes
;  Did program produce correct results? Yes
;  Is code formatted correctly including indentation, spacing and vertical alignment? Yes
;  Is every line of code commented? Yes
;
;  Estimate of time in hours to complete assignment: 7 hours 30 min
;  In a few words describe the main challenge in writing this program:	This program was a challenge. I remember at the beginning
;																		not knowing where to start, so like the last program I got
;																		the easy  stuff out of the way like putting in the data,
;																		constants, and printing out program 5 and my name. I think
;																		that knowing this assignment was going to be a lot of work 
;																		made it more daunting. However after getting going, it doesn't 
;																		seem as bad. I definitly struggled with the jumps to decide 
;																		what function to use as well as how to deal with overflow.
;																		Also it was hard when I was just forgetting one small thing 
;																		like sign extention that made a big difference in the division 
;																		section of my output.
;  
;  Short description of what program does:	Program performs various signed arithmetic based 
;											on data from an arrays holding operands and operators.
;
;
;  *************************************************************
;  Reminder: each assignment should be the result of your
;  individual effort with no collaboration with other students.
;
;  Reminder: every line of code must be commented and formatted  
;  per the ProgramExpectations.pdf file on the class web site
; *************************************************************


.386      ;identifies minimum CPU for this program

.MODEL flat,stdcall    ;flat - protected mode program
                       ;stdcall - enables calling of MS_windows programs

;allocate memory for stack
;(default stack size for 32 bit implementation is 1MB without .STACK directive 
;  - default works for most situations)

.STACK 4096            ;allocate 4096 bytes (1000h) for stack

;*******************MACROS********************************

;mPrtChar - used to print single characters
;usage: mPrtChar character
;ie to display a 'm' say:
;mPrtChar 'm'


mPrtChar  MACRO  arg1					 ;arg1 is replaced by the name of character to be displayed
         push eax						 ;save eax
         mov al, arg1					 ;character to display should be in al
         call WriteChar					 ;display character in al
         pop eax						 ;restore eax
ENDM

;mPrtStr
;usage: mPrtStr nameOfString
;ie to display a 0 terminated string named message say:
;mPrtStr message

;Macro definition of mPrtStr. Wherever mPrtStr appears in the code
;it will  be replaced with 

mPrtStr  MACRO  arg1					 ;arg1 is replaced by the name of string to be displayed
         push edx						 
         mov edx, offset arg1			 ;address of str to display should be in dx
         call WriteString				 ;display 0 terminated string
         pop edx
ENDM

;*************************PROTOTYPES*****************************

ExitProcess PROTO,
    dwExitCode:DWORD					 ;from Win32 api not Irvine to exit to dos with exit code
										 
ReadChar PROTO							 ;Irvine code for getting a single char from keyboard
										 ;Character is stored in the al register.
										 ;Can be used to pause program execution until key is hit.						 
WriteChar PROTO							 ;write the character in al to the console
										 
WriteString PROTO						 ;Irvine code to write null-terminated string to output
										 ;EDX points to string

                        
;************************  Constants  **************************

    LF			equ     0Ah				 ; ASCII Line Feed
	$parm1		EQU DWORD PTR [ebp + 8]  ;parameter 1
	$parm2		EQU DWORD PTR [ebp + 12] ;parameter 2

;************************DATA SEGMENT***************************

.data

	operand1	dword   -2147483600,-2147483648,-2147482612,-5, -2147483648,1062741823,2147483647,2147483547, 0, -94567 ,4352687,-2147483648,-249346713,-678, -2147483643,32125, -2147483648, -2147483648
	operators	byte    '-','-', '+','*','*', '*', '+', '%', '/',  '/', '+', '-','/', '%','-','*','/', '+'
	operand2	dword    -200,545,12, 2, -8, 2, 10, -5635, 543,   383, 19786, 150,43981, 115,5,31185,365587,-10
	ARRAY_SIZE  equ     ($ - operand2)
	;The ARRAY_SIZE constant should be defined immediately after the operand2 array 
	;otherwise the value contained in it will not be correct.


	titleMsg    byte	"Program 4 by Nathan Jaggers",LF,LF,0
	equals		byte	" = ",0
	linefeed	byte	LF,0 ; delete after done with program and anything associated

	;Use the following messages if overflow is detected.
	;Do not change the messages between the quotes.
	posOF		byte    "+++Positive Overflow Error+++",0
	negOF		byte    "---Negative Overflow Error---",0
	multOF		byte    "***Multiplication Overflow***",0

;************************CODE SEGMENT****************************

.code

Main PROC
	mPrtStr		titleMsg				 ;macro prints string in titleMsg
										 
	mov			ecx, 0					 ;ecx = 0
	mov			ebx, 0					 ;ebx = 0
										 
looptop:								 
										 
	cmp			ecx, ARRAY_SIZE			 ;ecx - ARRAY_SIZE
	jae			Done					 ;if ecx > ARRAY_SIZE, then jump to Done
										 
	mov			eax, operand1[ecx]		 ;eax = operand at index ecx
	call		DspDword				 ;call function to display operand
	mPrtChar	' '						 ;macro prints space
										 
	mPrtChar	operators[ebx]			 ;macro prints operator at index ebx
	mPrtChar	' '						 ;macro prints space
										 
	mov			eax, operand2[ecx]		 ;eax = operand at index ecx
	call		DspDword				 ;call function to display operand
	mPrtStr		equals					 ;macro prints string in equals
										 
	push		operand2[ecx]			 ;push operand2 onto the stack
	push		operand1[ecx]			 ;push operand1 onto the stack
										 
	cmp			operators[ebx],'-'		 ;if operator is - doSub
	jne			else1					 ;if not test for next operator
	call		doSub					 ;call do doSub
	jno			printResult				 ;test for overflow
	jmp			overflow				 ;if overflow, jump to it	
else1:									 
	cmp			operators[ebx],'+'		 ;if operator is + doAdd
	jne			else2					 ;if not test for next operator
	call		doAdd					 ;call do doAdd
	jno			printResult				 ;test for overflow
overflow:								 ;if overflow:
	js			other					 ;if answer is negative then print positive overflow
	mPrtStr		negOF					 ;else print negative overflow
	jmp			continue				 ;jump to continue
other:									 ;positive overflow:
	mPrtStr		posOF					 ;print positive overflow
	jmp			continue				 ;jump to continue
										 
else2:									 
	cmp			operators[ebx],'*'		 ;if operator is * doMult
	jne			else3					 ;if not test for next operator
	call		doMult					 ;call do doMult
	jno			printResult				 ;jump to printResult
	mPrtStr		multOF					 ;macro prints string in multOF
	jmp			continue				 ;jump to continue
else3:									 
	call		doDiv					 ;division between two operands
	cmp			operators[ebx],'%'		 ;if operator is / print quotient
	jne			printResult				 ;if not, then its % and jump to print remainder
	mov			eax,edx					 ;eax = edx
	jmp			printResult				 ;jump to print result
										 
printResult:							 
	call		DspDword				 ;call function to display result
										 
continue:								 
	mPrtChar	LF						 ;macro prints line feed
	inc			ebx						 ;increment ebx 
	add			ecx, 4					 ;ecx = ecx + 4
	jmp			looptop					 ;jump to loop top
										 
Done:									 
										 
    call		ReadChar                 ;pause execution
	INVOKE		ExitProcess,0            ;exit to dos: like C++ exit(0)

Main ENDP

;************** DspDword - display DWORD in decimal
;
;
;       ENTRY - eax contains unsigned number to display
;       EXIT  - none
;       REGS  - EAX,EBX,EDX,edi,EFLAGS
;
;       To call DspDword: populate eax with number to print then call DspDword
;
;           mov  eax, 8954
;           call DspDword
;           
;
;       DspDword was originally written by Paul Lou and Gary Montante to display a
;       64 bit number and to use stack parameters.
;       It was modified to pass a parameter via register and to 
;       work with 32 bits and Irvine library by Fred Kennedy FA19
;       
;
;-------------- Input Parameters
        
    ;byte array beginning = ebp - 1
    ;ebp           ebp + 0
    ;ret address   ebp + 4
    

    ; 0FDCh | eax            [ebp - 28] <--ESP
    ; 0FE0h | edx            [ebp - 24]
    ; 0FE4h | ebx            [ebp - 20]
    ; 0FE8h | edi            [ebp - 16]
    ; 0FECh |  ?             [ebp - 12]
    ; 0FEDh |  ?             [ebp - 11]
    ; 0FEEh | '0'            [ebp - 10]
    ; 0FEFh | '0'            [ebp - 9]
    ; 0FF0h | '0'            [ebp - 8]
    ; 0FF1h | '0'            [ebp - 7]
    ; 0FF2h | '0'            [ebp - 6]
    ; 0FF3h | '0'            [ebp - 5]
    ; 0FF4h | '8'            [ebp - 4]
    ; 0FF5h | '9'            [ebp - 3]
    ; 0FF6h | '5'            [ebp - 2]
    ; 0FF7h | '4'            [ebp - 1]
    ; 0FF8h | ebp            [ebp + 0]  <--EBP
    ; 0FFCh | return address [ebp + 4]
    ; 1000h | 




    ;digits are peeled off and put on stack in reverse order (right to left)
    
DspDword proc
    push     ebp						 ;save ebp to stack
    mov      ebp,esp					 ;save stack pointer
    sub      esp,12						 ;allocate 12 bytes for byte array
										 ;note: must be an increment of 4
										 ;otherwise WriteChar will  not work
    push     edi						 ;save edi to stack
    push     ebx						 ;save ebx to stack
    push     edx						 ;save edx to stack
    push     eax						 ;save eax to stack
										 
    mov      edi,-1						 ;edi = offset of beginning of byte array from ebp 
    mov 	 ebx,10						 ;ebx = divisor for peeling off decimal digits
										 
	or		 eax,eax					 ;or instruction used to set sign flag if number is negative
	jns		 next_digit					 ;if eax is positive, jump to next_digit
	mPrtChar '-'						 ;macro to print out '-' for negative number
	neg		 eax						 ;twos complement of number in eax

;each time through loop peel off one digit (division by 10),
;(the digit peeled off is the remainder after division by 10)
;convert the digit to ascii and store the digit on the stack
;in reverse order: 8954 stored as 4598
next_digit:
    mov      edx,0						 ; before edx:eax / 10, set edx to 0 
    div      ebx						 ; eax = quotient = dividend shifted right
										 ; edx = remainder = digit to print.
										 ; next time through loop quotient becomes
										 ; new dividend.
    add      dl,'0'						 ; convert digit to ascii character: i.e. 1 becomes '1'
    mov      [ebp+edi],dl				 ; Save converted digit to buffer on stack
    dec      edi						 ; Move down in stack to next digit position
    cmp      edi, -10					 ; only process 10 digits
    jge      next_digit					 ; repeat until 10 digits on stack
										 ; since working with a signed number, use jge not jae
										 
    inc      edi						 ; when above loop ends we have gone 1 byte too far
										 ; so back up one byte

;loop to display all digits stored in byte array on stack
DISPLAY_NEXT_DIGIT:      
    cmp      edi,-1						 ; are we done processing digits?
    jg       DONE10						 ; repeat loop as long as edi <= -1
    mPrtChar byte ptr[ebp+edi]			 ; print digit
    inc      edi						 ; edi = edi + 1: if edi = -10 then edi + 1 = -9
    jmp      DISPLAY_NEXT_DIGIT			 ; repeat
DONE10:									 
    									 
    pop      eax						 ; eax restored to original value
    pop      edx						 ; edx restored to original value
    pop      ebx						 ; ebx restored to original value
    pop      edi						 ; edi restored to original value
										 
    mov      esp,ebp					 ;restore stack pointer which removes local byte array
    pop      ebp						 ;restore ebp to original value
    ret
DspDword endp

;************** doSub - dword subtraction
;
; ENTRY - operand 1 and operand 2 are pushed on the stack
;
; EXIT -EAX = result (operand 1 - operand 2)
; REGS - ebp, esp, eax
;
; note: Before calling doSub push operand 2 onto the stack and then push operand 1.
;
; to call doSub in main function:
; push 2 ;32 bit operand2
; push 10 ;32 bit operand1
; call doSub ;10 – 2 = 8 (answer in eax)
;
; Remove parameters by using ret 8 rather than just ret at the end of this function
;--------------
doSub PROC
;required code at top
	push	ebp							 ;push ebp on the stack 
	mov		ebp,esp						 ;ebp = esp , ebp used to navigate stack
;add code to save registers if any
										 
	mov		eax, $parm1					 ;eax = $parm1
										 
	neg		$parm2						 ;2's complement of $parm2
	add		eax, $parm2					 ;eax = eax + ebx

;and the following code at the bottom
;add code to restore saved registers if any
	pop		ebp							 ;restore value of ebp
	ret 8								 ;return to main and increment stack by 8
doSub ENDP


;************** doAdd - dword addition
;
; ENTRY – operand 1 and operand 2 are on the stack
;
; EXIT - EAX = result (operand 1 + operand 2) (any carry is ignored so the answer must fit in 32 bits)
; REGS - ebp, esp, eax
;
; note: Before calling doAdd push operand 2 onto the stack and then push operand 1.
;
;
; to call doAdd in main function:
; push 9 ;32 bit operand2
; push 1 ;32 bit operand1
; call doAdd ;1 + 9 = 10 (answer in eax)
;
; Remove parameters by using ret 8 rather than just ret at the end of this function
;
;--------------
doAdd PROC
;required code at top
	push	ebp							 ;push ebp on the stack 
	mov		ebp,esp						 ;ebp = esp , ebp used to navigate stack
;add code to save registers if any

	mov		eax, $parm1					 ;eax = $parm1
	add		eax, $parm2					 ;eax = $parm2

;and the following code at the bottom;
;add code to restore saved registers if any
	pop		ebp							 ;restore value of ebp
	ret 8								 ;return to main and increment stack by 8
doAdd ENDP


;************** doMult - signed dword multiplication
;
; ENTRY - operand 1 and operand 2 are on the stack
;
; EXIT - EDX:EAX = result (operand 1 * operand 2)
; (for this assignment the product is assumed to fit in EAX and EDX is ignored)
;
; REGS - ebp, esp, eax, edx
;
; note: Before calling doMult push operand 2 onto the stack and then push operand 1.
;
; to call doMult in main function:
; push 2 ;32 bit operand2
; push 6 ;32 bit operand1
; call doMult ; 6 * 2 = 12 (answer in eax)
;
; Remove parameters by using ret 8 rather than just ret at the end of this function
;--------------
doMult PROC
;required code at top
	push	ebp							 ;push ebp on the stack 
	mov		ebp,esp						 ;ebp = esp , ebp used to navigate stack
;add code to save registers if any		 
										 
	mov		eax, $parm1					 ;eax = $parm1
	imul	$parm2						 ;eax = eax * $parm2
										 

;and the following code at the bottom;
;add code to restore saved registers if any
	pop		ebp							 ;restore value of ebp
	ret 8								 ;return to main and increment stack by 8
doMult ENDP


;************** doDiv - signed dword / dword division
;
; ENTRY - operand 1(dividend) and operand 2(divisor) are on the stack
;
; EXIT - EAX = quotient
; EDX = remainder
; REGS - ebp, esp, eax, edx
;
; note: Before calling doDiv push operand 2(divisor) onto the stack and then push operand 1(dividend).
;
; to call doDiv in main function:
; push 4 ;32 bit operand2 (Divisor)
; push 19 ;32 bit operand1 (Dividend)
; call doDiv ;19/ 4 = 4 R3(4 = quotient in eax, 3 = remainder in edx )
;
; Remove parameters by using ret 8 rather than just ret at the end of this function
;--------------
doDiv PROC
;required code at top
	push	ebp							 ;push ebp on the stack 
	mov		ebp,esp						 ;ebp = esp , ebp used to navigate stack
;add code to save registers if any		 
										 
	mov		eax, $parm1					 ;eax = $parm1
	cdq									 ;edx = sign extend of eax
	idiv	$parm2						 ;edx:eax / $parm2

;and the following code at the bottom;
;add code to restore saved registers if any
	pop		ebp							 ;restore value of ebp
	ret 8								 ;return to main and increment stack by 8
doDiv ENDP


END Main