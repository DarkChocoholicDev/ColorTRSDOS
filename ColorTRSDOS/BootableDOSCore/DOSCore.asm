
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
B1      FDB     B2-B1   SIZE OF OVERLAY
        lda     'I'
        jsr     [ChrOut]
        leau    CmdShellName,pcr
        ldx     #USRDCB
        ldb     #11
        jsr     XFRUX
        lda     'O'
        jsr     [ChrOut]
        DOS     GO,EXEC
        rts
        
CmdShellName:
        FCC     /LCMD    BIN/


B2      FDB    B3-B2    SIZE OF OVERLAY
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

B3      FDB    B4-B3    SIZE OF OVERLAY
        DOS   DO,RUNIP

B4      FDB    B5-B4    SIZE OF OVERLAY
        DOS   DO,RUNIP

B5      FDB    B6-B5    SIZE OF OVERLAY
        DOS   DO,RUNIP

B6      FDB    B7-B6    SIZE OF OVERLAY
        DOS   DO,RUNIP

B7      FDB    B8-B7    SIZE OF OVERLAY
        DOS   DO,RUNIP

B8      FDB    B9-B8    SIZE OF OVERLAY
        DOS   DO,RUNIP

B9      FDB    B10-B9   SIZE OF OVERLAY
        DOS   DO,RUNIP

B10     FDB    B11-B10  SIZE OF OVERLAY
        DOS   DO,RUNIP

B11     FDB    B12-B11  SIZE OF OVERLAY
        DOS   DO,RUNIP


*
*******************************************
* ACTUALLY LOAD AND EXECUTE PROGRAM
* GIVEN: DCB FOR THE PROGRAM FILE STORED
*        IN USRDCB
*******************************************
B12    FDB   B13-B12   SIZE OF OVERLAY
       ; BRA  *
       PSHS X          SAVE MY BASE (LOWEST LOAD ADDRESS ALLOWED)
* STEP 1 OPEN THE PROGRAM FILE - DOES IT EXIST?
       LDU   #USRDCB
       LDA   #$FF
       STA   DCBDRV,U SEARCH ALL DRIVES
       DOS   OPEN,INPUT
       BEQ   EX1       IF OK
       CMPA #ERR13     NOT PREV CLOSED IS OK
       BEQ   EX1
EXERR JSR     [ERROR]
       PULS   X
       DOS    GO,MENU
*
* READ FILE PREFIX DATA (LOAD ADDR, RBA OF 1ST OVERLAY. ETC)
EX1    LDX    >OLYLOC POINT BEYOND ME
       STX    DCBLRB,U USE AS LOGICAL REC BUFFER
       LDD    #10      READ 1ST 10 BYTES OF PROGRAM FILE
       STD    DCBRSZ,U
       DOS    READ,RBA
       BNE    EXERR
       TST    ,X       IS 1ST BYTE ZERO?
       BEQ    EX2      IF YES, OK
       LDA    #ERR27   WRONG TYPE FILE
       BRA    EXERR
EX2    LDD    3,X      (LOAD ADDRESS)
       BEQ    EX3A     IF BASED AT ZERO, ASSUME RELOCATABLE
       CMPD   ,S       HE MUST LOAD ABOVE THIS POINT
       BCC    EX3      IF HE IS OK
       LDA    #ERR26   LOAD ADDR IS TOO LOW
       BRA    EXERR
* LOAD ADDRESS IS HIGH ENOUGH
EX3    STD    DCBLRB,U SET THIS AS LOGICAL RECORD BUFFER
EX3A   LDD    DCBLRB,U
       INCD
       STD    >USRBSE
       LDD    8,X      (SHOULD BE RBA OF 1ST OVERLAY)
       STD    DCBRSZ,U THAT IS ALSO HOW BIG ROOT SECTION IS
       ADDD   DCBLRB,U RESULT IS WHERE END OF ROOT WILL BE IN MEMORY
       ADDD   #3
       STD    >OLYLOC SET THIS AS BASE OF FUTURE OVERLAYS
       TFR    D,Y
       LDA    #$FF     INVALIDATE WHICH OVERLAY IS IN OVERLAY AREA
       STA    -1,Y
       LDA    #5
       STA    DCBRBA+2,U START READING WITH 6TH BYTE
       PULS   X        U
       JMP    B12A     GO LOAD ROOT & XFER CONTROL TO IT

B13     FDB    B14-B13  SIZE OF OVERLAY
        DOS   DO,RUNIP

B14     FDB    B15-B14  SIZE OF OVERLAY
        DOS   DO,RUNIP

B15     FDB    B16-B15  SIZE OF OVERLAY
        DOS   DO,RUNIP

B16     FDB    B17-B16  SIZE OF OVERLAY
        DOS   DO,RUNIP

B17     FDB    B18-B17  SIZE OF OVERLAY
        DOS   DO,RUNIP

B18     FDB    B19-B18  SIZE OF OVERLAY
        DOS   DO,RUNIP

B19     FDB    B20-B19  SIZE OF OVERLAY
        DOS   DO,RUNIP

B20     FDB    LASTPG-B20  SIZE OF OVERLAY
        DOS   DO,RUNIP

LASTPG:

; Values used by the boot loader to relocate our code to the intended location.
        fdb     ORGIN                   ; Boot relocation target.
        fdb     LASTPG-ORGIN            ; Count of bytes to copy.
        fdb     InitWithoutRelocation   ; Branch address after copy.

    ; When run directly, the program loader uses this for the start of execution.
    end