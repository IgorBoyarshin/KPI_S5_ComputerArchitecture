; [x1;x2;y1;y2;y3;y4;y5;--]

; --------------------Main Start-------------------
; Prepare to read x1 and x2


; x1 condition
    anl P2, #00000000b
    orl P2, #11000000b
	in A, P2
   	jb7 x1_1
	jmp x1_0

x1_0:
label1:
    call block1

; x2 condition
    anl P2, #00000000b
    orl P2, #11000000b
    in A, P2
    jb6 x2_1
	jmp x2_0

x2_0:
    call block3
    jmp label1

x1_1:
    call block2
x2_1:
    call block4
    call block1
    jmp the_end
; -------------------- Main End -------------------





; ------------------Block 1 Start------------------
; y1[y5]
; y1 = 40
; [y5] = 150 = 40 + (80) * 1 + 30
block1:
	; 40 [41.5]
	mov R7, #07h
	orl P2, #00100010b      ; ON y1y5       ;..1.5
block1_l1:	
    djnz R7, block1_l1 					    ; (5) * 7
    anl P2, #00000010b      ; OFF y1        ; 3.5.. [5]

	; [80 + 15 = 95]
	mov A, #FFh ; (-1)dk                    ; 5
	mov T, A                                ; 2.5
    strt T                                  ; 2.5
block1_l2:                                  ; 80 + 5
    jtf block1_l3
    jmp block1_l2
block1_l3:
            
	; [13.5]
    mov R7, #01h                            ; 5
block1_l4:
    djnz R7, block1_l4                      ; (5) * 1
    anl P2, #11000000       ; Off y5        ; 3.5..

    ret
; ------------------ Block 1 End ------------------





; ------------------Block 2 Start------------------
; y2
; y2 = 240 = (80) * 2 + 80
block2:
	; 1.5 + (80) * 2 + 15 = 176.5
    orl P2, #00010000b      ; ON y2         ; ..1.5
	mov A, #FEh ; (-2)dk                    ; 5
	mov T, A                                ; 2.5
    strt T                                  ; 2.5
block2_l1:                                  ; (80) * 2 + 5
    jtf block2_l2
    jmp block2_l1
block2_l2:
            
	; 5 + (5) * 11 + 3.5 = 63.5
    mov R7, #0Bh            ; 11            ; 5
block2_l3:
    djnz R7, block2_l3                      ; (5) * 11
    anl P2, #11000000       ; Off y2        ; 3.5..

    ret
; ------------------ Block 2 End ------------------





; ------------------Block 3 Start------------------
; y2y3y4
; y4 = 50
; [y3] = 100 = 50 + 50
; {y2} = 240 = 100 + (80) * 1 + 60
block3:
    ; 50 [51.5] {51.5}
    mov R7, #09h
	orl P2, #00011100b      ; ON y2y3y4     ;..1.5
block3_l1:	
    djnz R7, block3_l1 					    ; (5) * 9
    anl P2, #00011000b      ; OFF y4        ; 3.5.. [5] {5}

    ; [48.5] {50}
    mov R7, #08h                            ; 5
block3_l2:	
    djnz R7, block3_l2 					    ; (5) * 8
    anl P2, #00010000b      ; OFF y3        ; 3.5.. {5}

    ; {95}
    mov A, #FFh ; (-1)dk                    ; 5
	mov T, A                                ; 2.5
    strt T                                  ; 2.5
block3_l3:                                  ; 80 + 5
    jtf block3_l4
    jmp block3_l3
block3_l4:

    ; {43.5}
    mov R7, #07h                            ; 5
block3_l5:	
    djnz R7, block3_l5 					    ; (5) * 7
    anl P2, #11000000b      ; OFF y2        ; 3.5..

    ret
; ------------------ Block 3 End ------------------





; ------------------Block 4 Start------------------
; y1y2y5
; y1 = 40
; [y5] = 150 = 40 + (80) * 1 + 30
; {y2} = 240 = 150 + 90
block4:
    ; 40 [41.5] {41.5}
    mov R7, #07h
	orl P2, #00110010b      ; ON y1y2y5     ;..1.5
block4_l1:	
    djnz R7, block4_l1 					    ; (5) * 9
    anl P2, #00010010b      ; OFF y1        ; 3.5.. [5] {5}

    ; [95] {95}
    mov A, #FFh ; (-1)dk                    ; 5
	mov T, A                                ; 2.5
    strt T                                  ; 2.5
block4_l2:                                  ; 80 + 5
    jtf block4_l3
    jmp block4_l2
block4_l3:

    ; [13.5] {15}
    nop                                     ; 2.5
    nop                                     ; 2.5
    nop                                     ; 2.5
    nop                                     ; 2.5
    anl P2, #00010000b      ; OFF y5        ; 3.5.. {5}

    ; {88.5}
    mov R7, #10h                            ; 5
block4_l4:	
    djnz R7, block4_l4 					    ; (5) * 16
    anl P2, #11000000b      ; OFF y2        ; 3.5..

    ret
; ------------------ Block 4 End ------------------


the_end:
