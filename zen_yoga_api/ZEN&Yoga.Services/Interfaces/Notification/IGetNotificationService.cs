using ZEN_Yoga.Models.Responses;
using ZEN_Yoga.Models.SearchObjects;
using ZEN_Yoga.Services.Interfaces.Base;

namespace ZEN_Yoga.Services.Interfaces.Notification
{
    public interface IGetNotificationService : IGetService<Models.Notification, NotificationResponse>
    {
        Task<List<NotificationResponse>> GetNotificationsQuery(NotificationQuery notificationQuery);

        Task<List<NotificationResponse>> GetByUserId(int userId);
    }
}
