using Microsoft.AspNetCore.SignalR;
using ZEN_Yoga.Models.Requests;
using ZEN_Yoga.Services.Interfaces.Notification;

namespace ZEN_YogaWebAPI.Notifications
{
    public class SendInAppNotificationService(IHubContext<NotificationHub> hubContext) : ISendInAppNotificationService
    {
        public async Task SendToUserAsync(string userId, AddNotification notification)
        {
            await hubContext.Clients
                .Group($"user_{userId}")
                .SendAsync("ReceiveNotification", notification);
        }
    }
}
