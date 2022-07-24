;  Comment block below must be filled out completely for each assignment
;  ************************************************************* 
;  Student Name: Nathan Jaggers
;  COMSC-260 Fall 2019
;  Date:9/25/2019
;  Assignment 4
;  Version of Visual Studio used: 2019  
;  Did program compile? Yes
;  Did program produce correct results? Yes
;  Is code formatted correctly including indentation, spacing and vertical alignment? Yes
;  Is every line of code commented? Yes
;
;  Estimate of time in hours to complete assignment: 4 hours
;  In a few words describe the main challenge in writing this program: The main challenge in this program was 
;																	   planning the code and assembling the code for
;																	   the full bit adder. I definitly also had a
;																	   hard time understanding where and how to start
;																	   however after looking at examples and getting 
;																	   basic parts of the display to show up I managed to
;																	   get through it. 
;  
;  Short description of what program does: Takes data from an array and adds up the 
;										   the values like a full bit adder. 
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
									;(default stack size for 32 bit implementation is 1MB without .STACK directive 
									;  - default works for most situations)

.STACK 4096							;allocate 4096 bytes (1000h) for stack


;*******************MACROS********************************

;mPrtStr
;usage: mPrtStr nameOfString
;ie to display a 0 terminated string named message say:
;mPrtStr message

;Macro definition of mPrtStr. Wherever mPrtStr appears in the code
;it will  be replaced with 

mPrtStr  MACRO  arg1				;arg1 is replaced by the name of string to be displayed
         push edx
         mov edx, offset arg1		;address of str to display should be in dx
         call WriteString			;display 0 terminated string
         pop edx
ENDM

;*************************PROTOTYPES*****************************

ExitProcess PROTO,
    dwExitCode:DWORD				;from Win32 api not Irvine to exit to dos with exit code


WriteDec PROTO						;Irvine code to write number stored in eax
									;to console in decimal

ReadChar PROTO						;Irvine code for getting a single char from keyboard
									;Character is stored in the al register.
									;Can be used to pause program execution until key is hit.

WriteChar PROTO						;write the character in al to the console

WriteString PROTO					;Irvine code to write null-terminated string to output
									;EDX points to string

;************************  Constants  ***************************

    LF         equ     0Ah			; ASCII Line Feed
    
;************************DATA SEGMENT***************************

.data
;					0,1,2,3,4,5,6,7
    inputAnum  byte 0,0,0,0,1,1,1,1
    inputBnum  byte 0,0,1,1,0,0,1,1
    carryInNum byte 0,1,0,1,0,1,0,1
    ARRAY_SIZE equ $-carryInNum         
    ;The '$' acts as a place maker where you are currently in memory
    ;which at the end of the carryInNum array.
    ;The ending address of the carryInNum array minus the beginning
    ;address equals the total bytes of the carryInNum array
    ;which is stored in the ARRAY_SIZE constant.
    ;NOTE: there can be no other variables between the 
    ;declation of the ARRAY_SIZE constant and the declaration
    ;of the array you are trying to calculate the size of.

    ;You can add LFs to the strings below for proper output line spacing
    ;but do not change anything between the quotes "do not change".

    ;I will be using a comparison program to compare your output to mine and
    ;the spacing must match exactly.

    endingMsg           byte LF,LF,"Hit any key to exit!",0

    titleMsg            byte "Program 4 by Nathan Jaggers",LF,0

    testingAdderMsg     byte LF," Testing Adder",0

	inputA              byte LF,LF,"   Input A: ",0
    inputB              byte LF,"   Input B: ",0
    carryin             byte LF,"  Carry in: ",0
    sum                 byte LF,"       Sum: ",0
    carryout            byte LF," Carry Out: ",0

    dashes              byte LF," ------------",0

;************************CODE SEGMENT****************************

.code

main PROC
	
	mPrtStr		titleMsg			;print string in titleMsg

	mPrtStr		dashes				;print string in dashes
	mPrtStr		testingAdderMsg		;print string in testingAdderMsg
	mPrtStr		dashes				;print string in dashes

	mov			esi, 0				;esi = 0
