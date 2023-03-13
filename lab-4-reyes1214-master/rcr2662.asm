;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 	description: 	Connect 4 game!				;
;								;
; 								;
;	file:		connect4_start.asm			;
;	This is the starter code for the Connect4 game		;
;								;
;	Nina Telang, 11/10/19					;
;								;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.ORIG x3000

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	Main Program						;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	JSR INIT
ROUND
	JSR DISPLAY_BOARD
	JSR GET_MOVE
	JSR UPDATE_BOARD
	JSR UPDATE_STATE

	ADD R6, R6, #0
	BRz ROUND

	JSR DISPLAY_BOARD
	JSR GAME_OVER

	HALT

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	Functions & Constants!!!				;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	DISPLAY_TURN						;
;	description:	Displays the appropriate prompt.	;
;	inputs:		None!					;
;	outputs:	None!					;
;	assumptions:	TURN is set appropriately!		;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DISPLAY_TURN
	ST R0, DT_R0
	ST R7, DT_R7

	LD R0, TURN
	ADD R0, R0, #-1
	BRp DT_P2
	LEA R0, DT_P1_PROMPT
	PUTS
	BRnzp DT_DONE
DT_P2
	LEA R0, DT_P2_PROMPT
	PUTS

DT_DONE

	LD R0, DT_R0
	LD R7, DT_R7

	RET
DT_P1_PROMPT	.stringz 	"Player 1, choose a column: "
DT_P2_PROMPT	.stringz	"Player 2, choose a column: "
DT_R0		.blkw	1
DT_R7		.blkw	1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	GET_MOVE						;
;	description:	gets a column from the user.		;
;			also checks whether the move is valid,	;
;			or not, by calling the CHECK_VALID 	;
;			subroutine!				;
;	inputs:		None!					;
;	outputs:	R6 has the user entered column number!	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GET_MOVE
	ST R0, GM_R0
	ST R7, GM_R7

GM_REPEAT
	JSR DISPLAY_TURN
	GETC
	OUT
	JSR CHECK_VALID
	LD R0, ASCII_NEWLINE
	OUT

	ADD R6, R6, #0
	BRp GM_VALID

	LEA R0, GM_INVALID_PROMPT
	PUTS
	LD R0, ASCII_NEWLINE
	OUT
	BRnzp GM_REPEAT

GM_VALID

	LD R0, GM_R0
	LD R7, GM_R7

	RET
GM_INVALID_PROMPT 	.stringz "Invalid move. Try again."
GM_R0			.blkw	1
GM_R7			.blkw	1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	UPDATE_BOARD						;
;	description:	updates the game board with the last 	;
;			move!					;
;	inputs:		R6 has the column for last move.	;
;	outputs:	R5 has the row for last move.		;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
UPDATE_BOARD
	ST R1, UP_R1
	ST R2, UP_R2
	ST R3, UP_R3
	ST R4, UP_R4
	ST R6, UP_R6
	ST R7, UP_R7

	; clear R5
	AND R5, R5, #0
	ADD R5, R5, #6

	LEA R4, ROW6
	
UB_NEXT_LEVEL
	ADD R3, R4, R6

	LDR R1, R3, #-1
	LD R2, ASCII_NEGHYP

	ADD R1, R1, R2
	BRz UB_LEVEL_FOUND

	ADD R4, R4, #-7
	ADD R5, R5, #-1
	BRnzp UB_NEXT_LEVEL

UB_LEVEL_FOUND
	LD R4, TURN
	ADD R4, R4, #-1
	BRp UB_P2

	LD R4, ASCII_O
	STR R4, R3, #-1

	BRnzp UB_DONE
UB_P2
	LD R4, ASCII_X
	STR R4, R3, #-1

UB_DONE		

	LD R1, UP_R1
	LD R2, UP_R2
	LD R3, UP_R3
	LD R4, UP_R4
	LD R6, UP_R6
	LD R7, UP_R7

	RET
