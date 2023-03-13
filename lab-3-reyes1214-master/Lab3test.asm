;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Testcase for Lab 3
; Linked List contains: Pointer to resource name, location, pointer to next node
; Author: Jerry Yang
; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.ORIG x6000
.FILL HEAD
.BLKW x1000

HEAD .FILL RES3
     .FILL x4203
     .FILL N2

     .BLKW 3
 
N1   .FILL RES4
     .FILL x4504
     .FILL N3

     .BLKW 2

N2   .FILL RES1
     .FILL x4305
     .FILL N1

     .BLKW 5

N3   .FILL RES5
     .FILL x4202
     .FILL N4

     .BLKW 6

N4   .FILL RES2
     .FILL x4603
     .FILL 0

     .BLKW x100

RES1 .STRINGZ "EER"
RES2 .STRINGZ "Perry-Castaneda Library"
RES3 .STRINGZ "Counseling and Mental Health Center"
RES4 .STRINGZ "Gender/Sexuality Center"
RES5 .STRINGZ "Littlefield Cafe"

.END