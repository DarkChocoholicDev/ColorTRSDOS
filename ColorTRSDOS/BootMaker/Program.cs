namespace BootMaker
{
    internal class Program
    {
        struct RSDOS
        {
            public const int BytesPerSector = 256;
            public const int SectorsPerTrack = 18;
            public const int SidesPerDisk = 1;
            public const int TracksPerDisk = 35;
            public const int BytesPerDisk = TracksPerDisk * SidesPerDisk * SectorsPerTrack * BytesPerSector;
            public const int BytesPerTrack = SectorsPerTrack * BytesPerSector;

            // Relative byte address (bytes from beginning of disk) of the book track.
            public const int BootTrackRBA = 34 * BytesPerTrack;
        }

        static int Main(string[] args)
        {
            if (args.Length != 2)
            {
                Usage();
                return 0;
            }

            return WriteBootImage(args[0], args[1]) ? 0 : 1;
        }

        static void Usage()
        {
            Console.WriteLine
            (
                """
                BootMaker
                
                Usage:
                    bootmaker <boot-image-file> <disk-image-file>

                Where:
                    boot-image-file
                        The file to be written to track 34 of the Tandy Color Computer formatted diskette.

                    disk-image-file
                        The disk image file for the Tandy Color Computer formatted diskette.
                """
            );
        }

        static bool WriteBootImage(string bootImageFilePath, string diskImageFilePath)
        {
            // Validate the boot and disk image files.
            var bootImageFileInfo = new FileInfo(bootImageFilePath);
            var diskImageFileInfo = new FileInfo(diskImageFilePath);
            if (ValidateImageFile(bootImageFileInfo) && ValidateDiskImageFile(diskImageFileInfo))
            {
                return TransferBootImage(bootImageFileInfo, diskImageFileInfo);
            }

            return false;
        }

        static bool ValidateDiskImageFile(FileInfo diskImageFileInfo) 
        {
            if (diskImageFileInfo.Exists)
            {
                if (diskImageFileInfo.Length == RSDOS.BytesPerDisk)
                {
                    return true;
                }
                else
                {
                    return Fail($"Unexpected file size for disk image. Expected {RSDOS.BytesPerDisk} bytes, found {diskImageFileInfo.Length} bytes.");
                }
            }
            else
            {
                return Fail($"Disk image file not found: {diskImageFileInfo.FullName}");
            }
        }

        static bool ValidateImageFile(FileInfo bootImageFileInfo)
        {
            if (bootImageFileInfo.Exists)
            {
                if (bootImageFileInfo.Length > 0 && bootImageFileInfo.Length  <= RSDOS.BytesPerTrack)
                {
                    return true;
                }
                else
                {
                    return Fail($"Unsupported file size for boot image. Maximum size: {RSDOS.BytesPerDisk} bytes, actual size: {bootImageFileInfo.Length} bytes.");
                }
            }
            else
            {
                return Fail($"Boot image file not found: {bootImageFileInfo.FullName}");
            }
        }

        static bool TransferBootImage(FileInfo bootImageFileInfo, FileInfo diskImageFileInfo)
        {
            Console.WriteLine($"Transferring boot image \"{bootImageFileInfo.Name}\" to disk image \"{diskImageFileInfo.Name}\".");

            FileStream? bootImageStream = null;
            FileStream? diskImageStream = null;

            try
            {
                using (bootImageStream = bootImageFileInfo.OpenRead())
                {
                    using (diskImageStream = diskImageFileInfo.OpenWrite())
                    {
                        byte[] ioBuffer = new byte[RSDOS.BytesPerTrack]; 
                        int readLength = (int)Math.Min(bootImageFileInfo.Length, RSDOS.BytesPerTrack);
                        bootImageStream.ReadExactly(ioBuffer, 0, readLength);
                        diskImageStream.Position = RSDOS.BootTrackRBA;
                        diskImageStream.Write(ioBuffer, 0, RSDOS.BytesPerTrack);
                    }
                }
            }
            catch (Exception ex)
            {
                Fail($"Error while transferring boot image: {ex.Message}");
            }

            return false;
        }

        static bool Fail(string message)
        {
            Console.WriteLine(message);
            return false;
        }
    }
}
