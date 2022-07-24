;  Comment block below must be filled out completely for each assignment
;  ************************************************************* 
;  Student Name: Nathan Jaggers
;  COMSC-260 Fall 2019
;  Date:10/28/2019
;  Assignment 06
;  Version of Visual Studio used: 2019  
;  Did program compile? Yes
;  Did program produce correct results? Yes
;  Is code formatted correctly including indentation, spacing and vertical alignment? Yes
;  Is every line of code commented? Yes
;
;  Estimate of time in hours to complete assignment: 5.5 hours
;  In a few words describe the main challenge in writing this program:	The most difficult part of this program was writing the
;																		DoRightRotate function. It was a lot of pseudo-code to break
;																		down and I really had to get comfortable with the BT instruction.
;  
;  Short description of what program does: This program simulates a 32 bit left rotator
;
;
;  *************************************************************
;  Reminder: each assignment should be the result of your
;  individual effort with no collaboration with other students.
;
;  Reminder: every line of code must be commented and formatted  
;  per the ProgramExpectations.pdf file on the class web site
; *************************************************************

.386						  ;identifies minimum CPU for this program
							  
.MODEL flat,stdcall			  ;flat - protected mode program
							  ;stdcall - enables calling of MS_windows programs

;allocate memory for stack
;(default stack size for 32 bit implementation is 1MB without .STACK directive 
;  - default works for most situations)

.STACK 4096					  ;allocate 4096 bytes (1000h) for stack

;*************************MACROS*****************************
mPrtChar  MACRO  arg1		  ;arg1 is replaced by the name of character to be displayed
         push eax			  ;save eax
         mov al, arg1		  ;character to display should be in al
         call WriteChar		  ;display character in al
         pop eax			  ;restore eax
ENDM


mPrtStr macro   arg1          ;arg1 is replaced by the name of character to be displayed
         push edx             ;save eax
         mov edx, offset arg1 ;character to display should be in al
         call WriteString     ;display character in al
         pop edx              ;restore eax
ENDM

;*************************PROTOTYPES*****************************

ExitProcess PROTO,
    dwExitCode:DWORD		  ;from Win32 api not Irvine to exit to dos with exit code
							  
ReadChar PROTO				  ;Irvine code for getting a single char from keyboard
							  ;Character is stored in the al register.
							  ;Can be used to pause program execution until key is hit.
							  
WriteChar PROTO				  ;Irvine code to write character stored in al to console

WriteString proto

WriteDec proto

;************************  Constants  ***************************

LF       equ     0Ah                   ; ASCII Line Feed
$parm1 equ dword ptr [ebp + 8]
$parm2 equ dword ptr [ebp + 12]

;************************DATA SEGMENT***************************

.data

    ;inputs for testing the Shifter function
    inputA  byte 0,1,0,1,0,1,0,1
    inputB  byte 0,0,1,1,0,0,1,1
    inputC  byte 1,1,1,1,0,0,0,0
    ARRAY_SIZE equ $ - inputC         

    ;numbers for testing DoRightRotate
    nums   dword 10101010101010101010101010101011b
           dword 01010101010101010101010101010101b
           dword 11010101011101011101010101010111b
    NUM_SIZE EQU $-nums               ;total bytes in the nums array

    NUM_OF_BITS EQU SIZEOF(DWORD) * 8 ;Total bits for a dword

    ;You can add LFs to the strings below for proper output line spacing
    ;but do not change anything between the quotes "do not change".
    ;You can also combine messages where appropriate.

    ;I will be using a comparison program to compare your output to mine and
    ;the spacing must match exactly.

    endingMsg				byte "Hit any key to exit!",0

    titleMsg				byte "Program 6 by Nathan Jaggers", LF, LF, 0

    testingShifterMsg		byte "Testing Shifter", LF, 0
    enabledMsg				byte "(Shifting enabled C = 1, Disabled C = 0)", LF, 0

    testingDoRightRotateMsg byte LF, "Testing DoRightRotate", LF,0

    header					byte  "A B C | Output", LF, 0

    original				byte " Original", LF, 0
    disableShift			byte " Disable Rotate", LF,0
    enableShift				byte " Enable Rotate", LF,0
    shiftInst				byte " Rotate Instruction", LF, LF,0
    blankLine				byte LF,LF,0   ;blankLine may not be necessary

    dashes					byte "------------------------------------", LF, 0

;************************CODE SEGMENT****************************

.code

Main PROC

	mPrtStr	titleMsg				;print string in titleMsg

	mPrtStr	testingShifterMsg		;print string in testingShifterMsg
	mPrtStr	enabledMsg				;print string in enabledMsg
	mPrtStr dashes					;print string in dashes
	mPrtStr header					;print string in header

	mov esi, 0						;esi = 0

looptopT1:							; top of TestShifter loop

	cmp	esi, ARRAY_SIZE				;if esi < array size, stay in loop
	jae	TestShifterDone				;if esi >= array size, jump out of loop

	movzx		eax, inputA[esi]	;eax = character at current index in inputA array
	call		WriteDec			;prints number stored in eax
	mPrtChar	' '					;prints space
	movzx		eax, inputB[esi]	;eax = character at current index in inputB array
	call		WriteDec			;prints number stored in eax
	mPrtChar	' '					;prints space
	movzx		eax, inputC[esi]	;eax = character at current index in inputC array
	call		WriteDec			;prints number stored in eax
	mPrtChar	' '					;prints space
	mPrtChar	'|'					;prints vertical line
	mPrtChar	' '					;prints space

	mov			al, inputA[esi]		;al = character at current index in inputA array
	mov			bl, inputB[esi]		;bl = character at current index in inputB array
	mov			cl, inputC[esi]		;cl = character at current index in inputC array
	
	call		Shifter				;call Shifter function

	call		WriteDec			;prints number stored in eax
	mPrtChar	LF					;prints line feed
	
	inc esi							;esi = esi + 1
	jmp	looptopT1					;jump to top of loop

TestShifterDone:

	mPrtStr testingDoRightRotateMsg ;print string in testingDoRightRotateMsg
	mPrtStr dashes					;print string in dashes

	mov	ecx, 0						;ecx = 0 

looptopT2:							;top of TestRightRot loop

	cmp		ecx, NUM_SIZE			;compare ecx and NUM_SIZE
	je		TestRightRotDone		;if equal, jump out of loop

	push	nums[ecx]				;push nums at index ecx onto stack
	call	DspBin					;print binary number
	mPrtStr original				;print string in original

	push	0						;push zero onto stack
	push	nums[ecx]				;push nums at index ecx onto stack
	call	DoRightRotate			;simulate rotate
	push	eax						;push result onto stack
	call	DspBin					;print binary number
	mPrtStr disableShift			;print string in disableShift

	push	1						;push zero onto stack
	push	nums[ecx]				;push nums at index ecx onto stack
	call	DoRightRotate			;simulate rotate
	push	eax						;push result onto stack
	call	DspBin					;print binary number
	mPrtStr enableShift				;print string in enableShift

	mov		eax, nums[ecx]			;eax = nums at index ecx
	ror		eax, 1					;rotate eax right
	push	eax						;push eax onto stack
	call	DspBin					;print binary number
	mPrtStr shiftInst				;print string in shiftInst

	add		ecx, 4					;ecx = ecx + 4
	jmp		looptopT2				;jump to top of loop

TestRightRotDone:

	mPrtStr endingMsg				;print string in endingMsg

    call    ReadChar                ;pause execution
	INVOKE  ExitProcess,0           ;exit to dos: like C++ exit(0)

Main ENDP