ASCII_X	.fill	x0058
ASCII_O	.fill	x004f
UP_R1	.blkw	1
UP_R2	.blkw	1
UP_R3	.blkw	1
UP_R4	.blkw	1
UP_R5	.blkw	1
UP_R6	.blkw	1
UP_R7	.blkw	1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	CHANGE_TURN						;
;	description:	changes the turn by updating TURN!	;
;	inputs:		none!					;
;	outputs:	none!					;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CHANGE_TURN
	ST R0, CT_R0
	ST R1, CT_R1
	ST R7, CT_R7

	LD R0, TURN
	ADD R1, R0, #-1
	BRz CT_TURN_P2

	ST R1, TURN
	BRnzp CT_DONE

CT_TURN_P2
	ADD R0, R0, #1
	ST R0, TURN

CT_DONE
	LD R0, CT_R0
	LD R1, CT_R1
	LD R7, CT_R7

	RET
CT_R0	.blkw	1
CT_R1	.blkw	1
CT_R7	.blkw	1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	CHECK_WINNER						;
;	description:	checks if the last move resulted in a	;
;			win or not!				;
;	inputs:		R6 has the column of last move.		;
;			R5 has the row of last move.		;
;	outputs:	R4 has  0, if not winning move,		;
;				1, otherwise.			;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CHECK_WINNER
	ST R5, CW_R5
	ST R6, CW_R6
	ST R7, CW_R7

	AND R4, R4, #0
	
	JSR CHECK_HORIZONTAL
	ADD R4, R4, #0
	BRp CW_DONE

	JSR CHECK_VERTICAL
	ADD R4, R4, #0
	BRp CW_DONE

	JSR CHECK_DIAGONALS

CW_DONE

	LD R5, CW_R5
	LD R6, CW_R6
	LD R7, CW_R7

	RET
CW_R5	.blkw	1
CW_R6	.blkw	1
CW_R7	.blkw	1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	UPDATE_STATE						;
;	description:	updates the state of the game by 	;
;			checking the board. i.e. tries to figure;
;			out whether the last move ended the game;
; 			or not! if not updates the TURN! also	;
;			updates the WINNER if there is a winner!;
;	inputs:		R6 has the column of last move.		;
;			R5 has the row of last move.		;
;	outputs:	R6 has  1, if the game is over,		;
;				0, otherwise.			;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
UPDATE_STATE
	ST R0, US_R0
	ST R1, US_R1
	ST R4, US_R4
	ST R7, US_R7
	
	; checking if the last move resulted in a win or not!
	JSR CHECK_WINNER
	
	ADD R4, R4, #0
	BRp US_OVER
	
	; checking if the board is full or not!
	AND R6, R6, #0
		
	LD R0, NBR_FILLED
	ADD R0, R0, #1
	ST R0, NBR_FILLED

	LD R1, MAX_FILLED
	ADD R1, R0, R1
	BRz US_TIE

US_NOT_OVER
	JSR CHANGE_TURN
	BRnzp US_DONE

US_OVER
	ADD R6, R6, #1
	LD R0, TURN
	ST R0, WINNER
	BRnzp US_DONE

US_TIE
	ADD R6, R6, #1

US_DONE
	LD R0, US_R0
	LD R1, US_R1
	LD R4, US_R4
	LD R7, US_R7

	RET
NBR_FILLED	.fill	#0
MAX_FILLED	.fill	#-36
US_R0		.blkw	1
US_R1		.blkw	1
US_R4		.blkw	1
US_R7		.blkw	1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	INIT							;
;	description:	simply sets the BOARD_PTR appropriately!;
;	inputs:		none!					;
;	outputs:	none!					;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
INIT
	ST R0, I_R0
	ST R7, I_R7

	LEA R0, ROW1
	ST R0, BOARD_PTR

	LD R0, I_R0
	LD R7, I_R7

	RET
