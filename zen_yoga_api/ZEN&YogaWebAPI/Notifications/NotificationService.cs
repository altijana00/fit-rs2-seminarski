using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ZEN_Yoga.Models.Notifications;
using ZEN_Yoga.Services.Interfaces.Notification;
using ZEN_YogaWebAPI.Notifications;

namespace ZEN_Yoga.Services.Services.Notification
{
    public class NotificationService(IHubContext<NotificationHub> hubContext) : INotificationService
    {
        public async Task SendToUserAsync(string userId, AppNotification notification)
        {
            await hubContext.Clients
                .Group($"user_{userId}")
                .SendAsync("ReceiveNotification", notification);
        }

        public async Task SendToAllAsync(AppNotification notification)
        {
            await hubContext.Clients.All.SendAsync("ReceiveNotification", notification);
        }
    }
}
