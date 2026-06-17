using Microsoft.AspNetCore.Http;



namespace ZEN_Yoga.Models.Helpers
{
    public static class FileValidationHelper
    {
        private static readonly HashSet<string> AllowedExtensions =
        [
            ".jpg",
            ".jpeg",
            ".png"
        ];

        private static readonly HashSet<string> AllowedMimeTypes =
        [
            "image/jpeg",
            "image/png"
        ];

        public static bool IsValidImage(IFormFile file)
        {
            if (file == null || file.Length == 0)
                return false;

            var extension = Path.GetExtension(file.FileName).ToLowerInvariant();

            if (!AllowedExtensions.Contains(extension))
                return false;

            if (!AllowedMimeTypes.Contains(file.ContentType))
                return false;

            using var stream = file.OpenReadStream();

            var header = new byte[8];
            stream.Read(header, 0, header.Length);

            return IsJpeg(header) || IsPng(header);
        }

        private static bool IsJpeg(byte[] header)
        {
            return header.Length >= 3
                && header[0] == 0xFF
                && header[1] == 0xD8
                && header[2] == 0xFF;
        }

        private static bool IsPng(byte[] header)
        {
            return header.Length >= 8
                && header[0] == 0x89
                && header[1] == 0x50
                && header[2] == 0x4E
                && header[3] == 0x47
                && header[4] == 0x0D
                && header[5] == 0x0A
                && header[6] == 0x1A
                && header[7] == 0x0A;
        }
    }
}