I_R0	.blkw	1
I_R7	.blkw	1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	Global Constants!!!					;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ASCII_SPACE	.fill		x0020				;
ASCII_NEWLINE	.fill		x000A				;
TURN		.fill		1				;
WINNER		.fill		0				;
								;
ASCII_OFFSET	.fill		x-0030				;
ASCII_NEGONE	.fill		x-0031				;
ASCII_NEGSIX	.fill		x-0036				;
ASCII_NEGHYP	.fill	 	x-002d				;
								;
ROW1		.stringz	"------"			;
ROW2		.stringz	"------"			;
ROW3		.stringz	"------"			;
ROW4		.stringz	"------"			;
ROW5		.stringz	"------"			;
ROW6		.stringz	"------"			;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;DO;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;NOT;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;CHANGE;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;ANYTHING;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;ABOVE;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;THIS!!!;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	DISPLAY_BOARD						;
;	description:	Displays the board.			;
;	inputs:		None!					;
;	outputs:	None!					;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DISPLAY_BOARD
	
	ST R7 TOOT
	ST R0 HOOT
	ST R1 BOOT
	ST R2 FOOT
	ST R3 ROOT
	LEA R1 ROW1
	LD R3 NOOT
FOO	LD R2 NOOT
	ADD R2 R2 #-1
	
OOF	LDR R0 R1 #0
	OUT
	LD R0 ASCII_SPACE
	OUT
	ADD R1 R1 #1
	ADD R2 R2 #-1
	BRNP OOF
	LDR R0 R1 #0
	OUT


HOOP	LD R0 ASCII_NEWLINE
	OUT
	ADD R1 R1 #2
	ADD R3 R3 #-1

	BRNP FOO
	LD R7 TOOT
	LD R0 HOOT
	LD R1 BOOT
	LD R2 FOOT
	LD R3 ROOT

	RET
TOOT	.BLKW x1
HOOT	.BLKW x1
BOOT	.BLKW x1
FOOT 	.BLKW x1
ROOT	.BLKW x1
NOOT	.FILL #6

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	GAME_OVER						;
;	description:	checks WINNER and outputs the proper	;
;			message!				;
;	inputs:		none!					;
;	outputs:	none!					;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GAME_OVER
	ST R7 ONCE
	ST R0 TWICE
	ST R1 THRICE
	ST R2 UNKNOWN
	LD R0 TWOS
	LD R1 WINNER
	BRZ TIED
	ADD R2 R1 R0
	BRZ P2
	LEA R0 P1_WIN
	PUTS
	BR DONE
TIED	LEA R0 TIEDD
	PUTS
	BR DONE
P2	LEA R0 P2_WIN
	PUTS 

DONE	LD R7 ONCE
	LD R0 TWICE
	LD R1 THRICE
	LD R2 UNKNOWN
	RET
P1_WIN	.STRINGZ "Player 1 Wins."
P2_WIN	.STRINGZ "Player 2 Wins."
TIEDD	.STRINGZ "Tie Game."
ONCE	.BLKW x1
TWICE	.BLKW x1
THRICE	.BLKW x1
UNKNOWN	.BLKW x1
TWOS	.FILL #2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	CHECK_VALID						;
;	description:	checks whether a move is valid or not!	;
;	inputs:		R0 has the ASCII value of the move!	;
;	outputs:	R6 has:	0, if invalid move,		;
;				decimal col. val., if valid.    ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CHECK_VALID
	ST R7 YOU
	ST R0 MOO
	ST R1 SUE
	ST R2 TOO
	ST R3 POO
	ST R4 WHO
	ST R5 DO
	LD R1 ASCII_OFFSET
	LD R2 ONE
	LD R5 SIX
	ADD R6 R0 R1
GO	NOT R3 R2
	ADD R3 R3 #1
	ADD R4 R6 R3
	BRZ OOO
	ADD R2 R2 #1
	ADD R5 R5 #-1
	BRZ ZERO
	BRNZP GO
OOO	LEA R0 ROW1
	ADD R0 R6 R0
	LDR R0 R0 #-1
	LD R7 ASCII_NEGHYP
	ADD R0 R7 R0
	BRZ GOO
