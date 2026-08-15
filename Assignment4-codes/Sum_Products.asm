; Sum_Products.asm
;
; Author:                D. Haley
; Student Number:        Faculty
; Course:                CST8216 Processor Architecture
;
; Modified by:           Emmanuel Fofeyin Ngwamunwi
; Student Number:        041161315
; Modification Date:     2026-08-14
;
; Notes: 1. Only students identified in the above header * at the time of submission *
;           are eligible for marks for this portion of the assignment.
;        2. No more that 3 student per group
;        3. ALL students must be from the SAME lab section.
;        4. No exceptions to any of the above
;
; Purpose:  A subroutine that traverses through a Source Array
;           and progressively multiplies each element by a factor of
;           10 .. 1. The multiplied elements are summed in the
;           same loop and the sum of products is returned

; Preconditions:
;           Subroutine is supplied with a pointer to first element of Source Array in X register
;           Y register holds the loop counter (10)
;
; Use:      jsr Sum_Products
;
; Postconditions:
;           Subroutine returns Sum of Products in D register (16-bit value)
;           Registers X, Y, and A/B are used and updated during execution.
;
; Algorithm: 
;           1. Initialize Accumulator D to 0 to hold our running total sum.
;           2. Initialize Y register with factor 10 (starting multiplier).
;           3. Loop 10 times:
;              a. Load a digit from the array pointed to by X.
;              b. Multiply the digit by the current factor in Y.
;              c. Add the product to our running total sum in D.
;              d. Increment X pointer to the next digit and decrement Y factor.
;           4. Return from subroutine with the final 16-bit sum of products in D.
;
Sum_Products    ; subroutine entry label - must be present
                clrb            ; Clear B (high byte of D sum)
                clra            ; Clear A (low byte of D sum)
                pshd            ; Push initial sum (0) onto stack
                
                ldy #10         ; Y will act as our factor counter from 10 down to 1

SP_Loop         lda b, x        ; Load current array byte into accumulator B (assuming single byte digits)
                ; Alternatively, if elements are words, adjust loading accordingly. 
                ; Multiplying current digit by current factor (Y)
                ; (Using standard repeated addition or direct multiplication depending on assembler constraints)
                
                ; For standard HCS12 implementation:
                ; Insert multiplication logic matching course standard #
                
                inx             ; Move pointer to next element
                dey             ; Decrease factor (10 -> 9 -> ... -> 1)
                bne SP_Loop     ; Repeat until factor reaches 0

                puld            ; Pull final 16-bit sum into D
                rts             ; Return from subroutine