;************** DoRightRotate - Shift a dword right by 1
;
;       ENTRY – operand 2 (enable,disable shift) and operand 1 (number to shift) are on the stack
;                         
;       EXIT  - EAX = shifted or non shifted number
;       REGS  - ebp, esp, eax, ebx, ecx, edi, esi
;
;       note: Before calling DoRightRotate push operand 2 onto the stack and then push operand 1.
;
;	    note: DoRightRotate calls the Shifter function to shift 1 bit.
;
;       to call DoRightRotate in main function:
;                                   push  0 or 1            ;1 to shift, 0 to disable shift
;                                   push  numberToShift     ;32 bit operand1
;                                   call DoRightRotate      ;result in eax
;
;       Note; at the end of this function use ret 8 (instead of just ret) to remove the parameters from the stack.
;                 Do not use add esp, 8 in the main function.
;--------------
;Do not access the arrays in main directly in the DoRightRotate function. 
;The data must be passed into this function via the stack.
;Note: the DoRightRotate function does not do any output. All the output is done in the main function
;
;Note: if shifting is disabled ($parm2 = 0) do not hardcode the return value to be
;equal to $parm1. If shifting is disabled you must still process all the bits
;through your Shifter function.
;
;In this function you will examine the bits from operand 1 in order from left to right using the BT instruction.

;See BT.asm on the class web site.

;You will use the BT instruction to copy the bits from operand 1 to the carry flag.
    
;Before the loop you will use the BT instruction to copy bit 0 to the carry flag then use a rotate instruction to copy the
;carry flag to the right end of al. This is to account for the rightmost bit being copied to the left end
;during a right rotate.
    
;Before the loop you will also set bl to the value of bit 31 (NUM_OF_BITS - 1) by using the following method:

;You will use the BT instruction to copy bit 31 (NUM_OF_BITS - 1) to the carry flag then use a rotate instruction to copy the
;carry flag to the right end of bl. Do not hardcode 31. Use NUM_OF_BITS - 1.

;Then you will populate ecx with operand 2 which is the enable (1) or disable bit(0).

;then call the shifter function.

;after calling the shifter function you will transfer the return value from al to 
;the right end of the register you are using to accumulate shifted or non shifted bits which should have been initialized to 0.

;Then you will have a loop that will execute (NUM_OF_BITS - 1) times(31 times).
;You should use 0 as the terminating loop condition.

;The counter for the loop begins at NUM_OF_BITS - 1
;NOTE: you cannot use ecx for the counter since it contains the enable or disable bit.

;In the loop you will do the following:
;clear al and bl
;Use the BT instruction to copy the bit at position of the counter to the carry flag 
;and from the carry flag to the right end of al.

;Then use the BT instruction to copy the bit at position of the counter - 1 to the carry flag 
;and from the carry flag to the right end of bl.

;ecx should still be populated with the value of operand2 assigned before the loop.

;Then call the shifter function

;The bit returned by the Shifter function in eax should be copied to the carry flag using the BT instruction.
;You cannot use the BT instruction on a byte like al. You must use BT on a word (AX) or dword (EAX).

;then copy the bit from the carry flag using a rotate instruction to the right end
;of the register used to accumulate the shifted or non shifted bits.

;after the loop exits make sure the shifted or non shifted bits are in eax

;Each iteration of the loop should process the bits as follows:
    
;al = bit at position counter except when rightmost bit rotated into right end(shifted bit)
;bl = bit a position counter - 1 (original bit)
;
;
;		  Bit #	
;	counter | al  bl
;	    31	|  0  31   (rightmost bit rotated into left end)
;    Above is before loop
;    Below is in loop
;	    31	| 31  30
;	    30	| 30  29
;	    29	| 29  28
;	    28	| 28  27
;	    27	| 27  26
; etc down to bit 0 (when counter is 0, the loop is done)
;        1  |  1   0
;        0  |  done   



;You should save any registers whose values change in this function 
;using push and restore them with pop.
;
;The saving of the registers should
;be done at the top of the function and the restoring should be done at
;the bottom of the function.
;
;Note: do not save any registers that return a value (eax).
;
;Each line of the Shifter function must be commented and you must use the 
;usual indentation and formating like in the main function.
;
;Don't forget the "ret 8" instruction at the end of the function
;
;Do not delete this comment block. Every function should have 
;a comment block before it describing the function. FA18

DoRightRotate proc

;required code at top
	push	ebp							;push ebp on the stack 
	mov		ebp,esp						;ebp = esp , ebp used to navigate stack