ZERO 	AND R6 R6 #0
GOO	LD R7 YOU
	LD R0 MOO
	LD R1 SUE
	LD R2 TOO
	LD R3 POO
	LD R4 WHO
	LD R5 DO
	RET
ONE	.FILL #1
SIX	.FILL #6
YOU	.BLKW x1
MOO	.BLKW x1
SUE	.BLKW x1
TOO	.BLKW x1
POO	.BLKW x1
WHO	.BLKW x1
DO	.BLKW x1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;USE THE FOLLOWING TO ACCESS THE BOARD!!!;;;;;;;;;;;;;;;;;;
;;;;;IT POINTS TO THE FIRST ELEMENT OF ROW1 (TOP-MOST ROW)!!!;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
BOARD_PTR	.blkw	1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	CHECK_HORIZONTAL					;
;	description:	horizontal check.			;
;	inputs:		R6 has the column of the last move.	;
;			R5 has the row of the last move.	;
;	outputs:	R4 has  0, if not winning move,		;
;				1, otherwise.			;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CHECK_HORIZONTAL

	ST R7 GUY
	ST R0 FLY
	ST R1 SKY
	ST R2 HIGH
	ST R3 MY
	ST R5 BYE
	ST R6 BY
	LD R0 ONE
	LD R7 SIX
	ADD R7 R7 #-2
	ADD R6 R7 #0
	ADD R6 R6 #-1
	NOT R1 R0
	ADD R1 R1 #1
	ADD R2 R1 R5
	BRZ FIRST
	ADD R0 R0 #1
	NOT R1 R0
	ADD R1 R1 #1
	ADD R2 R1 R5
	BRZ SECOND
	ADD R0 R0 #1
	NOT R1 R0
	ADD R1 R1 #1
	ADD R2 R1 R5
	BRZ THIRD
	ADD R0 R0 #1
	NOT R1 R0
	ADD R1 R1 #1
	ADD R2 R1 R5
	BRZ FOURTH
	ADD R0 R0 #1
	NOT R1 R0
	ADD R1 R1 #1
	ADD R2 R1 R5
	BRZ FIFTH
	LEA R0 ROW6
	BR CHECK


FIRST	LEA R0 ROW1
	BR CHECK
SECOND 	LEA R0 ROW2
	BR CHECK
THIRD	LEA R0 ROW3
	BR CHECK
FOURTH	LEA R0 ROW4
	BR CHECK
FIFTH	LEA R0 ROW5

CHECK	ADD R4 R0 #1
UMPH	LDR R3 R0 #0
	LDR R2 R4 #0
	NOT R2 R2
	ADD R2 R2 #1
	ADD R5 R2 R3
	BRZ MAYBE
	LD R6 SIX
	ADD R6 R6 #-3
	ADD R0 R4 #0
	ADD R4 R4 #1
	ADD R7 R7 #-1
	BRZ NO_WIN
	BR UMPH
MAYBE	LD R1 ASCII_NEGHYP
	ADD R1 R1 R3
	BRZ NO_WIN
	ADD R4 R4 #1
	ADD R6 R6 #-1
	BRNP UMPH

WIN	AND R4 R4 #0
	ADD R4 R4 #1
	BR FINISH
	
NO_WIN	AND R4 R4 #0
FINISH	LD R0 FLY
	LD R1 SKY
	LD R2 HIGH
	LD R3 MY
	LD R5 BYE
	LD R6 BY
	LD R7 GUY
	RET
