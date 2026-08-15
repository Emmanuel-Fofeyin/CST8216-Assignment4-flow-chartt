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
;          Subroutine is supplied with Sum of Products,
;          a 16-bit value in D register
;
; Use:     jsr Validate_ISBN
;
; Postconditions:
;          Subroutine returns a validation flag in accumulator A.
;          A = $55 for VALID
;          A = $AA for INVALID
;          Registers D and X are updated/destroyed.
;
; Algorithm:
;          1. Load divisor 11 into X.
;          2. Divide D by X.
;          3. IDIV leaves the quotient in X and remainder in D.
;          4. If remainder is zero, return VALID_ISBN ($55).
;          5. Otherwise, return INVALID_ISBN ($AA).
;          6. Return from subroutine.
;

Validate_ISBN
                ldx     #11             ; Divisor = 11

                idiv                    ; D / X
                                        ; X = quotient
                                        ; D = remainder

                cpd     #0              ; Check remainder

                bne     ISBN_Bad        ; Non-zero remainder = invalid

                ldaa    #VALID_ISBN     ; Valid ISBN = $55
                bra     ISBN_Done

ISBN_Bad
                ldaa    #INVALID_ISBN   ; Invalid ISBN = $AA

ISBN_Done
                rts