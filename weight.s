.EQU SWI_STOP, 0x11

.DATA
data_start: .word 0x205A15E3
            .word 0x256C8700
data_end:   .word 0x295468F2
NUM:        .word 0x0
WEIGHT:     .word 0x0 
.TEXT
.global MAIN

MAIN:
    LDR R6, =data_start         @ Load data_start address in R6
    LDR R7, =data_end           @ Load data_end address in R7
    ADD R7, R7, #4              @ Add #4 to R7 to check all data are read or not
    MOV R4, #0                  @ Setting R4 to #0 which will have weight at end
LOOP:                           @ This loop will get executes for all data items
    LDR R0, [R6], #4            @ Store contents pointed by address R6 in R0 and increment R6 to next address
    MOV R1, #1                  @ Move #1 to R1
    MOV R3, #0                  @ Set R3 to #0 for weight calculation for each number
INNER_LOOP:                     @ INNER_LOOP is executed for 32 bits in word
    ANDS R2, R0, R1             @ AND R0 with R1 and store the result in R2 and set the status flags
    ADDNE R3, R3, #1            @ Add #1 to R3 if Z flag is not set which mean the bit is not set in R1 position
    MOV R1, R1, LSL #1          @ Shift R1 by one bit to left
    CMP R1, #0                  @ R1 will become after 31 shift so comparing with #0
    BNE INNER_LOOP              @ If R1 not reached #0 loop again to INNER_LOOP
    CMP R4, R3                  @ Compare R4 with R3; R4 is used to contain maximum weight 
    MOVMI R4, R3                @ Move contents of R3 to R4 if N flag is set which mean R3 is large
    MOVMI R5, R0                @ Move the largest weight word to R5
    CMP R6, R7                  @ Compare R6 with R7 to check whether last word is done or not
    BEQ EXIT                    @ If Both R6 and R7 same means it reached end so jump to EXIT
    B LOOP                      @ If not jump to LOOP
EXIT:
    LDR R6, =NUM                @ Load NUM address to R6
    LDR R7, =WEIGHT             @ Load WEIGHT address to R7
    STR R4, [R7]                @ Store R4 contents (weight) to memory location pointed by R7
    STR R5, [R6]                @ Store R5 contents (largest weight number) to memory location pointed by R6
    SWI SWI_STOP                