
; Include the core DOS support from ColorTRSDOS.asm, skipping the system overlays.
SKIP_OVERLAY_SECTION    set    1
                        include "..\OriginalDOSBIN\ColorTRSDOS.asm"
    


ChrOut      equ     $A002       ; Output a character to the active device.
PolCat      equ     $A000       ; Retrieve a character from the console.


; Define the values referenced in the core DOS.

*
**************************************************************************
* INITIAL START UP - CHECK FOR AUTO EXECUTE
*
**************************************************************************
B1     FDB    B2-B1    SIZE OF OVERLAY

        leax    MsgUnsupported,pcr
        bsr     WriteString
        bra     *

MsgUnsupported  fcz     "UNSUPPORTED SYSTEM OVERLAY."

WriteChar
        jsr     [ChrOut]
        rts

WriteLine
        pshs    a
        bsr     WriteString
        lda     13
        bsr     WriteChar
        puls    a
        rts

WriteString
        pshs    a,x
    WL1:
        lda     ,x+
        beq     WL2
        jsr     [ChrOut]
        bra     WL1

    WL2:
        puls    a,x
        rts

B2:
B3:
B4:
B5:
B6:
B7:
B8:
B9:
B10:
B11:
B12:
B13:
B14:
B15:
B16:
B17:
B18:
B19:
B20:
LASTPG:

; Values used by the boot loader to relocate our code to the intended location.
        fdb     ORGIN                   ; Boot relocation target.
        fdb     LASTPG-ORGIN            ; Count of bytes to copy.
        fdb     InitWithoutRelocation   ; Branch address after copy.

    ; When run directly, the program loader uses this for the start of execution.
    end