GUY	.BLKW x1
FLY	.BLKW x1
SKY	.BLKW x1
HIGH	.BLKW x1
MY	.BLKW x1
BYE 	.BLKW x1
BY	.BLKW x1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	CHECK_VERTICAL						;
;	description:	vertical check.				;
;	inputs:		R6 has the column of the last move.	;
;			R5 has the row of the last move.	;
;	outputs:	R4 has  0, if not winning move,		;
;				1, otherwise.			;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CHECK_VERTICAL
	
	ST R7 WAY
	ST R0 PAY
	ST R1 SAY
	ST R2 DAY
	ST R3 PLAY
	ST R5 HAY
	ST R6 YAY
	LD R0 ONE
	LD R7 ONE
	ADD R7 R7 #2
	NOT R1 R0
	ADD R1 R1 #1
	ADD R2 R1 R5
	BRZ YES
	ADD R0 R0 #1
	NOT R1 R0
	ADD R1 R1 #1
	ADD R2 R1 R5
	BRZ YE
	ADD R0 R0 #1
	NOT R1 R0
	ADD R1 R1 #1
	ADD R2 R1 R5
	BRZ Y
	ADD R0 R0 #1
	NOT R1 R0
	ADD R1 R1 #1
	ADD R2 R1 R5
	BRZ NOPE
	ADD R0 R0 #1
	NOT R1 R0
	ADD R1 R1 #1
	ADD R2 R1 R5
	BRZ NOPE
	LD R0 BOARD_PTR
	ADD R0 R0 #7
	ADD R0 R0 #7
	ADD R0 R0 #7
	ADD R0 R0 #7
	ADD R0 R0 #7
	BR NOPE


YES	LD R0 BOARD_PTR
	BR TOP
YE 	LD R0 BOARD_PTR
	ADD R0 R0 #7
	BR TOP
Y	LD R0 BOARD_PTR
	ADD R0 R0 #7
	ADD R0 R0 #7

TOP	ADD R4 R6 R0
	ADD R4 R4 #-1
	ADD R6 R7 #0
BOP	ADD R5 R4 #7
	LDR R1 R4 #0
OOPS	LDR R2 R5 #0
	NOT R2 R2 
	ADD R2 R2 #1
	ADD R3 R2 R1
	BRZ POSSIBLE
	LD R6 ONE
	ADD R6 R6 #1
	ADD R4 R5 #0
	ADD R7 R7 #-1
	BRZ NOPE
	BR BOP
POSSIBLE ADD R5 R5 #7
	ADD R6 R6 #-1
	BRZ FIB
	BR OOPS	
FIB	AND R4 R4 #0
	ADD R4 R4 #1
	BR HOP
NOPE	AND R4 R4 #0
HOP	LD R0 PAY
	LD R1 SAY
	LD R2 DAY
	LD R3 PLAY
	LD R5 HAY
	LD R6 YAY
	LD R7 WAY

	RET
WAY	.BLKW x1
PAY	.BLKW x1
SAY	.BLKW x1
DAY	.BLKW x1
PLAY	.BLKW x1
HAY 	.BLKW x1
YAY	.BLKW x1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	CHECK_DIAGONALS						;
;	description:	checks diagonals by calling 		;
;			CHECK_D1 & CHECK_D2.			;
;	inputs:		R6 has the column of the last move.	;
;			R5 has the row of the last move.	;
;	outputs:	R4 has  0, if not winning move,		;
;				1, otherwise.			;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CHECK_DIAGONALS
	ST R7 HOT
	

	JSR CHECK_D1
	ADD R4 R4 #0
	BRP LAST

CHECKS	JSR CHECK_D2
	ADD R4 R4 #0

	
LAST	LD R7 HOT
	RET
HOT	.BLKW x1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	CHECK_D1						;
;	description:	1st diagonal check.			;
;	inputs:		R6 has the column of the last move.	;
;			R5 has the row of the last move.	;
;	outputs:	R4 has  0, if not winning move,		;
;				1, otherwise.			;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CHECK_D1	
	ST R7 GOOP
	ST R0 MOP
	ST R1 STOP
	ST R2 GOT
	ST R3 POP
	ST R5 COP
	ST R6 SOP
	LD R5 TWO
	ADD R6 R5 #1
	LD R0 BOARD_PTR
	ST R0 PTR
	ADD R0 R0 #7
	ADD R0 R0 #7
	ADD R0 R0 #7
	ADD R0 R0 #7
	ADD R0 R0 #7
	ADD R1 R0 #3

	ADD R2 R1 #-8
