;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Testcase for Timelines Lab
; Author: Jerry Yang
; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.ORIG x4000 ; store this at x4000

; List of events and dates
.FILL E1
.FILL x1903
.FILL E2
.FILL x1947
.FILL E3
.FILL x1964
.FILL E4
.FILL x1981
.FILL E5
.FILL x2017

.BLKW 10 ; Data spacer

; Events as strings
E1 .STRINGZ "UT EE established" 
E2 .STRINGZ "Edith Clarke becomes first female professor in UT EE"
E3 .STRINGZ "Moore's Law coined"
E4 .STRINGZ "UT EE becomes UT ECE"
E5 .STRINGZ "UT ECE moves into EER"

.END