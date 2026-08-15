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
;
; Preconditions:
;           Subroutine is supplied with a pointer to first element of Source Array in X register
;
; Use:      jsr Sum_Products
;
; Postconditions:
;           Subroutine returns Sum of Products in D register (16-bit value)
;           Registers X, Y, and A/B are used and updated during execution.
;
; Algorithm:
;           1. Initialize Accumulator D to 0.
;           2. Initialize Y register with factor 10.
;           3. Loop 10 times:
;              a. Load a digit from the array pointed to by X.
;              b. Multiply the digit by the current factor in Y.
;              c. Add the product to the running total.
;              d. Increment X and decrement Y.
;           4. Return the final Sum of Products in D.
;

Sum_Products
                clra                    ; D = 0
                clrb                    ; D = 0

                ldy     #10             ; Start multiplier at 10

SP_Loop
                pshd                    ; Save current running total

                ldaa    0,x             ; Load current ISBN digit into A
                psha                    ; Save digit temporarily

                tfr     y,d             ; Copy multiplier Y into D
                                        ; B now contains multiplier

                pula                    ; Restore digit into A
                                        ; A = digit, B = multiplier

                mul                     ; D = A * B

                addd    0,sp            ; Add previous running total

                std     0,sp            ; Save updated running total

                inx                     ; Move to next ISBN digit
                dey                     ; Decrease multiplier
                bne     SP_Loop         ; Repeat until multiplier = 0

                puld                    ; Return final sum in D
                rts