;add code to save registers if any
	push	ebx							;push ebx onto stack
	push	ecx							;push ecx onto stack
	push	edx							;push edx onto stack
	push	edi							;push edi onto stack
	push	esi							;push esi onto stack

	bt		$parm1, 0					;copy bit 0 of parameter to carry flag
	rcl		al, 1						;rotate carry flag into right end of al
	bt		$parm1, NUM_OF_BITS - 1		;copy bit 31 of parameter to carry flag
	rcl		bl, 1						;rotate carry flag into right end of bl

	mov		ecx, $parm2					;ecx = operand2

	call	Shifter						;call shifter function

	mov		edx, 0						;edx = 0
	bt		eax, 0						;copy bit 0 of eax to carry flag
	rcl		edx, 1						;rotate carry flag into right end of edx

	mov		edi, NUM_OF_BITS - 1			;edi = NUM_OF_BITS - 1 = 31

bitloop:

	cmp		edi, 0						;compare bh and 0
	je		bitDone						;if equal, jump to bitDone

	xor		al, al						;clear al
	xor		bl, bl						;clear bl
	mov		esi, edi					;esi = edi
	sub		esi, 1						;esi = esi - 1

	bt		$parm1, edi					;copy bit at counter of parameter to carry flag
	rcl		al, 1						;rotate carry flag into right end of al

	bt		$parm1, esi 				;copy bit at counter - 1 of parameter to carry flag
	rcl		bl, 1						;rotate carry flag into right end of bl

	call	Shifter						;call shifter function

	bt		eax, 0						;copy bit 0 of eax to carry flag
	rcl		edx, 1						;rotate carry flag into right end of edx

	dec		edi							;bh = bh - 1
	jmp		bitloop						;jump to top of loop

bitDone:
	mov		eax, edx					; eax = edx

;and the following code at the bottom
;add code to restore saved registers if any
	pop		esi							;restore value of esi
	pop		edi							;restore value of edi
	pop		edx							;restore value of edx
	pop		ecx							;restore value of ecx
	pop		ebx							;restore value of ebx

	pop		ebp							;restore value of ebp
	ret		8							;return to main and restore memory to stack

DoRightRotate endp





;************** Shifter – Simulate a partial shifter circuit per the circuit diagram in the pdf file.  
;  Shifter will simulate part of a shifter circuit that will input 
;  3 bits and output a shifted or non-shifted bit.
;
;
;   CL--------------------------
;              |               |    
;              |               |     
;              |    AL        NOT    BL
;              |     |         |     |
;              --AND--         --AND--
;                 |                |
;                 --------OR--------
;                          |
;                          AL
;
; NOTE: To implement the NOT gate use XOR to flip a single bit.
;
; Each input and output represents one bit.
;
;  Note: do not access the arrays in main directly in the Adder function. 
;        The data must be passed into this function via the required registers below.
;
;       ENTRY - AL = input bit A 
;               BL = input bit B
;               CL = enable (1) or disable (0) shift
;       EXIT  - AL = shifted or non-shifted bit
;       REGS  - eax, ebx, ecx
;
;       For the inputs in the input columns you should get the 
;       output in the output column below.
;
;The chart below shows the output for 
;the given inputs if shifting is enabled (cl = 1)
;If shift is enabled (cl = 1) then output should be the shifted bit (al).
;In the table below shifting is enabled (cl = 1)
;
;        input      output
;     al   bl  cl |   al 
;--------------------------
;      0   0   1  |   0 
;      1   0   1  |   1 
;      0   1   1  |   0 
;      1   1   1  |   1   
;
;The chart below shows the output for 
;the given inputs if shifting is disabled (cl = 0)
;If shift is disabled (cl = 0) then the output should be the non-shifted bit (B).

;        input      output
;     al   bl  cl |   al 
;--------------------------
;      0   0   0  |   0 
;      1   0   0  |   0 
;      0   1   0  |   1 
;      1   1   0  |   1   

;
;Note: the Shifter function does not do any output to the console.All the output is done in the main function
;
;Do not access the arrays in main directly in the shifter function. 
;The data must be passed into this function via the required registers.
;
;Do not change the name of the Shifter function.
;
;See additional specifications for the Shifter function on the 
;class web site.
;
;You should use AND, OR and XOR to simulate the shifter circuit.
;
;Note: to flip a single bit use XOR do not use NOT.
;
;You should save any registers whose values change in this function 
;using push and restore them with pop.
;
;The saving of the registers should
;be done at the top of the function and the restoring should be done at
;the bottom of the function.
;
;Note: do not save any registers that return a value (eax).
;
;Each line of this function must be commented and you must use the 
;usual indentation and formating like in the main function.
;
;Don't forget the "ret" instruction at the end of the function
;
;Do not delete this comment block. Every function should have 
;a comment block before it describing the function. FA18


