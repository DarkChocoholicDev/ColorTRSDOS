!IFNDEF LWToolsPath
!MESSAGE LWToolsPath environment variable is not set. Let's hope LWASM is in the path!
!ENDIF

!IF "$(LWToolsPath)" == ""
!MESSAGE LWToolsPath=$(LWToolsPath)
LWASM=lwasm.exe
!ELSE
!MESSAGE LWToolsPath=$(LWToolsPath)
LWASM="$(LWToolsPath)\lwasm.exe"
!ENDIF

ASMFLAGS = --decb
RAWFLAGS = --raw
OUTDIR = bin

all: $(OUTDIR)\DOSBOOT.raw $(OUTDIR)\DOS.BIN $(OUTDIR)\DOSBOOT.raw

$(OUTDIR)\DOSCore.raw: DOSCore.asm ..\OriginalDOSBIN\ColorTRSDOS.asm
	@if not exist "$(OUTDIR)" mkdir "$(OUTDIR)"
	$(LWASM) $(RAWFLAGS) -o $(OUTDIR)\DOSCore.raw DOSCore.asm  --list=$(OUTDIR)\DOSCore.lst

$(OUTDIR)\DOS.BIN: $(OUTDIR)\DOSCore.raw DOSCoreWrapper.asm
	$(LWASM) $(ASMFLAGS) -o $(OUTDIR)\DOS.BIN DOSCoreWrapper.asm --list=$(OUTDIR)\DOSCoreWrapper.lst

$(OUTDIR)\DOSBOOT.raw: $(OUTDIR)\DOSCore.raw BootWrapper.asm
	$(LWASM) $(RAWFLAGS) -o $(OUTDIR)\DOSBOOT.raw BootWrapper.asm

clean:
	-del /q $(OUTDIR)\*