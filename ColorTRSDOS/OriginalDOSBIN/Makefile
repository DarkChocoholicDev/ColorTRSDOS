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

all: $(OUTDIR)/DOS.BIN

$(OUTDIR)/ColorTRSDOS.raw: ColorTRSDOS.asm
	@if not exist "$(OUTDIR)" mkdir "$(OUTDIR)"
	$(LWASM) $(RAWFLAGS) -o $(OUTDIR)\ColorTRSDOS.raw ColorTRSDOS.asm

$(OUTDIR)/DOS.BIN: $(OUTDIR)/ColorTRSDOS.raw DOSWrapper.asm
	$(LWASM) $(ASMFLAGS) -o $(OUTDIR)\DOS.BIN DOSWrapper.asm

clean:
	-del /q $(OUTDIR)\*