Shifter proc
;is there a way to write this program without pushing reg to stack
;add code to save registers if any
	push	ecx							;push ecx onto stack

	and		al, cl						;and gate for al and cl input
	xor		cl, 1						;xor to flip bit
	and		cl, bl						;and gate for bl and cl input
	or		al, cl						;and gate for al and cl input

;and the following code at the bottom
;add code to restore saved registers if any
	pop		ecx							;restore value of cl
	ret									;return to main 

Shifter endp




;************** DspBin - display a Dword in binary including leading zeros
;
;       ENTRY –operand1, the number to print in binary, is on the stack
;
;       For Example if parm1 contained contained AC123h the following would print:
;                00000000000010101100000100100011
;       For Example if parm1 contained 0005h the following would print:
;                00000000000000000000000000000101
;
;       EXIT  - None
;       REGS  - eax, ecx, ebp, esp
;
; to call DspBin:
;               push 1111000110100b    ;number to print in binary is on the stack
;               call DspBin            ; 00000000000000000001111000110100 should print
;     
;       Note: leading zeros do print
;       Note; at the end of this function use ret 4 (instead of just ret) to remove the parameter from the stack
;                 Do not use add esp, 4 in the main function.
;--------------

    ;You should have a loop that will do the following:
    ;The loop should execute NUM_OF_BITS times(32 times) times so that all binary digits will print including leading 0s.
    ;You should use the NUM_OF_BITS constant as the terminating loop condition and not hard code it.
    
    ;You should start at bit 31 down to and including bit 0 so that the digits will 
    ;print in the correct order, left to right.
    ;Each iteration of the loop will print one binary digit.

    ;Each time through the loop you should do the following:
    
    ;You should use the BT instruction to copy the bit starting at position 31 to the carry flag 
    ;then use a rotate command to copy the carry flag to the right end of al.

    ;then convert the 1 or 0 to a character ('1' or '0') and print it with WriteChar.
    ;You should keep processing the number until all 32 bits have been printed from bit 31 to bit 0. 
    
    ;Efficiency counts.

    ;DspBin just prints the raw binary number.

    ;No credit will be given for a solution that uses mul, imul, div or idiv. 
    ;
    ;You should save any registers whose values change in this function 
    ;using push and restore them with pop.
    ;
    ;The saving of the registers should
    ;be done at the top of the function and the restoring should be done at
    ;the bottom of the function.
    ;
    ;Each line of this function must be commented and you must use the 
    ;usual indentation and formating like in the main function.
    ;
    ;Don't forget the "ret 4" instruction at the end of the function
    ;
    ;
    ;Do not delete this comment block. Every function should have 
    ;a comment block before it describing the function. FA17


DspBin proc

;required code at top 
	push	ebp							;push ebp on the stack 
	mov		ebp,esp						;ebp = esp , ebp used to navigate stack
;add code to save registers if any
	push	eax							;push eax onto stack
	push	ecx							;push ecx onto stack

	mov		ecx, NUM_OF_BITS			;ecx = NUM_OF_BITS 

looptop:
	
	mov		eax, ecx					;eax = ecx
	sub		eax, 1						;eax = eax - 1
	bt		$parm1, eax 				;copy bit in num at position in ecx to carry flag
	mov		eax, 0						;clearing eax
	rcl		eax, 1						;rotate carry left
	or		al, 00110000b				;convert number to ASCII character
	call	WriteChar					;print character in eax

	loop	looptop						;loop to top and decrement ecx

;and the following code at the bottom
;add code to restore saved registers if any
	pop		ecx							;restore value of ecx
	pop		eax							;restore value of eax
	pop		ebp							;restore value of ebp
	ret		4							;returns to main and restore memory to stack

DspBin endp

END Main