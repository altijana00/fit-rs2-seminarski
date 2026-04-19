using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ZEN_Yoga.Models.Notifications;

namespace ZEN_Yoga.Services.Interfaces.Notification
{
    public interface INotificationService
    {
        Task SendToUserAsync(string userId, AppNotification notification);
    }
}