HIT	LDR R3 R1 #0
	LDR R4 R2 #0
	NOT R4 R4 
	ADD R4 R4 #1
	ADD R4 R4 R3
	BRZ BOO

	LD R0 BOARD_PTR
	ADD R0 R0 #7
	ADD R0 R0 #7
	ADD R0 R0 #7
	ADD R1 R0 #5
	ADD R5 R5 #-1
	BRZ BUM
	BR HIT

BOO	LD R7 NEGHYP
	ADD R7 R7 R3
	BRZ NOO
	ADD R2 R2 #-8
	ADD R6 R6 #-1
	BRZ WOO
	BR HIT

BUM	LD R7 NEGHYP
	ADD R7 R7 R3
	BRZ NOO	
	LD R0 BOARD_PTR
	ADD R0 R0 #7
	ADD R0 R0 #7
	ADD R0 R0 #7
	ADD R0 R0 #7
	ADD R0 R0 #7
	ADD R1 R0 #4
	LD R7 TWO
	ADD R7 R7 #1
HOW	ADD R7 R7 #-1
	BRZ BUMS
	LD R5 TWO
	ADD R6 R5 #1
HITS	ADD R2 R1 #-8
HITZ	LDR R3 R1 #0
	LDR R4 R2 #0
	NOT R4 R4 
	ADD R4 R4 #1
	ADD R4 R4 R3
	BRZ BRUH
	LD R6 TWO
	ADD R6 R6 #1
	ADD R1 R2 #0
	ADD R5 R5 #-1
	BRNP HITS
	
	LD R0 BOARD_PTR
	ST R0 PTR
	ADD R0 R0 #7
	ADD R0 R0 #7
	ADD R0 R0 #7
	ADD R0 R0 #7
	ADD R1 R0 #5
	BR HOW

BRUH	LD R7 NEGHYP
	ADD R7 R7 R3
	BRZ NOO
	ADD R2 R2 #-8
	ADD R6 R6 #-1
	BRZ WOO
	BR HITZ

BUMS	LD R0 PTR
	LD R6 TWO
	ADD R6 R6 #1
	ADD R5 R6 #0
	ADD R0 R0 #7
	ADD R0 R0 #7
	ADD R0 R0 #7
	ADD R0 R0 #7
	ADD R0 R0 #7
	ADD R1 R0 #5
YEET	ADD R2 R1 #-8
YEETZ	LDR R3 R1 #0
	LDR R4 R2 #0
	NOT R4 R4 
	ADD R4 R4 #1
	ADD R4 R4 R3
	BRZ HMMM
	LD R6 TWO
	ADD R6 R6 #1
	ADD R1 R2 #0
	ADD R5 R5 #-1
	BRZ NOO
	BR YEET
HMMM	LD R7 NEGHYP
	ADD R7 R7 R3
	BRZ NOO
	ADD R2 R2 #-8
	ADD R6 R6 #-1
	BRNP YEETZ


WOO	AND R4 R4 #0
	ADD R4 R4 #1
	BR RIP

NOO	AND R4 R4 #0

RIP	LD R7 GOOP
	LD R0 MOP
	LD R1 STOP
	LD R2 GOT
	LD R3 POP
	LD R5 COP
	LD R6 SOP
	RET
