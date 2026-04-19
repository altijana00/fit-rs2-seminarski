namespace ZEN_Yoga.Models.Notifications
{
    public record AppNotification(string Title, string Message, string Type = "info");
}
