namespace ZEN_Yoga.Models.Responses
{
    public class NotificationResponse
    {
        public int Id { get; set; }
        public int UserId { get; set; }
        public required string Title { get; set; }
        public string? Content { get; set; }
        public required string Type { get; set; }
        public bool IsRead { get; set; }
        public DateTime CreatedAt { get; set; }
    }
}