NEGHYP	.FILL	 x-002d
TWO	.FILL #2
MOP	.BLKW x1
STOP	.BLKW x1
GOT	.BLKW x1
POP	.BLKW x1
COP	.BLKW x1
SOP	.BLKW x1
GOOP	.BLKW x1
PTR	.BLKW x1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	CHECK_D2						;
;	description:	2nd diagonal check.			;
;	inputs:		R6 has the column of the last move.	;
;			R5 has the row of the last move.	;
;	outputs:	R4 has  0, if not winning move,		;
;				1, otherwise.			;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CHECK_D2	

	ST R7 MADE
	ST R0 UP
	ST R1 WORD
	ST R2 HERE
	ST R3 PLS
	ST R5 AN
	ST R6 THX
	LD R5 TWO
	ADD R6 R5 #1
	LD R0 PTR
	ADD R0 R0 #7
	ADD R0 R0 #7
	ADD R0 R0 #7
	ADD R0 R0 #7
	ADD R0 R0 #7
	ADD R1 R0 #2

	ADD R2 R1 #-6
WE	LDR R3 R1 #0
	LDR R4 R2 #0
	NOT R4 R4 
	ADD R4 R4 #1
	ADD R4 R4 R3
	BRZ OOB

	LD R0 PTR
	ADD R0 R0 #7
	ADD R0 R0 #7
	ADD R0 R0 #7
	ADD R1 R0 #0
	ADD R5 R5 #-1
	BRZ MUB
	BR WE

OOB	LD R7 NEGHYP
	ADD R7 R7 R3
	BRZ OON
	ADD R2 R2 #-6
	ADD R6 R6 #-1
	BRZ OOW
	BR WE

MUB	LD R7 NEGHYP
	ADD R7 R7 R3
	BRZ OON
	LD R0 PTR
	ADD R0 R0 #7
	ADD R0 R0 #7
	ADD R0 R0 #7
	ADD R0 R0 #7
	ADD R0 R0 #7
	ADD R1 R0 #1
	LD R7 TWO
	ADD R7 R7 #1
WOH	ADD R7 R7 #-1
	BRZ SMUB
	LD R5 TWO
	ADD R6 R5 #1
STIH	ADD R2 R1 #-6
ZTIH	LDR R3 R1 #0
	LDR R4 R2 #0
	NOT R4 R4 
	ADD R4 R4 #1
	ADD R4 R4 R3
	BRZ HURB
	LD R6 TWO
	ADD R6 R6 #1
	ADD R1 R2 #0
	ADD R5 R5 #-1
	BRNP STIH
	
	LD R0 PTR
	ADD R0 R0 #7
	ADD R0 R0 #7
	ADD R0 R0 #7
	ADD R0 R0 #7
	ADD R1 R0 #0
	BR WOH

HURB	LD R7 NEGHYP
	ADD R7 R7 R3
	BRZ OON
	ADD R2 R2 #-6
	ADD R6 R6 #-1
	BRZ OOW
	BR ZTIH

SMUB	LD R0 PTR
	LD R6 TWO
	ADD R6 R6 #1
	ADD R5 R6 #0
	ADD R0 R0 #7
	ADD R0 R0 #7
	ADD R0 R0 #7
	ADD R0 R0 #7
	ADD R0 R0 #7
	ADD R1 R0 #0
TEEY	ADD R2 R1 #-6
ZTEEY	LDR R3 R1 #0
	LDR R4 R2 #0
	NOT R4 R4 
	ADD R4 R4 #1
	ADD R4 R4 R3
	BRZ MMM
	LD R6 TWO
	ADD R6 R6 #1
	ADD R1 R2 #0
	ADD R5 R5 #-1
	BRZ OON
	BR TEEY
MMM	LD R7 NEGHYP
	ADD R7 R7 R3
	BRZ OON
	ADD R2 R2 #-6
	ADD R6 R6 #-1
	BRNP ZTEEY


OOW	AND R4 R4 #0
	ADD R4 R4 #1
	BR PIR

OON	AND R4 R4 #0

PIR	LD R7 MADE
	LD R0 UP
	LD R1 WORD
	LD R2 HERE
	LD R3 PLS
	LD R5 AN
	LD R6 THX
	RET

MADE	.BLKW x1
UP	.BLKW x1
WORD 	.BLKW x1
HERE	.BLKW x1
PLS	.BLKW x1
AN	.BLKW x1
THX	.BLKW x1

.END