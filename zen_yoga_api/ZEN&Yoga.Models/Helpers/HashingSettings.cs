using Microsoft.Extensions.Options;

namespace ZEN_Yoga.Models.Helpers
{
    public static class HashingConfig
    {
        public static string? Salt { get; set; }

        public static void Init(HashingSettings settings) 
        {
            Salt = settings.Salt;
        }
    }
    public class HashingSettings
    {
        public string? Salt { get; set; }

       
    }
}
