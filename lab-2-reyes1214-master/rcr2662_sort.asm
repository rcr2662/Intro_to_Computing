.ORIG x3000
CLEAR	AND R7 R7 #0	; Clears R7 which is the swap counter register
	LD R0 EVENT	; Loads the address of the event pointer into R0
	LD R1 START	; Loads the address of the first year in R1
COMPARE	ADD R2 R1 #2	; Calculate the address of the second year to be compared and store in R2
	LDR R3 R1 #0	; Load the first year to be compared into R3
	LDR R4 R2 #0	; Load the second year to be compared into R4 to keep intact 
	LDR R5 R2 #0	; Load the second address to be compared into R5
	NOT R5 R5	; Negate ...
	ADD R5 R5 #1	; the second year
	ADD R6 R3 R5	; Add the years 
	BRP NO_SWAP	; Difference is positive so no swap needed, go to NO SWAP
	STR R3 R2 #0	; Swap...
	STR R4 R1 #0	; the years
	LDR R5 R0 #0	; Loads the event pointer into R5
	ADD R0 R0 #2	; Increment to the address of the next event pointer
	LDR R3 R0 #0	; Loads the event pointer into R3
	STR R5 R2 #-1	; Stores the event pointer into the address before the new address of the corresponding year
	STR R3 R1 #-1	; Stores the event pointer into the address before the new address of the corresponding year
	ADD R7 R7 #1	; Increment the swap counter register
NO_SWAP	ADD R1 R1 #1	; Increment year pointer
	LDR R3 R1 #0	; Load contents of new address into R3
	BRZ COUNTER	; Check if contents are 0
	ADD R1 R1 #1	; Null not encountered, so increment to the next year pointer
	BRNZP COMPARE	; Go back to COMPARE to compare next set of years
COUNTER	ADD R7 R7 #0	; Update condiotion codes
	BRZ END		; If no swaps were made, sorting is complete, go to END
	BRNZP CLEAR	; If swaps were made, go to clear to start comparison process over new order
END	HALT

START 	.FILL x4001
EVENT	.FILL x4000

	.END