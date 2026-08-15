; Validate_ISBN.asm
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
; Purpose: To Validate an ISBN 10 by
;             dividing its Sum Of Products
;             value by 11 and observing
;             the Remainder.
;          If the Remainder = 0, then the
;             ISBN is VALID; otherwise,
;             it is not
;
; Preconditions:
;          Subroutine is supplied with Sum of Products, a 16-bit value in D register
;
; Use:     jsr Validate_ISBN
;
; Postconditions:
;          Subroutine returns a "Flag" in accumulator A (e.g., 0 for Valid, 1 for InValid).
;          Registers D and X/Y used during division are updated or destroyed.
;
; Algorithm:  
;          1. Load the 16-bit Sum of Products into the D register.
;          2. Perform an unsigned integer division of D by 11 (using IDIV or EDIV standard structure).
;          3. Check the remainder (which resides in the designated remainder register/accumulator).
;          4. Set the validation flag to 0 if the remainder is zero (Valid), or 1 if non-zero (InValid).
;          5. Return from subroutine.
;
Validate_ISBN   ; subroutine entry label - must be present
                ldx #11         ; Load divisor 11 into X register
                idiv            ; Perform integer division: D / X -> quotient in X, remainder in D
                cpx #0          ; Check if remainder (in X) is equal to 0
                beq Is_Valid    ; If remainder is 0, jump to valid tag
                lda #1          ; Otherwise, set flag to 1 (InValid)
                bra End_Validate
Is_Valid        clra            ; Set flag to 0 (Valid)
End_Validate    rts             ; Return from subroutine