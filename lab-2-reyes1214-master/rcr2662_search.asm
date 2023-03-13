.ORIG x3000
	LD R2, STORE		; Loads the address of the first counter into R2
	LD R7, INTERVAL1	; Loads the maximum for the first interval
	STR R7, R2, #-1		; Store the maximum of the first interval into the beginning of the frequency table
	LD R7 INTERVAL2		; Load the minimum of the second interval into R7
	STR R7, R2, #1		; Store the minimum of the second interval into the corresponding address
	LD R7 INTERVAL3		; Load the minimum of the third interval into R7
	STR R7, R2, #3		; Store the minimum of the third interval into corresponding address
	LD R7, INTERVAL4	; Load the minimum of the minimum of the fourth interval into R7
	STR R7, R2, #5		; Store the minimum of the fourth interval into the corresponding address

	AND R3, R3, #0		; Clears R3 which is the counter for the interval of before 1900
	AND R4, R4, #0		; Clears R4 which is the counter for the interval of 1901 to 1950 
	AND R5, R5, #0		; Clears R5 which is the counter for the interval of 1951 to 2000
	AND R6, R6, #0		; Clears R6 which is the counter for the interval of 2001 to today
	LD R0 ADDRESS		; Loads the address of the first year to compare into R0
YEAR	LDR R1, R0 #0		; Loads the year being compared into R1
	BRZ	DONE		; No list present
	LD R7, INTERVAL1	; Loads the maximum for the first interval
	NOT R7, R7		; Negate...
	ADD R7, R7, #1		; the maximum of the interval
	ADD R7, R1, R7		; Subtract the maximum from the year being compared
	BRP	NEXT		; Difference is positive, year is larger than first interval, move to next comparison
	ADD R3, R3, #1		; Difference is zero or negative so it fits in the first interval, increment counter
	BRNZP	SKIP		; Avoid incrementing other counters
NEXT	LD R7 INTERVAL3		; Load the minimum of the third interval into R7
	NOT R7, R7		; Negate
	ADD R7, R7, #1		; the minimum of the interval 
	ADD R7, R1, R7		; Subtract the minimum from the year being compared
	BRZP	NEXTER		; Difference is positve or zero, year is larger than second interval, move to next comparison
	ADD R4, R4, #1		; Difference is negative so it fits in the second interval, increment counter
	BRNZP	SKIP		; Avoid incrementing other counters
NEXTER	LD R7, INTERVAL4	; Load the minimum of the minimum of the fourth interval into R7
	NOT R7, R7		; Negate...
	ADD R7, R7, #1		; the minimum ofthe fourth interval 
	ADD R7, R1, R7		; Subtract the minimum of the fourth interval from the year being compared
	BRZP	NEXTERERER	; Difference is positive or zero so the year belongs in the fourth interval
	ADD R5, R5, #1		; Difference is negative, year fits into the third interval, increment counter
	BRNZP	SKIP		; Avoid incrementing fourth interval counter 
NEXTERERER ADD R6, R6, #1	; Year fits into the fourth interval, increment counter
SKIP	ADD R0, R0 #1		; Increment year pointer
	LDR R7, R0, #0		; Load contents for purpose of checking
	BRZ	STORING		; Contents are x0000 meaning null termination, store register values into corresponding addresses
	ADD R0, R0 #1		; Contents are not 0 so to next year pointer
	BRNZP	YEAR		; Compare next year to check what interval it falls under	
STORING	STR R3, R2, #0		; Store counter for first interval into corresponding address
	STR R4, R2, #2		; Store counter for second interval into corresponding address
	STR R5, R2, #4		; Store counter for third interval into corresponding address
	STR R6, R2, #6		; Store counter for fourth interval into corresponding address
DONE	HALT

ADDRESS		.FILL x4001
STORE		.FILL x6001
INTERVAL1	.FILL x1900
INTERVAL2	.FILL x1901
INTERVAL3	.FILL X1951
INTERVAL4	.FILL x2001

.END