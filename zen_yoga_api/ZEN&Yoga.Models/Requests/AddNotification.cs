namespace ZEN_Yoga.Models.Requests
{
    public class AddNotification
    {
        public int UserId { get; set; }
        public required string Title { get; set; }
        public string? Content { get; set; }
        public required string Type { get; set; }
    }
}