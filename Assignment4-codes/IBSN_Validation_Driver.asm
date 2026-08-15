; IBSN_Validation_Driver.asm
;
; Author:                D. Haley
; Student Number:        Faculty
; Course:                CST8216 Processor Architecture
;
; Modified by:                      Emmanuel Fofeyin Ngwamunwi
; Student Number:                   041161315
; Modification Date:                2026-08-14
;
; Notes: 1. Only students identified in the above header * at the time of submission *
;           are eligible for marks for this portion of the assignment.
;        2. No more that 3 student per group
;        3. ALL students must be from the SAME lab section.
;        4. No exceptions to any of the above
;
; Background:
;        This program builds upon a previous one that converted
;        ISBNs to Digits by skipping the EAN's "978-" and removing Hyphens '-'
;        and converting the ASCII values to Digits and placing them into a
;        Destination array for further processing.
;
; Purpose:
;
;        After ISBN conversion from ASCII EAN (ISBN-13) to Digits is complete,
;        each of the ISBN-10 values are validated using the process detailed in
;         the assignment. Then, the results of the number of Valid
;        and Invalid ISBNs are displayed on the HEX Displays.
;
; Notes: The subroutine to convert from ASCII to Digit is included in
;        API.s19 and the details regarding the EAN_String_Conversion
;        subroutine is in included in the provided
;        22F CST8216 API Booklet for A4.pdf document. This is MANDATORY reading.
;
;        You must complete the other two subroutines that support this
;        program - Sum_Products and Validate_ISBN, which are required to
;        implement the functionality described in the assignment document.
;        Their "include" statements are at the end of this program.
;
; ***** DO NOT CHANGE ANY CODE BETWEEN THESE MARKERS *****
;
; New Library Routine used in this software:
#include API_Config.txt
;
; Program Constants
STACK           equ     $2000
                                ; Port P (PPT) Display Selection Values
DIGIT3_PP0      equ     %1110   ; Left-most display MSB
DIGIT0_PP3      equ     %0111   ; Right-most display LSB

; Delay Subroutine Values
DVALUE  equ     #250            ; Delay value (base 10) 0 - 255 ms
                                ; 125 = 1/8 second <- good for Dragon12 Board

; Program Constants - These values should be used in your solution
EAN_LENGTH      equ     17        ; Each ASCII EAN has 17 ASCII characters
ISBN_LENGTH     equ     10        ; Each numeric ISBN has 10 digits
NUMBER_OF_EANs  equ     06        ; Total of six EANs to Validate
ASCII_HYPHEN    equ     '-'       ; Hyphen to be removed from ASCII ISBN
VALID_ISBN      equ     $55       ; Valid DATA indicator
INVALID_ISBN    equ     $AA       ; Invalid DATA indicator

        org        $1000
Start_ASCII_EAN
#include EAN_Lab_Section_301.txt
End_ASCII_EAN

        org        $1070          ; Aligns Values in Simulator Address Window
Number_Of_Valid_ISBNs   ds      1 ; 8 bit total    Mandatory Storage
Number_Of_InValid_ISBNs ds      1 ; 8 bit total    Mandatory Storage

        org        $1080          ; Aligns Values in Simulator Address Window
Start_Numeric_ISBN
        ds        ISBN_LENGTH*NUMBER_OF_EANs ;    size of this destination array
End_Numeric_ISBN

        org     $2000
        lds     #$2000
; Strip "978-" and Hyphens '-' from ASCII EAN and convert ASCII values to Digits
        ldx     #Start_ASCII_EAN                ; Pointer to Source
        ldy     #Start_Numeric_ISBN             ; Pointer to Destination Array
        ldaa    #EAN_LENGTH*NUMBER_OF_EANS      ; Number of ASCII EAN Characters
                                                ; to process
        ldab    #ASCII_HYPHEN                   ; Character to Remove from EANs
        jsr     EAN_String_Conversion           ; Destination Array Filled with
                                                ; ISBN Digits

; ***** END OF DO NOT CHANGE ANY CODE BETWEEN THESE MARKERS *****

; Your code goes here - approxiametly 15 lines of code
        ; Your code goes here - approxiametly 15 lines of code
        clra                            ; Clear ACCA to initialize valid counter
        staa    Number_Of_Valid_ISBNs   ; Number_Of_Valid_ISBNs = 0
        staa    Number_Of_InValid_ISBNs ; Number_Of_InValid_ISBNs = 0
        ldx     #Start_Numeric_ISBN     ; X points to the first numeric ISBN
        ldab    #NUMBER_OF_EANs         ; B acts as our loop counter (6 EANs)

Validate_Loop:
        pshb                            ; Save loop counter on stack
        pshx                            ; Save current ISBN pointer on stack
        jsr     Sum_Products            ; Calculate Sum of Products for current ISBN
        jsr     Validate_ISBN           ; Validate the ISBN using the remainder check
        pulx                            ; Restore ISBN pointer
        pulb                            ; Restore loop counter

        cmpa    #VALID_ISBN             ; Check if result returned valid ($55)
        bne     Not_Valid               ; If not equal, jump to increment invalid count

        ldaa    Number_Of_Valid_ISBNs   ; Load current valid count
        inca                            ; Increment count by 1
        staa    Number_Of_Valid_ISBNs   ; Store back updated valid count
        bra     Next_ISBN

Not_Valid:
        ldaa    Number_Of_InValid_ISBNs ; Load current invalid count
        inca                            ; Increment count by 1
        staa    Number_Of_InValid_ISBNs ; Store back updated invalid count

Next_ISBN:
        xgdx                            ; Move X pointer into D temporarily
        addd    #ISBN_LENGTH            ; Advance pointer by 10 bytes to next ISBN
        xgdx                            ; Move updated pointer back into X
        decb                            ; Decrement loop counter
        bne     Validate_Loop           ; Repeat loop if more EANs remain

; ***** DO NOT CHANGE ANY CODE BETWEEN THESE MARKERS *****
        jsr     Config_HEX_Displays
Display ldaa    Number_Of_Valid_ISBNs
        ldab    #DIGIT3_PP0             ; Select MSB
        jsr     Hex_Displays            ; Display the value
        ldaa    #DVALUE
        jsr     Delay_ms                ; Delay for DELAY_VALUE milliseconds
        ldaa    Number_Of_InValid_ISBNs
        ldab    #DIGIT0_PP3             ; Select LSB
        jsr     Hex_Displays            ; Display the value
        ldaa    #DVALUE
        jsr     Delay_ms                ; Delay for DELAY_VALUE milliseconds
        bra     Display                 ; Endless loop

#include Sum_Products.asm               ; Subroutine to be completed
#include Validate_ISBN.asm              ; Subroutine to be completed
; ***** END OF DO NOT CHANGE ANY CODE BETWEEN THESE MARKERS *****

         end
         