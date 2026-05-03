namespace ZEN_Yoga.Models.Requests
{
    public class EditNotification
    {
        public required string Title { get; set; }
        public string? Content { get; set; }
        public required string Type { get; set; }
    }
}