namespace ZEN_Yoga.Services.Configurations
{
    public class AzureBlobStorageSettings
    {
        public string? ConnectionString { get; set; }
        public string? UserPhotosContainer { get; set; }
        public string? StudioPhotosContainer { get; set; }

        public AzureBlobStorageSettings()
        {
                
        }
    }
}
