using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ZEN_Yoga.Models.Requests;

namespace ZEN_Yoga.Services.Interfaces.Notification
{
    public interface ISendInAppNotificationService
    {
        Task SendToUserAsync(string userId, AddNotification notification);
    }
}