loopTop:							;enter loop
	cmp			esi, ARRAY_SIZE		;compare esi to ARRAY_SIZE
	jae			DONE				;if esi is above or equal array value (7),
									;jump out of loop

	movzx		eax,inputAnum[esi]	;eax = inputAnum[esi]
									;value stored at array index
	mPrtStr		inputA				;print string in dashes
	call		WriteDec			;prints out current contents of eax

	movzx		eax,inputBnum[esi]	;eax = inputAnum[esi]
									;value stored at array index
	mov			ebx,eax				;ebx = eax
	mPrtStr		inputB				;print string in dashes
	call		WriteDec			;prints out current contents of eax

	movzx		eax,carryInnum[esi]	;eax = inputAnum[esi]
									;value stored at array index
	mov			ecx,eax				;ecx = eax
	mPrtStr		carryin				;print string in dashes
	call		WriteDec			;prints out current contents of eax

	movzx		eax,inputAnum[esi]  ;restore eax to inputAnum[esi]
	mPrtStr		dashes				;print string in dashes

	call		Adder				;calls adder function

	mPrtStr		sum					;print string in dashes
	call		WriteDec			;prints out current contents of eax

	mPrtStr		carryout			;print string in dashes
	mov			eax,ecx				;eax = ecx
	call		WriteDec			;prints out current contents of eax
	
	inc			esi					;esi = esi + 1
	jmp			loopTop				;repeat loop

DONE:								;exit loop
	mPrtStr		endingMsg			;print string in endingMsg

	call		ReadChar			;stop program to view output
	INVOKE		ExitProcess,0		;exit program

main ENDP

;************** Adder – Simulate a full Adder circuit  
;  Adder will simulate a full Adder circuit that will add together 
;  3 input bits and output a sum bit and a carry bit
;
;    Each input and output represents one bit.
;
;  Note: do not access the arrays in main directly in the Adder function. 
;        The data must be passed into this function via the required registers below.
;
;       ENTRY - EAX = input bit A 
;               EBX = input bit B
;               ECX = Cin (carry in bit)
;       EXIT  - EAX = sum bit
;               ECX = carry out bit
;       REGS  - EAX, EBX, ECX, EDX
;
;       For the inputs in the input columns you should get the 
;       outputs in the output columns below:
;
;        input                  output
;     eax  ebx   ecx   =      eax     ecx
;      A  + B +  Cin   =      Sum     Cout
;      0  + 0 +   0    =       0        0
;      0  + 0 +   1    =       1        0
;      0  + 1 +   0    =       1        0
;      0  + 1 +   1    =       0        1
;      1  + 0 +   0    =       1        0
;      1  + 0 +   1    =       0        1
;      1  + 1 +   0    =       0        1
;      1  + 1 +   1    =       1        1
;
;   Note: the Adder function does not do any output. 
;         All the output is done in the main function.
;
;Do not change the name of the Adder function.
;
;See additional specifications for the Adder function on the 
;class web site.
;
;You should use AND, OR and XOR to simulate the full adder circuit.
;
;You should save any registers whose values change in this function 
;using push and restore them with pop.
;
;The saving of the registers should
;be done at the top of the function and the restoring should be done at
;the bottom of the function.
;
;Note: do not save any registers that return a value (ecx and eax).
;
;Each line of the Adder function must be commented and you must use the 
;usual indentation and formating like in the main function.
;
;Don't forget the "ret" instruction at the end of the function
;
;Do not delete this comment block. FA19 Every function should have 
;a comment block before it describing the function. 


Adder proc							;start of function
	push	ebx						;save main value of ebx on stack
	push	edx						;save main value of edx on stack

	mov		edx,eax					;edx = eax
	xor		eax,ebx					;exclusive-or between eax and ebx 
									;stored in eax
	and		ebx,edx					;and between ebx and edx(eax)
									;stored in ebx
	mov		edx,eax					;edx = eax
	xor		eax,ecx					;exclusive-or between eax and ecx 
									;stored in eax (now holds sum)
	and		ecx,edx					;and between ecx and edx(eax)
									;stored in ecx
	or		ecx,ebx					;or between ecx and ebx
									;stored in ecx (now holds carry)

	pop		edx						;restore main value of edx from stack
	pop		ebx						;restore main value of ebx from stack

	ret								;return to main function	
									;pop from stack return address

Adder endp							;end of function

END main
