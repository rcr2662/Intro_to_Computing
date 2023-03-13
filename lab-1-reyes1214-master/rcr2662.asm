.ORIG x3000 ;Start program at address x3000

LD R0, X0008  ;Load x3500 into Register 0
LD R1, x0008  ;Load bitmask x00FF for "AND" into Register 1
LD R2, x0008  ;Load bitmask x3FFF for "ADD" into Register 2
LDR R3 R0 #0  ;Load data from address in Register 0 and store it in Register 3
LDR R4 R3 #0  ;Load data from address in Register 3 and store it in Register 4
AND R5 R4 R1  ;"AND" data in Register 4 with bitmask in Register 1 and store it in Register 5
ADD R6 R5 R2  ;"ADD" data in Register 5 with bitmask in Register 2 and store it in Register 6
STR R4 R6 #0  ;"Store" data in Register 4 into address in Register 6
HALT

.FILL x3500
.FILL x00FF
.FILL x3FFF

.END
