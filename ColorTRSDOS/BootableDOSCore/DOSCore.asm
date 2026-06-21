
; Include the core DOS support from ColorTRSDOS.asm, skipping the system overlays.

SKIP_OVERLAY_SECTION    set    1
                        include "..\OriginalDOSBIN\ColorTRSDOS.asm"

DOSCoreInit:
    




; Define the values referenced in the core DOS.
OVRLAY:
B1:
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

    ; The boot loader will look here for the start of execution.
    fdb     DOSCoreInit

    ; When run directly, the program loader uses this for the start of execution.
    end     DOSCoreInit