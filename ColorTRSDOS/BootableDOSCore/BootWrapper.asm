        PRAGMA  6809    ; Restrict code to using just valid 6809 instructions.

        ORG     $2600

        ; "Bootable" signature.
        FCC     "OS"

        ; Pause in the debugger.
        ;bra     *

        ; Relocate the core DOS code.
		ldx		#DOSCoreBegin
        ldu     RelocationTarget
        ldy     RelocationLength
RelocationLoop:
        lda     ,x+
        sta     ,u+
        leay    -1,y
        bne     RelocationLoop
		jmp     [BranchAddress]

; Define 

; Include our core DOS code.
DOSCoreBegin:
        INCLUDEBIN "bin\DOSCore.raw"
DOSCoreEnd:

RelocationTarget    equ     *-6
RelocationLength    equ     *-4
BranchAddress       equ     *-2

        END
