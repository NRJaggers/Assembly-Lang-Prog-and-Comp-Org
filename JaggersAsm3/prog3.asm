;  Comment block below must be filled out completely for each assignment
;  ************************************************************* 
;  Student Name: Nathan Jaggers
;  COMSC-260 Fall 2019
;  Date:9/18/2019
;  Assignment 3
;  Version of Visual Studio used: 2019  
;  Did program compile? Yes/No
;  Did program produce correct results? Yes/No
;  Is code formatted correctly including indentation, spacing and vertical alignment? Yes/No
;  Is every line of code commented? Yes/No
;
;  Estimate of time in hours to complete assignment: 	
;  In a few words describe the main challenge in writing this program: 
;  
;  Short description of what program does: 
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

;*******************MACROS********************************

mPrtStr  MACRO  arg1			;arg1 is replaced by the name of string to be displayed
		 push edx				;save edx
         mov  edx, offset arg1  ;address of str to display should be in edx
         call WriteString       ;display 0 terminated string
         pop  edx				;restore edx
ENDM

;*************************PROTOTYPES*****************************

ExitProcess PROTO,
 dwExitCode:DWORD						;from Win32 api not Irvine to exit to dos with exit code

ReadHex PROTO							;Irvine code to read 32 bit hex number from console
										;and store it into eax

WriteString PROTO						; Irvine code to write null-terminated string to output
										; EDX points to string

RandomRange PROTO						; Returns an unsigned pseudo-random 32-bit integer
										; in EAX, between 0 and n-1. If n = 6h a random number
										; in the range 0-5 is generated.
										;
										; Input parameter: EAX = n.
Randomize PROTO							; Re-seeds the random number generator with the current time
										; in seconds.

MessageBoxA PROTO,						;MessageBoxA takes 4 parameters:
  handleOwn:DWORD,						;1. window owner handle
	 msgAdd:DWORD,						;2. message address (zero terminated string)
 captionAdd:DWORD,						;3. title address(zero terminated string)
	boxType:DWORD						;4. which button(s) to display

;************************ Constants ***************************

	LF			equ		0Ah				;ASCII Line Feed

;************************DATA SEGMENT***************************

.data	
		;create strings with embedded line feeds

	authorMsg	byte	"Program 3 by Nathan Jaggers", LF, 0
	guessMsg	byte	LF, "Guess a hex number in the range 1h - Fh.", LF, 0
	guessLabel	byte	"Guess: ", 0
	highMsg		byte	"High! Guess lower!", LF, 0
	lowMsg		byte	"Low! Guess higher!", LF, 0
	againMsg	byte	"Correct! Play again?"


;************************CODE SEGMENT****************************

.code

main PROC
	
	mPrtStr authorMsg					;print string in authorMsg

	call    Randomize					;seed the random number generator

loopGame:								;enter loop to start game
	mPrtStr	guessMsg					;macro prints guess message
	mov     eax, 0Fh					;range to generate random numbers 0-14
    call    RandomRange					;generate random number in range
										;random number is in eax
	mov		ebx, 1h						;ebx = 1h 
	add		ebx, eax					;ebx = ebx + eax 
loopGuess:
	mPrtStr	guessLabel					;print string in guessMsg
	call	ReadHex						;get guess from user stored in eax
	cmp		eax,ebx						;compares eax and ebx (eax - ebx)
	je		DONE						;if eax == ebx, answer is correct. Jump to done
	ja		ifHigh						;if eax >  ebx, anser is high. Jump to ifHigh
;ifLow									;if neither above, answer is low.
	mPrtStr lowMsg						;macro prints lowMsg message
	jmp		loopGuess					;jump to loopGuess
ifHigh:									;jump label if guess is high
	mPrtStr	highMsg						;macro prints highMsg message
	jmp		loopGuess					;jump to loopGuess

DONE:									;jump label if guess is correct
	invoke MessageBoxA ,				;call MessageBoxA Win32 API function
					  0,				;indicates no window owner
		  addr againMsg,				;address of message to be displayed in middle of msg box
		 addr authorMsg,				;caption to be displayed in title bar of msg box
					  4					;display yes, no buttons in msg box
										;(6 returned in eax if user hits yes)
										;(7 returned in eax if user hits no)
	cmp		eax,6						;compares eax and 6 (eax - 6)
	je		loopGame					;if eax == 6 loop to start of game
    
	INVOKE	ExitProcess,0				;exit to dos: like C++ exit(0)

main ENDP
END main