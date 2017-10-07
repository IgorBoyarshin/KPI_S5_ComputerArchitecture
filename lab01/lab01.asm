; ----------------Input-----------------
; P4:P5 [high:low]

; Write into the low bits
sel RB0

; Load R0
movd A, P4
swap A
mov R0, A
movd A, P5
orl A, R0
mov R0, A

; Load R1
movd A, P4
swap A
mov R1, A
movd A, P5
orl A, R1
mov R1, A

; Load R2
movd A, P4
swap A
mov R2, A
movd A, P5
orl A, R2
mov R2, A

; Load R3
movd A, P4
swap A
mov R3, A
movd A, P5
orl A, R3
mov R3, A

; Load R4
movd A, P4
swap A
mov R4, A
movd A, P5
orl A, R4
mov R4, A

; Load R5
movd A, P4
swap A
mov R5, A
movd A, P5
orl A, R5
mov R5, A

; Load R6
movd A, P4
swap A
mov R6, A
movd A, P5
orl A, R6
mov R6, A

; Load R7
mov R7, #04h


; ----------------Main-----------------
; BANK1:BANK0 [high:low]

; -----Block 01 Start-----
; R0 = !(R2 xor R3)
; This operation always results in 1s in the high chunk of R0
sel RB0 ; low
mov A, R2
xrl A, R3
cpl A
mov R0, A

sel RB1 ; high
mov A, #FFh
mov R0, A
; ----- Block 01 End -----

; -----Block 02 Start-----
; R3 = 2 * (R0 - R4 - 1) ===
; === 2 * (R0 + !R4)
sel RB0 ; low
mov A, R4
cpl A ; invert
add A, R0
mov R3, A

; Add the carry into the high chunk
sel RB1 ; high
mov A, R4 
cpl A ; invert
addc A, R0
mov R3, A

; Shift the low chunk
sel RB0 ; low
mov A, R3
clr C
rlc A
mov R3, A

; Shift the carry flag into the high chunk
sel RB1 ; high
mov A, R3
rlc A
mov R3, A
; ----- Block 02 End -----

loop5:
; -----Block 03 Start-----
; R2 = (R1 - 1) / 2
sel RB0 ; low
mov A, R1
add A, #FFh ; dec A
mov R2, A

sel RB1 ; high
mov A, R1
addc A, #FFh
clr C ; now shift the high chunk
rrc A
mov R2, A

sel RB0 ; low
mov A, R2
rrc A
mov R2, A
; ----- Block 03 End -----

if4:
jc if4_yes
if4_no:
call mpp

if4_yes:
sel RB0 ; low 
djnz R7, loop5

; -----Block 06 Start-----
; R0 = !R6 & R3
sel RB0 ; low
mov A, R6
cpl A ;invert
anl A, R3
mov R0, A

sel RB1 ; high
mov A, R6
cpl A ;invert
anl A, R3
mov R0, A
; ----- Block 06 End -----
jmp exit




mpp:
; -------MPP Start-------
; -----Block 07 Start-----
; R6 = 2 * (R5 - R2 - 1) ===
; === 2 * (R5 + !R2)
sel RB0 ; low
mov A, R2
cpl A ; invert
add A, R5
mov R6, A

; Add the carry into the high chunk
sel RB1 ; high
mov A, R2
cpl A
addc A, R5
mov R6, A

; Shift the low chunk
sel RB0 ; low
mov A, R6
clr C
rlc A
mov R6, A

; Shift the carry flag into the high chunk
sel RB1 ; high
mov A, R6
rlc A
mov R6, A
; ----- Block 07 End -----

if8:
jf1 if8_no
if8_yes:
; -----Block 09 Start-----
sel RB0 ; low
mov A, R6
add A, #77h
mov R1, A

sel RB1 ; high
mov A, R6
addc A, #77h
mov R1, A
; ----- Block 09 End -----

if8_no:
; -----Block 10 Start-----
; R6 = (R0 - 1) / 2
sel RB0 ; low
mov A, R0
add A, #FFh ; dec A
mov R6, A

sel RB1 ; high
mov A, R0
addc A, #FFh
clr C ; now shift the high chunk
rrc A
mov R6, A

sel RB0 ; low
mov A, R6
rrc A
mov R6, A
; ----- Block 10 End -----

; -----Block 11 Start-----
; R5 = R6 + 1
sel RB0 ; low
mov A, R6
add A, 1
mov R5, A

sel RB1 ; high
mov A, R6
addc A, 0
mov R5, A
; ----- Block 11 End -----

ret
; ------- MPP End -------



exit:
; -------- END --------

