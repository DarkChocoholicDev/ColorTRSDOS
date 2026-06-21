# ColorTRSDOS
An archive of the original Color TRSDOS source code for the Tandy Color Computer, plus a new command line shell built around it.

The original "Color TRSDOS" software was written by Robert G. Kilgus and released as part of disk-based applications for the Tandy Color Computer.
Tandy's "Disk EDTASM" product, an editor/assembler utility for the Tandy Color computer, not only included the executable files for Color TRSDOS,
but it included the assembly language source code for the machine language component (DOS.BIN) in the user manual for Disk EDTASM. This GitHub project
preserves that original source code as best as possible.

Because the original UI for Color TRSDOS consisted of just a simple text menu with a handful of options for tasks such as displaying a directory listing,
copying files, and running a program, this project additionally provides a command line shell to offer a more traditional "DOS-like" interface.

## Visual Studio Solution and Projects
This repro consists primarily of the Visual Studio 2026 solution, ColorTRSDOS. The solution contains several projects, listed below.
For those simply seeking the original source code for DOS.BIN, head straight to the "OriginalDOSBIN" project.

**Note**: The LWASM assembler is used to build the assembly language files. At least for the moment, the build files assume that the LWToolsPath environment
variable contains the location of the LWTools toolset. If there's a better way to handle that dependency, I'm sure we can incorporate it going forward.

### OriginalDOSBIN
The OriginalDOSBIN project contains the heavily-repaired OCR-scanned DOS program listing from the user manual for Tandy's "Disk EDTASM" product.
The project builds DOS.BIN exactly as it was on the Disk EDTASM product
diskette. To reproduce DOS.BIN exactly, the main assembly file, ColorTRSDOS.asm, is first assembled to a "raw" file (i.e. no
loader information), and then a "wrapper" file, DOSWrapper.asm, is used to slightly re-order the output. Without the wrapper, the "overlay" and "core" portions
are reversed (as they are in the main assembly file), and thus not precisely what was shipped in executable form.

**Note 1**: The OCR process that generated the code introduced a lot of content and formatting errors. Fortunately,
I was able to fix the resulting code errors so that it assembles to exactly what was shipped in the original DOS.BIN executable. However, repairs to the
formatting and code comments is still ongoing.

**Note 2**: I've prefixed my "adjustments" with my initials "KJF" to help explain the changes. For the most part, those are fixes/corrections to make things
assemble properly with LWASM. In one special case, though, I've added conditional assembly to let the file assemble without the "overlay" section, so that the "DOS core"
and "overlay" sections can be built and package separately by the BootableDOSCore project (which creates a bootable version of ColorTRSDOS). When I am completely done
with the cleanup of OCR issues, I'll remove my conditional assembly and simply maintain a separate version of the file for the BootableDOSCore project so that the original
file can stay pristine.

### BootableDOSCore
The BootableDOSCore project creates a special version of Color TRSDOS that can be loaded onto track 34 of a diskette and booted via BASIC's "DOS" command.
My ultimate goal is to separate out the "menu system" of the existing Color TRSDOS and replace it with a command shell that can be used for a more-traditional
DOS-like user experience.

### BootMaker
The BootMaker project creates a Windows/Linux command line utility for installing a boot image onto track 34 of a CoCo diskette image. This will likely be a
"quick-n-dirty" utility for now to help me automate my process of creating and testing a bootable Color TRSDOS experience, but I envision it morphing into
something more general purpose.
